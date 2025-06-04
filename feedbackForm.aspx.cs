using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WAPPSS
{
    public partial class feedbackForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is logged in
                if (Session["UserID"] == null)
                {
                    Response.Redirect("Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.ToString()));
                    return;
                }

                // Apply dark mode if needed
                ApplyDarkModeIfNeeded();

                // Set focus to category dropdown
                ddlCategory.Focus();
            }
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

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            try
            {
                // Hide previous messages
                pnlSuccessMessage.Visible = false;
                pnlErrorMessage.Visible = false;

                // Check if user is still logged in
                if (Session["UserID"] == null)
                {
                    Response.Redirect("Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.ToString()));
                    return;
                }

                // Validate form inputs
                if (!Page.IsValid)
                {
                    ShowErrorMessage("Please correct the errors and try again.");
                    return;
                }

                string category = ddlCategory.SelectedValue.Trim();
                string content = txtContent.Text.Trim();
                int userId = Convert.ToInt32(Session["UserID"]);

                // Additional server-side validation
                if (string.IsNullOrEmpty(category))
                {
                    ShowErrorMessage("Please select a feedback category.");
                    return;
                }

                if (string.IsNullOrEmpty(content))
                {
                    ShowErrorMessage("Please enter your feedback.");
                    return;
                }

                if (content.Length > 2000)
                {
                    ShowErrorMessage("Feedback content cannot exceed 2000 characters.");
                    return;
                }

                // Save feedback to database
                bool success = SaveFeedback(userId, category, content);

                if (success)
                {
                    ShowSuccessMessage("Thank you for your feedback! We appreciate your input and will review it carefully.");
                    ClearForm();
                }
                else
                {
                    ShowErrorMessage("An error occurred while submitting your feedback. Please try again.");
                }
            }
            catch (Exception ex)
            {
                // Log the error (you might want to implement proper logging here)
                ShowErrorMessage("An unexpected error occurred. Please try again later.");

                // For debugging purposes - remove in production
                System.Diagnostics.Debug.WriteLine("Feedback Form Error: " + ex.Message);
            }
        }

        private bool SaveFeedback(int userId, string category, string content)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string insertQuery = @"
                        INSERT INTO Feedback (UserID, Category, Content, FeedbackDate) 
                        VALUES (@UserID, @Category, @Content, GETDATE())";

                    using (SqlCommand command = new SqlCommand(insertQuery, connection))
                    {
                        command.Parameters.AddWithValue("@UserID", userId);
                        command.Parameters.AddWithValue("@Category", category);
                        command.Parameters.AddWithValue("@Content", content);

                        int rowsAffected = command.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (SqlException sqlEx)
            {
                // Log SQL-specific errors
                System.Diagnostics.Debug.WriteLine("SQL Error in SaveFeedback: " + sqlEx.Message);
                return false;
            }
            catch (Exception ex)
            {
                // Log general errors
                System.Diagnostics.Debug.WriteLine("General Error in SaveFeedback: " + ex.Message);
                return false;
            }
        }

        private void ShowSuccessMessage(string message)
        {
            lblSuccessMessage.Text = message;
            pnlSuccessMessage.Visible = true;
            pnlErrorMessage.Visible = false;
        }

        private void ShowErrorMessage(string message)
        {
            lblErrorMessage.Text = message;
            pnlErrorMessage.Visible = true;
            pnlSuccessMessage.Visible = false;
        }

        private void ClearForm()
        {
            ddlCategory.SelectedIndex = 0;
            txtContent.Text = string.Empty;
            ddlCategory.Focus();
        }

        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);

            // Register client script for character counter
            string script = @"
                function updateCharCounter() {
                    var textArea = document.getElementById('" + txtContent.ClientID + @"');
                    var charCount = document.getElementById('charCount');
                    if (textArea && charCount) {
                        var currentLength = textArea.value.length;
                        charCount.textContent = currentLength;
                        
                        // Change color when approaching limit
                        if (currentLength > 1800) {
                            charCount.style.color = '#f44336';
                        } else if (currentLength > 1500) {
                            charCount.style.color = '#ff9800';
                        } else {
                            charCount.style.color = '#607d8b';
                        }
                    }
                }
                
                // Initialize character counter
                if (document.readyState === 'loading') {
                    document.addEventListener('DOMContentLoaded', updateCharCounter);
                } else {
                    updateCharCounter();
                }
            ";

            ClientScript.RegisterStartupScript(this.GetType(), "CharCounterScript", script, true);
        }
    }
}