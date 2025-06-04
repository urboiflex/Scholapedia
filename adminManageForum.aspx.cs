using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Drawing;

namespace WAPPSS
{
    public partial class adminManageForum : System.Web.UI.Page
    {
        private readonly string[] SubjectColors = {
            "#8e2de2", "#4a00e0", "#ff6b6b", "#4ecdc4", "#45b7d1",
            "#96ceb4", "#ffeaa7", "#fab1a0", "#fd79a8", "#6c5ce7"
        };

        protected void Page_Load(object sender, EventArgs e)
        {
            UnobtrusiveValidationMode = UnobtrusiveValidationMode.None;

            // Check if admin is logged in
            if (Session["AdminID"] == null || Session["AdminAuthenticated"] == null || !(bool)Session["AdminAuthenticated"])
            {
                Response.Redirect("adminLogin.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // Clear any previous messages
                lblMessage.Text = string.Empty;

                // Initialize the forum discussion data
                LoadAdminInfo();
                LoadDiscussionStatistics();
                LoadSubjects();
                LoadQuestions();
                LoadRecentReplies();
            }
        }

        #region Database Methods

        private string GetConnectionString()
        {
            return ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
        }

        private void LoadAdminInfo()
        {
            try
            {
                if (Session["AdminID"] == null)
                {
                    ShowErrorMessage("Admin session has expired. Please log in again.");
                    Response.Redirect("adminLogin.aspx");
                    return;
                }

                int adminId = Convert.ToInt32(Session["AdminID"]);

                using (SqlConnection connection = new SqlConnection(GetConnectionString()))
                {
                    string query = "SELECT Username FROM Admins WHERE AdminID = @AdminID";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@AdminID", adminId);

                    try
                    {
                        connection.Open();
                        object result = command.ExecuteScalar();

                        if (result != null && result != DBNull.Value)
                        {
                            string username = result.ToString();
                            litAdminInitial.Text = username.Length > 0 ? username[0].ToString().ToUpper() : "A";
                            litAdminName.Text = username;
                        }
                        else
                        {
                            Session.Clear();
                            Response.Redirect("adminLogin.aspx");
                        }
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Error loading admin info: " + ex.Message);
                        ShowErrorMessage("Error loading admin information. Please try again.");
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in LoadAdminInfo: " + ex.Message);
                ShowErrorMessage("An error occurred. Please try again.");
            }
        }

        private void LoadDiscussionStatistics()
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(GetConnectionString()))
                {
                    try
                    {
                        connection.Open();

                        // Get total questions count
                        string totalQuestionsQuery = "SELECT COUNT(*) FROM Questions";
                        using (SqlCommand command = new SqlCommand(totalQuestionsQuery, connection))
                        {
                            int totalQuestions = Convert.ToInt32(command.ExecuteScalar());
                            litTotalQuestions.Text = totalQuestions.ToString();
                        }

                        // Get total replies count
                        string totalRepliesQuery = "SELECT COUNT(*) FROM Replies";
                        using (SqlCommand command = new SqlCommand(totalRepliesQuery, connection))
                        {
                            int totalReplies = Convert.ToInt32(command.ExecuteScalar());
                            litTotalReplies.Text = totalReplies.ToString();
                        }

                        // Get active subjects count
                        string activeSubjectsQuery = "SELECT COUNT(*) FROM Subjects";
                        using (SqlCommand command = new SqlCommand(activeSubjectsQuery, connection))
                        {
                            int activeSubjects = Convert.ToInt32(command.ExecuteScalar());
                            litActiveSubjects.Text = activeSubjects.ToString();
                        }

                        // Get total likes count
                        string totalLikesQuery = "SELECT COUNT(*) FROM AnswerLike";
                        using (SqlCommand command = new SqlCommand(totalLikesQuery, connection))
                        {
                            int totalLikes = Convert.ToInt32(command.ExecuteScalar());
                            litTotalLikes.Text = totalLikes.ToString();
                        }
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Error loading discussion statistics: " + ex.Message);

                        // Set default values
                        litTotalQuestions.Text = "0";
                        litTotalReplies.Text = "0";
                        litActiveSubjects.Text = "0";
                        litTotalLikes.Text = "0";
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in LoadDiscussionStatistics: " + ex.Message);
                ShowErrorMessage("Error loading statistics. Please try again.");
            }
        }

        private void LoadQuestions()
        {
            try
            {
                string searchText = txtSearch.Text.Trim();
                string selectedSubject = ddlFilterSubject.SelectedValue;
                string sortOrder = ddlFilterSort.SelectedValue;

                DataTable questionData = GetQuestionsList(searchText, selectedSubject, sortOrder);
                rptQuestions.DataSource = questionData;
                rptQuestions.DataBind();

                // Update question count
                litQuestionCount.Text = questionData.Rows.Count.ToString();

                // Show empty state if no questions
                pnlEmptyState.Visible = questionData.Rows.Count == 0;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in LoadQuestions: " + ex.Message);
                ShowErrorMessage("Error loading questions. Please try again.");
            }
        }

        private void LoadRecentReplies()
        {
            try
            {
                DataTable replyData = GetRecentReplies();
                rptRecentReplies.DataSource = replyData;
                rptRecentReplies.DataBind();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in LoadRecentReplies: " + ex.Message);
                ShowErrorMessage("Error loading recent replies. Please try again.");
            }
        }

        private void LoadSubjects()
        {
            try
            {
                List<Subject> subjects = GetSubjects();

                // Load filter dropdown
                ddlFilterSubject.Items.Clear();
                ddlFilterSubject.Items.Add(new ListItem("All Subjects", ""));

                foreach (Subject subject in subjects)
                {
                    ddlFilterSubject.Items.Add(new ListItem(subject.SubjectName, subject.SubjectID.ToString()));
                }

                // Load subjects repeater
                rptSubjects.DataSource = GetSubjectsWithStats();
                rptSubjects.DataBind();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in LoadSubjects: " + ex.Message);
                ShowErrorMessage("Error loading subjects. Please try again.");
            }
        }

        private DataTable GetQuestionsList(string searchText = "", string subjectFilter = "", string sortOrder = "latest")
        {
            DataTable dt = new DataTable();
            string connectionString = GetConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string baseQuery = @"
                    SELECT 
                        q.QuestionID,
                        q.Title,
                        q.Content,
                        q.PostDate,
                        q.UserID,
                        q.SubjectID,
                        s.SubjectName,
                        u.Username,
                        ISNULL(replyStats.ReplyCount, 0) as ReplyCount,
                        ISNULL(likeStats.TotalLikes, 0) as TotalLikes,
                        ISNULL(bestStats.BestReplyCount, 0) as BestReplyCount
                    FROM Questions q
                    LEFT JOIN Subjects s ON q.SubjectID = s.SubjectID
                    LEFT JOIN Users u ON q.UserID = u.UserID
                    LEFT JOIN (
                        SELECT QuestionID, COUNT(*) as ReplyCount
                        FROM Replies
                        GROUP BY QuestionID
                    ) replyStats ON q.QuestionID = replyStats.QuestionID
                    LEFT JOIN (
                        SELECT r.QuestionID, COUNT(al.LikeID) as TotalLikes
                        FROM Replies r
                        LEFT JOIN AnswerLike al ON r.ReplyID = al.AnswerID
                        GROUP BY r.QuestionID
                    ) likeStats ON q.QuestionID = likeStats.QuestionID
                    LEFT JOIN (
                        SELECT QuestionID, COUNT(*) as BestReplyCount
                        FROM Replies
                        WHERE IsBest = 1
                        GROUP BY QuestionID
                    ) bestStats ON q.QuestionID = bestStats.QuestionID
                    WHERE 1=1";

                List<SqlParameter> parameters = new List<SqlParameter>();

                // Add search filter
                if (!string.IsNullOrEmpty(searchText))
                {
                    baseQuery += " AND (q.Title LIKE @SearchText OR q.Content LIKE @SearchText OR u.Username LIKE @SearchText)";
                    parameters.Add(new SqlParameter("@SearchText", $"%{searchText}%"));
                }

                // Add subject filter
                if (!string.IsNullOrEmpty(subjectFilter) && int.TryParse(subjectFilter, out int subjectId))
                {
                    baseQuery += " AND q.SubjectID = @SubjectID";
                    parameters.Add(new SqlParameter("@SubjectID", subjectId));
                }

                // Add sort order
                string orderBy = GetSortOrderClause(sortOrder);
                baseQuery += " " + orderBy;

                SqlCommand command = new SqlCommand(baseQuery, connection);
                command.Parameters.AddRange(parameters.ToArray());

                try
                {
                    using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                    {
                        adapter.Fill(dt);
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error loading questions list: " + ex.Message);
                }
            }

            return dt;
        }

        private DataTable GetRecentReplies()
        {
            DataTable dt = new DataTable();
            string connectionString = GetConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT TOP 10
                        r.ReplyID,
                        r.QuestionID,
                        r.RepliedBy,
                        r.ReplyText,
                        r.Likes,
                        r.CreatedAt,
                        r.IsBest,
                        q.Title as QuestionTitle
                    FROM Replies r
                    INNER JOIN Questions q ON r.QuestionID = q.QuestionID
                    ORDER BY r.CreatedAt DESC";

                SqlCommand command = new SqlCommand(query, connection);

                try
                {
                    using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                    {
                        adapter.Fill(dt);
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error loading recent replies: " + ex.Message);
                }
            }

            return dt;
        }

        private List<Subject> GetSubjects()
        {
            List<Subject> subjects = new List<Subject>();
            string connectionString = GetConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT SubjectID, SubjectName FROM Subjects ORDER BY SubjectName";
                SqlCommand command = new SqlCommand(query, connection);

                try
                {
                    connection.Open();
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            subjects.Add(new Subject
                            {
                                SubjectID = Convert.ToInt32(reader["SubjectID"]),
                                SubjectName = reader["SubjectName"].ToString()
                            });
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error loading subjects: " + ex.Message);
                }
            }

            return subjects;
        }

        private DataTable GetSubjectsWithStats()
        {
            DataTable dt = new DataTable();
            string connectionString = GetConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        s.SubjectID,
                        s.SubjectName,
                        ISNULL(questionStats.QuestionCount, 0) as QuestionCount
                    FROM Subjects s
                    LEFT JOIN (
                        SELECT SubjectID, COUNT(*) as QuestionCount
                        FROM Questions
                        GROUP BY SubjectID
                    ) questionStats ON s.SubjectID = questionStats.SubjectID
                    ORDER BY s.SubjectName";

                SqlCommand command = new SqlCommand(query, connection);

                try
                {
                    using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                    {
                        adapter.Fill(dt);
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error loading subjects with stats: " + ex.Message);
                }
            }

            return dt;
        }

        private bool DeleteQuestion(int questionId)
        {
            bool success = false;
            string connectionString = GetConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    using (SqlTransaction transaction = connection.BeginTransaction())
                    {
                        try
                        {
                            // First delete all likes for replies in this question
                            string deleteLikesQuery = @"
                                DELETE al FROM AnswerLike al
                                INNER JOIN Replies r ON al.AnswerID = r.ReplyID
                                WHERE r.QuestionID = @QuestionID";
                            using (SqlCommand command = new SqlCommand(deleteLikesQuery, connection, transaction))
                            {
                                command.Parameters.AddWithValue("@QuestionID", questionId);
                                command.ExecuteNonQuery();
                            }

                            // Then delete all replies for this question
                            string deleteRepliesQuery = "DELETE FROM Replies WHERE QuestionID = @QuestionID";
                            using (SqlCommand command = new SqlCommand(deleteRepliesQuery, connection, transaction))
                            {
                                command.Parameters.AddWithValue("@QuestionID", questionId);
                                command.ExecuteNonQuery();
                            }

                            // Finally delete the question
                            string deleteQuestionQuery = "DELETE FROM Questions WHERE QuestionID = @QuestionID";
                            using (SqlCommand command = new SqlCommand(deleteQuestionQuery, connection, transaction))
                            {
                                command.Parameters.AddWithValue("@QuestionID", questionId);
                                int result = command.ExecuteNonQuery();
                                success = (result > 0);
                            }

                            transaction.Commit();
                        }
                        catch (Exception ex)
                        {
                            transaction.Rollback();
                            System.Diagnostics.Debug.WriteLine("Error in question deletion transaction: " + ex.Message);
                            throw;
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error deleting question: " + ex.Message);
                }
            }

            return success;
        }

        private bool DeleteReply(int replyId)
        {
            bool success = false;
            string connectionString = GetConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    using (SqlTransaction transaction = connection.BeginTransaction())
                    {
                        try
                        {
                            // First delete all likes for this reply
                            string deleteLikesQuery = "DELETE FROM AnswerLike WHERE AnswerID = @ReplyID";
                            using (SqlCommand command = new SqlCommand(deleteLikesQuery, connection, transaction))
                            {
                                command.Parameters.AddWithValue("@ReplyID", replyId);
                                command.ExecuteNonQuery();
                            }

                            // Then delete the reply
                            string deleteReplyQuery = "DELETE FROM Replies WHERE ReplyID = @ReplyID";
                            using (SqlCommand command = new SqlCommand(deleteReplyQuery, connection, transaction))
                            {
                                command.Parameters.AddWithValue("@ReplyID", replyId);
                                int result = command.ExecuteNonQuery();
                                success = (result > 0);
                            }

                            transaction.Commit();
                        }
                        catch (Exception ex)
                        {
                            transaction.Rollback();
                            System.Diagnostics.Debug.WriteLine("Error in reply deletion transaction: " + ex.Message);
                            throw;
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error deleting reply: " + ex.Message);
                }
            }

            return success;
        }

        private bool ToggleBestReply(int replyId)
        {
            bool success = false;
            string connectionString = GetConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    using (SqlTransaction transaction = connection.BeginTransaction())
                    {
                        try
                        {
                            // Get current best status and question ID
                            string getCurrentStatusQuery = "SELECT IsBest, QuestionID FROM Replies WHERE ReplyID = @ReplyID";
                            bool currentBestStatus = false;
                            int questionId = 0;

                            using (SqlCommand command = new SqlCommand(getCurrentStatusQuery, connection, transaction))
                            {
                                command.Parameters.AddWithValue("@ReplyID", replyId);
                                using (SqlDataReader reader = command.ExecuteReader())
                                {
                                    if (reader.Read())
                                    {
                                        currentBestStatus = Convert.ToBoolean(reader["IsBest"]);
                                        questionId = Convert.ToInt32(reader["QuestionID"]);
                                    }
                                }
                            }

                            if (questionId > 0)
                            {
                                if (!currentBestStatus)
                                {
                                    // Remove best status from all other replies in this question
                                    string removeBestQuery = "UPDATE Replies SET IsBest = 0 WHERE QuestionID = @QuestionID";
                                    using (SqlCommand command = new SqlCommand(removeBestQuery, connection, transaction))
                                    {
                                        command.Parameters.AddWithValue("@QuestionID", questionId);
                                        command.ExecuteNonQuery();
                                    }

                                    // Set this reply as best
                                    string setBestQuery = "UPDATE Replies SET IsBest = 1 WHERE ReplyID = @ReplyID";
                                    using (SqlCommand command = new SqlCommand(setBestQuery, connection, transaction))
                                    {
                                        command.Parameters.AddWithValue("@ReplyID", replyId);
                                        int result = command.ExecuteNonQuery();
                                        success = (result > 0);
                                    }
                                }
                                else
                                {
                                    // Remove best status from this reply
                                    string removeBestQuery = "UPDATE Replies SET IsBest = 0 WHERE ReplyID = @ReplyID";
                                    using (SqlCommand command = new SqlCommand(removeBestQuery, connection, transaction))
                                    {
                                        command.Parameters.AddWithValue("@ReplyID", replyId);
                                        int result = command.ExecuteNonQuery();
                                        success = (result > 0);
                                    }
                                }
                            }

                            transaction.Commit();
                        }
                        catch (Exception ex)
                        {
                            transaction.Rollback();
                            System.Diagnostics.Debug.WriteLine("Error in toggle best reply transaction: " + ex.Message);
                            throw;
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error toggling best reply: " + ex.Message);
                }
            }

            return success;
        }

        private bool AddSubject(string subjectName)
        {
            bool success = false;
            string connectionString = GetConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "INSERT INTO Subjects (SubjectName) VALUES (@SubjectName)";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@SubjectName", subjectName);

                try
                {
                    connection.Open();
                    int result = command.ExecuteNonQuery();
                    success = (result > 0);
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error adding subject: " + ex.Message);
                }
            }

            return success;
        }

