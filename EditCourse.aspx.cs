using System;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WAPPSS
{
    public partial class EditCourse : System.Web.UI.Page
    {
        protected string NavbarUserName = "User";
        protected string NavbarProfilePic = "Images/Profile/default.jpg";
        protected string NavbarProfilePicResolved = "/Images/Profile/default.jpg";
        protected string ModeTypeFromDB = "light"; // Default to light

        protected void Page_Init(object sender, EventArgs e)
        {
            if (Session["UserID"] != null)
            {
                string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                using (var conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    // Get user's name and profile pic (same as other pages)
                    using (var cmd = new SqlCommand(
                        "SELECT u.FirstName, pt.ProfilePic FROM Users u LEFT JOIN ProfileTC pt ON u.UserID = pt.UserID WHERE u.UserID = @UserID", conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                        using (var rdr = cmd.ExecuteReader())
                        {
                            if (rdr.Read())
                            {
                                NavbarUserName = (rdr["FirstName"] != DBNull.Value && rdr["FirstName"] != null)
                                    ? rdr["FirstName"].ToString()
                                    : "User";
                                NavbarProfilePic = rdr["ProfilePic"] != DBNull.Value && !string.IsNullOrEmpty(rdr["ProfilePic"].ToString())
                                    ? rdr["ProfilePic"].ToString()
                                    : "Images/Profile/default.jpg";
                            }
                        }
                    }
                    NavbarProfilePicResolved = ResolveUrl("~/" + NavbarProfilePic.TrimStart('~', '/'));

                    // Get ModeType from Mode table for logged in user
                    using (var cmd = new SqlCommand("SELECT ModeType FROM Mode WHERE UserID = @UserID", conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                        object modeTypeObj = cmd.ExecuteScalar();
                        if (modeTypeObj != null && modeTypeObj != DBNull.Value)
                        {
                            ModeTypeFromDB = modeTypeObj.ToString().ToLower() == "dark" ? "dark" : "light";
                        }
                    }
                }
            }
        }


        private void RestorePreviews()
        {
            if (ViewState["CoverImage"] != null)
            {
                string coverImage = ViewState["CoverImage"].ToString();
                imgCoverPreview.ImageUrl = coverImage.StartsWith("~/") ? coverImage : "~/" + coverImage;
                imgCoverPreview.Visible = true;
                lblCoverImageName.Text = System.IO.Path.GetFileName(coverImage);
                lblCoverImageName.Visible = true;
            }
            else
            {
                imgCoverPreview.Visible = false;
                lblCoverImageName.Text = "";
                lblCoverImageName.Visible = false;
            }

            if (ViewState["ResourceFile"] != null)
            {
                string resourceFile = ViewState["ResourceFile"].ToString();
                lnkResourceFile.Text = "Download Resource";
                lnkResourceFile.NavigateUrl = resourceFile.StartsWith("~/") ? resourceFile : "~/" + resourceFile;
                lnkResourceFile.Visible = true;
                lblResourceFileName.Text = System.IO.Path.GetFileName(resourceFile);
                lblResourceFileName.Visible = true;
            }
            else
            {
                lnkResourceFile.Visible = false;
                lblResourceFileName.Text = "";
                lblResourceFileName.Visible = false;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string courseId = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(courseId))
                {
                    ViewState["CourseID"] = courseId;
                    LoadCourseDetails(courseId);
                }
            }
            // Always restore image and resource previews
            RestorePreviews();
            UpdateRemoveButtonsVisibility();
        }

        private void UpdateRemoveButtonsVisibility()
        {
            btnRemoveCover.Visible = imgCoverPreview.Visible && !string.IsNullOrEmpty(imgCoverPreview.ImageUrl);
            btnRemoveResource.Visible = lnkResourceFile.Visible && !string.IsNullOrEmpty(lnkResourceFile.NavigateUrl);
        }

        private string HandleFileUpload(HttpPostedFile file, string virtualFolder)
        {
            if (file == null || file.ContentLength == 0) return null;
            string fileName = Guid.NewGuid().ToString() + Path.GetExtension(file.FileName);
            string relativePath = virtualFolder + fileName; // e.g. Images/Covers/xxxxx.jpg
            string fullPath = Server.MapPath("~/" + relativePath);
            string dir = Path.GetDirectoryName(fullPath);
            if (!Directory.Exists(dir)) Directory.CreateDirectory(dir);
            file.SaveAs(fullPath);
            return relativePath;
        }
        protected void BtnSave_Click(object sender, EventArgs e)
        {
            try
            {
                string courseId = ViewState["CourseID"]?.ToString();
                if (string.IsNullOrEmpty(courseId))
                {
                    lblStatus.Text = "❌ Course ID not found.";
                    return;
                }

                string courseName = txtCourseName.Text.Trim();
                string duration = $"{txtDurationHours.Text.Trim()}h {txtDurationMinutes.Text.Trim()}m";
                string skillLevel = ddlSkillLevel.SelectedValue;
                string language = ddlLanguage.SelectedValue;
                string moduleType = ddlModuleType.SelectedValue;
                string coverImage = ViewState["CoverImage"] as string;
                string resourceFile = ViewState["ResourceFile"] as string;

                DateTime publishDate = calendarPublish.SelectedDate;
                TimeSpan publishTime = TimeSpan.Parse(Request.Form["timePublish"]);

                // Upload new cover image if selected - ensure path is Images/Covers/...
                if (fuCover.HasFile)
                {
                    // --- COVER IMAGE VALIDATION (server-side) ---
                    string ext = Path.GetExtension(fuCover.FileName).ToLower();
                    string mime = fuCover.PostedFile.ContentType.ToLower();
                    bool isImage = mime.StartsWith("image/") ||
                        ext == ".jpg" || ext == ".jpeg" || ext == ".png" ||
                        ext == ".gif" || ext == ".bmp" || ext == ".webp";
                    if (!isImage)
                    {
                        lblStatus.Text = "❌ Error: Cover image must be an image file (JPG, PNG, GIF, BMP, WEBP, etc).";
                        lblStatus.ForeColor = System.Drawing.Color.Red;
                        RestorePreviews();
                        ClientScript.RegisterStartupScript(this.GetType(), "coverWrongFormat", "window.alert('Error Wrong Format');", true);
                        return;
                    }
                    string coverImagePath = HandleFileUpload(fuCover.PostedFile, "Images/Covers/");
                    coverImage = coverImagePath;
                    ViewState["CoverImage"] = coverImage;
                }

                // Upload new resource if selected - use Resources/ for consistency (optional)
                if (fuResources.HasFile)
                {
                    // --- RESOURCE FILE VALIDATION (server-side) ---
                    string ext = Path.GetExtension(fuResources.FileName).ToLower();
                    string mime = fuResources.PostedFile.ContentType.ToLower();
                    // Accept: PDF, PPT, PPTX, all video/*
                    // BLOCK: image/*
                    bool isImage = mime.StartsWith("image/") ||
                        ext == ".jpg" || ext == ".jpeg" || ext == ".png" || ext == ".gif" || ext == ".bmp" || ext == ".webp";
                    bool isValid =
                        (ext == ".pdf" ||
                        ext == ".ppt" ||
                        ext == ".pptx" ||
                        mime == "application/pdf" ||
                        mime == "application/vnd.ms-powerpoint" ||
                        mime == "application/vnd.openxmlformats-officedocument.presentationml.presentation" ||
                        mime.StartsWith("video/")) && !isImage;
                    if (!isValid)
                    {
                        lblStatus.Text = "❌ Error: Only PDF, PPT, or Video files are allowed. Images are not allowed.";
                        lblStatus.ForeColor = System.Drawing.Color.Red;
                        RestorePreviews();
                        ClientScript.RegisterStartupScript(this.GetType(), "resourceWrongFormat", "window.alert('Error Wrong Format');", true);
                        return;
                    }
                    string resourcePath = HandleFileUpload(fuResources.PostedFile, "Resources/");
                    resourceFile = resourcePath;
                    ViewState["ResourceFile"] = resourceFile;
                }

                // Validate all required fields before saving
                if (string.IsNullOrEmpty(courseName) ||
                    string.IsNullOrEmpty(txtDurationHours.Text.Trim()) ||
                    string.IsNullOrEmpty(txtDurationMinutes.Text.Trim()) ||
                    string.IsNullOrEmpty(skillLevel) ||
                    string.IsNullOrEmpty(language) ||
                    string.IsNullOrEmpty(moduleType) ||
                    publishDate == default ||
                    string.IsNullOrEmpty(Request.Form["timePublish"]))
                {
                    lblStatus.Text = "❌ Please fill in all required fields.";
                    lblStatus.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"
                        UPDATE TeacherCourses SET
                            TC_CourseName = @CourseName,
                            TC_CoverImage = @CoverImage,
                            TC_ResourceFile = @ResourceFile,
                            TC_PublishDate = @PublishDate,
                            TC_PublishTime = @PublishTime,
                            TC_ModuleType = @ModuleType,
                            TC_Duration = @Duration,
                            TC_SkillLevel = @SkillLevel,
                            TC_Language = @Language
                        WHERE TC_ID = @CourseID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseID", courseId);
                        cmd.Parameters.AddWithValue("@CourseName", courseName ?? (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@CoverImage", coverImage ?? (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@ResourceFile", resourceFile ?? (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@PublishDate", publishDate);
                        cmd.Parameters.AddWithValue("@PublishTime", publishTime);
                        cmd.Parameters.AddWithValue("@ModuleType", moduleType ?? (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@Duration", duration ?? (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@SkillLevel", skillLevel ?? (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@Language", language ?? (object)DBNull.Value);

                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        conn.Close();

                        if (rowsAffected > 0)
                        {
                            // Success: Show popup and redirect to course.aspx
                            string script = "window.onload = function() { alert('Course has been edited successfully.'); window.location='course.aspx'; }";
                            ClientScript.RegisterStartupScript(this.GetType(), "SuccessRedirect", script, true);
                            return; // Don't continue further
                        }
                        else
                        {
                            lblStatus.Text = "❌ Update failed. Course may not exist.";
                            lblStatus.ForeColor = System.Drawing.Color.Red;
                        }
                    }
                }
                // After save, reload details to refresh preview and remove buttons
                LoadCourseDetails(courseId);
                RestorePreviews();
                UpdateRemoveButtonsVisibility();
            }
            catch (Exception ex)
            {
                lblStatus.Text = "❌ Error: " + ex.Message;
                lblStatus.ForeColor = System.Drawing.Color.Red;
            }
        }

        protected void btnRemoveCover_Click(object sender, EventArgs e)
        {
            string courseId = ViewState["CourseID"]?.ToString();
            if (!string.IsNullOrEmpty(courseId))
            {
                string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "UPDATE TeacherCourses SET TC_CoverImage = NULL WHERE TC_ID = @CourseID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseID", courseId);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        conn.Close();
                    }
                }
                ViewState["CoverImage"] = null;
                imgCoverPreview.Visible = false;
                lblCoverImageName.Text = "";
                lblCoverImageName.Visible = false;
                btnRemoveCover.Visible = false;
            }
        }

        
        protected void btnRemoveResource_Click(object sender, EventArgs e)
        {
            string courseId = ViewState["CourseID"]?.ToString();
            if (!string.IsNullOrEmpty(courseId))
            {
                string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "UPDATE TeacherCourses SET TC_ResourceFile = NULL WHERE TC_ID = @CourseID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseID", courseId);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        conn.Close();
                    }
                }
                ViewState["ResourceFile"] = null;
                lnkResourceFile.Visible = false;
                lblResourceFileName.Text = "";
                lblResourceFileName.Visible = false;
                btnRemoveResource.Visible = false;
            }
        }

        private void LoadCourseDetails(string courseId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
            SELECT 
                TC_CourseName, TC_ModuleType, TC_PublishDate, TC_PublishTime, TC_Duration, 
                TC_SkillLevel, TC_Language, TC_CoverImage, TC_ResourceFile 
            FROM TeacherCourses
            WHERE TC_ID = @ID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@ID", courseId);
                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    txtCourseName.Text = reader["TC_CourseName"].ToString();

                    // Duration split
                    string duration = reader["TC_Duration"].ToString();
                    if (duration.Contains(":") && TimeSpan.TryParse(duration, out TimeSpan time))
                    {
                        txtDurationHours.Text = time.Hours.ToString();
                        txtDurationMinutes.Text = time.Minutes.ToString();
                    }
                    else if (duration.Contains("h") && duration.Contains("m")) // For e.g. "12h 30m"
                    {
                        var parts = duration.Split(new[] { 'h', 'm', ' ' }, StringSplitOptions.RemoveEmptyEntries);
                        if (parts.Length >= 2)
                        {
                            txtDurationHours.Text = parts[0];
                            txtDurationMinutes.Text = parts[1];
                        }
                    }

                    ddlSkillLevel.SelectedValue = reader["TC_SkillLevel"].ToString();
                    ddlLanguage.SelectedValue = reader["TC_Language"].ToString();
                    ddlModuleType.SelectedValue = reader["TC_ModuleType"].ToString();

                    // Publish date and time
                    if (DateTime.TryParse(reader["TC_PublishDate"].ToString(), out DateTime publishDate))
                    {
                        calendarPublish.SelectedDate = publishDate;
                    }
                    if (TimeSpan.TryParse(reader["TC_PublishTime"].ToString(), out TimeSpan publishTime))
                    {
                        timePublish.Value = publishTime.ToString(@"hh\:mm");
                    }

                    // Cover image preview
                    string coverImage = reader["TC_CoverImage"].ToString();
                    if (!string.IsNullOrEmpty(coverImage))
                    {
                        imgCoverPreview.ImageUrl = coverImage.StartsWith("~/") ? coverImage : "~/" + coverImage;
                        imgCoverPreview.Visible = true;
                        lblCoverImageName.Text = System.IO.Path.GetFileName(coverImage);
                        lblCoverImageName.Visible = true;
                        ViewState["CoverImage"] = coverImage;
                    }
                    else
                    {
                        imgCoverPreview.Visible = false;
                        lblCoverImageName.Text = "";
                        ViewState["CoverImage"] = null;
                    }

                    // Resource file preview
                    string resourceFile = reader["TC_ResourceFile"].ToString();
                    if (!string.IsNullOrEmpty(resourceFile))
                    {
                        lnkResourceFile.Text = "Download Resource";
                        lnkResourceFile.NavigateUrl = resourceFile.StartsWith("~/") ? resourceFile : "~/" + resourceFile;
                        lnkResourceFile.Visible = true;
                        lblResourceFileName.Text = System.IO.Path.GetFileName(resourceFile);
                        lblResourceFileName.Visible = true;
                        ViewState["ResourceFile"] = resourceFile;
                    }
                    else
                    {
                        lnkResourceFile.Visible = false;
                        lblResourceFileName.Text = "";
                        ViewState["ResourceFile"] = null;
                    }
                }
                reader.Close();
            }
        }
        protected void calendarPublish_SelectionChanged(object sender, EventArgs e)
        {
            DateTime selectedDate = calendarPublish.SelectedDate;
            DateTime today = DateTime.Today;

            if (selectedDate <= today)
            {
                // Block this selection, revert to previous (if any) or today
                ScriptManager.RegisterStartupScript(this, GetType(), "blockPastDate", "window.alert('You can only select a date after today\\'s date.');", true);
                if (ViewState["LastValidPublishDate"] != null)
                {
                    calendarPublish.SelectedDate = (DateTime)ViewState["LastValidPublishDate"];
                }
                else
                {
                    calendarPublish.SelectedDate = today.AddDays(1);
                }
                return;
            }

            // Save the selected date in the DB for this course
            string courseId = ViewState["CourseID"]?.ToString();
            if (!string.IsNullOrEmpty(courseId))
            {
                string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "UPDATE TeacherCourses SET TC_PublishDate = @PublishDate WHERE TC_ID = @CourseID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@PublishDate", selectedDate);
                        cmd.Parameters.AddWithValue("@CourseID", courseId);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        conn.Close();
                    }
                }
                // Optionally show a success popup
                ScriptManager.RegisterStartupScript(this, GetType(), "dateSaved", "window.alert('Publish date updated successfully.');", true);
            }

            ViewState["LastValidPublishDate"] = selectedDate;
        }
    }
}