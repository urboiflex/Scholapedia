using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Script.Serialization;
using System.Collections.Generic;
using System.Text;
using System.Web.UI.HtmlControls;
using System.Web.Services;


namespace WAPPSS
{
    public partial class testForStudents : System.Web.UI.Page
    {
        public string CourseName { get; set; }
        protected string ModeType = "light";
        
        public int CourseID { get; set; } // Add this

        protected void Page_Load(object sender, EventArgs e)
        {
            FetchAndApplyModeType();

            int testId = 0;
            int.TryParse(Request.QueryString["testid"], out testId);
            if (testId == 0)
            {
                Response.Redirect("~/Default.aspx");
                return;
            }

            // Get UserID from session or query string
            int userId = 0;
            if (Session["UserID"] != null)
            {
                int.TryParse(Session["UserID"].ToString(), out userId);
            }
            else if (Request.QueryString["userid"] != null)
            {
                int.TryParse(Request.QueryString["userid"], out userId);
            }

            if (userId == 0)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            // Check if user has already taken this test
            if (HasUserTakenTest(userId, testId))
            {
                Response.Write("<script>alert('You have already taken this test.'); window.location='course_detail.aspx';</script>");
                return;
            }

            hfTestID.Value = testId.ToString();
            hfUserID.Value = userId.ToString();

            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            string title = "", instr = "";
            int time = 0;
            var questions = new List<QuestionData>();
            var correctAnswers = new List<List<int>>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Get test basic info
                using (SqlCommand cmd = new SqlCommand("SELECT TestTitle, TestInstructions, TestTime FROM Test WHERE TestID=@tid", conn))
                {
                    cmd.Parameters.AddWithValue("@tid", testId);
                    using (var r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            title = r["TestTitle"].ToString();
                            instr = r["TestInstructions"].ToString();
                            time = Convert.ToInt32(r["TestTime"]);
                        }
                    }
                }

                // Get questions
                using (SqlCommand cmd = new SqlCommand("SELECT QuestionID, QuestionText, QuestionType, QuestionOrder FROM TestQuestions WHERE TestID=@tid ORDER BY QuestionOrder", conn))
                {
                    cmd.Parameters.AddWithValue("@tid", testId);
                    using (var r = cmd.ExecuteReader())
                    {
                        while (r.Read())
                        {
                            questions.Add(new QuestionData
                            {
                                QuestionID = (int)r["QuestionID"],
                                Text = r["QuestionText"].ToString(),
                                Type = r["QuestionType"].ToString()
                            });
                        }
                    }
                }

                // Get options for radio/checkbox questions
                for (int i = 0; i < questions.Count; i++)
                {
                    if (questions[i].Type == "radio" || questions[i].Type == "checkbox")
                    {
                        questions[i].Options = new List<string>();
                        correctAnswers.Add(new List<int>());
                        using (SqlCommand cmd = new SqlCommand("SELECT OptionText, IsCorrect FROM TestOptions WHERE QuestionID=@qid ORDER BY OptionID", conn))
                        {
                            cmd.Parameters.AddWithValue("@qid", questions[i].QuestionID);
                            using (var r = cmd.ExecuteReader())
                            {
                                int optIdx = 0;
                                while (r.Read())
                                {
                                    questions[i].Options.Add(r["OptionText"].ToString());
                                    if ((bool)r["IsCorrect"]) correctAnswers[i].Add(optIdx);
                                    optIdx++;
                                }
                            }
                        }
                    }
                    else
                    {
                        correctAnswers.Add(new List<int>());
                    }
                }