        private bool DeleteSubject(int subjectId)
        {
            bool success = false;
            string connectionString = GetConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    using (SqlTransaction transaction = connection.BeginTransaction())
                    {
                        try
                        {
                            // Update questions to remove subject reference
                            string updateQuestionsQuery = "UPDATE Questions SET SubjectID = NULL WHERE SubjectID = @SubjectID";
                            using (SqlCommand command = new SqlCommand(updateQuestionsQuery, connection, transaction))
                            {
                                command.Parameters.AddWithValue("@SubjectID", subjectId);
                                command.ExecuteNonQuery();
                            }

                            // Delete the subject
                            string deleteSubjectQuery = "DELETE FROM Subjects WHERE SubjectID = @SubjectID";
                            using (SqlCommand command = new SqlCommand(deleteSubjectQuery, connection, transaction))
                            {
                                command.Parameters.AddWithValue("@SubjectID", subjectId);
                                int result = command.ExecuteNonQuery();
                                success = (result > 0);
                            }

                            transaction.Commit();
                        }
                        catch (Exception ex)
                        {
                            transaction.Rollback();
                            System.Diagnostics.Debug.WriteLine("Error in subject deletion transaction: " + ex.Message);
                            throw;
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error deleting subject: " + ex.Message);
                }
            }

            return success;
        }

