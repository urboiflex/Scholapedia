using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;

namespace WAPPSS
{
    public partial class coursesTest : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            UnobtrusiveValidationMode = UnobtrusiveValidationMode.None;

            if (!IsPostBack)
            {
                // Clear any previous messages
                lblMessage.Text = string.Empty;

                // Set default publish date to today
                txtPublishDate.Text = DateTime.Now.ToString("yyyy-MM-dd");

                // Set default publish time to current time
                txtPublishTime.Text = DateTime.Now.ToString("HH:mm");
            }
        }

        protected void btnSaveCourse_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    // Get form values
                    string courseName = txtCourseName.Text.Trim();
                    DateTime publishDate = Convert.ToDateTime(txtPublishDate.Text);
                    TimeSpan publishTime = TimeSpan.Parse(txtPublishTime.Text);
                    string moduleType = ddlModuleType.SelectedValue;
                    string duration = txtDuration.Text.Trim();
                    string skillLevel = ddlSkillLevel.SelectedValue;
                    string language = ddlLanguage.SelectedValue;

                    // Handle file uploads
                    string coverImagePath = SaveCoverImage();
                    string resourceFilePath = SaveResourceFile();

                    // Save to database
                    if (SaveCourseToDatabase(courseName, coverImagePath, resourceFilePath, publishDate, publishTime, moduleType, duration, skillLevel, language))
                    {
                        lblMessage.Text = "Course saved successfully!";
                        lblMessage.CssClass = "success-message";
                        ClearForm();
                    }
                    else
                    {
                        lblMessage.Text = "Failed to save course. Please try again.";
                        lblMessage.CssClass = "error-message";
                    }
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Error: " + ex.Message;
                    lblMessage.CssClass = "error-message";
                    System.Diagnostics.Debug.WriteLine("Error saving course: " + ex.ToString());
                }
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        private string SaveCoverImage()
        {
            string fileName = "";

            if (fuCoverImage.HasFile)
            {
                try
                {
                    // Validate file type
                    string[] allowedExtensions = { ".jpg", ".jpeg", ".png", ".gif", ".bmp" };
                    string fileExtension = Path.GetExtension(fuCoverImage.FileName).ToLower();

                    if (!allowedExtensions.Contains(fileExtension))
                    {
                        throw new Exception("Invalid image format. Please upload JPG, PNG, GIF, or BMP files only.");
                    }

                    // Validate file size (5MB max)
                    if (fuCoverImage.PostedFile.ContentLength > 5 * 1024 * 1024)
                    {
                        throw new Exception("Cover image file size must be less than 5MB.");
                    }

                    // Create upload directory if it doesn't exist
                    string uploadPath = Server.MapPath("~/Uploads/CoverImages/");
                    if (!Directory.Exists(uploadPath))
                    {
                        Directory.CreateDirectory(uploadPath);
                    }

                    // Generate unique filename
                    fileName = DateTime.Now.Ticks + "_" + Path.GetFileName(fuCoverImage.FileName);
                    string fullPath = Path.Combine(uploadPath, fileName);

                    // Save the file
                    fuCoverImage.SaveAs(fullPath);

                    // Return relative path for database storage
                    return "~/Uploads/CoverImages/" + fileName;
                }
                catch (Exception ex)
                {
                    throw new Exception("Error uploading cover image: " + ex.Message);
                }
            }

            return null; // No file uploaded
        }

        private string SaveResourceFile()
        {
            string fileName = "";

            if (fuResourceFile.HasFile)
            {
                try
                {
                    // Validate file type
                    string[] allowedExtensions = { ".pdf", ".doc", ".docx", ".ppt", ".pptx", ".zip", ".rar", ".txt", ".xls", ".xlsx" };
                    string fileExtension = Path.GetExtension(fuResourceFile.FileName).ToLower();

                    if (!allowedExtensions.Contains(fileExtension))
                    {
                        throw new Exception("Invalid resource file format. Please upload PDF, DOC, PPT, ZIP, or other document files only.");
                    }

                    // Validate file size (50MB max)
                    if (fuResourceFile.PostedFile.ContentLength > 50 * 1024 * 1024)
                    {
                        throw new Exception("Resource file size must be less than 50MB.");
                    }

                    // Create upload directory if it doesn't exist
                    string uploadPath = Server.MapPath("~/Uploads/ResourceFiles/");
                    if (!Directory.Exists(uploadPath))
                    {
                        Directory.CreateDirectory(uploadPath);
                    }

                    // Generate unique filename
                    fileName = DateTime.Now.Ticks + "_" + Path.GetFileName(fuResourceFile.FileName);
                    string fullPath = Path.Combine(uploadPath, fileName);

                    // Save the file
                    fuResourceFile.SaveAs(fullPath);

                    // Return relative path for database storage
                    return "~/Uploads/ResourceFiles/" + fileName;
                }
                catch (Exception ex)
                {
                    throw new Exception("Error uploading resource file: " + ex.Message);
                }
            }

            return null; // No file uploaded
        }

        private bool SaveCourseToDatabase(string courseName, string coverImagePath, string resourceFilePath, DateTime publishDate, TimeSpan publishTime, string moduleType, string duration, string skillLevel, string language)
        {
            bool success = false;

            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"INSERT INTO TeacherCourses 
                                   (TC_CourseName, TC_CoverImage, TC_ResourceFile, TC_PublishDate, TC_PublishTime, TC_ModuleType, TC_Duration, TC_SkillLevel, TC_Language) 
                                   VALUES 
                                   (@CourseName, @CoverImage, @ResourceFile, @PublishDate, @PublishTime, @ModuleType, @Duration, @SkillLevel, @Language)";

                    SqlCommand command = new SqlCommand(query, connection);

                    // Add parameters
                    command.Parameters.AddWithValue("@CourseName", courseName);
                    command.Parameters.AddWithValue("@CoverImage", (object)coverImagePath ?? DBNull.Value);
                    command.Parameters.AddWithValue("@ResourceFile", (object)resourceFilePath ?? DBNull.Value);
                    command.Parameters.AddWithValue("@PublishDate", publishDate);
                    command.Parameters.AddWithValue("@PublishTime", publishTime);
                    command.Parameters.AddWithValue("@ModuleType", moduleType);
                    command.Parameters.AddWithValue("@Duration", duration);
                    command.Parameters.AddWithValue("@SkillLevel", skillLevel);
                    command.Parameters.AddWithValue("@Language", language);

                    connection.Open();
                    int result = command.ExecuteNonQuery();
                    success = (result > 0);

                    System.Diagnostics.Debug.WriteLine("Course saved successfully. Rows affected: " + result);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error saving course to database: " + ex.ToString());
                throw new Exception("Database error while saving course: " + ex.Message);
            }

            return success;
        }

        private void ClearForm()
        {
            txtCourseName.Text = string.Empty;
            txtPublishDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            txtPublishTime.Text = DateTime.Now.ToString("HH:mm");
            ddlModuleType.SelectedIndex = 0;
            txtDuration.Text = string.Empty;
            ddlSkillLevel.SelectedIndex = 0;
            ddlLanguage.SelectedIndex = 0;
            lblMessage.Text = string.Empty;
        }
    }
}