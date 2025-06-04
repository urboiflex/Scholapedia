using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace WAPPSS
{
    public partial class course_detail : System.Web.UI.Page
    {
        private int TC_ID = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            string selectedCourse = Request.QueryString["course"] ?? (Session["SelectedCourse"] as string);
            if (!IsPostBack)
            {
                // NEW: Check and set dark mode
                SetDarkMode();

                if (!string.IsNullOrEmpty(selectedCourse))
                {
                    LoadCourseDetails(selectedCourse);
                    LoadResources(selectedCourse);
                    LoadClassSchedule(selectedCourse);
                    LoadManageStudents();
                    LoadTests(selectedCourse);
                }
                else
                {
                    courseName.InnerText = "Course not selected.";
                }
            }

            if (!string.IsNullOrEmpty(selectedCourse))
            {
                LoadFlashcards(selectedCourse);
            }
        }

        /// <summary>
        /// Checks the ModeType in the Mode table and sets dark mode or light mode.
        /// </summary>
        private void SetDarkMode()
        {
            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string q = "SELECT TOP 1 ModeType FROM Mode";
                using (SqlCommand cmd = new SqlCommand(q, conn))
                {
                    var modeType = cmd.ExecuteScalar();
                    if (modeType != null && modeType.ToString().Equals("dark", StringComparison.OrdinalIgnoreCase))
                    {
                        ViewState["IsDarkMode"] = true;
                    }
                    else
                    {
                        ViewState["IsDarkMode"] = false;
                    }
                }
            }
        }
        private void ApplyDarkModeIfNeeded()
        {
            string modeType = "light";
            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT TOP 1 ModeType FROM Mode";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                object result = cmd.ExecuteScalar();
                if (result != null)
                {
                    modeType = result.ToString().ToLower();
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
        private void LoadTests(string courseNameStr)
        {
            DataTable dt = new DataTable();
            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            int tc_id = GetTC_ID();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string q = @"SELECT TestID, TestTitle, TestTime FROM Test WHERE TC_ID = @tcid";
                using (SqlCommand cmd = new SqlCommand(q, conn))
                {
                    cmd.Parameters.AddWithValue("@tcid", tc_id);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }
            var tests = dt.AsEnumerable().Select(row => new
            {
                TestID = row.Field<int>("TestID"),
                TestTitle = row.Field<string>("TestTitle"),
                TestTime = row.Field<int>("TestTime")
            }).ToList();

            TestRepeater.DataSource = tests;
            TestRepeater.DataBind();

            if (tests.Count == 0 && TestRepeater.Controls.Count > 0)
            {
                var lit = (Literal)TestRepeater.Controls[TestRepeater.Controls.Count - 1].FindControl("litNoTests");
                if (lit != null)
                    lit.Text = "<div style='color:#888; text-align:center; margin:15px 0;'>No tests for this course yet.</div>";
            }
        }

        protected void TestRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DeleteTest")
            {
                int testId = Convert.ToInt32(e.CommandArgument);
                string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                // Make sure to wrap all deletes in a transaction for integrity
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    using (SqlTransaction tran = conn.BeginTransaction())
                    {
                        try
                        {
                            // Delete TestOptions for all questions in this test
                            using (SqlCommand cmdOption = new SqlCommand(
                                "DELETE FROM TestOptions WHERE QuestionID IN (SELECT QuestionID FROM TestQuestions WHERE TestID=@tid)", conn, tran))
                            {
                                cmdOption.Parameters.AddWithValue("@tid", testId);
                                cmdOption.ExecuteNonQuery();
                            }
                            // Delete TestQuestions for this test
                            using (SqlCommand cmdQ = new SqlCommand(
                                "DELETE FROM TestQuestions WHERE TestID=@tid", conn, tran))
                            {
                                cmdQ.Parameters.AddWithValue("@tid", testId);
                                cmdQ.ExecuteNonQuery();
                            }
                            // Delete the Test itself (this will succeed only if FK are set up as ON DELETE NO ACTION, which is default)
                            using (SqlCommand cmdTest = new SqlCommand(
                                "DELETE FROM Test WHERE TestID=@tid", conn, tran))
                            {
                                cmdTest.Parameters.AddWithValue("@tid", testId);
                                cmdTest.ExecuteNonQuery();
                            }
                            tran.Commit();
                        }
                        catch
                        {
                            tran.Rollback();
                            throw; // Let ASP.NET show error for debugging
                        }
                    }
                }
                // Re-load tests to update UI
                string selectedCourse = Request.QueryString["course"] ?? (Session["SelectedCourse"] as string);
                LoadTests(selectedCourse);
            }
            else if (e.CommandName == "PreviewTest")
            {
                int testId = Convert.ToInt32(e.CommandArgument);
                // Redirect to preview page
                Response.Redirect("TestPreview.aspx?testid=" + testId);
            }
        }
        private int GetTC_ID()
        {
            if (ViewState["TC_ID"] != null) return (int)ViewState["TC_ID"];
            string selectedCourse = Request.QueryString["course"] ?? (Session["SelectedCourse"] as string);
            if (string.IsNullOrEmpty(selectedCourse)) return 0;

            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT TC_ID FROM TeacherCourses WHERE TC_CourseName=@CourseName", conn))
                {
                    cmd.Parameters.AddWithValue("@CourseName", selectedCourse);
                    var val = cmd.ExecuteScalar();
                    if (val != null && val != DBNull.Value)
                    {
                        ViewState["TC_ID"] = Convert.ToInt32(val);
                        return Convert.ToInt32(val);
                    }
                }
            }
            return 0;
        }

        // UPDATED: Load students in this course - Fixed case sensitivity
        private void LoadManageStudents()
        {
            int tc_id = GetTC_ID();
            if (tc_id == 0) return;

            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string q = @"SELECT cs.CourseStudentID, u.UserID, u.FirstName, u.LastName, u.Username, cs.Progress
                            FROM CourseStudents cs
                            JOIN Users u ON cs.UserID = u.UserID
                            WHERE cs.TC_ID = @tcid AND LOWER(u.Category) = 'student'";
                using (SqlCommand cmd = new SqlCommand(q, conn))
                {
                    cmd.Parameters.AddWithValue("@tcid", tc_id);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }
            var students = dt.AsEnumerable().Select(row => new {
                CourseStudentID = row.Field<int>("CourseStudentID"),
                UserID = row.Field<int>("UserID"),
                FullName = row.Field<string>("FirstName") + " " + row.Field<string>("LastName") +
                          (row.Field<string>("Username") != null ? $" ({row.Field<string>("Username")})" : ""),
                Progress = row.Field<int>("Progress")
            }).ToList();

            CourseStudentsRepeater.DataSource = students;
            CourseStudentsRepeater.DataBind();

            // Also clear search results after any action
            SearchResultsRepeater.DataSource = null;
            SearchResultsRepeater.DataBind();
        }

        // UPDATED: Search students by name or username - Much more flexible
        protected void btnSearchStudent_Click(object sender, EventArgs e)
        {
            string searchText = txtStudentSearch.Text.Trim();
            if (string.IsNullOrEmpty(searchText)) return;

            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            DataTable dt = new DataTable();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = "";
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;

                // Check if search text contains space (probably first name + last name)
                if (searchText.Contains(" "))
                {
                    string[] parts = searchText.Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
                    if (parts.Length >= 2)
                    {
                        string firstName = parts[0];
                        string lastName = parts[1];

                        query = @"SELECT UserID, FirstName, LastName, Username 
                                 FROM Users
                                 WHERE LOWER(Category) = 'student' AND 
                                       LOWER(FirstName) = LOWER(@fn) AND LOWER(LastName) = LOWER(@ln)";
                        cmd.CommandText = query;
                        cmd.Parameters.AddWithValue("@fn", firstName);
                        cmd.Parameters.AddWithValue("@ln", lastName);
                    }
                }
                else
                {
                    // Single word search - could be first name, last name, or username
                    query = @"SELECT UserID, FirstName, LastName, Username 
                             FROM Users
                             WHERE LOWER(Category) = 'student' AND 
                                   (LOWER(FirstName) = LOWER(@search) OR 
                                    LOWER(LastName) = LOWER(@search) OR 
                                    LOWER(Username) = LOWER(@search))";
                    cmd.CommandText = query;
                    cmd.Parameters.AddWithValue("@search", searchText);
                }

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    da.Fill(dt);
                }
            }

            var students = dt.AsEnumerable().Select(row => new
            {
                UserID = row.Field<int>("UserID"),
                FullName = row.Field<string>("FirstName") + " " + row.Field<string>("LastName") +
                          (row.Field<string>("Username") != null ? $" ({row.Field<string>("Username")})" : "")
            }).ToList();

            SearchResultsRepeater.DataSource = students;
            SearchResultsRepeater.DataBind();
        }

        // Add student to course
        protected void SearchResultsRepeater_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "AddStudent")
            {
                int userId = Convert.ToInt32(e.CommandArgument);
                int tc_id = GetTC_ID();
                if (tc_id == 0 || userId == 0) return;

                string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    // Check not already added
                    string checkQ = "SELECT COUNT(*) FROM CourseStudents WHERE TC_ID=@tcid AND UserID=@uid";
                    using (SqlCommand cmd = new SqlCommand(checkQ, conn))
                    {
                        cmd.Parameters.AddWithValue("@tcid", tc_id);
                        cmd.Parameters.AddWithValue("@uid", userId);
                        int count = (int)cmd.ExecuteScalar();
                        if (count == 0)
                        {
                            string addQ = "INSERT INTO CourseStudents (TC_ID, UserID, Progress) VALUES (@tcid, @uid, 0)";
                            using (SqlCommand addCmd = new SqlCommand(addQ, conn))
                            {
                                addCmd.Parameters.AddWithValue("@tcid", tc_id);
                                addCmd.Parameters.AddWithValue("@uid", userId);
                                addCmd.ExecuteNonQuery();
                            }
                        }
                    }
                }
                LoadManageStudents();
            }
        }

        // UPDATED: Autocomplete suggestions - Much more flexible search
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<StudentSuggestion> GetStudentSuggestions(string prefix)
        {
            var suggestions = new List<StudentSuggestion>();
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                string q = @"SELECT TOP 8 UserID, FirstName, LastName, Username 
                             FROM Users 
                             WHERE LOWER(Category) = 'student' AND 
                                   (LOWER(FirstName) LIKE LOWER(@p) OR 
                                    LOWER(LastName) LIKE LOWER(@p) OR 
                                    LOWER(Username) LIKE LOWER(@p) OR
                                    LOWER(FirstName + ' ' + LastName) LIKE LOWER(@p))
                             ORDER BY FirstName, LastName";
                using (var cmd = new SqlCommand(q, conn))
                {
                    cmd.Parameters.AddWithValue("@p", prefix + "%");
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string username = reader.IsDBNull(3) ? "" : reader.GetString(3);
                            string displayName = reader.GetString(1) + " " + reader.GetString(2);
                            if (!string.IsNullOrEmpty(username))
                            {
                                displayName += $" ({username})";
                            }

                            suggestions.Add(new StudentSuggestion
                            {
                                UserID = reader.GetInt32(0),
                                FullName = displayName
                            });
                        }
                    }
                }
            }
            return suggestions;
        }

        // Remove student from course
        protected void CourseStudentsRepeater_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "RemoveStudent")
            {
                int courseStudentId = Convert.ToInt32(e.CommandArgument);
                string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string q = "DELETE FROM CourseStudents WHERE CourseStudentID=@id";
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", courseStudentId);
                        cmd.ExecuteNonQuery();
                    }
                }
                LoadManageStudents();
            }
        }

        // Optionally, handle search on text change (AutoPostBack)
        protected void txtStudentSearch_TextChanged(object sender, EventArgs e)
        {
            btnSearchStudent_Click(sender, e);
        }

        public class StudentSuggestion
        {
            public int UserID { get; set; }
            public string FullName { get; set; }
        }
        public class Resource
        {
            public string FileName { get; set; }
            public string FilePath { get; set; }
        }

        public class ClassScheduleEntry
        {
            public int ScheduleID { get; set; }
            public DateTime ClassDate { get; set; }
            public TimeSpan ClassTime { get; set; }
        }

        private void LoadCourseDetails(string courseNameStr)
        {
            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            string userFirstName = Session["FirstName"] as string ?? "";
            string userLastName = Session["LastName"] as string ?? "";

            string query = @"SELECT TC_ID, TC_CourseName, TC_ModuleType, TC_CoverImage, 
                                    TC_Duration, TC_SkillLevel, TC_Language, TC_PublishDate, TC_PublishTime, 
                                    TC_ResourceFile
                             FROM TeacherCourses WHERE TC_CourseName = @CourseName";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseName", courseNameStr);
                    conn.Open();

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        TC_ID = Convert.ToInt32(reader["TC_ID"]);
                        ViewState["TC_ID"] = TC_ID;
                        string mode = reader["TC_ModuleType"].ToString();
                        string courseTitle = reader["TC_CourseName"].ToString();

                        // Set course name
                        courseName.InnerText = courseTitle;

                        // Set course image (moved below title)
                        string imagePath = reader["TC_CoverImage"]?.ToString();
                        courseImage.ImageUrl = !string.IsNullOrEmpty(imagePath) ? ResolveUrl("~/" + imagePath.TrimStart('~', '/')) : "Images/Covers/default-course.jpg";

                        // Set course mode
                        courseMode.InnerText = mode;

                        // Set instructor (from session)
                        instructor.InnerText = $"{userFirstName} {userLastName}";

                        // Set rating (always 4.5)
                        rating.InnerHtml = @"<span style='color:#FFD700'>★★★★☆</span> 4.5";

                        // Set duration
                        string durationStr = reader["TC_Duration"]?.ToString();

                        if (!string.IsNullOrEmpty(durationStr))
                        {
                            if (durationStr.Contains(":"))
                            {
                                string[] parts = durationStr.Split(':');
                                courseDuration.InnerText = $"{parts[0]} hours {parts[1]} minutes";
                            }
                            else
                            {
                                courseDuration.InnerText = durationStr + " hours";
                            }
                        }
                        else
                        {
                            courseDuration.InnerText = "—";
                        }

                        // Skill Level
                        courseSkill.InnerText = reader["TC_SkillLevel"]?.ToString() ?? "—";

                        // Language
                        courseLanguage.InnerText = reader["TC_Language"]?.ToString() ?? "—";

                        // Published: date and time
                        object dateObj = reader["TC_PublishDate"];
                        object timeObj = reader["TC_PublishTime"];
                        string formattedPublish = "—";
                        if (dateObj != DBNull.Value && timeObj != DBNull.Value)
                        {
                            DateTime datePart;
                            TimeSpan timePart;
                            if (DateTime.TryParse(dateObj.ToString(), out datePart) && TimeSpan.TryParse(timeObj.ToString(), out timePart))
                            {
                                // Combine date and time for display
                                DateTime publishDateTime = datePart.Date + timePart;
                                formattedPublish = publishDateTime.ToString("dd MMM yyyy, h:mm tt"); // Example: 30 May 2025, 3:44 AM
                            }
                        }
                        publishedDate.InnerText = formattedPublish;

                        // Show/hide lectures/join meeting & calendar
                        bool isSynchronous = (mode != null && mode.Equals("Synchronous", StringComparison.OrdinalIgnoreCase));
                        lecturesDiv.Visible = isSynchronous;
                        calendarPanel.Visible = isSynchronous;
                    }
                    else
                    {
                        courseName.InnerText = "Course not found.";
                    }
                }
            }
        }

        protected void btnAddResource_Click(object sender, EventArgs e)
        {
            string selectedCourse = Request.QueryString["course"] ?? (Session["SelectedCourse"] as string);
            if (string.IsNullOrEmpty(selectedCourse)) return;

            if (resourceUpload.HasFile)
            {
                string fileName = System.IO.Path.GetFileName(resourceUpload.FileName);
                string ext = System.IO.Path.GetExtension(fileName).ToLower();

                // Only allow: .mp4, .pdf, .doc, .docx, .ppt, .pptx
                if (ext == ".png" || ext == ".jpg" || ext == ".jpeg")
                {
                    // Show error popup (server-side fallback)
                    ClientScript.RegisterStartupScript(this.GetType(), "fileTypeError", "alert('Only PDF, Word, PowerPoint, and Video files are allowed. Image files (.png, .jpg) cannot be uploaded.');", true);
                    return;
                }
                if (!(ext == ".mp4" || ext == ".pdf" || ext == ".doc" || ext == ".docx" || ext == ".ppt" || ext == ".pptx"))
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "fileTypeError", "alert('Only PDF, Word, PowerPoint, and Video files are allowed.');", true);
                    return;
                }

                string savePath = Server.MapPath("~/Resources/") + fileName;
                resourceUpload.SaveAs(savePath);
                string relativePath = "Resources/" + fileName;

                string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string existingFiles = "";
                    using (SqlCommand getCmd = new SqlCommand("SELECT TC_ResourceFile FROM TeacherCourses WHERE TC_CourseName=@CourseName", conn))
                    {
                        getCmd.Parameters.AddWithValue("@CourseName", selectedCourse);
                        var val = getCmd.ExecuteScalar();
                        if (val != null && val != DBNull.Value)
                            existingFiles = val.ToString();
                    }

                    var filesList = new List<string>();
                    if (!string.IsNullOrWhiteSpace(existingFiles))
                        filesList.AddRange(existingFiles.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries).Select(f => f.Trim()));
                    filesList.Add(relativePath);

                    string newFiles = string.Join(",", filesList);

                    using (SqlCommand cmd = new SqlCommand("UPDATE TeacherCourses SET TC_ResourceFile=@files WHERE TC_CourseName=@CourseName", conn))
                    {
                        cmd.Parameters.AddWithValue("@files", newFiles);
                        cmd.Parameters.AddWithValue("@CourseName", selectedCourse);
                        cmd.ExecuteNonQuery();
                    }
                }
                LoadResources(selectedCourse);
            }
        }

        protected void ResourceRepeater_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DeleteResource")
            {
                string fileToDelete = e.CommandArgument as string;
                string selectedCourse = Request.QueryString["course"] ?? (Session["SelectedCourse"] as string);
                string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string existingFiles = "";
                    using (SqlCommand getCmd = new SqlCommand("SELECT TC_ResourceFile FROM TeacherCourses WHERE TC_CourseName=@CourseName", conn))
                    {
                        getCmd.Parameters.AddWithValue("@CourseName", selectedCourse);
                        var val = getCmd.ExecuteScalar();
                        if (val != null && val != DBNull.Value)
                            existingFiles = val.ToString();
                    }

                    var filesList = new List<string>();
                    if (!string.IsNullOrWhiteSpace(existingFiles))
                        filesList.AddRange(existingFiles.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries).Select(f => f.Trim()));

                    filesList = filesList.Where(f => !string.Equals(f, fileToDelete, StringComparison.OrdinalIgnoreCase)).ToList();

                    string newFiles = string.Join(",", filesList);

                    using (SqlCommand cmd = new SqlCommand("UPDATE TeacherCourses SET TC_ResourceFile=@files WHERE TC_CourseName=@CourseName", conn))
                    {
                        cmd.Parameters.AddWithValue("@files", newFiles);
                        cmd.Parameters.AddWithValue("@CourseName", selectedCourse);
                        cmd.ExecuteNonQuery();
                    }
                }
                LoadResources(selectedCourse);
            }
        }

        private void LoadResources(string selectedCourse)
        {
            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            List<Resource> videoResources = new List<Resource>();
            List<Resource> readingResources = new List<Resource>();
            List<Resource> pptResources = new List<Resource>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = "SELECT TC_ResourceFile FROM TeacherCourses WHERE TC_CourseName = @CourseName";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseName", selectedCourse);
                    var val = cmd.ExecuteScalar();
                    if (val != null && val != DBNull.Value)
                    {
                        string[] files = val.ToString().Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                        foreach (var file in files)
                        {
                            string fileName = System.IO.Path.GetFileName(file);
                            string ext = System.IO.Path.GetExtension(fileName).ToLower();
                            string filePath = file.Trim();
                            if (ext == ".mp4") videoResources.Add(new Resource { FileName = fileName, FilePath = filePath });
                            else if (ext == ".pdf" || ext == ".doc" || ext == ".docx") readingResources.Add(new Resource { FileName = fileName, FilePath = filePath });
                            else if (ext == ".ppt" || ext == ".pptx") pptResources.Add(new Resource { FileName = fileName, FilePath = filePath });
                        }
                    }
                }
            }

            VideoRepeater.DataSource = videoResources;
            VideoRepeater.DataBind();

            ReadingRepeater.DataSource = readingResources;
            ReadingRepeater.DataBind();

            // NEW: bind PowerPoint files
            PptRepeater.DataSource = pptResources;
            PptRepeater.DataBind();
        }
        protected void btnAddClass_Click(object sender, EventArgs e)
        {
            int tc_id = ViewState["TC_ID"] != null ? Convert.ToInt32(ViewState["TC_ID"]) : 0;
            if (tc_id == 0) return;

            DateTime classDate;
            TimeSpan classTime;
            if (!DateTime.TryParse(txtClassDate.Text, out classDate)) return;
            if (!TimeSpan.TryParse(txtClassTime.Text, out classTime)) return;

            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

            // --- Check for duplicate event for this course on this date ---
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string checkQuery = "SELECT COUNT(*) FROM ClassSchedule WHERE TC_ID = @tcid AND ClassDate = @date";
                using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                {
                    checkCmd.Parameters.AddWithValue("@tcid", tc_id);
                    checkCmd.Parameters.AddWithValue("@date", classDate.Date);
                    int existingCount = (int)checkCmd.ExecuteScalar();
                    if (existingCount > 0)
                    {
                        // There is already an event for this course on this date
                        ClientScript.RegisterStartupScript(this.GetType(), "ClassScheduleExists", "alert('There is already a class scheduled for this course on this date');", true);
                        return;
                    }
                }

                // No conflict, allow insert
                using (SqlCommand cmd = new SqlCommand("INSERT INTO ClassSchedule (TC_ID, ClassDate, ClassTime) VALUES (@tcid, @date, @time)", conn))
                {
                    cmd.Parameters.AddWithValue("@tcid", tc_id);
                    cmd.Parameters.AddWithValue("@date", classDate.Date);
                    cmd.Parameters.AddWithValue("@time", classTime);
                    cmd.ExecuteNonQuery();
                }
            }
            string selectedCourse = Request.QueryString["course"] ?? (Session["SelectedCourse"] as string);
            LoadClassSchedule(selectedCourse);
        }
        private void LoadClassSchedule(string courseNameStr)
        {
            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            int tc_id = 0;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT TC_ID FROM TeacherCourses WHERE TC_CourseName=@CourseName", conn))
                {
                    cmd.Parameters.AddWithValue("@CourseName", courseNameStr);
                    var val = cmd.ExecuteScalar();
                    if (val != null && val != DBNull.Value)
                        tc_id = Convert.ToInt32(val);
                }
            }
            if (tc_id == 0) { calendarLiteral.Text = ""; return; }

            List<ClassScheduleEntry> schedule = new List<ClassScheduleEntry>();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT ScheduleID, ClassDate, ClassTime FROM ClassSchedule WHERE TC_ID=@tcid", conn))
                {
                    cmd.Parameters.AddWithValue("@tcid", tc_id);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            schedule.Add(new ClassScheduleEntry
                            {
                                ScheduleID = Convert.ToInt32(reader["ScheduleID"]),
                                ClassDate = Convert.ToDateTime(reader["ClassDate"]),
                                ClassTime = (TimeSpan)reader["ClassTime"]
                            });
                        }
                    }
                }
            }
            DateTime firstDay = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
            int daysInMonth = DateTime.DaysInMonth(firstDay.Year, firstDay.Month);

            var sb = new StringBuilder();
            sb.Append("<table class='calendar-table'><thead><tr>");
            string[] days = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" };
            foreach (string d in days) sb.Append("<th>" + d + "</th>");
            sb.Append("</tr></thead><tbody><tr>");

            int currentDayOfWeek = (int)firstDay.DayOfWeek;
            for (int i = 0; i < currentDayOfWeek; i++) sb.Append("<td></td>");

            for (int day = 1; day <= daysInMonth; day++)
            {
                DateTime currentDate = new DateTime(firstDay.Year, firstDay.Month, day);
                var scheduled = schedule.Where(s => s.ClassDate.Date == currentDate.Date).ToList();
                if (scheduled.Any())
                {
                    sb.Append("<td class='scheduled'>");
                    sb.Append(day + "<br/>");
                    foreach (var s in scheduled)
                    {
                        sb.Append("<span style='font-size:13px;'>" + s.ClassTime.ToString(@"hh\:mm") + "</span><br/>");
                    }
                    sb.Append("</td>");
                }
                else
                {
                    sb.Append("<td>" + day + "</td>");
                }
                if ((int)currentDate.DayOfWeek == 6 && day != daysInMonth) sb.Append("</tr><tr>");
            }
            int lastDayOfWeek = (int)new DateTime(firstDay.Year, firstDay.Month, daysInMonth).DayOfWeek;
            for (int i = lastDayOfWeek + 1; i < 7; i++) sb.Append("<td></td>");
            sb.Append("</tr></tbody></table>");
            calendarLiteral.Text = sb.ToString();
        }

        // --- FLASHCARDS SECTION: updated ---
        private void LoadFlashcards(string courseNameStr)
        {
            DataTable dtDecks = new DataTable();
            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            int tc_id = GetTC_ID();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string q = @"SELECT DeckID, DeckTitle, DeckDescription FROM FlashcardDecks WHERE TC_ID = @tcid";
                using (SqlCommand cmd = new SqlCommand(q, conn))
                {
                    cmd.Parameters.AddWithValue("@tcid", tc_id);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dtDecks);
                    }
                }
            }

            // Always show flashcards, even if there are no decks
            var decks = dtDecks.AsEnumerable().Select(row => new
            {
                DeckID = row.Field<int>("DeckID"),
                DeckTitle = row.Field<string>("DeckTitle"),
                DeckDescription = row.Field<string>("DeckDescription"),
            }).ToList();

            FlashcardDeckRepeater.DataSource = decks;
            FlashcardDeckRepeater.DataBind();

            // Ensure flashcards always show after postback (move out of !IsPostBack block)
            // (no change needed in this function, just call LoadFlashcards on every Page_Load)

            if (decks.Count == 0 && FlashcardDeckRepeater.Controls.Count > 0)
            {
                var lit = (Literal)FlashcardDeckRepeater.Controls[FlashcardDeckRepeater.Controls.Count - 1].FindControl("litNoDecks");
                if (lit != null)
                    lit.Text = "<div style='color:#888; text-align:center; margin:15px 0;'>No flashcard decks for this course yet.</div>";
            }
        }
        // This will always show all flashcards in Flashcards table for each deck
        protected void FlashcardDeckRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
                return;

            var deck = e.Item.DataItem as dynamic;
            int deckID = deck.DeckID;
            var ph = (PlaceHolder)e.Item.FindControl("phFlashcards");

            DataTable dt = new DataTable();
            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT FlashcardID, FrontText, BackText FROM Flashcards WHERE DeckID=@deckid", conn))
                {
                    cmd.Parameters.AddWithValue("@deckid", deckID);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }
            if (dt.Rows.Count > 0)
            {
                var sb = new StringBuilder();
                sb.Append("<div class='flashcard-showcase'>");
                foreach (DataRow row in dt.Rows)
                {
                    string front = Server.HtmlEncode(row["FrontText"].ToString());
                    string back = Server.HtmlEncode(row["BackText"].ToString());
                    string flashcardId = row["FlashcardID"].ToString();
                    sb.Append($@"
  <div class='course-flashcard'>
    <div class='card-inner'>
      <div class='card-front'>{front}<div class='card-hint'>Click to flip</div></div>
      <div class='card-back'>{back}</div>
    </div>
    <a href='flashcard.aspx?id={flashcardId}' title='Edit Flashcard' class='edit-flashcard-link' style='margin-left:10px;color:#3c40c1;font-size:17px;vertical-align:middle;'>
      <i class='fa fa-pencil-alt'></i>
    </a>
  </div>
");
                }
                sb.Append("</div>");
                ph.Controls.Add(new Literal { Text = sb.ToString() });
            }
            else
            {
                ph.Controls.Add(new Literal { Text = "<div style='color:#888;text-align:center;font-size:0.97rem;'>No cards in this deck yet.</div>" });
            }
        }

        public string GetTimeAgo(DateTime dateTime)
        {
            var span = DateTime.Now - dateTime;
            if (span.TotalDays >= 1)
                return $"{(int)span.TotalDays}d";
            if (span.TotalHours >= 1)
                return $"{(int)span.TotalHours}h";
            if (span.TotalMinutes >= 1)
                return $"{(int)span.TotalMinutes}m";
            return "Just now";
        }
    }
}