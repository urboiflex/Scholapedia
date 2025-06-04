using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.HtmlControls;
using System.Collections.Generic;
using System.Text;
using System.Web.Services;
using System.Web.Script.Services;
using System.Web.Script.Serialization;

namespace WAPPSS
{
    public partial class course : System.Web.UI.Page
    {
        private List<DateTime> userClassDates = new List<DateTime>();

        // Properties for navbar profile information
        protected string NavbarUserName = "User";
        protected string NavbarProfilePic = "images/Profiles/default.jpg";
        protected string NavbarProfilePicResolved = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Load navbar profile information first
            LoadNavbarProfileInfo();

            ApplyDarkModeIfNeeded();

            if (!IsPostBack)
            {
                SetWelcomeMessage();
                LoadCourseCards();
                LoadUserClassDates();
            }
        }

        private void LoadNavbarProfileInfo()
        {
            if (Session["UserID"] != null)
            {
                string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                try
                {
                    using (var conn = new SqlConnection(connStr))
                    {
                        conn.Open();
                        using (var cmd = new SqlCommand(
                            "SELECT u.FirstName, pt.ProfilePic FROM Users u LEFT JOIN ProfileTC pt ON u.UserID = pt.UserID WHERE u.UserID = @UserID", conn))
                        {
                            cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                            using (var rdr = cmd.ExecuteReader())
                            {
                                if (rdr.Read())
                                {
                                    // Get first name
                                    NavbarUserName = (rdr["FirstName"] != DBNull.Value && rdr["FirstName"] != null)
                                        ? rdr["FirstName"].ToString()
                                        : "User";

                                    // Get profile picture path
                                    string dbProfilePic = rdr["ProfilePic"] != DBNull.Value && !string.IsNullOrEmpty(rdr["ProfilePic"].ToString())
                                        ? rdr["ProfilePic"].ToString()
                                        : "";

                                    // Set profile picture path with proper fallback
                                    if (!string.IsNullOrEmpty(dbProfilePic))
                                    {
                                        NavbarProfilePic = dbProfilePic;
                                    }
                                    else
                                    {
                                        NavbarProfilePic = "images/Profiles/default.jpg";
                                    }
                                }
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error loading navbar profile info: {ex.Message}");
                    // Keep default values on error
                }
            }

            // Resolve the URL properly
            try
            {
                NavbarProfilePicResolved = ResolveUrl("~/" + NavbarProfilePic.TrimStart('~', '/'));
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error resolving profile picture URL: {ex.Message}");
                NavbarProfilePicResolved = ResolveUrl("~/images/Profiles/default.jpg");
            }
        }

        private void ApplyDarkModeIfNeeded()
        {
            string modeType = "light";

            // Only check dark mode for the current user
            if (Session["UserID"] != null)
            {
                string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                try
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        string query = "SELECT ModeType FROM Mode WHERE UserID = @UserID";
                        SqlCommand cmd = new SqlCommand(query, conn);
                        cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                        conn.Open();
                        object result = cmd.ExecuteScalar();
                        if (result != null)
                        {
                            modeType = result.ToString().ToLower();
                        }
                    }
                }
                catch (Exception ex)
                {
                    // If Mode table doesn't exist or any error occurs, default to light mode
                    System.Diagnostics.Debug.WriteLine($"Error loading mode: {ex.Message}");
                }
            }

            if (modeType == "dark")
            {
                HtmlGenericControl body = (HtmlGenericControl)this.FindControl("bodyTag");
                if (body != null)
                {
                    body.Attributes["class"] = "dark-mode";
                }
            }
        }

        private void LoadUserClassDates()
        {
            userClassDates.Clear();
            if (Session["UserID"] == null)
                return;

            string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            int userId = Convert.ToInt32(Session["UserID"]);

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Check if both ClassSchedule and TeacherCourses tables exist
                    SqlCommand checkTableCmd = new SqlCommand(
                        @"SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES 
                          WHERE TABLE_NAME IN ('ClassSchedule', 'TeacherCourses')", conn);
                    int tablesExist = (int)checkTableCmd.ExecuteScalar();

                    if (tablesExist < 2)
                    {
                        // Tables don't exist, skip loading class dates
                        return;
                    }

                    // Query to get class dates for the user
                    SqlCommand cmd = new SqlCommand(
                        @"SELECT cs.ClassDate 
                          FROM ClassSchedule cs 
                          INNER JOIN TeacherCourses tc ON cs.TC_ID = tc.TC_ID 
                          WHERE tc.UserID = @UserID", conn);
                    cmd.Parameters.AddWithValue("@UserID", userId);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            if (reader["ClassDate"] != DBNull.Value)
                            {
                                DateTime classDate = Convert.ToDateTime(reader["ClassDate"]);
                                userClassDates.Add(classDate.Date);
                            }
                        }
                    }
                }
            }
            catch (SqlException ex)
            {
                // Handle SQL exceptions gracefully
                System.Diagnostics.Debug.WriteLine($"Error loading class dates: {ex.Message}");
            }
            catch (Exception ex)
            {
                // Handle other exceptions
                System.Diagnostics.Debug.WriteLine($"General error loading class dates: {ex.Message}");
            }
        }

        // Method to convert class dates to JSON for JavaScript
        protected string GetClassDatesJson()
        {
            try
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                List<string> dateStrings = new List<string>();

                foreach (DateTime date in userClassDates)
                {
                    dateStrings.Add(date.ToString("yyyy-MM-dd"));
                }

                return serializer.Serialize(dateStrings);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error serializing class dates: {ex.Message}");
                return "[]"; // Return empty array on error
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetClassDetailsForDate(string dateString)
        {
            try
            {
                DateTime date = DateTime.Parse(dateString);
                return GetClassDetailsForDateInternal(date);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in WebMethod: {ex.Message}");
                return "<p>Error loading class details. Please try again later.</p>";
            }
        }

        private static string GetClassDetailsForDateInternal(DateTime date)
        {
            // Get UserID from session
            var context = System.Web.HttpContext.Current;
            if (context?.Session["UserID"] == null)
                return "<p>Session expired. Please <a href='login.aspx'>login again</a>.</p>";

            string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            int userId = Convert.ToInt32(context.Session["UserID"]);
            StringBuilder classDetails = new StringBuilder();

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Check if tables exist
                    SqlCommand checkTableCmd = new SqlCommand(
                        @"SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES 
                          WHERE TABLE_NAME IN ('ClassSchedule', 'TeacherCourses')", conn);
                    int tablesExist = (int)checkTableCmd.ExecuteScalar();

                    if (tablesExist < 2)
                    {
                        return "<p>Class schedule information is not available.</p>";
                    }

                    // Get class details for the specific date
                    SqlCommand cmd = new SqlCommand(
                        @"SELECT cs.ClassTime, tc.TC_CourseName, tc.TC_ModuleType, cs.ScheduleID
                          FROM ClassSchedule cs 
                          INNER JOIN TeacherCourses tc ON cs.TC_ID = tc.TC_ID 
                          WHERE tc.UserID = @UserID AND cs.ClassDate = @ClassDate
                          ORDER BY cs.ClassTime", conn);

                    cmd.Parameters.AddWithValue("@UserID", userId);
                    cmd.Parameters.AddWithValue("@ClassDate", date.Date);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (!reader.HasRows)
                        {
                            return "<p>No classes scheduled for this date.</p>";
                        }

                        classDetails.Append("<div class='class-details-list'>");

                        while (reader.Read())
                        {
                            string courseName = System.Web.HttpUtility.HtmlEncode(reader["TC_CourseName"].ToString());
                            string moduleType = System.Web.HttpUtility.HtmlEncode(reader["TC_ModuleType"].ToString());
                            TimeSpan classTime = (TimeSpan)reader["ClassTime"];
                            int scheduleId = Convert.ToInt32(reader["ScheduleID"]);

                            // Format time to 12-hour format
                            DateTime timeAsDateTime = DateTime.Today.Add(classTime);
                            string formattedTime = timeAsDateTime.ToString("h:mm tt");

                            // Determine module type color
                            string moduleColor = moduleType.ToLower() == "synchronous" ? "#20bf6b" : "#eb3b5a";

                            classDetails.Append($@"
                                <div class='class-item'>
                                    <div class='class-header'>
                                        <h3 class='course-name'>{courseName}</h3>
                                        <span class='module-type' style='background-color: {moduleColor}'>{moduleType}</span>
                                    </div>
                                    <div class='class-info'>
                                        <div class='time-info'>
                                            <i class='fas fa-clock'></i>
                                            <span>{formattedTime}</span>
                                        </div>
                                        <div class='schedule-id'>
                                            <i class='fas fa-calendar-alt'></i>
                                            <span>Schedule ID: {scheduleId}</span>
                                        </div>
                                    </div>
                                </div>
                            ");
                        }

                        classDetails.Append("</div>");
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error getting class details: {ex.Message}");
                return "<p>Error loading class details. Please try again later.</p>";
            }

            return classDetails.ToString();
        }

        private void SetWelcomeMessage()
        {
            string firstName = "User";
            if (Session["FirstName"] != null)
                firstName = Session["FirstName"].ToString();
            else if (Session["UserID"] != null)
            {
                string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                try
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        conn.Open();
                        SqlCommand cmd = new SqlCommand("SELECT FirstName FROM Users WHERE UserID=@UserID", conn);
                        cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                        object result = cmd.ExecuteScalar();
                        if (result != null)
                            firstName = result.ToString();
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error loading user name: {ex.Message}");
                }
            }
            lblUserName.Text = firstName;
        }

        private void LoadCourseCards()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            int userId = Session["UserID"] != null ? Convert.ToInt32(Session["UserID"]) : 0;
            if (userId == 0)
                return;

            string instructorName = "Instructor";

            try
            {
                // Get the FirstName of the logged in user
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("SELECT FirstName FROM Users WHERE UserID = @UserID", conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        object result = cmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            instructorName = result.ToString();
                        }
                    }

                    // Check if TeacherCourses table exists and load courses
                    SqlCommand checkTableCmd = new SqlCommand(
                        "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TeacherCourses'", conn);
                    int tableExists = (int)checkTableCmd.ExecuteScalar();

                    if (tableExists > 0)
                    {
                        SqlCommand cmdCourses = new SqlCommand("SELECT TC_CourseName, TC_ModuleType, TC_CoverImage FROM TeacherCourses WHERE UserID = @UserID", conn);
                        cmdCourses.Parameters.AddWithValue("@UserID", userId);
                        SqlDataReader reader = cmdCourses.ExecuteReader();

                        HtmlGenericControl cardsContainer = new HtmlGenericControl("div");
                        cardsContainer.Attributes["class"] = "course-cards";

                        while (reader.Read())
                        {
                            string courseName = reader["TC_CourseName"].ToString();
                            string moduleType = reader["TC_ModuleType"].ToString();
                            string coverImagePath = reader["TC_CoverImage"] != DBNull.Value ?
                                reader["TC_CoverImage"].ToString() :
                                "Images/Covers/default-course.jpg";

                            string fullImagePath = ResolveUrl("~/" + coverImagePath.TrimStart('~', '/'));

                            HtmlGenericControl courseCard = new HtmlGenericControl("div");
                            courseCard.Attributes["class"] = "course-card";
                            courseCard.Style["opacity"] = "0";

                            string courseCardHtml = $@"
                <span class='course-mode {(moduleType.ToLower() == "asynchronous" ? "asynchronous" : "synchronous")}'>
                    {moduleType}
                </span>
                <img src='{fullImagePath}' alt='{courseName}' class='course-cover-img' />
                <h3>{courseName}</h3>
                <div class='course-info'>
                    <i class='fa fa-user'></i>
                    <span class='person-name'>{instructorName}</span>
                    <i class='fa fa-star'></i>
                    <span class='rating'>4.5</span>
                </div>
                <div class='view-details-container'>
                    <a href='course_detail.aspx?course={Server.UrlEncode(courseName)}' class='view-details-btn'>
                        View Details
                    </a>
                </div>";

                            courseCard.InnerHtml = courseCardHtml;
                            cardsContainer.Controls.Add(courseCard);
                        }

                        courseCardsWrapper.Controls.Add(cardsContainer);
                        reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading course cards: {ex.Message}");
            }
        }
    }
}