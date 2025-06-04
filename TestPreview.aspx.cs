using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Script.Serialization;
using System.Collections.Generic;
using System.Text;
using System.Web.UI.HtmlControls;

namespace WAPPSS
{
    public partial class TestPreview : System.Web.UI.Page
    {
        public string CourseName { get; set; }
        protected string ModeType = "light";

        protected void Page_Load(object sender, EventArgs e)
        {
            FetchAndApplyModeType();

            int testId = 0;
            int.TryParse(Request.QueryString["testid"], out testId);
            if (testId == 0) return;
            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            string title = "", instr = "";
            int time = 0;
            var questions = new List<QuestionPreview>();
            var correctAnswers = new List<List<int>>();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
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
                using (SqlCommand cmd = new SqlCommand("SELECT QuestionID, QuestionText, QuestionType, QuestionOrder FROM TestQuestions WHERE TestID=@tid ORDER BY QuestionOrder", conn))
                {
                    cmd.Parameters.AddWithValue("@tid", testId);
                    using (var r = cmd.ExecuteReader())
                    {
                        while (r.Read())
                        {
                            questions.Add(new QuestionPreview
                            {
                                QuestionID = (int)r["QuestionID"],
                                Text = r["QuestionText"].ToString(),
                                Type = r["QuestionType"].ToString()
                            });
                        }
                    }
                }
                // For radio/checkbox, need options
                for (int i = 0; i < questions.Count; i++)
                {
                    if (questions[i].Type == "radio" || questions[i].Type == "checkbox")
                    {
                        questions[i].Options = new List<string>();
                        correctAnswers.Add(new List<int>());
                        using (SqlCommand cmd = new SqlCommand("SELECT OptionText, IsCorrect FROM TestOptions WHERE QuestionID=@qid", conn))
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
                // Fetch course name for this test
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT t.TestTitle, t.TestInstructions, t.TestTime, tc.TC_CourseName " +
                    "FROM Test t INNER JOIN TeacherCourses tc ON t.TC_ID = tc.TC_ID WHERE t.TestID=@tid", conn))
                {
                    cmd.Parameters.AddWithValue("@tid", testId);
                    using (var r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            title = r["TestTitle"].ToString();
                            instr = r["TestInstructions"].ToString();
                            time = Convert.ToInt32(r["TestTime"]);
                            CourseName = r["TC_CourseName"].ToString();
                        }
                    }
                }
            }
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
            PreviewPanel.Controls.Add(new System.Web.UI.LiteralControl(sb.ToString()));
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

        public class QuestionPreview
        {
            public int QuestionID { get; set; }
            public string Text { get; set; }
            public string Type { get; set; }
            public List<string> Options { get; set; }
        }
    }
}