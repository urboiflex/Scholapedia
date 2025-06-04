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
    public partial class adminSettings : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            UnobtrusiveValidationMode = UnobtrusiveValidationMode.None;

            // Check if admin is logged in - matching register pattern
            if (Session["AdminID"] == null || Session["AdminAuthenticated"] == null || !(bool)Session["AdminAuthenticated"])
            {
                Response.Redirect("adminLogin.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // Clear any previous messages
                lblMessage.Text = string.Empty;

                // Load admin information
                LoadAdminInfo();
            }
        }

        #region Database Methods

        private string GetConnectionString()
        {
            // Get connection string from web.config - matching register pattern
            return ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
        }

        private void LoadAdminInfo()
        {
            try
            {
                // Get admin ID from session
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

                            // Update form and display
                            txtUsername.Text = username;
                            litAdminInitial.Text = username.Length > 0 ? username[0].ToString().ToUpper() : "A";
                            litAdminName.Text = username;

                            // Update session if needed
                            Session["AdminUsername"] = username;
                        }
                        else
                        {
                            // Admin not found, redirect to login
                            Session.Clear();
                            Response.Redirect("adminLogin.aspx");
                        }
                    }
                    catch (Exception ex)
                    {
                        // Log the exception (in a production environment)
                        System.Diagnostics.Debug.WriteLine("Error loading admin info: " + ex.Message);
                        ShowErrorMessage("Error loading admin information. Please try again.");
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the exception (in a production environment)
                System.Diagnostics.Debug.WriteLine("Error in LoadAdminInfo: " + ex.Message);
                ShowErrorMessage("An error occurred. Please try again.");
            }
        }

        private bool IsUsernameExists(string username, int currentAdminId)
        {
            bool exists = false;
            string connectionString = GetConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM Admins WHERE Username = @Username AND AdminID != @AdminID";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@Username", username);
                command.Parameters.AddWithValue("@AdminID", currentAdminId);

                try
                {
                    connection.Open();
                    int count = (int)command.ExecuteScalar();
                    exists = (count > 0);
                }
                catch (Exception ex)
                {
                    // Log the exception (in a production environment)
                    System.Diagnostics.Debug.WriteLine("Error checking username existence: " + ex.Message);
                }
            }

            return exists;
        }

        private bool VerifyCurrentPassword(int adminId, string password)
        {
            bool isValid = false;
            string connectionString = GetConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM Admins WHERE AdminID = @AdminID AND Password = @Password";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@AdminID", adminId);
                command.Parameters.AddWithValue("@Password", password);

                try
                {
                    connection.Open();
                    int count = (int)command.ExecuteScalar();
                    isValid = (count > 0);
                }
                catch (Exception ex)
                {
                    // Log the exception (in a production environment)
                    System.Diagnostics.Debug.WriteLine("Error verifying password: " + ex.Message);
                }
            }

            return isValid;
        }

        private bool UpdateAdminProfile(int adminId, string newUsername)
        {
            bool success = false;
            string connectionString = GetConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "UPDATE Admins SET Username = @Username WHERE AdminID = @AdminID";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@Username", newUsername);
                command.Parameters.AddWithValue("@AdminID", adminId);

                try
                {
                    connection.Open();
                    int result = command.ExecuteNonQuery();
                    success = (result > 0);
                }
                catch (Exception ex)
                {
                    // Log the exception (in a production environment)
                    System.Diagnostics.Debug.WriteLine("Error updating profile: " + ex.Message);
                }
            }

            return success;
        }

        private bool UpdateAdminPassword(int adminId, string newPassword)
        {
            bool success = false;
            string connectionString = GetConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "UPDATE Admins SET Password = @Password WHERE AdminID = @AdminID";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@Password", newPassword);
                command.Parameters.AddWithValue("@AdminID", adminId);

                try
                {
                    connection.Open();
                    int result = command.ExecuteNonQuery();
                    success = (result > 0);
                }
                catch (Exception ex)
                {
                    // Log the exception (in a production environment)
                    System.Diagnostics.Debug.WriteLine("Error updating password: " + ex.Message);
                }
            }

            return success;
        }

        #endregion

        #region Event Handlers

        protected void btnUpdateProfile_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string newUsername = txtUsername.Text.Trim();

                // Additional validation
                if (string.IsNullOrEmpty(newUsername))
                {
                    lblMessage.Text = "Username is required.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Visible = true;
                    return;
                }

                if (newUsername.Length < 3)
                {
                    lblMessage.Text = "Username must be at least 3 characters long.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Visible = true;
                    return;
                }

                if (newUsername.Length > 50)
                {
                    lblMessage.Text = "Username must be less than 50 characters.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Visible = true;
                    return;
                }

                try
                {
                    int adminId = Convert.ToInt32(Session["AdminID"]);

                    // Check if the username already exists (excluding the current admin)
                    if (IsUsernameExists(newUsername, adminId))
                    {
                        lblMessage.Text = "Username already exists. Please choose a different username.";
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                        lblMessage.Visible = true;
                        return;
                    }

                    // Update the profile
                    if (UpdateAdminProfile(adminId, newUsername))
                    {
                        // Update the session
                        Session["AdminUsername"] = newUsername;

                        // Update the display
                        litAdminInitial.Text = newUsername.Length > 0 ? newUsername[0].ToString().ToUpper() : "A";
                        litAdminName.Text = newUsername;

                        lblMessage.Text = "Profile updated successfully.";
                        lblMessage.ForeColor = System.Drawing.Color.Green;
                        lblMessage.Visible = true;
                    }
                    else
                    {
                        lblMessage.Text = "Failed to update profile. Please try again.";
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                        lblMessage.Visible = true;
                    }
                }
                catch (Exception ex)
                {
                    // Log the exception (in a production environment)
                    System.Diagnostics.Debug.WriteLine("Error in btnUpdateProfile_Click: " + ex.Message);
                    lblMessage.Text = "An error occurred while updating profile. Please try again.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Visible = true;
                }
            }
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string currentPassword = txtCurrentPassword.Text;
                string newPassword = txtNewPassword.Text;
                string confirmPassword = txtConfirmPassword.Text;

                // Additional validation
                if (string.IsNullOrEmpty(currentPassword))
                {
                    lblMessage.Text = "Current password is required.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Visible = true;
                    return;
                }

                if (string.IsNullOrEmpty(newPassword))
                {
                    lblMessage.Text = "New password is required.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Visible = true;
                    return;
                }

                if (newPassword.Length < 6)
                {
                    lblMessage.Text = "New password must be at least 6 characters long.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Visible = true;
                    return;
                }

                if (newPassword != confirmPassword)
                {
                    lblMessage.Text = "New password and confirm password do not match.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Visible = true;
                    return;
                }

                try
                {
                    int adminId = Convert.ToInt32(Session["AdminID"]);

                    // Verify current password
                    if (!VerifyCurrentPassword(adminId, currentPassword))
                    {
                        lblMessage.Text = "Current password is incorrect.";
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                        lblMessage.Visible = true;
                        return;
                    }

                    // Update the password
                    if (UpdateAdminPassword(adminId, newPassword))
                    {
                        // Clear password fields
                        txtCurrentPassword.Text = string.Empty;
                        txtNewPassword.Text = string.Empty;
                        txtConfirmPassword.Text = string.Empty;

                        lblMessage.Text = "Password changed successfully.";
                        lblMessage.ForeColor = System.Drawing.Color.Green;
                        lblMessage.Visible = true;
                    }
                    else
                    {
                        lblMessage.Text = "Failed to change password. Please try again.";
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                        lblMessage.Visible = true;
                    }
                }
                catch (Exception ex)
                {
                    // Log the exception (in a production environment)
                    System.Diagnostics.Debug.WriteLine("Error in btnChangePassword_Click: " + ex.Message);
                    lblMessage.Text = "An error occurred while changing password. Please try again.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Visible = true;
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            try
            {
                // Clear all session variables
                Session.Clear();
                Session.Abandon();

                // Clear authentication cookie if exists
                if (Request.Cookies["AdminLoginCookie"] != null)
                {
                    HttpCookie cookie = new HttpCookie("AdminLoginCookie");
                    cookie.Expires = DateTime.Now.AddDays(-1); // Expire the cookie
                    Response.Cookies.Add(cookie);
                }

                // Redirect to login page
                Response.Redirect("adminLogin.aspx");
            }
            catch (Exception ex)
            {
                // Log the exception (in a production environment)
                System.Diagnostics.Debug.WriteLine("Error in btnLogout_Click: " + ex.Message);

                // Still try to redirect even if there's an error
                Response.Redirect("adminLogin.aspx");
            }
        }

        #endregion

        #region Helper Methods

        private void ShowSuccessMessage(string message)
        {
            lblMessage.Text = message;
            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Visible = true;
        }

        private void ShowErrorMessage(string message)
        {
            lblMessage.Text = message;
            lblMessage.ForeColor = System.Drawing.Color.Red;
            lblMessage.Visible = true;
        }

        #endregion
    }
}