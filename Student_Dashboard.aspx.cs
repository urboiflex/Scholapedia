using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Text;
using System.Web.Services;
using System.Web.Script.Services;

namespace WAPPSS
{
    public partial class Student_Dashboard : System.Web.UI.Page
    {
        private List<DateTime> userEventDates = new List<DateTime>();

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    if (Session["FirstName"] != null)
                    {
                        lblUserName.Text = Session["FirstName"].ToString();
                    }
                    else
                    {
                        // If not logged in, redirect to login page
                        Response.Redirect("login.aspx");
                        return;
                    }
                }

                LoadUserIcon();
                LoadStudentDetails();
                LoadEventsData();
                LoadUserEventDates(); // Calendar functionality

                // Handle dark mode
                if (Session["DarkMode"] != null && (bool)Session["DarkMode"] == true)
                {
                    darkModeCss.Href = "darkmode.css";
                }
            }
            catch (Exception ex)
            {
                // Log the error and handle gracefully
                System.Diagnostics.Debug.WriteLine("Error in Page_Load: " + ex.Message);
                // Initialize with empty events data if there's an error
                hiddenEventData.Value = "[]";
            }
        }

        // Load user event dates for calendar highlighting
        private void LoadUserEventDates()
        {
            userEventDates.Clear();
            if (Session["UserID"] == null)
                return;

            string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            int userId = Convert.ToInt32(Session["UserID"]);

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Check if EventSchedule table exists
                    SqlCommand checkTableCmd = new SqlCommand(
                        @"SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES 
                          WHERE TABLE_NAME = 'EventSchedule'", conn);
                    int tableExists = (int)checkTableCmd.ExecuteScalar();

                    if (tableExists == 0)
                    {
                        // Table doesn't exist, skip loading event dates
                        return;
                    }

                    // Query to get event dates for the user
                    SqlCommand cmd = new SqlCommand(
                        @"SELECT EventDate 
                          FROM EventSchedule 
                          WHERE UserID = @UserID", conn);
                    cmd.Parameters.AddWithValue("@UserID", userId);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            if (reader["EventDate"] != DBNull.Value)
                            {
                                DateTime eventDate = Convert.ToDateTime(reader["EventDate"]);
                                userEventDates.Add(eventDate.Date);
                            }
                        }
                    }
                }
            }
            catch (SqlException ex)
            {
                // Handle SQL exceptions gracefully
                System.Diagnostics.Debug.WriteLine($"Error loading event dates: {ex.Message}");
            }
            catch (Exception ex)
            {
                // Handle other exceptions
                System.Diagnostics.Debug.WriteLine($"General error loading event dates: {ex.Message}");
            }
        }

        // Method to convert event dates to JSON for JavaScript
        protected string GetEventDatesJson()
        {
            try
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                List<string> dateStrings = new List<string>();

                foreach (DateTime date in userEventDates)
                {
                    dateStrings.Add(date.ToString("yyyy-MM-dd"));
                }

                return serializer.Serialize(dateStrings);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error serializing event dates: {ex.Message}");
                return "[]"; // Return empty array on error
            }
        }

        // WebMethod to get event details for a specific date (for calendar modal)
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetEventDetailsForDate(string dateString)
        {
            try
            {
                DateTime date = DateTime.Parse(dateString);
                return GetEventDetailsForDateInternal(date);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in WebMethod: {ex.Message}");
                return "<p>Error loading event details. Please try again later.</p>";
            }
        }

        private static string GetEventDetailsForDateInternal(DateTime date)
        {
            // Get UserID from session
            var context = System.Web.HttpContext.Current;
            if (context?.Session["UserID"] == null)
                return "<p>Session expired. Please <a href='login.aspx'>login again</a>.</p>";

            string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            int userId = Convert.ToInt32(context.Session["UserID"]);
            StringBuilder eventDetails = new StringBuilder();

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Check if EventSchedule table exists
                    SqlCommand checkTableCmd = new SqlCommand(
                        @"SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES 
                          WHERE TABLE_NAME = 'EventSchedule'", conn);
                    int tableExists = (int)checkTableCmd.ExecuteScalar();

                    if (tableExists == 0)
                    {
                        return "<p>Event schedule information is not available.</p>";
                    }

                    // Get event details for the specific date
                    SqlCommand cmd = new SqlCommand(
                        @"SELECT EventID, EventTitle, EventDescription
                          FROM EventSchedule 
                          WHERE UserID = @UserID AND EventDate = @EventDate
                          ORDER BY EventTitle", conn);

                    cmd.Parameters.AddWithValue("@UserID", userId);
                    cmd.Parameters.AddWithValue("@EventDate", date.Date);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (!reader.HasRows)
                        {
                            return "<p>No events scheduled for this date.</p>";
                        }

                        eventDetails.Append("<div class='event-details-list'>");

                        while (reader.Read())
                        {
                            string eventTitle = System.Web.HttpUtility.HtmlEncode(reader["EventTitle"].ToString());
                            string eventDescription = reader["EventDescription"] != DBNull.Value
                                ? System.Web.HttpUtility.HtmlEncode(reader["EventDescription"].ToString())
                                : "No description provided";
                            int eventId = Convert.ToInt32(reader["EventID"]);

                            eventDetails.Append($@"
                                <div class='event-item'>
                                    <div class='event-header'>
                                        <h3 class='event-title'>{eventTitle}</h3>
                                    </div>
                                    <div class='event-info'>
                                        <p class='event-description'>{eventDescription}</p>
                                        <div class='event-id'>
                                            <i class='fas fa-calendar-alt'></i>
                                            <span>Event ID: {eventId}</span>
                                        </div>
                                    </div>
                                </div>
                            ");
                        }

                        eventDetails.Append("</div>");
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error getting event details: {ex.Message}");
                return "<p>Error loading event details. Please try again later.</p>";
            }

            return eventDetails.ToString();
        }

        private void LoadStudentDetails()
        {
            string userId = Session["UserID"]?.ToString();
            if (string.IsNullOrEmpty(userId)) return;

            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "SELECT Username, Email FROM Users WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);

                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                lblStudentName.Text = reader["Username"].ToString();
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in LoadStudentDetails: " + ex.Message);
                lblStudentName.Text = "Student"; // Fallback
            }
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
                System.Diagnostics.Debug.WriteLine("Error in LoadUserIcon: " + ex.Message);
                userIcon.ImageUrl = ResolveUrl("~/icons/default.jpg"); // Fallback
            }
        }

        private void LoadEventsData()
        {
            try
            {
                string userId = Session["UserID"]?.ToString();
                if (string.IsNullOrEmpty(userId))
                {
                    hiddenEventData.Value = "[]";
                    return;
                }

                List<Dictionary<string, string>> eventsList = new List<Dictionary<string, string>>();
                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // Try the new EventSchedule table first
                    string query = @"SELECT EventTitle as EventName, EventDescription, EventDate, 'General' as Category 
                                   FROM EventSchedule WHERE UserID = @UserID 
                                   ORDER BY EventDate";

                    try
                    {
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@UserID", userId);
                            conn.Open();

                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                while (reader.Read())
                                {
                                    Dictionary<string, string> eventItem = new Dictionary<string, string>();
                                    eventItem["Name"] = reader["EventName"].ToString();
                                    eventItem["Description"] = reader["EventDescription"]?.ToString() ?? "";
                                    eventItem["Date"] = Convert.ToDateTime(reader["EventDate"]).ToString("yyyy-MM-dd");
                                    eventItem["Category"] = reader["Category"].ToString();
                                    eventsList.Add(eventItem);
                                }
                            }
                        }
                    }
                    catch (SqlException)
                    {
                        // If EventSchedule table doesn't exist, try the old Events table
                        conn.Close();
                        conn.Open();

                        string fallbackQuery = @"SELECT EventName, EventDescription, EventDate, Category 
                                               FROM Events WHERE UserID = @UserID 
                                               ORDER BY EventDate";

                        using (SqlCommand cmd = new SqlCommand(fallbackQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@UserID", userId);

                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                while (reader.Read())
                                {
                                    Dictionary<string, string> eventItem = new Dictionary<string, string>();
                                    eventItem["Name"] = reader["EventName"].ToString();
                                    eventItem["Description"] = reader["EventDescription"].ToString();
                                    eventItem["Date"] = Convert.ToDateTime(reader["EventDate"]).ToString("yyyy-MM-dd");
                                    eventItem["Category"] = reader["Category"].ToString();
                                    eventsList.Add(eventItem);
                                }
                            }
                        }
                    }
                }

                // Store events in session and serialize for JavaScript
                Session["EventList"] = eventsList;
                var serializer = new JavaScriptSerializer();
                hiddenEventData.Value = serializer.Serialize(eventsList);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in LoadEventsData: " + ex.Message);
                hiddenEventData.Value = "[]";
            }
        }

        // CRUD Operations for EventSchedule table
        public bool CreateEventSchedule(string eventTitle, string description, DateTime eventDate)
        {
            try
            {
                string userId = Session["UserID"]?.ToString();
                if (string.IsNullOrEmpty(userId)) return false;

                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"INSERT INTO EventSchedule (UserID, EventDate, EventTitle, EventDescription) 
                                   VALUES (@UserID, @EventDate, @EventTitle, @EventDescription)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.Parameters.AddWithValue("@EventDate", eventDate.Date);
                        cmd.Parameters.AddWithValue("@EventTitle", eventTitle);
                        cmd.Parameters.AddWithValue("@EventDescription", description ?? "");

                        conn.Open();
                        return cmd.ExecuteNonQuery() > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in CreateEventSchedule: " + ex.Message);
                return false;
            }
        }

        public DataTable ReadUserEventSchedule()
        {
            try
            {
                string userId = Session["UserID"]?.ToString();
                if (string.IsNullOrEmpty(userId)) return new DataTable();

                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT EventID, EventDate, EventTitle, EventDescription 
                                   FROM EventSchedule WHERE UserID = @UserID ORDER BY EventDate";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        DataTable dataTable = new DataTable();
                        adapter.Fill(dataTable);
                        return dataTable;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in ReadUserEventSchedule: " + ex.Message);
                return new DataTable();
            }
        }

        public bool UpdateEventSchedule(int eventId, string eventTitle, string description, DateTime eventDate)
        {
            try
            {
                string userId = Session["UserID"]?.ToString();
                if (string.IsNullOrEmpty(userId)) return false;

                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"UPDATE EventSchedule SET EventDate = @EventDate, EventTitle = @EventTitle, 
                                   EventDescription = @EventDescription 
                                   WHERE EventID = @EventID AND UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@EventID", eventId);
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.Parameters.AddWithValue("@EventDate", eventDate.Date);
                        cmd.Parameters.AddWithValue("@EventTitle", eventTitle);
                        cmd.Parameters.AddWithValue("@EventDescription", description ?? "");

                        conn.Open();
                        return cmd.ExecuteNonQuery() > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in UpdateEventSchedule: " + ex.Message);
                return false;
            }
        }

        public bool DeleteEventSchedule(int eventId)
        {
            try
            {
                string userId = Session["UserID"]?.ToString();
                if (string.IsNullOrEmpty(userId)) return false;

                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "DELETE FROM EventSchedule WHERE EventID = @EventID AND UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@EventID", eventId);
                        cmd.Parameters.AddWithValue("@UserID", userId);

                        conn.Open();
                        return cmd.ExecuteNonQuery() > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in DeleteEventSchedule: " + ex.Message);
                return false;
            }
        }

        // Legacy CRUD Operations for Events table (for backward compatibility)
        public bool CreateEvent(string eventName, string description, DateTime eventDate, string category)
        {
            try
            {
                string userId = Session["UserID"]?.ToString();
                if (string.IsNullOrEmpty(userId)) return false;

                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"INSERT INTO Events (UserID, EventName, EventDescription, EventDate, Category, CreatedDate) 
                                   VALUES (@UserID, @EventName, @Description, @EventDate, @Category, @CreatedDate)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.Parameters.AddWithValue("@EventName", eventName);
                        cmd.Parameters.AddWithValue("@Description", description);
                        cmd.Parameters.AddWithValue("@EventDate", eventDate);
                        cmd.Parameters.AddWithValue("@Category", category);
                        cmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now);

                        conn.Open();
                        return cmd.ExecuteNonQuery() > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in CreateEvent: " + ex.Message);
                return false;
            }
        }

        public DataTable ReadUserEvents()
        {
            try
            {
                string userId = Session["UserID"]?.ToString();
                if (string.IsNullOrEmpty(userId)) return new DataTable();

                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT EventID, EventName, EventDescription, EventDate, Category, CreatedDate 
                                   FROM Events WHERE UserID = @UserID ORDER BY EventDate";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        DataTable dataTable = new DataTable();
                        adapter.Fill(dataTable);
                        return dataTable;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in ReadUserEvents: " + ex.Message);
                return new DataTable();
            }
        }

        public bool UpdateEvent(int eventId, string eventName, string description, DateTime eventDate, string category)
        {
            try
            {
                string userId = Session["UserID"]?.ToString();
                if (string.IsNullOrEmpty(userId)) return false;

                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"UPDATE Events SET EventName = @EventName, EventDescription = @Description, 
                                   EventDate = @EventDate, Category = @Category, ModifiedDate = @ModifiedDate 
                                   WHERE EventID = @EventID AND UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@EventID", eventId);
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.Parameters.AddWithValue("@EventName", eventName);
                        cmd.Parameters.AddWithValue("@Description", description);
                        cmd.Parameters.AddWithValue("@EventDate", eventDate);
                        cmd.Parameters.AddWithValue("@Category", category);
                        cmd.Parameters.AddWithValue("@ModifiedDate", DateTime.Now);

                        conn.Open();
                        return cmd.ExecuteNonQuery() > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in UpdateEvent: " + ex.Message);
                return false;
            }
        }

        public bool DeleteEvent(int eventId)
        {
            try
            {
                string userId = Session["UserID"]?.ToString();
                if (string.IsNullOrEmpty(userId)) return false;

                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "DELETE FROM Events WHERE EventID = @EventID AND UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@EventID", eventId);
                        cmd.Parameters.AddWithValue("@UserID", userId);

                        conn.Open();
                        return cmd.ExecuteNonQuery() > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in DeleteEvent: " + ex.Message);
                return false;
            }
        }

        // User Profile CRUD operations
        public bool UpdateUserProfile(string username, string email, string firstName, string lastName)
        {
            try
            {
                string userId = Session["UserID"]?.ToString();
                if (string.IsNullOrEmpty(userId)) return false;

                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"UPDATE Users SET Username = @Username, Email = @Email, 
                                   FirstName = @FirstName, LastName = @LastName, ModifiedDate = @ModifiedDate 
                                   WHERE UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.Parameters.AddWithValue("@Username", username);
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@FirstName", firstName);
                        cmd.Parameters.AddWithValue("@LastName", lastName);
                        cmd.Parameters.AddWithValue("@ModifiedDate", DateTime.Now);

                        conn.Open();
                        return cmd.ExecuteNonQuery() > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in UpdateUserProfile: " + ex.Message);
                return false;
            }
        }

        public bool UpdateProfilePicture(string iconName)
        {
            try
            {
                string userId = Session["UserID"]?.ToString();
                if (string.IsNullOrEmpty(userId)) return false;

                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // Check if profile record exists
                    string checkQuery = "SELECT COUNT(*) FROM ProfileTC WHERE UserID = @UserID";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@UserID", userId);
                        conn.Open();

                        int recordCount = (int)checkCmd.ExecuteScalar();
                        conn.Close();

                        string query;
                        if (recordCount > 0)
                        {
                            // Update existing record
                            query = "UPDATE ProfileTC SET ProfilePic = @ProfilePic WHERE UserID = @UserID";
                        }
                        else
                        {
                            // Insert new record
                            query = "INSERT INTO ProfileTC (UserID, ProfilePic) VALUES (@UserID, @ProfilePic)";
                        }

                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@UserID", userId);
                            cmd.Parameters.AddWithValue("@ProfilePic", iconName);

                            conn.Open();
                            return cmd.ExecuteNonQuery() > 0;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in UpdateProfilePicture: " + ex.Message);
                return false;
            }
        }

        public DataTable ReadUserProfile()
        {
            try
            {
                string userId = Session["UserID"]?.ToString();
                if (string.IsNullOrEmpty(userId)) return new DataTable();

                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT u.UserID, u.Username, u.Email, u.FirstName, u.LastName, 
                                   p.ProfilePic, p.Bio, p.DateOfBirth, p.Phone, p.Address
                                   FROM Users u 
                                   LEFT JOIN ProfileTC p ON u.UserID = p.UserID 
                                   WHERE u.UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        DataTable dataTable = new DataTable();
                        adapter.Fill(dataTable);
                        return dataTable;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in ReadUserProfile: " + ex.Message);
                return new DataTable();
            }
        }

        protected void btnEditProfile_Click(object sender, EventArgs e)
        {
            Response.Redirect("EditProfile.aspx");
        }
    }
}