                // Get course name for this test
                using (SqlCommand cmd = new SqlCommand(
    "SELECT tc.TC_CourseName, tc.TC_ID " +
    "FROM Test t INNER JOIN TeacherCourses tc ON t.TC_ID = tc.TC_ID WHERE t.TestID=@tid", conn))
                {
                    cmd.Parameters.AddWithValue("@tid", testId);
                    using (var r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            CourseName = r["TC_CourseName"].ToString();
                            CourseID = Convert.ToInt32(r["TC_ID"]); // Add this property
                        }
                    }
                }
            }

            // Set page content
            testTitle.InnerText = title;
            testInstructions.InnerText = instr;
            hfTestTime.Value = time.ToString();

            var serializer = new JavaScriptSerializer();
            hfQuestionsJSON.Value = serializer.Serialize(questions);
            hfCorrectAnswers.Value = serializer.Serialize(correctAnswers);

            // Render questions panel
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < questions.Count; i++)
            {
                var q = questions[i];
                sb.Append($"<div class='preview-question' data-type='{q.Type}'>");
                sb.Append($"<div class='q-title'>Q{i + 1}. {Server.HtmlEncode(q.Text)}</div>");

                if (q.Type == "radio" || q.Type == "checkbox")
                {
                    string inputType = q.Type;
                    for (int j = 0; j < q.Options.Count; j++)
                    {
                        sb.Append("<div class='option-row'>");
                        sb.Append($"<input type='{inputType}' name='q{i}' value='{j}' id='q{i}_opt{j}' />");
                        sb.Append($"<label for='q{i}_opt{j}'>{Server.HtmlEncode(q.Options[j])}</label>");
                        sb.Append("</div>");
                    }
                }
                else if (q.Type == "short")
                {
                    sb.Append("<input type='text' maxlength='500' />");
                }
                else if (q.Type == "long")
                {
                    sb.Append("<textarea maxlength='1000'></textarea>");
                }
                sb.Append("</div>");
            }
            QuestionsPanel.Controls.Add(new System.Web.UI.LiteralControl(sb.ToString()));
        }

        private bool HasUserTakenTest(int userId, int testId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT COUNT(*) FROM StudentTestResults WHERE UserID=@uid AND TestID=@tid";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@uid", userId);
                cmd.Parameters.AddWithValue("@tid", testId);
                conn.Open();
                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }

        private void FetchAndApplyModeType()
        {
            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT TOP 1 ModeType FROM Mode";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                object result = cmd.ExecuteScalar();
                if (result != null)
                {
                    ModeType = result.ToString().ToLower();
                }
            }
            if (ModeType == "dark")
            {
                HtmlGenericControl body = (HtmlGenericControl)this.FindControl("bodyTag");
                if (body != null)
                {
                    body.Attributes["class"] = "dark-mode";
                }
            }
        }

        [WebMethod]
        public static SaveResultResponse SaveTestResult(int userID, int testID, int score)
        {
            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Check if user has already taken this test
                    using (SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM StudentTestResults WHERE UserID=@uid AND TestID=@tid", conn))
                    {
                        checkCmd.Parameters.AddWithValue("@uid", userID);
                        checkCmd.Parameters.AddWithValue("@tid", testID);
                        int existingCount = (int)checkCmd.ExecuteScalar();

                        if (existingCount > 0)
                        {
                            return new SaveResultResponse
                            {
                                success = false,
                                message = "You have already taken this test."
                            };
                        }
                    }

                    // Insert new result
                    using (SqlCommand cmd = new SqlCommand(
                        "INSERT INTO StudentTestResults (UserID, TestID, Score, DateTaken) VALUES (@uid, @tid, @score, @date)", conn))
                    {
                        cmd.Parameters.AddWithValue("@uid", userID);
                        cmd.Parameters.AddWithValue("@tid", testID);
                        cmd.Parameters.AddWithValue("@score", score);
                        cmd.Parameters.AddWithValue("@date", DateTime.Now);

                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            return new SaveResultResponse
                            {
                                success = true,
                                message = "Test results saved successfully!"
                            };
                        }
                        else
                        {
                            return new SaveResultResponse
                            {
                                success = false,
                                message = "Failed to save test results."
                            };
                        }
                    }
                }
            }
            catch (SqlException ex)
            {
                if (ex.Number == 2627) // Unique constraint violation
                {
                    return new SaveResultResponse
                    {
                        success = false,
                        message = "You have already taken this test."
                    };
                }
                else
                {
                    return new SaveResultResponse
                    {
                        success = false,
                        message = "Database error: " + ex.Message
                    };
                }
            }
            catch (Exception ex)
            {
                return new SaveResultResponse
                {
                    success = false,
                    message = "Error saving results: " + ex.Message
                };
            }
        }

        public class QuestionData
        {
            public int QuestionID { get; set; }
            public string Text { get; set; }
            public string Type { get; set; }
            public List<string> Options { get; set; }
        }

        public class SaveResultResponse
        {
            public bool success { get; set; }
            public string message { get; set; }
        }
    }
}