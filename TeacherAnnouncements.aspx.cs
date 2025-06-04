using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WAPPSS
{
    public partial class TeacherAnnouncements : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

        // Expose ModeTypeFromDB for aspx to use in JS
        public string ModeTypeFromDB = "light"; // default

        protected void Page_Load(object sender, EventArgs e)
        {
            // Get ModeType from Mode table for the current user
            if (Session["UserID"] != null)
            {
                string userId = Session["UserID"].ToString();
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
                    var cmd = new SqlCommand("SELECT TOP 1 ModeType FROM Mode WHERE UserID=@UserID", con);
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    var mode = cmd.ExecuteScalar();
                    if (mode != null && mode != DBNull.Value)
                    {
                        ModeTypeFromDB = mode.ToString().Trim().ToLower();
                    }
                }
            }

            if (!IsPostBack)
            {
                // Check if user is a teacher
                if (IsUserLecturer())
                {
                    LoadLecturerAnnouncements();
                }
                else
                {
                    // Redirect if not a lecturer
                    Response.Redirect("Login.aspx");
                }
            }
        }

        private bool IsUserLecturer()
        {
            if (Session["UserID"] == null)
                return false;

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
                    var cmd = new SqlCommand("SELECT Category FROM Users WHERE UserID = @UserID", con);
                    cmd.Parameters.AddWithValue("@UserID", Session["UserID"].ToString());
                    var category = cmd.ExecuteScalar();

                    return category != null && (category.ToString().Equals("Teacher", StringComparison.OrdinalIgnoreCase) ||
                                               category.ToString().Equals("Lecturer", StringComparison.OrdinalIgnoreCase));
                }
            }
            catch
            {
                return false;
            }
        }

        private void LoadLecturerAnnouncements()
        {
            pnlAnnouncements.Controls.Clear();

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    // Query announcements for lecturers only and all users
                    var cmd = new SqlCommand(@"
                        SELECT AnnouncementID, adminID, title, content, target, time
                        FROM Announcements
                        WHERE target IN ('Lecturers only', 'Lecturers', 'All users', 'All Users')
                        ORDER BY time DESC", con);

                    var reader = cmd.ExecuteReader();
                    bool hasAnnouncements = false;

                    while (reader.Read())
                    {
                        hasAnnouncements = true;
                        CreateAnnouncementCard(reader);
                    }

                    reader.Close();

                    // Show no announcements message if needed
                    pnlNoAnnouncements.Visible = !hasAnnouncements;
                }
            }
            catch (Exception ex)
            {
                // Log error and show message
                var errorLiteral = new Literal();
                errorLiteral.Text = $@"
                    <div class='alert alert-danger' role='alert'>
                        <i class='bi bi-exclamation-triangle-fill me-2'></i>
                        Error loading announcements: {HttpUtility.HtmlEncode(ex.Message)}
                    </div>";
                pnlAnnouncements.Controls.Add(errorLiteral);
            }
        }

        private void CreateAnnouncementCard(SqlDataReader reader)
        {
            int announcementId = Convert.ToInt32(reader["AnnouncementID"]);
            int adminId = Convert.ToInt32(reader["adminID"]);
            string title = reader["title"]?.ToString() ?? "No Title";
            string content = reader["content"]?.ToString() ?? "";
            string target = reader["target"]?.ToString() ?? "";
            DateTime time = Convert.ToDateTime(reader["time"]);

            // Format the date
            string formattedDate = time.ToString("MMM dd, yyyy 'at' h:mm tt");
            string relativeTime = GetRelativeTime(time);

            // Determine target badge style
            string targetBadgeClass = "";
            string targetText = "";

            if (target.Contains("Lecturers"))
            {
                targetBadgeClass = "target-teachers";
                targetText = "Lecturers Only";
            }
            else if (target.Contains("All"))
            {
                targetBadgeClass = "target-all";
                targetText = "All Users";
            }
            else
            {
                targetBadgeClass = "target-all";
                targetText = target;
            }

            StringBuilder html = new StringBuilder();
            html.Append($@"
                <div class='card announcement-card'>
                    <div class='card-header d-flex align-items-center justify-content-between'>
                        <div class='d-flex align-items-center'>
                            <div class='me-3'>
                                <i class='bi bi-person-gear' style='font-size: 2rem; color: #6f42c1;'></i>
                            </div>
                            <div>
                                <div class='d-flex align-items-center mb-1'>
                                    <span class='admin-badge me-2'>
                                        <i class='bi bi-shield-check me-1'></i>Admin #{adminId}
                                    </span>
                                </div>
                                <div class='time-text'>
                                    <i class='bi bi-clock me-1'></i>
                                    {formattedDate} • {relativeTime}
                                </div>
                            </div>
                        </div>
                        <div>
                            <span class='target-badge {targetBadgeClass}'>
                                <i class='bi bi-people-fill me-1'></i>{targetText}
                            </span>
                        </div>
                    </div>
                    <div class='card-body'>
                        <h5 class='card-title mb-3'>
                            <i class='bi bi-megaphone me-2'></i>{HttpUtility.HtmlEncode(title)}
                        </h5>");

            if (!string.IsNullOrEmpty(content))
            {
                // Format content with line breaks
                string formattedContent = HttpUtility.HtmlEncode(content).Replace("\n", "<br />");
                html.Append($"<div class='card-text'>{formattedContent}</div>");
            }

            html.Append($@"
                    </div>
                    <div class='card-footer text-muted d-flex justify-content-between align-items-center'>
                        <small>
                            <i class='bi bi-info-circle me-1'></i>
                            Announcement ID: {announcementId}
                        </small>
                        <small>
                            <i class='bi bi-person-badge me-1'></i>
                            Posted by Admin #{adminId}
                        </small>
                    </div>
                </div>");

            var literal = new Literal();
            literal.Text = html.ToString();
            pnlAnnouncements.Controls.Add(literal);
        }

        private string GetRelativeTime(DateTime dateTime)
        {
            var timeSpan = DateTime.Now - dateTime;

            if (timeSpan.Days > 0)
            {
                return timeSpan.Days == 1 ? "1 day ago" : $"{timeSpan.Days} days ago";
            }
            else if (timeSpan.Hours > 0)
            {
                return timeSpan.Hours == 1 ? "1 hour ago" : $"{timeSpan.Hours} hours ago";
            }
            else if (timeSpan.Minutes > 0)
            {
                return timeSpan.Minutes == 1 ? "1 minute ago" : $"{timeSpan.Minutes} minutes ago";
            }
            else
            {
                return "Just now";
            }
        }
    }
}