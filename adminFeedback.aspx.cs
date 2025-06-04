using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace WAPPSS
{
    public partial class adminFeedback : System.Web.UI.Page
    {
        // Connection string from web.config
        private string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if admin is logged in
            if (Session["AdminID"] == null || Session["AdminAuthenticated"] == null || !(bool)Session["AdminAuthenticated"])
            {
                Response.Redirect("adminLogin.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // Load feedback data
                BindFeedbackData();

                // Load admin information in the header
                LoadAdminInfo();
            }
        }

        private void LoadAdminInfo()
        {
            try
            {
                // Get admin ID from session
                int adminId = Convert.ToInt32(Session["AdminID"]);

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "SELECT Username FROM Admins WHERE AdminID = @AdminID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@AdminID", adminId);

                        conn.Open();
                        object result = cmd.ExecuteScalar();

                        if (result != null && result != DBNull.Value)
                        {
                            string username = result.ToString();

                            // Update the admin display
                            litAdminInitial.Text = username.Length > 0 ? username[0].ToString().ToUpper() : "A";
                            litAdminName.Text = username;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading admin info: " + ex.Message);
            }
        }

        private void BindFeedbackData()
        {
            string searchText = txtSearch.Text.Trim();
            string selectedCategory = ddlCategories.SelectedValue;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;

                    // Simplified SQL query using only columns that exist
                    string sql = @"SELECT f.FeedbackId, f.Content, f.Category, f.FeedbackDate, 
                                 u.UserName, 
                                 ISNULL(u.Email, 'N/A') as Email,
                                 'User' as [From]
                                 FROM Feedback f
                                 INNER JOIN Users u ON f.UserID = u.UserID
                                 WHERE 1=1";

                    // Add search filter
                    if (!string.IsNullOrEmpty(searchText))
                    {
                        sql += " AND (f.Content LIKE @Search OR u.UserName LIKE @Search)";
                        cmd.Parameters.AddWithValue("@Search", "%" + searchText + "%");
                    }

                    // Add category filter
                    if (!string.IsNullOrEmpty(selectedCategory))
                    {
                        sql += " AND f.Category = @Category";
                        cmd.Parameters.AddWithValue("@Category", selectedCategory);
                    }

                    sql += " ORDER BY f.FeedbackDate DESC";

                    cmd.CommandText = sql;

                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();

                    try
                    {
                        conn.Open();
                        adapter.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            gvFeedback.DataSource = dt;
                            gvFeedback.DataBind();

                            // Update feedback count display
                            string searchInfo = "";
                            if (!string.IsNullOrEmpty(searchText) || !string.IsNullOrEmpty(selectedCategory))
                            {
                                // Get total count without filters for comparison
                                int totalCount = GetTotalFeedbackCount();
                                searchInfo = $" (filtered from {totalCount} total)";
                            }

                            lblFeedbackCount.Text = $"Showing {dt.Rows.Count} feedback items{searchInfo}";
                        }
                        else
                        {
                            gvFeedback.DataSource = null;
                            gvFeedback.DataBind();

                            if (!string.IsNullOrEmpty(searchText) || !string.IsNullOrEmpty(selectedCategory))
                            {
                                lblFeedbackCount.Text = "No feedback found matching your criteria";
                            }
                            else
                            {
                                lblFeedbackCount.Text = "No feedback available";
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        // Log error and display user-friendly message
                        System.Diagnostics.Debug.WriteLine("Error loading feedback data: " + ex.Message);
                        lblFeedbackCount.Text = "Error loading feedback data. Please try again.";

                        gvFeedback.DataSource = null;
                        gvFeedback.DataBind();
                    }
                }
            }
        }

        private int GetTotalFeedbackCount()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "SELECT COUNT(*) FROM Feedback";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        return Convert.ToInt32(cmd.ExecuteScalar());
                    }
                }
            }
            catch
            {
                return 0;
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            // Reset to first page when searching
            gvFeedback.PageIndex = 0;
            BindFeedbackData();
        }

        protected void ddlCategories_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Reset to first page when filtering
            gvFeedback.PageIndex = 0;
            BindFeedbackData();
        }

        protected void gvFeedback_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvFeedback.PageIndex = e.NewPageIndex;
            BindFeedbackData();
        }

        protected void gvFeedback_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewDetails")
            {
                int feedbackId = Convert.ToInt32(e.CommandArgument);
                // Get feedback details and show in modal
                ShowFeedbackDetailsModal(feedbackId);
            }
        }

        private void ShowFeedbackDetailsModal(int feedbackId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    // Simplified SQL query using only columns that exist
                    cmd.CommandText = @"SELECT f.Content, f.Category, f.FeedbackDate, 
                                     u.UserName, 
                                     ISNULL(u.Email, 'N/A') as Email,
                                     'User' as [From]
                                     FROM Feedback f
                                     INNER JOIN Users u ON f.UserID = u.UserID
                                     WHERE f.FeedbackId = @FeedbackId";
                    cmd.Parameters.AddWithValue("@FeedbackId", feedbackId);

                    try
                    {
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            string userName = reader["UserName"].ToString();
                            string email = reader["Email"].ToString();
                            string category = reader["Category"].ToString();
                            string content = reader["Content"].ToString();
                            DateTime feedbackDate = Convert.ToDateTime(reader["FeedbackDate"]);
                            string userRole = "User"; // Fixed value since Role column doesn't exist

                            // Format the information for display
                            string userInfo = $"{userName} ({email}) - {userRole}";
                            string dateInfo = feedbackDate.ToString("MMMM dd, yyyy h:mm tt");

                            // Escape quotes and newlines for JavaScript
                            string escapedUserInfo = userInfo.Replace("'", "\\'").Replace("\"", "\\\"");
                            string escapedCategory = category.Replace("'", "\\'").Replace("\"", "\\\"");
                            string escapedContent = content.Replace("'", "\\'").Replace("\"", "\\\"").Replace("\r\n", "\\n").Replace("\n", "\\n").Replace("\r", "\\n");

                            // Use JavaScript to show the modal with feedback details
                            string script = $@"
                                showFeedbackDetails(
                                    '{escapedUserInfo}',
                                    '{escapedCategory}',
                                    '{dateInfo}',
                                    '{escapedContent}'
                                );
                            ";

                            ScriptManager.RegisterStartupScript(this, GetType(), "showFeedbackModal", script, true);
                        }
                        else
                        {
                            // Feedback not found
                            string script = "alert('Feedback details not found.');";
                            ScriptManager.RegisterStartupScript(this, GetType(), "feedbackNotFound", script, true);
                        }
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Error loading feedback details: " + ex.Message);
                        string script = "alert('Error loading feedback details. Please try again.');";
                        ScriptManager.RegisterStartupScript(this, GetType(), "feedbackError", script, true);
                    }
                }
            }
        }

        // Helper method to truncate content text
        public string TruncateContent(string content, int maxLength)
        {
            if (string.IsNullOrEmpty(content))
                return string.Empty;

            if (content.Length <= maxLength)
                return content;

            return content.Substring(0, maxLength) + "...";
        }
    }
}