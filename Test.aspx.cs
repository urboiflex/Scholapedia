using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Script.Serialization;
using System.Collections.Generic;
using System.Web.UI.HtmlControls;

namespace WAPPSS
{
    public partial class Test : System.Web.UI.Page
    {
        protected string ModeType = "light"; // default

        protected void Page_Load(object sender, EventArgs e)
        {
            FetchAndApplyModeType();
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

        protected void btnSaveTest_Click(object sender, EventArgs e)
        {
            string title = txtTestTitle.Text.Trim();
            string instructions = txtTestInstructions.Text.Trim();
            int time = int.TryParse(txtTestTime.Text.Trim(), out int tval) ? tval : 0;
            string courseName = Request.QueryString["course"] ?? (Session["SelectedCourse"] as string);

            int tc_id = 0;
            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT TC_ID FROM TeacherCourses WHERE TC_CourseName=@c", conn))
                {
                    cmd.Parameters.AddWithValue("@c", courseName);
                    var v = cmd.ExecuteScalar();
                    if (v != null && v != DBNull.Value)
                        tc_id = Convert.ToInt32(v);
                }
            }
            int userId = (Session["UserID"] != null) ? Convert.ToInt32(Session["UserID"]) : 0;
            if (tc_id == 0 || userId == 0 || string.IsNullOrEmpty(title) || time <= 0) return;

            // Parse questions JSON
            var serializer = new JavaScriptSerializer();
            var questions = serializer.Deserialize<List<QuestionSave>>(hfQuestionsJSON.Value);

            // Insert into DB
            int testId = 0;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                // Insert Test
                using (SqlCommand cmd = new SqlCommand("INSERT INTO Test (TC_ID, UserID, TestTitle, TestInstructions, TestTime) OUTPUT INSERTED.TestID VALUES (@tcid, @uid, @title, @instr, @time)", conn))
                {
                    cmd.Parameters.AddWithValue("@tcid", tc_id);
                    cmd.Parameters.AddWithValue("@uid", userId);
                    cmd.Parameters.AddWithValue("@title", title);
                    cmd.Parameters.AddWithValue("@instr", instructions);
                    cmd.Parameters.AddWithValue("@time", time);
                    testId = (int)cmd.ExecuteScalar();
                }
                // Insert Questions & Options
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

            // --- Show JS popup after saving ---
            string js = "window.showTestSavedPopup = true;";
            ClientScript.RegisterStartupScript(this.GetType(), "showTestSavedPopup", js, true);
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