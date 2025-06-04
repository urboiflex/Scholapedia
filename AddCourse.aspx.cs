using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace WAPPSS
{
    public partial class AddCourse : System.Web.UI.Page
    {
        // Add these for navbar/profile/theme
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

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Set default publish date to today
                calendarPublish.SelectedDate = DateTime.Today;
            }
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Debug.WriteLine("Save button clicked");
            try
            {
                // Validate required fields
                if (string.IsNullOrWhiteSpace(txtCourseName.Text))
                {
                    ShowAlert("Course name is required.");
                    return;
                }

                if (string.IsNullOrWhiteSpace(ddlSkillLevel.SelectedValue))
                {
                    ShowAlert("Please select a skill level.");
                    return;
                }

                if (string.IsNullOrWhiteSpace(ddlLanguage.SelectedValue))
                {
                    ShowAlert("Please select a language.");
                    return;
                }

                // Parse duration
                int hours = 0, minutes = 0;
                if (!string.IsNullOrWhiteSpace(txtDurationHours.Text)) int.TryParse(txtDurationHours.Text, out hours);
                if (!string.IsNullOrWhiteSpace(txtDurationMinutes.Text)) int.TryParse(txtDurationMinutes.Text, out minutes);
                TimeSpan duration = new TimeSpan(hours, minutes, 0);

                // Combine date and time
                DateTime publishDate = calendarPublish.SelectedDate;
                TimeSpan publishTime = TimeSpan.Parse(timePublish.Value);
                DateTime fullPublishDateTime = publishDate.Add(publishTime);

                // --- COVER IMAGE VALIDATION ---
                string coverImagePath = null;
                if (fuCover.PostedFile != null && fuCover.PostedFile.ContentLength > 0)
                {
                    string ext = Path.GetExtension(fuCover.PostedFile.FileName).ToLower();
                    string mime = fuCover.PostedFile.ContentType.ToLower();
                    bool isImage =
                        mime.StartsWith("image/") ||
                        ext == ".jpg" || ext == ".jpeg" || ext == ".png" || ext == ".gif" || ext == ".bmp" || ext == ".webp";
                    if (!isImage)
                    {
                        ShowAlert("Error: Cover image must be an image file (JPG, PNG, GIF, BMP, WEBP, etc).");
                        return;
                    }
                    coverImagePath = HandleFileUpload(fuCover.PostedFile, "Images/Covers/");
                }

                // --- RESOURCE FILE VALIDATION ---
                string resourcesPath = null;
                if (fuResources.PostedFile != null && fuResources.PostedFile.ContentLength > 0)
                {
                    string ext = Path.GetExtension(fuResources.PostedFile.FileName).ToLower();
                    string mime = fuResources.PostedFile.ContentType.ToLower();
                    // Accept: PDF, PPT, PPTX, all video/*
                    // BLOCK: image/*
                    bool isImage = mime.StartsWith("image/") ||
                        ext == ".jpg" || ext == ".jpeg" || ext == ".png" || ext == ".gif" || ext == ".bmp" || ext == ".webp";
                    bool isValid =
                        (ext == ".pdf" ||
                        ext == ".ppt" ||
                        ext == ".pptx" ||
                        mime.StartsWith("video/")) && !isImage;
                    if (!isValid)
                    {
                        ShowAlert("Error: Only PDF, PPT, or Video files are allowed. Images are not allowed.");
                        return;
                    }
                    resourcesPath = HandleFileUpload(fuResources.PostedFile, "Resources/");
                }

                // Make sure user is logged in
                if (Session["UserID"] == null)
                {
                    ShowAlert("You must be logged in to add a course.");
                    return;
                }
                int currentUserId = Convert.ToInt32(Session["UserID"]);

                // Save to database
                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"INSERT INTO TeacherCourses 
        (TC_CourseName, TC_Duration, TC_SkillLevel, TC_Language, 
         TC_CoverImage, TC_ResourceFile, TC_PublishDate, TC_PublishTime, TC_ModuleType, UserID) 
        VALUES 
        (@TC_CourseName, @TC_Duration, @TC_SkillLevel, @TC_Language, 
         @TC_CoverImage, @TC_ResourceFile, @TC_PublishDate, @TC_PublishTime, @TC_ModuleType, @UserID)";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@TC_CourseName", txtCourseName.Text.Trim());
                        command.Parameters.AddWithValue("@TC_Duration", $"{hours:D2}:{minutes:D2}");
                        command.Parameters.AddWithValue("@TC_SkillLevel", ddlSkillLevel.SelectedValue);
                        command.Parameters.AddWithValue("@TC_Language", ddlLanguage.SelectedValue);
                        command.Parameters.AddWithValue("@TC_CoverImage", string.IsNullOrEmpty(coverImagePath) ? DBNull.Value : (object)coverImagePath);
                        command.Parameters.AddWithValue("@TC_ResourceFile", string.IsNullOrEmpty(resourcesPath) ? DBNull.Value : (object)resourcesPath);
                        command.Parameters.AddWithValue("@TC_PublishDate", publishDate);
                        command.Parameters.AddWithValue("@TC_PublishTime", publishTime);
                        command.Parameters.AddWithValue("@TC_ModuleType", ddlModuleType.SelectedValue);
                        command.Parameters.AddWithValue("@UserID", currentUserId); // <-- FIXED: Add UserID here

                        connection.Open();
                        command.ExecuteNonQuery();
                        ShowAlert("Course saved successfully!");
                    }
                }

                string script = "alert('Course is successfully stored'); window.location='course.aspx';";
                ScriptManager.RegisterStartupScript(this, GetType(), "successAlert", script, true);

            }
            catch (Exception ex)
            {
                // Log the error (you might want to implement proper error logging)
                ShowAlert($"An error occurred: {ex.Message}");
            }
        }

        protected void calendarPublish_DayRender(object sender, DayRenderEventArgs e)
        {
            if (e.Day.Date <= DateTime.Today)
            {
                e.Day.IsSelectable = false;
                e.Cell.ForeColor = System.Drawing.Color.Gray;
                e.Cell.BackColor = System.Drawing.Color.LightGray;
                e.Cell.Attributes["style"] = "cursor:not-allowed; opacity:0.5;";
            }
        }

        private string HandleFileUpload(HttpPostedFile fileUpload, string targetFolder)
        {
            if (fileUpload != null && fileUpload.ContentLength > 0)
            {
                try
                {
                    // Create target directory if it doesn't exist
                    string serverPath = Server.MapPath("~/" + targetFolder);
                    if (!Directory.Exists(serverPath))
                    {
                        Directory.CreateDirectory(serverPath);
                    }

                    // Generate unique filename
                    string fileName = Path.GetFileName(fileUpload.FileName);
                    string uniqueFileName = Guid.NewGuid().ToString() + Path.GetExtension(fileName);
                    string filePath = Path.Combine(serverPath, uniqueFileName);

                    // Save the file
                    fileUpload.SaveAs(filePath);

                    // Return the relative path
                    return targetFolder + uniqueFileName;
                }
                catch (Exception ex)
                {
                    // Log file upload error
                    throw new Exception($"File upload failed: {ex.Message}");
                }
            }

            return null;
        }

        private void ShowAlert(string message)
        {
            lblStatus.Text = message; // Show error message visibly
            ScriptManager.RegisterStartupScript(this, GetType(), "showalert",
                $"alert('{message.Replace("'", "\\'")}');", true);
        }
        protected void calendarPublish_SelectionChanged(object sender, EventArgs e)
        {
            DateTime selectedDate = calendarPublish.SelectedDate;
            // You can do something with the selected date, e.g., display it in a Label or TextBox
        }
    }
}