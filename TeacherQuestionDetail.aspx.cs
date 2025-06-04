using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WAPPSS
{
    public partial class TeacherQuestionDetail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["ID"] == null)
                {
                    Response.Redirect("TeacherDiscussionForum.aspx");
                    return;
                }

                int questionId = Convert.ToInt32(Request.QueryString["ID"]);
                LoadQuestion(questionId);
                LoadReplies(questionId);

                pnlReplyForm.Visible = Session["UserID"] != null;

                // Show delete button if logged-in user is author
                btnDeleteQuestion.Visible = IsQuestionAuthor();
                btnEditQuestion.Visible = IsQuestionAuthor();
            }

            // Apply dark mode detection from database
            ApplyDarkModeIfNeeded();
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

            // Set dark mode class and CSS
            if (modeType == "dark")
            {
                // Set session for body class in ASPX
                Session["DarkMode"] = true;
                darkModeCss.Href = "darkmode.css";
            }
            else
            {
                Session["DarkMode"] = false;
            }
        }

        private void LoadQuestion(int questionId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                SELECT q.Title, q.Content, q.PostDate, u.Username, sub.SubjectName 
                FROM Questions q
                INNER JOIN Users u ON q.UserID = u.UserID
                INNER JOIN Subjects sub ON q.SubjectID = sub.SubjectID
                WHERE q.QuestionID = @QuestionID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@QuestionID", questionId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    lblTitle.Text = reader["Title"].ToString();
                    lblContent.Text = reader["Content"].ToString();
                    lblAuthor.Text = reader["Username"].ToString();
                    lblDate.Text = Convert.ToDateTime(reader["PostDate"]).ToString("MMM dd, yyyy");
                    lblSubject.Text = reader["SubjectName"].ToString();
                }
                reader.Close();
            }
        }

        private void LoadReplies(int questionId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                SELECT r.ReplyID, r.ReplyText, r.CreatedAt, r.Likes, r.IsBest,
                       u.Username, u.Category AS UserType
                FROM Replies r
                JOIN Users u ON r.RepliedBy = u.UserID
                WHERE r.QuestionID = @QuestionID
                ORDER BY r.IsBest DESC, r.CreatedAt DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@QuestionID", questionId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptReplies.DataSource = dt;
                rptReplies.DataBind();

                lblReplyCount.Text = dt.Rows.Count.ToString();
                lblNoReplies.Visible = dt.Rows.Count == 0;
            }
        }

        private bool IsQuestionAuthor()
        {
            if (Request.QueryString["ID"] == null || Session["UserID"] == null)
                return false;

            int questionId = Convert.ToInt32(Request.QueryString["ID"]);
            int userId = Convert.ToInt32(Session["UserID"]);

            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT 1 FROM Questions WHERE QuestionID = @QuestionID AND UserID = @UserID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@QuestionID", questionId);
                cmd.Parameters.AddWithValue("@UserID", userId);

                conn.Open();
                return cmd.ExecuteScalar() != null;
            }
        }

        protected void btnLike_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.ToString()));
                return;
            }

            int replyId = Convert.ToInt32(((LinkButton)sender).CommandArgument);
            int userId = Convert.ToInt32(Session["UserID"]);

            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Check if already liked
                string checkQuery = "SELECT 1 FROM AnswerLike WHERE AnswerID = @AnswerID AND UserID = @UserID";
                SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                checkCmd.Parameters.AddWithValue("@AnswerID", replyId);
                checkCmd.Parameters.AddWithValue("@UserID", userId);

                conn.Open();
                bool alreadyLiked = checkCmd.ExecuteScalar() != null;

                if (alreadyLiked)
                {
                    // Unlike
                    string deleteQuery = "DELETE FROM AnswerLike WHERE AnswerID = @AnswerID AND UserID = @UserID";
                    SqlCommand deleteCmd = new SqlCommand(deleteQuery, conn);
                    deleteCmd.Parameters.AddWithValue("@AnswerID", replyId);
                    deleteCmd.Parameters.AddWithValue("@UserID", userId);
                    deleteCmd.ExecuteNonQuery();

                    // Decrement like count
                    string updateQuery = "UPDATE Replies SET Likes = Likes - 1 WHERE ReplyID = @ReplyID";
                    SqlCommand updateCmd = new SqlCommand(updateQuery, conn);
                    updateCmd.Parameters.AddWithValue("@ReplyID", replyId);
                    updateCmd.ExecuteNonQuery();
                }
                else
                {
                    // Like
                    string insertQuery = "INSERT INTO AnswerLike (AnswerID, UserID) VALUES (@AnswerID, @UserID)";
                    SqlCommand insertCmd = new SqlCommand(insertQuery, conn);
                    insertCmd.Parameters.AddWithValue("@AnswerID", replyId);
                    insertCmd.Parameters.AddWithValue("@UserID", userId);
                    insertCmd.ExecuteNonQuery();

                    // Increment like count
                    string updateQuery = "UPDATE Replies SET Likes = Likes + 1 WHERE ReplyID = @ReplyID";
                    SqlCommand updateCmd = new SqlCommand(updateQuery, conn);
                    updateCmd.Parameters.AddWithValue("@ReplyID", replyId);
                    updateCmd.ExecuteNonQuery();
                }
            }

            // Refresh replies
            LoadReplies(Convert.ToInt32(Request.QueryString["ID"]));
        }

        protected void btnMarkBest_Click(object sender, EventArgs e)
        {
            if (!IsQuestionAuthor())
            {
                Response.Redirect("Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.ToString()));
                return;
            }

            int replyId = Convert.ToInt32(((LinkButton)sender).CommandArgument);
            int questionId = Convert.ToInt32(Request.QueryString["ID"]);

            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // First, unmark any existing best answer
                string clearQuery = "UPDATE Replies SET IsBest = 0 WHERE QuestionID = @QuestionID";
                SqlCommand clearCmd = new SqlCommand(clearQuery, conn);
                clearCmd.Parameters.AddWithValue("@QuestionID", questionId);

                // Then mark the selected reply as best
                string markQuery = "UPDATE Replies SET IsBest = 1 WHERE ReplyID = @ReplyID";
                SqlCommand markCmd = new SqlCommand(markQuery, conn);
                markCmd.Parameters.AddWithValue("@ReplyID", replyId);

                conn.Open();
                clearCmd.ExecuteNonQuery();
                markCmd.ExecuteNonQuery();
            }

            // Refresh replies
            LoadReplies(questionId);
        }

        protected void btnSubmitReply_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.ToString()));
                return;
            }

            if (string.IsNullOrWhiteSpace(txtReply.Text))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please enter your reply.');", true);
                return;
            }

            int questionId = Convert.ToInt32(Request.QueryString["ID"]);
            int userId = Convert.ToInt32(Session["UserID"]);
            string replyText = txtReply.Text.Trim();

            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Insert the reply
                string insertQuery = @"
                INSERT INTO Replies (QuestionID, RepliedBy, ReplyText, Likes, CreatedAt, IsBest)
                VALUES (@QuestionID, @RepliedBy, @ReplyText, 0, GETDATE(), 0)";

                SqlCommand insertCmd = new SqlCommand(insertQuery, conn);
                insertCmd.Parameters.AddWithValue("@QuestionID", questionId);
                insertCmd.Parameters.AddWithValue("@RepliedBy", userId);
                insertCmd.Parameters.AddWithValue("@ReplyText", replyText);

                insertCmd.ExecuteNonQuery();
            }

            txtReply.Text = "";
            LoadReplies(questionId);
        }

        protected void rptReplies_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                var dataRow = (DataRowView)e.Item.DataItem;
                string repliedBy = dataRow["Username"].ToString();
                string currentUsername = Session["Username"]?.ToString();
                bool isBest = Convert.ToBoolean(dataRow["IsBest"]);

                // Edit/Delete for replies
                LinkButton btnEdit = (LinkButton)e.Item.FindControl("btnEdit");
                LinkButton btnDelete = (LinkButton)e.Item.FindControl("btnDelete");

                if (btnEdit != null && btnDelete != null)
                {
                    btnEdit.Visible = (repliedBy == currentUsername);
                    btnDelete.Visible = (repliedBy == currentUsername);
                }

                // Mark as Best
                LinkButton btnMarkBest = (LinkButton)e.Item.FindControl("btnMarkBest");
                if (btnMarkBest != null)
                {
                    btnMarkBest.Visible = !isBest && IsQuestionAuthor();
                }
            }
        }

        // Remove nested reply functionality for now
        protected void rptNestedReplies_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            // This method is kept empty for now - no nested replies
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            int replyId = Convert.ToInt32(btn.CommandArgument);

            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // First delete from AnswerLike where this reply is liked
                string deleteLikes = "DELETE FROM AnswerLike WHERE AnswerID = @ReplyID";
                SqlCommand cmdLikes = new SqlCommand(deleteLikes, conn);
                cmdLikes.Parameters.AddWithValue("@ReplyID", replyId);
                cmdLikes.ExecuteNonQuery();

                // Then delete the reply itself
                string deleteReply = "DELETE FROM Replies WHERE ReplyID = @ReplyID";
                SqlCommand cmdReply = new SqlCommand(deleteReply, conn);
                cmdReply.Parameters.AddWithValue("@ReplyID", replyId);
                cmdReply.ExecuteNonQuery();
            }

            LoadReplies(Convert.ToInt32(Request.QueryString["ID"]));
        }

        protected void btnEditQuestion_Click(object sender, EventArgs e)
        {
            pnlEditQuestion.Visible = true;
            txtEditTitle.Text = lblTitle.Text;
            txtEditContent.Text = lblContent.Text;
        }

        protected void btnEdit_Click(object sender, EventArgs e)
        {
            LinkButton btnEdit = (LinkButton)sender;
            RepeaterItem item = (RepeaterItem)btnEdit.NamingContainer;

            Literal literalReplyText = (Literal)item.FindControl("LiteralReplyText");
            TextBox txtEditReply = (TextBox)item.FindControl("txtEditReply");
            Panel pnlEditReply = (Panel)item.FindControl("pnlEditReply");

            if (literalReplyText != null && txtEditReply != null && pnlEditReply != null)
            {
                pnlEditReply.Visible = true;
                txtEditReply.Text = literalReplyText.Text;
            }
        }

        protected void btnSaveReply_Click(object sender, EventArgs e)
        {
            LinkButton btnSave = (LinkButton)sender;
            RepeaterItem item = (RepeaterItem)btnSave.NamingContainer;
            TextBox txtEditReply = (TextBox)item.FindControl("txtEditReply");
            HiddenField hfReplyID = (HiddenField)item.FindControl("hfReplyID");

            string newReplyText = txtEditReply.Text.Trim();
            int replyId = Convert.ToInt32(hfReplyID.Value);

            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string updateQuery = "UPDATE Replies SET ReplyText = @ReplyText WHERE ReplyID = @ReplyID";
                SqlCommand cmd = new SqlCommand(updateQuery, conn);
                cmd.Parameters.AddWithValue("@ReplyText", newReplyText);
                cmd.Parameters.AddWithValue("@ReplyID", replyId);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            LoadReplies(Convert.ToInt32(Request.QueryString["ID"]));
        }

        protected void btnSaveQuestion_Click(object sender, EventArgs e)
        {
            int questionId = Convert.ToInt32(Request.QueryString["ID"]);
            string newTitle = txtEditTitle.Text.Trim();
            string newContent = txtEditContent.Text.Trim();

            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "UPDATE Questions SET Title = @Title, Content = @Content WHERE QuestionID = @QuestionID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Title", newTitle);
                cmd.Parameters.AddWithValue("@Content", newContent);
                cmd.Parameters.AddWithValue("@QuestionID", questionId);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            pnlEditQuestion.Visible = false;
            LoadQuestion(questionId);
        }

        protected void btnDeleteQuestion_Click(object sender, EventArgs e)
        {
            if (!IsQuestionAuthor())
            {
                Response.Redirect("Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.ToString()));
                return;
            }

            int questionId = Convert.ToInt32(Request.QueryString["ID"]);

            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Delete likes on replies first
                string deleteLikesQuery = @"
                DELETE AL FROM AnswerLike AL
                INNER JOIN Replies R ON AL.AnswerID = R.ReplyID
                WHERE R.QuestionID = @QuestionID";

                SqlCommand cmdDeleteLikes = new SqlCommand(deleteLikesQuery, conn);
                cmdDeleteLikes.Parameters.AddWithValue("@QuestionID", questionId);
                cmdDeleteLikes.ExecuteNonQuery();

                // Delete replies for that question
                string deleteRepliesQuery = "DELETE FROM Replies WHERE QuestionID = @QuestionID";
                SqlCommand cmdDeleteReplies = new SqlCommand(deleteRepliesQuery, conn);
                cmdDeleteReplies.Parameters.AddWithValue("@QuestionID", questionId);
                cmdDeleteReplies.ExecuteNonQuery();

                // Finally, delete the question itself
                string deleteQuestionQuery = "DELETE FROM Questions WHERE QuestionID = @QuestionID";
                SqlCommand cmdDeleteQuestion = new SqlCommand(deleteQuestionQuery, conn);
                cmdDeleteQuestion.Parameters.AddWithValue("@QuestionID", questionId);
                cmdDeleteQuestion.ExecuteNonQuery();
            }

            // Redirect back to teacher forum list after deletion
            Response.Redirect("TeacherDiscussionForum.aspx");
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            try
            {
                // Get the subject name to redirect back to the same subject in teacher forum
                string subjectName = lblSubject.Text;
                if (!string.IsNullOrEmpty(subjectName))
                {
                    Response.Redirect($"TeacherDiscussionForum.aspx?SubjectName={Server.UrlEncode(subjectName)}");
                }
                else
                {
                    Response.Redirect("TeacherDiscussionForum.aspx");
                }
            }
            catch
            {
                Response.Redirect("TeacherDiscussionForum.aspx");
            }
        }

        // Empty methods to prevent compilation errors - nested reply functionality removed
        protected void btnSubmitNestedReply_Click(object sender, EventArgs e) { }
        protected void btnSaveNestedReply_Click(object sender, EventArgs e) { }
        protected void btnCancelNestedReply_Click(object sender, EventArgs e) { }
        protected void btnDeleteNested_Click(object sender, EventArgs e) { }
        protected void btnEditNested_Click(object sender, EventArgs e) { }
    }
}