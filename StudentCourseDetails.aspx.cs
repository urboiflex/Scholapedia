using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WAPPSS
{
    public partial class StudentCourseDetails : System.Web.UI.Page
    {
        protected int UserID;  // Set this from your session or auth system
        protected int TC_ID;   // Set this from your query string or context

        private string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Get course ID (TC_ID) from query string
                if (Request.QueryString["id"] != null && int.TryParse(Request.QueryString["id"], out TC_ID))
                {
                    UserID = Convert.ToInt32(Session["UserID"]);
                    ViewState["TC_ID"] = TC_ID;
                    ViewState["UserID"] = UserID;

                    // Load progress checkboxes and set states
                    LoadProgressState();

                    // Load course details
                    LoadCourseDetails(TC_ID);

                    // Load flashcards
                    LoadFlashcardDecks(TC_ID);

                    // Load resource file
                    LoadResourceFile(TC_ID.ToString());

                    // Load course tests
                    LoadTests();
                    
                }
                else
                {
                    Response.Redirect("CourseList.aspx");
                }
            }
            else
            {
                // Retrieve from ViewState on postback
                TC_ID = (int)(ViewState["TC_ID"] ?? 0);
                UserID = (int)(ViewState["UserID"] ?? 0);

                // Check if postback was triggered by checkbox
                if (Request["__EVENTTARGET"] == "UpdateProgress")
                {
                    
                    LoadProgressState(); // Refresh UI with updated values
                }
            }
            if (Session["DarkMode"] != null && (bool)Session["DarkMode"])
            {
                darkModeCss.Href = "darkmode.css";
            }
        }





        private void LoadProgressState()
        {
            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string sql = @"SELECT IsFlashcardComplete, IsResourceComplete, IsTestComplete, Progress
                       FROM CourseStudents WHERE TC_ID = @tcid AND UserID = @userid";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@tcid", TC_ID);
                    cmd.Parameters.AddWithValue("@userid", UserID);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            chkFlashcard.Checked = !reader.IsDBNull(0) && reader.GetBoolean(0);
                            chkResource.Checked = !reader.IsDBNull(1) && reader.GetBoolean(1);
                            chkTest.Checked = !reader.IsDBNull(2) && reader.GetBoolean(2);

                            int progress = reader.IsDBNull(3) ? 0 : reader.GetInt32(3);
                            UpdateProgressBar(progress);
                        }
                        else
                        {
                            // no record found, maybe create it or reset checkboxes
                            chkFlashcard.Checked = false;
                            chkResource.Checked = false;
                            chkTest.Checked = false;
                            UpdateProgressBar(0);
                        }
                    }
                }
            }
        }


        private void UpdateProgress(string section, bool isComplete)
        {
            int tc_id = TC_ID;  // Assume you have these from ViewState or session
            int user_id = UserID;

            string columnName;

            switch (section)
            {
                case "Flashcard":
                    columnName = "IsFlashcardComplete";
                    break;
                case "Resource":
                    columnName = "IsResourceComplete";
                    break;
                case "Test":
                    columnName = "IsTestComplete";
                    break;
                default:
                    throw new ArgumentException("Invalid section");
            }


            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Update the checked bit column
                string updateBitSql = $"UPDATE CourseStudents SET {columnName} = @isComplete WHERE TC_ID = @tcid AND UserID = @userid";
                using (SqlCommand cmd = new SqlCommand(updateBitSql, conn))
                {
                    cmd.Parameters.AddWithValue("@isComplete", isComplete);
                    cmd.Parameters.AddWithValue("@tcid", tc_id);
                    cmd.Parameters.AddWithValue("@userid", user_id);
                    cmd.ExecuteNonQuery();
                }

                // Recalculate progress
                string progressSql = @"
            SELECT 
                CAST(IsFlashcardComplete AS int) + 
                CAST(IsResourceComplete AS int) + 
                CAST(IsTestComplete AS int) 
            FROM CourseStudents 
            WHERE TC_ID = @tcid AND UserID = @userid";

                int completedCount = 0;
                using (SqlCommand cmd = new SqlCommand(progressSql, conn))
                {
                    cmd.Parameters.AddWithValue("@tcid", tc_id);
                    cmd.Parameters.AddWithValue("@userid", user_id);

                    var result = cmd.ExecuteScalar();
                    if (result != DBNull.Value && result != null)
                        completedCount = Convert.ToInt32(result);
                }

                // Each checked item is 33.33%, so multiply by 33 for approximate or 34 for rounding up
                int totalSections = 3;
                int progressPercent = (int)Math.Round((completedCount / (double)totalSections) * 100);


                // Update the Progress column
                string updateProgressSql = "UPDATE CourseStudents SET Progress = @progress WHERE TC_ID = @tcid AND UserID = @userid";
                using (SqlCommand cmd = new SqlCommand(updateProgressSql, conn))
                {
                    cmd.Parameters.AddWithValue("@progress", progressPercent);
                    cmd.Parameters.AddWithValue("@tcid", tc_id);
                    cmd.Parameters.AddWithValue("@userid", user_id);
                    cmd.ExecuteNonQuery();
                }

                // Update progress bar on page
                UpdateProgressBar(progressPercent);
            }
        }

        private void UpdateProgressBar(int progressPercentage)
        {
            lblProgress.Text = $"Progress: {progressPercentage}%";
            progressBar.Style["width"] = progressPercentage + "%";
        }


        protected void chkFlashcard_CheckedChanged(object sender, EventArgs e)
        {
            UpdateProgress("Flashcard", ((CheckBox)sender).Checked);
        }

        protected void chkResource_CheckedChanged(object sender, EventArgs e)
        {
            UpdateProgress("Resource", ((CheckBox)sender).Checked);
        }

        protected void chkTest_CheckedChanged(object sender, EventArgs e)
        {
            UpdateProgress("Test", ((CheckBox)sender).Checked);
        }


        private void LoadTests()
        {
            DataTable dt = new DataTable();
            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string q = @"
            SELECT t.TestID, t.TestTitle, t.TestTime, r.Score,
                   (SELECT COUNT(*) FROM TestQuestions q WHERE q.TestID = t.TestID) AS TotalQuestions
            FROM Test t
            LEFT JOIN StudentTestResults r ON t.TestID = r.TestID AND r.UserID = @UserID
            WHERE t.TC_ID = @TC_ID";

                using (SqlCommand cmd = new SqlCommand(q, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", UserID);
                    cmd.Parameters.AddWithValue("@TC_ID", TC_ID);

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
                TestTime = row.Field<int>("TestTime"),
                Score = row.IsNull("Score") ? (int?)null : row.Field<int>("Score"),
                TotalQuestions = row.Field<int>("TotalQuestions")
            }).ToList();

            TestRepeater.DataSource = tests;
            TestRepeater.DataBind();

            if (tests.Count == 0)
            {
                litNoTests.Text = "<div style='color:#888; text-align:center; margin:15px 0;'>No tests for this course yet.</div>";
            }
        }




        protected void TestRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "TakeTest")
            {
                string testID = e.CommandArgument.ToString();

                // Get UserID from session
                string userID = "";
                if (Session["UserID"] != null)
                {
                    userID = Session["UserID"].ToString();
                }

                // Redirect to testForStudents.aspx with testid parameter
                if (!string.IsNullOrEmpty(userID))
                {
                    Response.Redirect($"testForStudents.aspx?testid={testID}&userid={userID}");
                }
                else
                {
                    // If no user session, redirect to login
                    Response.Redirect("Login.aspx");
                }
            }
            else if (e.CommandName == "PreviewTest") // Keep existing preview functionality if needed
            {
                string testID = e.CommandArgument.ToString();
                Response.Redirect($"TestPreview.aspx?testid={testID}");
            }
        }

        private int GetTC_ID()
        {
            if (TC_ID == 0)
            {
                string course = Request.QueryString["course"] ?? (Session["SelectedCourse"] as string);
                if (!string.IsNullOrEmpty(course))
                {
                    string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        conn.Open();
                        using (SqlCommand cmd = new SqlCommand("SELECT TC_ID FROM TeacherCourses WHERE CourseName = @c", conn))
                        {
                            cmd.Parameters.AddWithValue("@c", course);
                            var result = cmd.ExecuteScalar();
                            if (result != null)
                            {
                                TC_ID = Convert.ToInt32(result);
                            }
                        }
                    }
                }
            }
            return TC_ID;
        }



        private void LoadResourceFile(string tcId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            string query = "SELECT TC_ResourceFile FROM TeacherCourses WHERE TC_ID = @TC_ID";

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@TC_ID", tcId);
                conn.Open();
                object result = cmd.ExecuteScalar();

                if (result != null && result != DBNull.Value)
                {
                    string resourcePath = result.ToString(); // e.g., "Resources/filename.pdf"
                    string relativeUrl = ResolveUrl("~/" + resourcePath);

                    if (resourcePath.EndsWith(".pdf", StringComparison.OrdinalIgnoreCase))
                    {
                        // Display embedded PDF viewer
                        litResourceFile.Text = "<iframe class='pdf-viewer' src='" + relativeUrl + "'></iframe>";
                    }
                    else
                    {
                        // Display link for download or unknown type
                        litResourceFile.Text = "<a class='download-link' href='" + relativeUrl + "' target='_blank'>Download Resource</a>";
                    }
                }
                else
                {
                    litResourceFile.Text = "<p>No resource file available for this course.</p>";
                }
            }
        }


        private void LoadFlashcardDecks(int tcId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string deckQuery = @"
            SELECT DeckID, DeckTitle, DeckDescription 
            FROM FlashcardDecks 
            WHERE TC_ID = @TC_ID";

                SqlCommand deckCmd = new SqlCommand(deckQuery, conn);
                deckCmd.Parameters.AddWithValue("@TC_ID", tcId);
                conn.Open();

                List<dynamic> decks = new List<dynamic>();
                SqlDataReader deckReader = deckCmd.ExecuteReader();
                while (deckReader.Read())
                {
                    var deck = new
                    {
                        DeckID = Convert.ToInt32(deckReader["DeckID"]),
                        DeckTitle = deckReader["DeckTitle"].ToString(),
                        DeckDescription = deckReader["DeckDescription"].ToString(),
                        Flashcards = new List<dynamic>()
                    };

                    decks.Add(deck);
                }
                deckReader.Close();

                // Load flashcards for each deck
                foreach (var deck in decks)
                {
                    string cardQuery = @"
                SELECT FrontText, BackText 
                FROM Flashcards 
                WHERE DeckID = @DeckID";

                    SqlCommand cardCmd = new SqlCommand(cardQuery, conn);
                    cardCmd.Parameters.AddWithValue("@DeckID", deck.DeckID);

                    SqlDataReader cardReader = cardCmd.ExecuteReader();
                    var flashcards = new List<dynamic>();

                    while (cardReader.Read())
                    {
                        flashcards.Add(new
                        {
                            FrontText = cardReader["FrontText"].ToString(),
                            BackText = cardReader["BackText"].ToString()
                        });
                    }
                    cardReader.Close();

                    // Use reflection hack to set Flashcards property (anonymous object workaround)
                    var deckField = deck.GetType().GetField("<Flashcards>i__Field", System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Instance);
                    deckField.SetValue(deck, flashcards);
                }

                rptDecks.DataSource = decks;
                rptDecks.DataBind();
            }
        }



        private void LoadCourseDetails(int courseId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
            SELECT 
                tc.TC_CourseName,
                tc.TC_CoverImage,
                tc.TC_ModuleType,
                tc.TC_Duration,
                tc.TC_SkillLevel,
                tc.TC_Language,
                tc.TC_PublishDate,
                tc.TC_PublishTime,
                u.FirstName AS InstructorName
            FROM TeacherCourses tc
            JOIN Users u ON tc.UserID = u.UserID
            WHERE tc.TC_ID = @CourseId";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        // courseName is an HtmlGenericControl (<h1>) so use InnerText
                        courseName.InnerText = reader["TC_CourseName"].ToString();

                        // courseImage is an <asp:Image>, so assign ImageUrl
                        courseImage.ImageUrl = reader["TC_CoverImage"].ToString();

                        // For these spans, use InnerText
                        courseMode.InnerText = reader["TC_ModuleType"].ToString();
                        instructor.InnerText = reader["InstructorName"].ToString();
                        courseDuration.InnerText = reader["TC_Duration"].ToString();
                        courseSkill.InnerText = reader["TC_SkillLevel"].ToString();
                        courseLanguage.InnerText = reader["TC_Language"].ToString();

                        // Format published date and time into a single string
                        DateTime publishDate = reader["TC_PublishDate"] != DBNull.Value
                            ? Convert.ToDateTime(reader["TC_PublishDate"])
                            : DateTime.MinValue;
                        string publishTime = reader["TC_PublishTime"]?.ToString() ?? "";

                        if (publishDate != DateTime.MinValue)
                        {
                            publishedDate.InnerText = publishDate.ToString("dd/MM/yyyy") + " " + publishTime;
                        }
                        else
                        {
                            publishedDate.InnerText = "";
                        }
                    }
                }
            }
        }

        protected void rptDecks_ItemCommand(object source, RepeaterCommandEventArgs e)
        {

        }
    }
}