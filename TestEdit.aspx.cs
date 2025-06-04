using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Script.Serialization;
using System.Collections.Generic;
using System.Web.UI.HtmlControls;

namespace WAPPSS
{
    public partial class TestEdit : System.Web.UI.Page
    {
        protected string ModeType = "light"; // default
        protected int testId = 0;
        protected string courseName = ""; // NEW: Store course name

        protected void Page_Load(object sender, EventArgs e)
        {
            // Get TestID from query
            int.TryParse(Request.QueryString["id"], out testId);

            // Get course from query string (used for back-to-course button)
            courseName = Request.QueryString["course"] ?? (Session["SelectedCourse"] as string) ?? "";

            FetchAndApplyModeType();

            if (!IsPostBack)
            {
                if (testId > 0)
                {
                    LoadTest(testId);
                }
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

        private void LoadTest(int tid)
        {
            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            string testTitle = "";
            string testInstructions = "";
            int testTime = 0;

            var questionList = new List<QuestionSave>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                // Get test info + course name
                using (SqlCommand cmd = new SqlCommand("SELECT TestTitle, TestInstructions, TestTime, TC_ID FROM Test WHERE TestID=@tid", conn))
                {
                    cmd.Parameters.AddWithValue("@tid", tid);
                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            testTitle = reader["TestTitle"].ToString();
                            testInstructions = reader["TestInstructions"].ToString();
                            testTime = Convert.ToInt32(reader["TestTime"]);
                            // get course name if not in query string
                            if (string.IsNullOrEmpty(courseName) && reader["TC_ID"] != DBNull.Value)
                            {
                                int tcid = Convert.ToInt32(reader["TC_ID"]);
                                courseName = GetCourseNameByTCID(tcid);
                            }
                        }
                    }
                }
                txtTestTitle.Text = testTitle;
                txtTestInstructions.Text = testInstructions;
                txtTestTime.Text = testTime.ToString();

                // Questions (first, collect all questions and IDs)
                var questionIdList = new List<Tuple<int, string, string, int>>();
                using (SqlCommand cmd = new SqlCommand("SELECT QuestionID, QuestionText, QuestionType, QuestionOrder FROM TestQuestions WHERE TestID=@tid ORDER BY QuestionOrder", conn))
                {
                    cmd.Parameters.AddWithValue("@tid", tid);
                    using (var qReader = cmd.ExecuteReader())
                    {
                        while (qReader.Read())
                        {
                            questionIdList.Add(
                                Tuple.Create(
                                    Convert.ToInt32(qReader["QuestionID"]),
                                    qReader["QuestionText"].ToString(),
                                    qReader["QuestionType"].ToString(),
                                    Convert.ToInt32(qReader["QuestionOrder"])
                                ));
                        }
                    }
                }
                foreach (var q in questionIdList)
                {
                    int qid = q.Item1;
                    string qtext = q.Item2;
                    string qtype = q.Item3;
                    var qobj = new QuestionSave
                    {
                        text = qtext,
                        type = qtype,
                        options = new List<OptionSave>()
                    };

                    string optConnStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                    using (SqlConnection optConn = new SqlConnection(optConnStr))
                    {
                        optConn.Open();
                        using (SqlCommand optCmd = new SqlCommand("SELECT OptionText, IsCorrect FROM TestOptions WHERE QuestionID=@qid", optConn))
                        {
                            optCmd.Parameters.AddWithValue("@qid", qid);
                            using (var optReader = optCmd.ExecuteReader())
                            {
                                while (optReader.Read())
                                {
                                    qobj.options.Add(new OptionSave
                                    {
                                        text = optReader["OptionText"].ToString(),
                                        correct = (Convert.ToInt32(optReader["IsCorrect"]) == 1)
                                    });
                                }
                            }
                        }
                    }
                    questionList.Add(qobj);
                }
            }
            // Serialize to JSON (store as raw JS object literal for script)
            var serializer = new JavaScriptSerializer();
            string questionsJson = serializer.Serialize(questionList ?? new List<QuestionSave>());
            // Pass to page (for inline use in <script>)
            Page.Items["QuestionsJSON"] = questionsJson;
            // Store course name in ViewState for use in markup (for back link)
            ViewState["CourseName"] = courseName;
        }

