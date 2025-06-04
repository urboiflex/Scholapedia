using System;
using System.Data.SqlClient;
using System.Web.UI;
using System.Security.Cryptography;
using System.Text;
using System.Configuration;

namespace WAPPSS
{
    public partial class login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Set focus to username field on page load
                txtUsername.Focus();
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            try
            {
                // Get and validate input
                string userInput = txtUsername.Text?.Trim() ?? "";
                string password = txtPassword.Text?.Trim() ?? "";

                // Validate inputs
                if (string.IsNullOrEmpty(userInput))
                {
                    ShowMessage("⚠️ Please enter your username or email.");
                    return;
                }

                if (string.IsNullOrEmpty(password))
                {
                    ShowMessage("⚠️ Please enter your password.");
                    return;
                }

                // Attempt login
                var loginResult = AuthenticateUser(userInput, password);

                if (loginResult.IsSuccess)
                {
                    // Set session variables
                    Session["UserID"] = loginResult.UserID;
                    Session["FirstName"] = loginResult.FirstName;
                    Session["LastName"] = loginResult.LastName;
                    Session["Category"] = loginResult.Category;
                    Session["Username"] = loginResult.Username;
                    Session["Email"] = loginResult.Email;

                    // Handle "Remember Me" functionality
                    if (chkRemember.Checked)
                    {
                        // Set a cookie to remember the user (optional)
                        Response.Cookies["RememberUser"]["Username"] = loginResult.Username;
                        Response.Cookies["RememberUser"].Expires = DateTime.Now.AddDays(30);
                    }

                    // Determine redirect URL based on user category
                    string redirectUrl = GetRedirectUrl(loginResult.Category);
                    string userTypeDisplay = GetUserTypeDisplay(loginResult.Category);

                    // Success message and redirect
                    ShowMessage($"🎉 Welcome back, {loginResult.FirstName}! Redirecting to {userTypeDisplay} dashboard...", redirectUrl);
                }
                else
                {
                    // Show error message
                    ShowMessage($"❌ {loginResult.ErrorMessage}");
                }
            }
            catch (Exception ex)
            {
                // Log error and show user-friendly message
                LogError(ex);
                ShowMessage("🔧 We're experiencing technical difficulties. Please try again later.");
            }
        }

        private LoginResult AuthenticateUser(string userInput, string password)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // Query to find user by username or email (case-sensitive for username, case-insensitive for email)
                string selectQuery = @"
                    SELECT UserID, Username, Email, Password, Category, FirstName, LastName 
                    FROM Users 
                    WHERE (Username = @Input COLLATE SQL_Latin1_General_CP1_CS_AS) 
                       OR (LOWER(Email) = LOWER(@Input))";

                using (SqlCommand cmd = new SqlCommand(selectQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@Input", userInput);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            // User found - get stored information
                            int userID = Convert.ToInt32(reader["UserID"]);
                            string username = reader["Username"].ToString();
                            string email = reader["Email"].ToString();
                            string storedPasswordHash = reader["Password"].ToString();
                            string category = reader["Category"].ToString();
                            string firstName = reader["FirstName"].ToString();
                            string lastName = reader["LastName"]?.ToString() ?? "";

                            // Verify password using the secure PBKDF2 method
                            bool passwordValid = VerifyPassword(password, storedPasswordHash);

                            if (passwordValid)
                            {
                                // Check if user category is valid (Student or Teacher)
                                if (IsValidUserCategory(category))
                                {
                                    return new LoginResult
                                    {
                                        IsSuccess = true,
                                        UserID = userID,
                                        Username = username,
                                        FirstName = firstName,
                                        LastName = lastName,
                                        Category = category,
                                        Email = email
                                    };
                                }
                                else
                                {
                                    return new LoginResult
                                    {
                                        IsSuccess = false,
                                        ErrorMessage = $"Access denied. Your account type '{category}' is not authorized for this system."
                                    };
                                }
                            }
                            else
                            {
                                return new LoginResult
                                {
                                    IsSuccess = false,
                                    ErrorMessage = "Invalid password. Please check your password and try again."
                                };
                            }
                        }
                        else
                        {
                            return new LoginResult
                            {
                                IsSuccess = false,
                                ErrorMessage = "User not found. Please check your username/email and try again."
                            };
                        }
                    }
                }
            }
        }

        // Check if the user category is valid for login
        private bool IsValidUserCategory(string category)
        {
            return category.Equals("Teacher", StringComparison.OrdinalIgnoreCase) ||
                   category.Equals("Student", StringComparison.OrdinalIgnoreCase);
        }

        // Get redirect URL based on user category
        private string GetRedirectUrl(string category)
        {
            switch (category.ToLower())
            {
                case "teacher":
                    return "course.aspx"; // or "course.aspx" if that's the teacher dashboard
                case "student":
                    return "student_dashboard.aspx";
                default:
                    return "dashboard.aspx"; // fallback default dashboard
            }
        }

        // Get user-friendly display text for user type
        private string GetUserTypeDisplay(string category)
        {
            switch (category.ToLower())
            {
                case "teacher":
                    return "Teacher";
                case "student":
                    return "Student";
                default:
                    return "User";
            }
        }

        // UPDATED: Secure password verification method (matches the registration PBKDF2 method)
        private bool VerifyPassword(string password, string storedHash)
        {
            try
            {
                // Handle both old SHA256 hashes and new PBKDF2 hashes
                // This provides backward compatibility during transition

                // Check if it's the new PBKDF2 format (should be 88 characters in Base64)
                if (storedHash.Length == 88) // 64 bytes = 88 Base64 characters
                {
                    return VerifyPBKDF2Password(password, storedHash);
                }
                else
                {
                    // Fallback to old SHA256 method for existing users
                    return VerifyLegacyPassword(password, storedHash);
                }
            }
            catch (Exception ex)
            {
                LogError(new Exception($"Password verification failed: {ex.Message}", ex));
                return false;
            }
        }

        // New PBKDF2 password verification
        private bool VerifyPBKDF2Password(string password, string storedHash)
        {
            try
            {
                // Convert stored hash back to bytes
                byte[] hashBytes = Convert.FromBase64String(storedHash);

                // Extract salt (first 32 bytes)
                byte[] salt = new byte[32];
                Array.Copy(hashBytes, 0, salt, 0, 32);

                // Extract stored hash (last 32 bytes)
                byte[] storedPasswordHash = new byte[32];
                Array.Copy(hashBytes, 32, storedPasswordHash, 0, 32);

                // Hash the provided password with the same salt
                using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, 10000))
                {
                    byte[] testHash = pbkdf2.GetBytes(32);

                    // Compare the hashes
                    for (int i = 0; i < 32; i++)
                    {
                        if (testHash[i] != storedPasswordHash[i])
                            return false;
                    }
                    return true;
                }
            }
            catch
            {
                return false;
            }
        }

        // Legacy SHA256 password verification (for backward compatibility)
        private bool VerifyLegacyPassword(string password, string storedHash)
        {
            try
            {
                using (SHA256 sha256Hash = SHA256.Create())
                {
                    byte[] bytes = sha256Hash.ComputeHash(Encoding.UTF8.GetBytes(password + "YourSaltKey"));
                    string hashedPassword = Convert.ToBase64String(bytes);
                    return hashedPassword == storedHash;
                }
            }
            catch
            {
                return false;
            }
        }

        private void ShowMessage(string message, string redirectUrl = null)
        {
            string script = $"alert('{message.Replace("'", "\\'")}');";
            if (!string.IsNullOrEmpty(redirectUrl))
            {
                script += $" setTimeout(function() {{ window.location='{redirectUrl}'; }}, 1500);";
            }
            ClientScript.RegisterStartupScript(this.GetType(), "alert", script, true);
        }

        private void LogError(Exception ex)
        {
            try
            {
                string logMessage = $"{DateTime.Now}: Login Error - {ex.Message}\n{ex.StackTrace}\n";
                System.Diagnostics.EventLog.WriteEntry("Application", logMessage, System.Diagnostics.EventLogEntryType.Error);
            }
            catch
            {
                // If logging fails, don't throw another exception
            }
        }
    }

    // Helper class to return login results
    public class LoginResult
    {
        public bool IsSuccess { get; set; }
        public int UserID { get; set; }
        public string Username { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Category { get; set; }
        public string Email { get; set; }
        public string ErrorMessage { get; set; }
    }
}