        private string GetSortOrderClause(string sortValue)
        {
            switch (sortValue)
            {
                case "latest":
                    return "ORDER BY q.PostDate DESC";
                case "oldest":
                    return "ORDER BY q.PostDate ASC";
                case "replies":
                    return "ORDER BY ISNULL(replyStats.ReplyCount, 0) DESC, q.PostDate DESC";
                case "likes":
                    return "ORDER BY ISNULL(likeStats.TotalLikes, 0) DESC, q.PostDate DESC";
                default:
                    return "ORDER BY q.PostDate DESC";
            }
        }

        #endregion

        #region Event Handlers

        protected void rptQuestions_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (!int.TryParse(e.CommandArgument.ToString(), out int questionId))
            {
                ShowErrorMessage("Invalid question ID.");
                return;
            }

            if (e.CommandName == "ViewQuestion")
            {
                // Redirect to detailed question view (you can create this page)
                Response.Redirect($"adminQuestionDetail.aspx?questionId={questionId}");
            }
            else if (e.CommandName == "DeleteQuestion")
            {
                if (DeleteQuestion(questionId))
                {
                    LoadQuestions();
                    LoadDiscussionStatistics();
                    ShowSuccessMessage("Question deleted successfully.");
                }
                else
                {
                    ShowErrorMessage("Failed to delete question. Please try again.");
                }
            }
            else if (e.CommandName == "QuickReply")
            {
                // Redirect to reply page or show modal
                Response.Redirect($"adminQuestionDetail.aspx?questionId={questionId}#reply");
            }
        }

