using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.IO;

namespace WAPPSS
{
    public partial class adminManageCourses : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            UnobtrusiveValidationMode = UnobtrusiveValidationMode.None;

            // Check if admin is logged in
            if (Session["AdminID"] == null || Session["AdminAuthenticated"] == null || !(bool)Session["AdminAuthenticated"])
            {
                Response.Redirect("adminLogin.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadCreators();
                BindCourses();
                LoadAdminInfo();
            }
        }

        private void LoadAdminInfo()
        {
            try
            {
                // Get admin ID from session
                int adminId = Convert.ToInt32(Session["AdminID"]);
                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT Username FROM Admins WHERE AdminID = @AdminID";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@AdminID", adminId);

                    connection.Open();
                    object result = command.ExecuteScalar();

                    if (result != null && result != DBNull.Value)
                    {
                        string username = result.ToString();
                        litAdminInitial.Text = username.Length > 0 ? username[0].ToString().ToUpper() : "A";
                        litAdminName.Text = username;
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the exception (in a production environment)
                System.Diagnostics.Debug.WriteLine("Error loading admin info: " + ex.Message);
            }
        }

        private void LoadCreators()
        {
            try
            {
                ddlCreator.Items.Clear();
                ddlCreator.Items.Add(new ListItem("All Module Types", ""));

                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT DISTINCT TC_ModuleType FROM TeacherCourses WHERE TC_ModuleType IS NOT NULL AND TC_ModuleType != '' ORDER BY TC_ModuleType";
                    SqlCommand command = new SqlCommand(query, connection);

                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();

                    while (reader.Read())
                    {
                        string moduleType = reader["TC_ModuleType"].ToString();
                        ddlCreator.Items.Add(new ListItem(moduleType, moduleType));
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the exception (in a production environment)
                System.Diagnostics.Debug.WriteLine("Error loading module types: " + ex.Message);
            }
        }

        private void BindCourses()
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    StringBuilder query = new StringBuilder("SELECT TC_ID as CourseID, TC_CourseName as CourseName, TC_CoverImage as CoverImage, TC_ModuleType as ModuleType, TC_Duration as Duration, TC_SkillLevel as SkillLevel, TC_Language as Language, TC_PublishDate as PublishDate, TC_PublishTime as PublishTime FROM TeacherCourses WHERE 1=1");

                    SqlCommand command = new SqlCommand();
                    command.Connection = connection;

                    // Apply search filter if provided
                    if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
                    {
                        query.Append(" AND (TC_CourseName LIKE @Search OR TC_ModuleType LIKE @Search OR TC_SkillLevel LIKE @Search OR TC_Language LIKE @Search)");
                        command.Parameters.AddWithValue("@Search", "%" + txtSearch.Text.Trim() + "%");
                    }

                    // Apply module type filter if selected
                    if (!string.IsNullOrEmpty(ddlCreator.SelectedValue))
                    {
                        query.Append(" AND TC_ModuleType = @ModuleType");
                        command.Parameters.AddWithValue("@ModuleType", ddlCreator.SelectedValue);
                    }

                    query.Append(" ORDER BY TC_PublishDate DESC, TC_PublishTime DESC");
                    command.CommandText = query.ToString();

                    connection.Open();
                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    DataTable dataTable = new DataTable();
                    adapter.Fill(dataTable);

                    gvCourses.DataSource = dataTable;
                    gvCourses.DataBind();

                    litCourseCount.Text = $"Total {dataTable.Rows.Count} courses";
                }
            }
            catch (Exception ex)
            {
                // Log the exception (in a production environment)
                System.Diagnostics.Debug.WriteLine("Error loading courses: " + ex.Message);
            }
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            BindCourses();
        }

        protected void ddlCreator_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindCourses();
        }

        protected void btnAddCourse_Click(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "addCourse", "alert('Add Course functionality will be implemented here.');", true);
        }

        protected void btnExport_Click(object sender, EventArgs e)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT TC_ID, TC_CourseName, TC_ModuleType, TC_Duration, TC_SkillLevel, TC_Language, TC_PublishDate FROM TeacherCourses ORDER BY TC_CourseName";
                    SqlCommand command = new SqlCommand(query, connection);

                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();

                    StringBuilder csv = new StringBuilder();
                    csv.AppendLine("CourseID,CourseName,ModuleType,Duration,SkillLevel,Language,PublishDate");

                    while (reader.Read())
                    {
                        string courseName = (reader["TC_CourseName"]?.ToString() ?? "").Replace("\"", "\"\"");
                        string moduleType = (reader["TC_ModuleType"]?.ToString() ?? "").Replace("\"", "\"\"");
                        string duration = (reader["TC_Duration"]?.ToString() ?? "").Replace("\"", "\"\"");
                        string skillLevel = (reader["TC_SkillLevel"]?.ToString() ?? "").Replace("\"", "\"\"");
                        string language = (reader["TC_Language"]?.ToString() ?? "").Replace("\"", "\"\"");
                        string publishDate = reader["TC_PublishDate"] != DBNull.Value ? Convert.ToDateTime(reader["TC_PublishDate"]).ToString("yyyy-MM-dd") : "";

                        csv.AppendLine($"\"{reader["TC_ID"]}\",\"{courseName}\",\"{moduleType}\",\"{duration}\",\"{skillLevel}\",\"{language}\",\"{publishDate}\"");
                    }

                    Response.Clear();
                    Response.Buffer = true;
                    Response.AddHeader("content-disposition", "attachment;filename=TeacherCourses_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".csv");
                    Response.Charset = "";
                    Response.ContentType = "application/text";
                    Response.Output.Write(csv.ToString());
                    Response.Flush();
                    Response.End();
                }
            }
            catch (Exception ex)
            {
                // Log the exception (in a production environment)
                System.Diagnostics.Debug.WriteLine("Error exporting courses: " + ex.Message);
            }
        }

        protected void gvCourses_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int courseId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditCourse")
            {
                LoadCourseForEdit(courseId);
                ScriptManager.RegisterStartupScript(this, GetType(), "showEditModal", "setTimeout(function() { try { var modal = new bootstrap.Modal(document.getElementById('editCourseModal')); modal.show(); } catch(e) { $('#editCourseModal').modal('show'); } }, 100);", true);
            }
            else if (e.CommandName == "DeleteCourse")
            {
                DeleteCourse(courseId);
            }
            else if (e.CommandName == "ViewCourse")
            {
                LoadCourseForView(courseId);
                ScriptManager.RegisterStartupScript(this, GetType(), "showViewModal", "setTimeout(function() { try { var modal = new bootstrap.Modal(document.getElementById('viewCourseModal')); modal.show(); } catch(e) { $('#viewCourseModal').modal('show'); } }, 100);", true);
            }
        }

        private void LoadCourseForView(int courseId)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT TC_ID, TC_CourseName, TC_CoverImage, TC_ModuleType, TC_Duration, TC_SkillLevel, TC_Language, TC_PublishDate, TC_PublishTime FROM TeacherCourses WHERE TC_ID = @CourseID";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@CourseID", courseId);

                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();

                    if (reader.Read())
                    {
                        litViewCourseName.Text = reader["TC_CourseName"]?.ToString() ?? "N/A";
                        litViewModuleType.Text = reader["TC_ModuleType"]?.ToString() ?? "N/A";
                        litViewDuration.Text = reader["TC_Duration"]?.ToString() ?? "N/A";
                        litViewSkillLevel.Text = reader["TC_SkillLevel"]?.ToString() ?? "N/A";
                        litViewLanguage.Text = reader["TC_Language"]?.ToString() ?? "N/A";
                        litViewPublished.Text = FormatPublishDate(reader["TC_PublishDate"], reader["TC_PublishTime"]);

                        string imagePath = reader["TC_CoverImage"]?.ToString() ?? "";
                        imgViewCourse.ImageUrl = GetCourseImage(imagePath);
                        imgViewCourse.AlternateText = reader["TC_CourseName"]?.ToString() ?? "Course Image";
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the exception (in a production environment)
                System.Diagnostics.Debug.WriteLine("Error loading course for view: " + ex.Message);
            }
        }

        private void LoadCourseForEdit(int courseId)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT TC_ID, TC_CourseName, TC_CoverImage, TC_ModuleType, TC_Duration, TC_SkillLevel, TC_Language, TC_PublishDate, TC_PublishTime FROM TeacherCourses WHERE TC_ID = @CourseID";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@CourseID", courseId);

                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();

                    if (reader.Read())
                    {
                        hdnEditCourseId.Value = courseId.ToString();
                        txtEditCourseName.Text = reader["TC_CourseName"]?.ToString() ?? "";
                        txtEditDuration.Text = reader["TC_Duration"]?.ToString() ?? "";

                        SetDropDownSelection(ddlEditModuleType, reader["TC_ModuleType"]?.ToString() ?? "");
                        SetDropDownSelection(ddlEditSkillLevel, reader["TC_SkillLevel"]?.ToString() ?? "");
                        SetDropDownSelection(ddlEditLanguage, reader["TC_Language"]?.ToString() ?? "");

                        string imagePath = reader["TC_CoverImage"]?.ToString() ?? "";
                        imgEditCourse.ImageUrl = GetCourseImage(imagePath);
                        imgEditCourse.AlternateText = reader["TC_CourseName"]?.ToString() ?? "Course Image";
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the exception (in a production environment)
                System.Diagnostics.Debug.WriteLine("Error loading course for edit: " + ex.Message);
            }
        }

        protected void btnSaveChanges_Click(object sender, EventArgs e)
        {
            try
            {
                int courseId = Convert.ToInt32(hdnEditCourseId.Value);
                string imagePath = null;

                if (fuEditCourseImage.HasFile)
                {
                    try
                    {
                        string uploadsPath = Server.MapPath("~/uploads/courses/");
                        if (!Directory.Exists(uploadsPath))
                        {
                            Directory.CreateDirectory(uploadsPath);
                        }

                        string fileName = Guid.NewGuid().ToString() + Path.GetExtension(fuEditCourseImage.FileName);
                        string fullPath = Path.Combine(uploadsPath, fileName);
                        fuEditCourseImage.SaveAs(fullPath);
                        imagePath = "~/uploads/courses/" + fileName;
                    }
                    catch (Exception uploadEx)
                    {
                        // Log the exception (in a production environment)
                        System.Diagnostics.Debug.WriteLine("Error uploading image: " + uploadEx.Message);
                    }
                }

                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "UPDATE TeacherCourses SET TC_CourseName = @CourseName, TC_ModuleType = @ModuleType, TC_Duration = @Duration, TC_SkillLevel = @SkillLevel, TC_Language = @Language" + (imagePath != null ? ", TC_CoverImage = @CoverImage" : "") + " WHERE TC_ID = @CourseID";
                    SqlCommand command = new SqlCommand(query, connection);

                    command.Parameters.AddWithValue("@CourseID", courseId);
                    command.Parameters.AddWithValue("@CourseName", txtEditCourseName.Text.Trim());
                    command.Parameters.AddWithValue("@ModuleType", ddlEditModuleType.SelectedValue);
                    command.Parameters.AddWithValue("@Duration", txtEditDuration.Text.Trim());
                    command.Parameters.AddWithValue("@SkillLevel", ddlEditSkillLevel.SelectedValue);
                    command.Parameters.AddWithValue("@Language", ddlEditLanguage.SelectedValue);

                    if (imagePath != null)
                    {
                        command.Parameters.AddWithValue("@CoverImage", imagePath);
                    }

                    connection.Open();
                    int result = command.ExecuteNonQuery();

                    if (result > 0)
                    {
                        BindCourses();
                        ScriptManager.RegisterStartupScript(this, GetType(), "updateSuccess", "alert('Course updated successfully!'); $('#editCourseModal').modal('hide');", true);
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "updateFailed", "alert('Failed to update course. Please try again.');", true);
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the exception (in a production environment)
                System.Diagnostics.Debug.WriteLine("Error updating course: " + ex.Message);
            }
        }

        private void DeleteCourse(int courseId)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "DELETE FROM TeacherCourses WHERE TC_ID = @CourseID";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@CourseID", courseId);

                    connection.Open();
                    int result = command.ExecuteNonQuery();

                    if (result > 0)
                    {
                        BindCourses();
                        ScriptManager.RegisterStartupScript(this, GetType(), "courseDeleted", "alert('Course deleted successfully.');", true);
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "courseNotDeleted", "alert('Failed to delete course.');", true);
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the exception (in a production environment)
                System.Diagnostics.Debug.WriteLine("Error deleting course: " + ex.Message);
            }
        }

        protected void gvCourses_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // You can customize row appearance based on data here
            }
        }

        protected void gvCourses_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvCourses.PageIndex = e.NewPageIndex;
            BindCourses();
        }

        protected string GetCourseImage(object imagePath)
        {
            if (imagePath == null || string.IsNullOrEmpty(imagePath.ToString()))
            {
                return "~/images/default-course.png";
            }
            return ResolveUrl(imagePath.ToString());
        }

        protected string FormatPublishDate(object publishDate, object publishTime)
        {
            if (publishDate != null && publishDate != DBNull.Value)
            {
                DateTime date = Convert.ToDateTime(publishDate);
                string formattedDate = date.ToString("MMM dd, yyyy");

                if (publishTime != null && publishTime != DBNull.Value)
                {
                    TimeSpan time = (TimeSpan)publishTime;
                    formattedDate += " " + time.ToString(@"hh\:mm");
                }

                return formattedDate;
            }
            return "Not Published";
        }

        private void SetDropDownSelection(DropDownList ddl, string value)
        {
            try
            {
                if (!string.IsNullOrEmpty(value))
                {
                    ListItem item = ddl.Items.FindByValue(value);
                    if (item != null)
                    {
                        ddl.ClearSelection();
                        item.Selected = true;
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the exception (in a production environment)
                System.Diagnostics.Debug.WriteLine("Error setting dropdown selection: " + ex.Message);
            }
        }
    }
}