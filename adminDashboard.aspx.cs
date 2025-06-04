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

namespace WAPPSS
{
    public partial class adminDashboard : System.Web.UI.Page
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
                // Load admin information in the header
                LoadAdminInfo();

                // Load dashboard statistics
                LoadDashboardStats();

                // Load dashboard tables
                LoadRecentFeedbacks();
                LoadRecentUsers();
                LoadPopularCourses();
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

                        // Update the admin display
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

        private void LoadDashboardStats()
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    // Get total users from Users table
                    string userQuery = "SELECT COUNT(*) FROM Users";
                    SqlCommand userCmd = new SqlCommand(userQuery, connection);
                    int totalUsers = (int)userCmd.ExecuteScalar();
                    litTotalUsers.Text = totalUsers.ToString("N0"); // Format with comma separators

                    // Get total courses from TeacherCourses table
                    string courseQuery = "SELECT COUNT(*) FROM TeacherCourses";
                    SqlCommand courseCmd = new SqlCommand(courseQuery, connection);
                    int totalCourses = (int)courseCmd.ExecuteScalar();
                    litTotalCourses.Text = totalCourses.ToString("N0");

                    // Get total announcements from Announcements table
                    string announcementQuery = "SELECT COUNT(*) FROM Announcements";
                    SqlCommand announcementCmd = new SqlCommand(announcementQuery, connection);
                    int totalAnnouncements = (int)announcementCmd.ExecuteScalar();
                    litTotalAnnouncements.Text = totalAnnouncements.ToString("N0");

                    // Get total feedback from Feedback table
                    string feedbackQuery = "SELECT COUNT(*) FROM Feedback";
                    SqlCommand feedbackCmd = new SqlCommand(feedbackQuery, connection);
                    int totalFeedback = (int)feedbackCmd.ExecuteScalar();
                    litTotalFeedback.Text = totalFeedback.ToString("N0");
                }
            }
            catch (Exception ex)
            {
                // Log the exception
                System.Diagnostics.Debug.WriteLine("Error loading dashboard stats: " + ex.Message);
                // Set default values
                litTotalUsers.Text = "0";
                litTotalCourses.Text = "0";
                litTotalAnnouncements.Text = "0";
                litTotalFeedback.Text = "0";
            }
        }

        private void LoadRecentFeedbacks()
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT TOP 5 
                            f.FeedbackId,
                            f.Content as FeedbackText,
                            f.Category,
                            f.FeedbackDate as SubmissionDate,
                            u.Username,
                            5 as Rating
                        FROM Feedback f
                        INNER JOIN Users u ON f.UserID = u.UserID
                        ORDER BY f.FeedbackDate DESC";

                    SqlCommand command = new SqlCommand(query, connection);
                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    DataTable dataTable = new DataTable();

                    connection.Open();
                    adapter.Fill(dataTable);

                    gvRecentFeedbacks.DataSource = dataTable;
                    gvRecentFeedbacks.DataBind();
                }
            }
            catch (Exception ex)
            {
                // Log the exception
                System.Diagnostics.Debug.WriteLine("Error loading recent feedbacks: " + ex.Message);
                gvRecentFeedbacks.DataSource = null;
                gvRecentFeedbacks.DataBind();
            }
        }

        private void LoadRecentUsers()
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT TOP 5 
                            UserID,
                            Username,
                            Email,
                            DateRegistered as RegistrationDate,
                            'Active' as Status
                        FROM Users
                        ORDER BY DateRegistered DESC";

                    SqlCommand command = new SqlCommand(query, connection);
                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    DataTable dataTable = new DataTable();

                    connection.Open();
                    adapter.Fill(dataTable);

                    gvRecentUsers.DataSource = dataTable;
                    gvRecentUsers.DataBind();
                }
            }
            catch (Exception ex)
            {
                // Log the exception
                System.Diagnostics.Debug.WriteLine("Error loading recent users: " + ex.Message);
                gvRecentUsers.DataSource = null;
                gvRecentUsers.DataBind();
            }
        }

        private void LoadPopularCourses()
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT TOP 5 
                            TC_ID as CourseID,
                            TC_CourseName as CourseName,
                            TC_CoverImage as CoverImage,
                            TC_SkillLevel as SkillLevel,
                            'Teacher' as CreatorUsername,
                            TC_ID as EnrollmentCount
                        FROM TeacherCourses
                        ORDER BY TC_PublishDate DESC, TC_PublishTime DESC";

                    SqlCommand command = new SqlCommand(query, connection);
                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    DataTable dataTable = new DataTable();

                    connection.Open();
                    adapter.Fill(dataTable);

                    gvPopularCourses.DataSource = dataTable;
                    gvPopularCourses.DataBind();
                }
            }
            catch (Exception ex)
            {
                // Log the exception
                System.Diagnostics.Debug.WriteLine("Error loading popular courses: " + ex.Message);
                gvPopularCourses.DataSource = null;
                gvPopularCourses.DataBind();
            }
        }

        // Helper methods for formatting data
        protected string GetUserInitial(object username)
        {
            if (username != null && username != DBNull.Value)
            {
                string name = username.ToString();
                return name.Length > 0 ? name[0].ToString().ToUpper() : "U";
            }
            return "U";
        }

        protected string TruncateText(string text, int maxLength)
        {
            if (string.IsNullOrEmpty(text))
                return "";

            if (text.Length <= maxLength)
                return text;

            return text.Substring(0, maxLength) + "...";
        }

        protected string GenerateStars(int rating)
        {
            StringBuilder stars = new StringBuilder();

            for (int i = 1; i <= 5; i++)
            {
                if (i <= rating)
                {
                    stars.Append("<i class='fas fa-star' style='color: #ffc107;'></i>");
                }
                else
                {
                    stars.Append("<i class='far fa-star' style='color: #ddd;'></i>");
                }
            }

            return stars.ToString();
        }

        protected string FormatDateTime(object dateTime)
        {
            if (dateTime != null && dateTime != DBNull.Value)
            {
                DateTime dt = Convert.ToDateTime(dateTime);

                // If it's today, show time
                if (dt.Date == DateTime.Today)
                {
                    return "Today " + dt.ToString("HH:mm");
                }
                // If it's yesterday
                else if (dt.Date == DateTime.Today.AddDays(-1))
                {
                    return "Yesterday " + dt.ToString("HH:mm");
                }
                // If it's within a week
                else if (dt >= DateTime.Today.AddDays(-7))
                {
                    return dt.ToString("ddd HH:mm");
                }
                // Otherwise show date
                else
                {
                    return dt.ToString("MMM dd, yyyy");
                }
            }
            return "";
        }

        protected string GetCourseImage(object coverImage)
        {
            if (coverImage != null && coverImage != DBNull.Value && !string.IsNullOrEmpty(coverImage.ToString()))
            {
                string imagePath = coverImage.ToString();

                // Check if it's already a full URL
                if (imagePath.StartsWith("http://") || imagePath.StartsWith("https://"))
                {
                    return imagePath;
                }

                // If it's a relative path, make it absolute
                if (imagePath.StartsWith("~/"))
                {
                    return ResolveUrl(imagePath);
                }

                // If it's just a filename, assume it's in the images folder
                if (!imagePath.StartsWith("/"))
                {
                    imagePath = "~/images/courses/" + imagePath;
                }

                return ResolveUrl(imagePath);
            }

            // Return a default image if no cover image is specified
            return ResolveUrl("~/images/default-course.png");
        }
    }
}