        // Helper to get course name from TC_ID
        private string GetCourseNameByTCID(int tcid)
        {
            string name = "";
            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT TC_CourseName FROM TeacherCourses WHERE TC_ID=@id", conn))
                {
                    cmd.Parameters.AddWithValue("@id", tcid);
                    object val = cmd.ExecuteScalar();
                    if (val != null && val != DBNull.Value)
                        name = val.ToString();
                }
            }
            return name;
        }

        protected void btnSaveTest_Click(object sender, EventArgs e)
        {
            if (testId <= 0) return;

            string title = txtTestTitle.Text.Trim();
            string instructions = txtTestInstructions.Text.Trim();
            int time = int.TryParse(txtTestTime.Text.Trim(), out int tval) ? tval : 0;

            var serializer = new JavaScriptSerializer();
            var questions = serializer.Deserialize<List<QuestionSave>>(hfQuestionsJSON.Value);

            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Update Test table
                using (SqlCommand cmd = new SqlCommand("UPDATE Test SET TestTitle=@title, TestInstructions=@instr, TestTime=@time WHERE TestID=@tid", conn))
                {
                    cmd.Parameters.AddWithValue("@title", title);
                    cmd.Parameters.AddWithValue("@instr", instructions);
                    cmd.Parameters.AddWithValue("@time", time);
                    cmd.Parameters.AddWithValue("@tid", testId);
                    cmd.ExecuteNonQuery();
                }

                // Delete old questions/options
                using (SqlCommand cmd = new SqlCommand("DELETE FROM TestOptions WHERE QuestionID IN (SELECT QuestionID FROM TestQuestions WHERE TestID=@tid)", conn))
                {
                    cmd.Parameters.AddWithValue("@tid", testId);
                    cmd.ExecuteNonQuery();
                }
                using (SqlCommand cmd = new SqlCommand("DELETE FROM TestQuestions WHERE TestID=@tid", conn))
                {
                    cmd.Parameters.AddWithValue("@tid", testId);
                    cmd.ExecuteNonQuery();
                }

                // Insert new questions & options
                int qOrder = 0;
                foreach (var q in questions)
                {
                    int questionId = 0;
                    using (SqlCommand cmd = new SqlCommand("INSERT INTO TestQuestions (TestID, QuestionText, QuestionType, QuestionOrder) OUTPUT INSERTED.QuestionID VALUES (@tid, @text, @type, @order)", conn))
                    {
                        cmd.Parameters.AddWithValue("@tid", testId);
                        cmd.Parameters.AddWithValue("@text", q.text ?? "");
                        cmd.Parameters.AddWithValue("@type", q.type ?? "radio");
                        cmd.Parameters.AddWithValue("@order", ++qOrder);
                        questionId = (int)cmd.ExecuteScalar();
                    }
                    if ((q.type == "radio" || q.type == "checkbox") && q.options != null)
                    {
                        foreach (var opt in q.options)
                        {
                            using (SqlCommand cmd = new SqlCommand("INSERT INTO TestOptions (QuestionID, OptionText, IsCorrect) VALUES (@qid, @opt, @iscorrect)", conn))
                            {
                                cmd.Parameters.AddWithValue("@qid", questionId);
                                cmd.Parameters.AddWithValue("@opt", opt.text ?? "");
                                cmd.Parameters.AddWithValue("@iscorrect", opt.correct ? 1 : 0);
                                cmd.ExecuteNonQuery();
                            }
                        }
                    }
                }
            }
            pnlSuccess.Visible = true;
            pnlTestForm.Visible = false;
        }

        public string GetCourseForUrl()
        {
            // Use courseName from ViewState, fallback to property
            string cname = ViewState["CourseName"] as string ?? courseName ?? "";
            return Server.UrlEncode(cname);
        }

        public class QuestionSave
        {
            public string text { get; set; }
            public string type { get; set; }
            public List<OptionSave> options { get; set; }
        }
        public class OptionSave
        {
            public string text { get; set; }
            public bool correct { get; set; }
        }
    }
}