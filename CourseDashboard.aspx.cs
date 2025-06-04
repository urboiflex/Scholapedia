using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WAPPSS
{
    public partial class CourseDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadEnrolledCourses();
                LoadUserIcon();
                LoadStudentDetails();
            }
            if (Session["DarkMode"] != null && (bool)Session["DarkMode"])
            {
                darkModeCss.Href = "darkmode.css";
            }
        }

        private void LoadEnrolledCourses()
        {
            int userId = Convert.ToInt32(Session["UserID"]); // Student ID

            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Corrected query with proper column name
                string query = @"
            SELECT 
                tc.TC_ID, 
                tc.TC_CourseName, 
                tc.TC_CoverImage, 
                tc.TC_ModuleType,
                tc.UserID AS TeacherUserID,
                u.FirstName AS InstructorName
            FROM CourseStudents cs
            JOIN TeacherCourses tc ON cs.TC_ID = tc.TC_ID
            JOIN Users u ON tc.UserID = u.UserID
            WHERE cs.UserID = @UserID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);

                    try
                    {
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();
                        rptCourses.DataSource = reader;
                        rptCourses.DataBind();

                        // Debug: Check if any records were found
                        if (!reader.HasRows)
                        {
                            System.Diagnostics.Debug.WriteLine($"No courses found for UserID: {userId}");
                        }
                        else
                        {
                            System.Diagnostics.Debug.WriteLine($"Courses loaded successfully for UserID: {userId}");
                        }
                    }
                    catch (SqlException ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Database error: " + ex.Message);
                        // Create empty result set to prevent page crash
                        rptCourses.DataSource = null;
                        rptCourses.DataBind();
                    }
                }
            }
        }

        private void LoadEnrolledCoursesAlternative(int userId, string connStr)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Alternative query in case TeacherCourses has different column name for teacher ID
                string query = @"
                SELECT 
                    tc.TC_ID, 
                    tc.TC_CourseName, 
                    tc.TC_CoverImage, 
                    tc.TC_ModuleType,
                    tc.TeacherID,
                    u.FirstName AS InstructorName
                FROM CourseStudents cs
                JOIN TeacherCourses tc ON cs.TC_ID = tc.TC_ID
                JOIN Users u ON tc.TeacherID = u.UserID
                WHERE cs.UserID = @UserID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);

                    try
                    {
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();
                        rptCourses.DataSource = reader;
                        rptCourses.DataBind();

                        // Debug: Check if any records were found
                        if (!reader.HasRows)
                        {
                            System.Diagnostics.Debug.WriteLine($"No courses found for UserID: {userId} (Alternative query)");
                        }
                    }
                    catch (SqlException ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Database error (Alternative): " + ex.Message);

                        // If both queries fail, try without instructor name join
                        conn.Close();
                        LoadCoursesWithoutInstructor(userId, connStr);
                    }
                }
            }
        }

        private void LoadCoursesWithoutInstructor(int userId, string connStr)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Simplified query without instructor join to isolate the issue
                string query = @"
                SELECT 
                    tc.TC_ID, 
                    tc.TC_CourseName, 
                    tc.TC_CoverImage, 
                    tc.TC_ModuleType,
                    'Unknown' AS InstructorName
                FROM CourseStudents cs
                JOIN TeacherCourses tc ON cs.TC_ID = tc.TC_ID
                WHERE cs.UserID = @UserID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);

                    try
                    {
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();
                        rptCourses.DataSource = reader;
                        rptCourses.DataBind();

                        // Debug output
                        if (!reader.HasRows)
                        {
                            System.Diagnostics.Debug.WriteLine($"No courses found for UserID: {userId} (Simplified query)");
                        }
                        else
                        {
                            System.Diagnostics.Debug.WriteLine($"Courses found for UserID: {userId}");
                        }
                    }
                    catch (SqlException ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Database error (Simplified): " + ex.Message);
                        // Create empty result set to prevent page crash
                        rptCourses.DataSource = null;
                        rptCourses.DataBind();
                    }
                }
            }
        }

        protected string GetModuleTypeLabel(string moduleType)
        {
            // Sanitize and convert text to lowercase for safe comparison
            var mt = moduleType?.ToLowerInvariant() ?? "";

            if (mt == "synchronous")
                return "<span class='course-mode synchronous'>Synchronous</span>";
            else if (mt == "asynchronous")
                return "<span class='course-mode asynchronous'>Asynchronous</span>";
            else
                return $"<span class='course-mode'>{moduleType}</span>";
        }

        private void LoadUserIcon()
        {
            try
            {
                string userId = Session["UserID"]?.ToString();
                if (string.IsNullOrEmpty(userId))
                {
                    userIcon.ImageUrl = ResolveUrl("~/icons/default.jpg");
                    return;
                }

                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "SELECT ProfilePic FROM ProfileTC WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);

                        conn.Open();
                        object result = cmd.ExecuteScalar();

                        if (result != null && result != DBNull.Value)
                        {
                            string profilePicPath = result.ToString();
                            System.Diagnostics.Debug.WriteLine($"Profile pic from DB: {profilePicPath}");

                            // Check if the path already includes a folder structure
                            if (profilePicPath.Contains("/") || profilePicPath.Contains("\\"))
                            {
                                // Path already includes folder, use as-is
                                userIcon.ImageUrl = ResolveUrl("~/" + profilePicPath.TrimStart('~', '/', '\\'));
                            }
                            else
                            {
                                // Just filename, assume it's in icons folder
                                userIcon.ImageUrl = ResolveUrl("~/icons/" + profilePicPath);
                            }

                            System.Diagnostics.Debug.WriteLine($"Final image URL: {userIcon.ImageUrl}");
                        }
                        else
                        {
                            // No profile picture found, use default
                            userIcon.ImageUrl = ResolveUrl("~/icons/default.jpg");
                            System.Diagnostics.Debug.WriteLine("No profile picture found, using default");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading user icon: " + ex.Message);
                userIcon.ImageUrl = ResolveUrl("~/icons/default.jpg"); // Fallback
            }
        }

        private void LoadStudentDetails()
        {
            try
            {
                string userId = Session["UserID"]?.ToString(); // Ensure UserID is stored in session
                if (string.IsNullOrEmpty(userId)) return;

                string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "SELECT Username, Email FROM Users WHERE UserID = @UserID";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UserID", userId);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        lblStudentName.Text = reader["Username"].ToString();
                        // You can also access reader["Email"] here if needed
                    }
                }
            }
            catch (Exception ex)
            {
                // Handle error gracefully
                lblStudentName.Text = "Student"; // fallback
                System.Diagnostics.Debug.WriteLine("Error loading student details: " + ex.Message);
            }
        }

        protected void rptCourses_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // Implementation for course commands if needed
        }

        // Add this method to help debug the issue
        private void DebugCourseAssignments()
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Check if the user has any course assignments
                string checkQuery = "SELECT COUNT(*) FROM CourseStudents WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(checkQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    int count = (int)cmd.ExecuteScalar();
                    System.Diagnostics.Debug.WriteLine($"Total course assignments for UserID {userId}: {count}");
                }

                // List all course assignments for this user
                string listQuery = "SELECT TC_ID, UserID FROM CourseStudents WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(listQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            System.Diagnostics.Debug.WriteLine($"Course Assignment - TC_ID: {reader["TC_ID"]}, UserID: {reader["UserID"]}");
                        }
                    }
                }
            }
        }
    }
}