        protected void rptRecentReplies_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewQuestion")
            {
                if (!int.TryParse(e.CommandArgument.ToString(), out int questionId))
                {
                    ShowErrorMessage("Invalid question ID.");
                    return;
                }
                Response.Redirect($"adminQuestionDetail.aspx?questionId={questionId}");
            }
            else if (e.CommandName == "DeleteReply")
            {
                if (!int.TryParse(e.CommandArgument.ToString(), out int replyId))
                {
                    ShowErrorMessage("Invalid reply ID.");
                    return;
                }

                if (DeleteReply(replyId))
                {
                    LoadRecentReplies();
                    LoadQuestions();
                    LoadDiscussionStatistics();
                    ShowSuccessMessage("Reply deleted successfully.");
                }
                else
                {
                    ShowErrorMessage("Failed to delete reply. Please try again.");
                }
            }
            else if (e.CommandName == "ToggleBest")
            {
                if (!int.TryParse(e.CommandArgument.ToString(), out int replyId))
                {
                    ShowErrorMessage("Invalid reply ID.");
                    return;
                }

                if (ToggleBestReply(replyId))
                {
                    LoadRecentReplies();
                    LoadQuestions();
                    ShowSuccessMessage("Best answer status updated successfully.");
                }
                else
                {
                    ShowErrorMessage("Failed to update best answer status. Please try again.");
                }
            }
        }

        protected void rptSubjects_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DeleteSubject")
            {
                if (!int.TryParse(e.CommandArgument.ToString(), out int subjectId))
                {
                    ShowErrorMessage("Invalid subject ID.");
                    return;
                }

                if (DeleteSubject(subjectId))
                {
                    LoadSubjects();
                    LoadQuestions();
                    LoadDiscussionStatistics();
                    ShowSuccessMessage("Subject deleted successfully.");
                }
                else
                {
                    ShowErrorMessage("Failed to delete subject. Please try again.");
                }
            }
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            LoadQuestions();
            LoadRecentReplies();
            LoadDiscussionStatistics();
            ShowSuccessMessage("Data refreshed successfully.");
        }

        protected void btnClearFilters_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            ddlFilterSubject.SelectedIndex = 0;
            ddlFilterSort.SelectedIndex = 0;
            LoadQuestions();
        }

        protected void btnViewAllReplies_Click(object sender, EventArgs e)
        {
            // Load more replies or redirect to dedicated replies page
            LoadRecentReplies();
        }

        protected void btnAddSubject_Click(object sender, EventArgs e)
        {
            pnlAddSubject.Visible = !pnlAddSubject.Visible;
            txtSubjectName.Text = string.Empty;
        }

        protected void btnSaveSubject_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string subjectName = txtSubjectName.Text.Trim();

                if (string.IsNullOrEmpty(subjectName))
                {
                    ShowErrorMessage("Subject name is required.");
                    return;
                }

                if (AddSubject(subjectName))
                {
                    LoadSubjects();
                    LoadDiscussionStatistics();
                    pnlAddSubject.Visible = false;
                    txtSubjectName.Text = string.Empty;
                    ShowSuccessMessage("Subject added successfully.");
                }
                else
                {
                    ShowErrorMessage("Failed to add subject. Please try again.");
                }
            }
        }

        protected void btnCancelSubject_Click(object sender, EventArgs e)
        {
            pnlAddSubject.Visible = false;
            txtSubjectName.Text = string.Empty;
        }

        // NEW: Add event handlers for search and filter changes
        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            LoadQuestions();
        }

        protected void ddlFilterSubject_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadQuestions();
        }

        protected void ddlFilterSort_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadQuestions();
        }

        #endregion

        #region Helper Methods

        protected string TruncateText(string text, int maxLength)
        {
            if (string.IsNullOrEmpty(text) || text.Length <= maxLength)
                return text;

            return text.Substring(0, maxLength) + "...";
        }

        protected string GetSubjectColor(object dataItem)
        {
            if (dataItem == null) return SubjectColors[0];

            DataRowView row = dataItem as DataRowView;
            if (row == null) return SubjectColors[0];

            string subjectName = row["SubjectName"]?.ToString() ?? "";
            if (string.IsNullOrEmpty(subjectName)) return SubjectColors[0];

            // Use hash code to get consistent color for same subject
            int hash = Math.Abs(subjectName.GetHashCode());
            return SubjectColors[hash % SubjectColors.Length];
        }

        private void ShowErrorMessage(string message)
        {
            lblMessage.Text = message;
            lblMessage.ForeColor = Color.Red;
            lblMessage.CssClass = "message-label message-error";
            lblMessage.Visible = true;
        }

        private void ShowSuccessMessage(string message)
        {
            lblMessage.Text = message;
            lblMessage.ForeColor = Color.Green;
            lblMessage.CssClass = "message-label message-success";
            lblMessage.Visible = true;
        }

        #endregion

        #region Helper Classes

        public class Subject
        {
            public int SubjectID { get; set; }
            public string SubjectName { get; set; }
        }

        #endregion
    }
}