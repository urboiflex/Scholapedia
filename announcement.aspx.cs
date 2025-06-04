using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WAPPSS
{
    public partial class announcement : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

        // New: Expose ModeTypeFromDB for aspx to use in JS
        public string ModeTypeFromDB = "light"; // default

        protected void Page_Load(object sender, EventArgs e)
        {
            // --- NEW: Get ModeType from Mode table for the current user ---
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
            // -------------------------------------------------------------

            if (!IsPostBack)
            {
                LoadAnnouncements();
                LoadRecipientPanels();
                ShowOnlySelectedRecipientPanel("teachers");
                hfAnnounceTo.Value = "teachers";
            }
            else
            {
                // Handle like AJAX postback
                if (Request["__EVENTTARGET"] == "LikeAnnouncement" && !string.IsNullOrEmpty(Request["__EVENTARGUMENT"]))
                {
                    int announcementId, userId;
                    if (int.TryParse(Request["__EVENTARGUMENT"], out announcementId) && Session["UserID"] != null && int.TryParse(Session["UserID"].ToString(), out userId))
                    {
                        ToggleLike(announcementId, userId);
                        LoadAnnouncements();
                        upAnnouncements.Update();
                    }
                }
                // Handle delete AJAX postback
                else if (Request["__EVENTTARGET"] == "DeleteAnnouncement" && !string.IsNullOrEmpty(Request["__EVENTARGUMENT"]))
                {
                    int announcementId;
                    if (int.TryParse(Request["__EVENTARGUMENT"], out announcementId))
                    {
                        DeleteAnnouncement(announcementId);
                        LoadAnnouncements();
                        upAnnouncements.Update();
                    }
                }
            }
        }

        // ... rest of code unchanged ...
        // (All your methods for DeleteAnnouncement, ToggleLike, RecipientTypeChanged, LoadRecipientPanels, etc. remain the same as you posted)
        // (No changes are needed for the backend except for ModeTypeFromDB logic above.)

        private void DeleteAnnouncement(int announcementId)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                // Clean up related records first if necessary (Likes, Recipients, etc.)
                var delLikes = new SqlCommand("DELETE FROM AnnouncementLikes WHERE AnnouncementID=@AID", con);
                delLikes.Parameters.AddWithValue("@AID", announcementId);
                delLikes.ExecuteNonQuery();

                var delRecipients = new SqlCommand("DELETE FROM AnnouncementRecipients WHERE AnnouncementID=@AID", con);
                delRecipients.Parameters.AddWithValue("@AID", announcementId);
                delRecipients.ExecuteNonQuery();

                var cmd = new SqlCommand("DELETE FROM Announcements WHERE AnnouncementID=@AID", con);
                cmd.Parameters.AddWithValue("@AID", announcementId);
                cmd.ExecuteNonQuery();
            }
        }

        private void ToggleLike(int announcementId, int userId)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                var checkCmd = new SqlCommand("SELECT COUNT(*) FROM AnnouncementLikes WHERE AnnouncementID=@AID AND UserID=@UID", con);
                checkCmd.Parameters.AddWithValue("@AID", announcementId);
                checkCmd.Parameters.AddWithValue("@UID", userId);
                int count = (int)checkCmd.ExecuteScalar();
                if (count == 0)
                {
                    var cmd = new SqlCommand("INSERT INTO AnnouncementLikes (AnnouncementID, UserID) VALUES (@AID, @UID)", con);
                    cmd.Parameters.AddWithValue("@AID", announcementId);
                    cmd.Parameters.AddWithValue("@UID", userId);
                    cmd.ExecuteNonQuery();
                }
                else
                {
                    var cmd = new SqlCommand("DELETE FROM AnnouncementLikes WHERE AnnouncementID=@AID AND UserID=@UID", con);
                    cmd.Parameters.AddWithValue("@AID", announcementId);
                    cmd.Parameters.AddWithValue("@UID", userId);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        protected void RecipientTypeChanged(object sender, EventArgs e)
        {
            if (rbTeachers.Checked)
                hfAnnounceTo.Value = "teachers";
            else if (rbStudents.Checked)
                hfAnnounceTo.Value = "students";
            else if (rbCourses.Checked)
                hfAnnounceTo.Value = "courses";

            ShowOnlySelectedRecipientPanel(hfAnnounceTo.Value);
            LoadRecipientPanels();
            upRecipients.Update();
        }

        private void LoadRecipientPanels()
        {
            pnlTeachers.Controls.Clear();
            pnlStudents.Controls.Clear();
            pnlCourses.Controls.Clear();

            if (hfAnnounceTo.Value == "teachers")
                AddCheckBoxCards("All Teachers", "chkUsers", GetUsersForTeachers(), pnlTeachers);

            if (hfAnnounceTo.Value == "students")
                AddCheckBoxCards("All Students", "chkStudents", GetStudentsForStudents(), pnlStudents);

            if (hfAnnounceTo.Value == "courses")
                AddCheckBoxCards("All Courses", "chkCourses", GetCoursesForCourses(), pnlCourses);
        }

        private List<KeyValuePair<string, string>> GetUsersForTeachers()
        {
            var list = new List<KeyValuePair<string, string>>();
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                var cmd = new SqlCommand("SELECT UserID, FirstName, LastName FROM Users WHERE Category = 'Teacher'", con);
                var rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    string name = (rdr["FirstName"] != DBNull.Value ? rdr["FirstName"].ToString() : "") + " " +
                                  (rdr["LastName"] != DBNull.Value ? rdr["LastName"].ToString() : "");
                    list.Add(new KeyValuePair<string, string>(rdr["UserID"].ToString(), name.Trim()));
                }
            }
            return list;
        }

        private List<KeyValuePair<string, string>> GetStudentsForStudents()
        {
            var list = new List<KeyValuePair<string, string>>();
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                var cmd = new SqlCommand("SELECT UserID, FirstName, LastName FROM Users WHERE Category = 'Student'", con);
                var rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    string name = (rdr["FirstName"] != DBNull.Value ? rdr["FirstName"].ToString() : "") + " " +
                                  (rdr["LastName"] != DBNull.Value ? rdr["LastName"].ToString() : "");
                    list.Add(new KeyValuePair<string, string>(rdr["UserID"].ToString(), name.Trim()));
                }
            }
            return list;
        }

        private List<KeyValuePair<string, string>> GetCoursesForCourses()
        {
            var list = new List<KeyValuePair<string, string>>();
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                var cmd = new SqlCommand("SELECT TC_ID, TC_CourseName FROM TeacherCourses", con);
                var rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    string courseName = rdr["TC_CourseName"] != DBNull.Value ? rdr["TC_CourseName"].ToString() : "(No Name)";
                    list.Add(new KeyValuePair<string, string>(rdr["TC_ID"].ToString(), courseName));
                }
            }
            return list;
        }

        private void AddCheckBoxCards(string label, string name, List<KeyValuePair<string, string>> items, Panel parent)
        {
            var container = new Panel() { CssClass = "recipient-list" };
            foreach (var item in items)
            {
                var html = $"<div class='recipient-card'>" +
                           $"<input type='checkbox' class='form-check-input me-2' name='{name}' value='{item.Key}' id='{name}_{item.Key}' />" +
                           $"<label for='{name}_{item.Key}' class='ms-2'>{item.Value}</label></div>";
                container.Controls.Add(new Literal { Text = html });
            }
            parent.Controls.Add(container);
        }

        private void ShowOnlySelectedRecipientPanel(string announceType)
        {
            mvRecipients.ActiveViewIndex = announceType == "teachers" ? 0 :
                                           announceType == "students" ? 1 :
                                           announceType == "courses" ? 2 : 0;
        }

        protected void btnSendAnnouncement_Click(object sender, EventArgs e)
        {
            lblError.Text = "";
            string title = txtTitle.Text.Trim();
            string desc = txtDescription.Text.Trim();
            string announceType = hfAnnounceTo.Value;

            if (string.IsNullOrEmpty(title))
            {
                lblError.Text = "Title is required.";
                return;
            }

            string imgUrl = null;
            if (fuImage.HasFile)
            {
                try
                {
                    string ext = Path.GetExtension(fuImage.FileName).ToLower();
                    if (ext == ".jpg" || ext == ".jpeg" || ext == ".png" || ext == ".gif")
                    {
                        string fileName = Guid.NewGuid().ToString() + ext;
                        string savePath = Server.MapPath("~/UploadedImages/");
                        if (!Directory.Exists(savePath)) Directory.CreateDirectory(savePath);
                        fuImage.SaveAs(savePath + fileName);
                        imgUrl = "~/UploadedImages/" + fileName;
                    }
                    else
                    {
                        lblError.Text = "Only images are allowed.";
                        return;
                    }
                }
                catch
                {
                    lblError.Text = "Error uploading image.";
                    return;
                }
            }

            int createdByUserID = Convert.ToInt32(Session["UserID"] ?? "0");
            if (createdByUserID == 0)
            {
                lblError.Text = "You must be logged in.";
                return;
            }

            List<int> userIDs = new List<int>();
            List<int> courseIDs = new List<int>();
            if (announceType == "teachers")
            {
                var checkedUsers = Request.Form.GetValues("chkUsers");
                if (checkedUsers != null)
                {
                    foreach (var val in checkedUsers)
                    {
                        if (int.TryParse(val, out int id))
                            userIDs.Add(id);
                    }
                }
            }
            else if (announceType == "students")
            {
                var checkedStudents = Request.Form.GetValues("chkStudents");
                if (checkedStudents != null)
                {
                    foreach (var val in checkedStudents)
                    {
                        if (int.TryParse(val, out int id))
                            userIDs.Add(id);
                    }
                }
            }
            else if (announceType == "courses")
            {
                var checkedCourses = Request.Form.GetValues("chkCourses");
                if (checkedCourses != null)
                {
                    foreach (var val in checkedCourses)
                    {
                        if (int.TryParse(val, out int courseId))
                            courseIDs.Add(courseId);
                    }
                }
            }

            // Fix: If no recipients selected, show error and return!
            if (userIDs.Count == 0 && courseIDs.Count == 0)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowNotSaved", "alert('Announcement was not sent to any recipients.');", true);
                return;
            }

            int announcementID = 0;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                var cmd = new SqlCommand(@"
                    INSERT INTO Announcements (Title, Description, ImageUrl, CreatedByUserID, DateCreated)
                    OUTPUT INSERTED.AnnouncementID
                    VALUES (@Title, @Desc, @ImageUrl, @CreatedByUserID, GETDATE())", con);
                cmd.Parameters.AddWithValue("@Title", title);
                cmd.Parameters.AddWithValue("@Desc", (object)desc ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@ImageUrl", (object)imgUrl ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@CreatedByUserID", createdByUserID);
                announcementID = (int)cmd.ExecuteScalar();
            }

            bool recipientsAdded = false;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                if (userIDs.Count > 0)
                {
                    foreach (int id in userIDs)
                    {
                        var cmd = new SqlCommand("INSERT INTO AnnouncementRecipients (AnnouncementID, UserID) VALUES (@AnnouncementID, @UserID)", con);
                        cmd.Parameters.AddWithValue("@AnnouncementID", announcementID);
                        cmd.Parameters.AddWithValue("@UserID", id);
                        cmd.ExecuteNonQuery();
                        recipientsAdded = true;
                    }
                }
                if (courseIDs.Count > 0)
                {
                    foreach (int tcid in courseIDs)
                    {
                        // Get all users in this course from CourseStudents
                        var getUsersCmd = new SqlCommand("SELECT UserID FROM CourseStudents WHERE TC_ID = @CourseID", con);
                        getUsersCmd.Parameters.AddWithValue("@CourseID", tcid);
                        var rdr = getUsersCmd.ExecuteReader();
                        List<int> courseUserIDs = new List<int>();
                        while (rdr.Read())
                        {
                            courseUserIDs.Add(Convert.ToInt32(rdr["UserID"]));
                        }
                        rdr.Close();

                        foreach (int userId in courseUserIDs)
                        {
                            // Insert as individual user recipients
                            var cmd = new SqlCommand("INSERT INTO AnnouncementRecipients (AnnouncementID, UserID, CourseStudentID) VALUES (@AnnouncementID, @UserID, @CourseStudentID)", con);
                            cmd.Parameters.AddWithValue("@AnnouncementID", announcementID);
                            cmd.Parameters.AddWithValue("@UserID", userId);
                            cmd.Parameters.AddWithValue("@CourseStudentID", tcid);
                            cmd.ExecuteNonQuery();
                            recipientsAdded = true;
                        }
                    }
                }
            }

            txtTitle.Text = "";
            txtDescription.Text = "";
            LoadRecipientPanels();
            ShowOnlySelectedRecipientPanel(announceType);
            upRecipients.Update();

            if (recipientsAdded)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowSaved", "alert('Announcement saved!');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowNotSaved", "alert('Announcement was not sent to any recipients.');", true);
            }

            ScriptManager.RegisterStartupScript(this, GetType(), "HideModal", "$('#addAnnouncementModal').modal('hide');", true);
            LoadAnnouncements();
        }

        private void LoadAnnouncements()
        {
            pnlAnnouncements.Controls.Clear();

            int? currentUserID = null;
            if (Session["UserID"] != null)
            {
                int parsed;
                if (int.TryParse(Session["UserID"].ToString(), out parsed))
                    currentUserID = parsed;
            }
            if (currentUserID == null)
                return;

            List<int> allowedAnnouncementIDs = new List<int>();
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                var recipientCmd = new SqlCommand(@"
                    SELECT DISTINCT AnnouncementID FROM AnnouncementRecipients
                    WHERE UserID = @UserID OR CourseStudentID IN (SELECT TC_ID FROM CourseStudents WHERE UserID = @UserID)
                ", con);
                recipientCmd.Parameters.AddWithValue("@UserID", (object)currentUserID ?? DBNull.Value);
                using (var recipientRdr = recipientCmd.ExecuteReader())
                    while (recipientRdr.Read())
                        allowedAnnouncementIDs.Add(Convert.ToInt32(recipientRdr["AnnouncementID"]));
            }

            List<int> createdByMeIDs = new List<int>();
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                var createdCmd = new SqlCommand("SELECT AnnouncementID FROM Announcements WHERE CreatedByUserID=@UserID", con);
                createdCmd.Parameters.AddWithValue("@UserID", (object)currentUserID ?? DBNull.Value);
                using (var crdr = createdCmd.ExecuteReader())
                    while (crdr.Read())
                        createdByMeIDs.Add(Convert.ToInt32(crdr["AnnouncementID"]));
            }

            var totalIDs = allowedAnnouncementIDs.Union(createdByMeIDs).ToList();
            if (totalIDs.Count == 0) return;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                string inClause = string.Join(",", totalIDs);
                var cmd = new SqlCommand($@"
                    SELECT A.AnnouncementID, A.Title, A.Description, A.ImageUrl, A.CreatedByUserID, A.DateCreated,
                           U.FirstName, U.LastName, P.ProfilePic
                    FROM Announcements A
                    INNER JOIN Users U ON A.CreatedByUserID = U.UserID
                    LEFT JOIN ProfileTC P ON U.UserID = P.UserID
                    WHERE A.AnnouncementID IN ({inClause})
                    ORDER BY A.DateCreated DESC", con);

                var likesCmd = new SqlCommand($@"
                    SELECT AnnouncementID, COUNT(*) AS LikeCount
                    FROM AnnouncementLikes
                    WHERE AnnouncementID IN ({inClause})
                    GROUP BY AnnouncementID
                    ", con);
                var likeCounts = new Dictionary<int, int>();
                using (var ldr = likesCmd.ExecuteReader())
                {
                    while (ldr.Read())
                        likeCounts[Convert.ToInt32(ldr["AnnouncementID"])] = Convert.ToInt32(ldr["LikeCount"]);
                }

                var userLikesCmd = new SqlCommand($@"
                    SELECT AnnouncementID FROM AnnouncementLikes WHERE UserID=@UID AND AnnouncementID IN ({inClause})", con);
                userLikesCmd.Parameters.AddWithValue("@UID", currentUserID.Value);
                var likedByMe = new HashSet<int>();
                using (var ulr = userLikesCmd.ExecuteReader())
                {
                    while (ulr.Read())
                        likedByMe.Add(Convert.ToInt32(ulr["AnnouncementID"]));
                }

                var rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    int announcementId = Convert.ToInt32(rdr["AnnouncementID"]);
                    string title = rdr["Title"].ToString();
                    string desc = rdr["Description"]?.ToString();
                    string img = rdr["ImageUrl"]?.ToString();
                    string name = rdr["FirstName"] + " " + rdr["LastName"];
                    string profilePic = rdr["ProfilePic"]?.ToString();
                    string date = Convert.ToDateTime(rdr["DateCreated"]).ToString("g");
                    int likeCount = likeCounts.ContainsKey(announcementId) ? likeCounts[announcementId] : 0;
                    bool liked = likedByMe.Contains(announcementId);
                    int createdBy = Convert.ToInt32(rdr["CreatedByUserID"]);

                    StringBuilder html = new StringBuilder();
                    html.Append($@"
                        <div class='card announcement-card mb-4'>
                            <div class='card-header d-flex align-items-center'>");
                    html.Append($@"<img src='{ResolveUrl(profilePic ?? "~/default-profile.png")}' class='profile-pic me-2' alt='profile' />
                                <div>
                                    <strong>{name}</strong><br/>
                                    <small class='text-muted'>{date}</small>
                                </div>");

                    // Delete icon button for creator
                    if (currentUserID.HasValue && createdBy == currentUserID.Value)
                    {
                        html.Append($@"
                                <button type='button' class='delete-announcement-btn ms-auto' title='Delete Announcement' data-annid='{announcementId}' data-anntitle='{System.Web.HttpUtility.HtmlAttributeEncode(title)}'>
                                    <i class='bi bi-trash3-fill'></i>
                                </button>
                        ");
                    }

                    html.Append($@"</div>
                            <div class='card-body'>
                                <h5 class='card-title'>{title}</h5>");
                    if (!string.IsNullOrEmpty(desc))
                        html.Append($"<p class='card-text'>{desc}</p>");
                    if (!string.IsNullOrEmpty(img))
                        html.Append($"<img src='{ResolveUrl(img)}' class='img-fluid mb-2' style='max-width:400px;' /><br/>");

                    string btnClass = liked ? "btn-primary" : "btn-outline-primary";
                    string icon = liked ? "bi-hand-thumbs-up-fill" : "bi-hand-thumbs-up";
                    string btnText = liked ? "Unlike" : "Like";
                    html.Append($@"
    <div>
        <button type='button' class='btn {btnClass} btn-sm like-btn' data-annid='{announcementId}'>
            <i class='bi {icon}'></i> {btnText} <span class='like-count'>{likeCount}</span>
        </button>
    </div>
");

                    html.Append($@"</div></div>");
                    pnlAnnouncements.Controls.Add(new Literal { Text = html.ToString() });
                }
                rdr.Close();
            }
        }

        private string ResolveUrl(string url)
        {
            if (string.IsNullOrEmpty(url)) return "~/default-profile.png";
            if (url.StartsWith("~")) return ResolveClientUrl(url);
            return url;
        }
    }
}