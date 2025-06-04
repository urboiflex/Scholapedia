using System;
using System.Data.SqlClient;
using System.Web.UI;
using System.Configuration;
using System.Text.RegularExpressions;
using System.Security.Cryptography;
using System.Text;

namespace WAPPSS
{
    public partial class register : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Initialize page
                SetFocusOnLoad();
            }
        }

        private void SetFocusOnLoad()
        {
            // Set focus to first name field on page load
            txtFirstName.Focus();
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            try
            {
                // Validate all inputs
                if (!ValidateInputs())
                {
                    return;
                }

                // Get form values - PRESERVE CASE SENSITIVITY
                string firstName = txtFirstName.Text.Trim();
                string lastName = string.IsNullOrWhiteSpace(txtLastName.Text) ? null : txtLastName.Text.Trim();
                string username = txtUsername.Text.Trim(); // Keep original case
                string email = txtEmail.Text.Trim().ToLower(); // Email can be lowercase for consistency
                string password = txtPassword.Text; // Keep original case for password
                string category = hdnCategory.Value;

                // Hash password using secure PBKDF2 method
                string hashedPassword = HashPasswordSecure(password);

                // Register user
                bool registrationSuccess = RegisterUser(firstName, lastName, username, email, hashedPassword, category);

                if (registrationSuccess)
                {
                    // Clear form
                    ClearForm();

                    // Show success message and redirect
                    string script = @"
                        alert('🎉 Registration successful! Welcome to our community!');
                        setTimeout(function() {
                            window.location.href = 'login.aspx';
                        }, 1000);
                    ";
                    ClientScript.RegisterStartupScript(this.GetType(), "successAlert", script, true);
                }
            }
            catch (Exception ex)
            {
                // Log error (in production, use proper logging)
                LogError(ex);

                // Show user-friendly error message
                ShowErrorMessage("We're experiencing technical difficulties. Please try again later.");
            }
        }

        private bool ValidateInputs()
        {
            // Server-side validation (defense in depth)

            // Required fields
            if (string.IsNullOrWhiteSpace(txtFirstName.Text))
            {
                ShowErrorMessage("First name is required.");
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtUsername.Text))
            {
                ShowErrorMessage("Username is required.");
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtEmail.Text))
            {
                ShowErrorMessage("Email address is required.");
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtPassword.Text))
            {
                ShowErrorMessage("Password is required.");
                return false;
            }

            if (string.IsNullOrWhiteSpace(hdnCategory.Value))
            {
                ShowErrorMessage("Please select your role.");
                return false;
            }

            // Validate first name length and characters
            if (txtFirstName.Text.Trim().Length < 2 || txtFirstName.Text.Trim().Length > 50)
            {
                ShowErrorMessage("First name must be between 2 and 50 characters.");
                return false;
            }

            if (!Regex.IsMatch(txtFirstName.Text.Trim(), @"^[a-zA-Z\s'-]+$"))
            {
                ShowErrorMessage("First name contains invalid characters.");
                return false;
            }

            // Validate last name if provided
            if (!string.IsNullOrWhiteSpace(txtLastName.Text))
            {
                if (txtLastName.Text.Trim().Length > 50)
                {
                    ShowErrorMessage("Last name cannot exceed 50 characters.");
                    return false;
                }

                if (!Regex.IsMatch(txtLastName.Text.Trim(), @"^[a-zA-Z\s'-]+$"))
                {
                    ShowErrorMessage("Last name contains invalid characters.");
                    return false;
                }
            }

            // Validate username - PRESERVE CASE SENSITIVITY
            string username = txtUsername.Text.Trim(); // Don't convert to lowercase
            if (username.Length < 3 || username.Length > 30)
            {
                ShowErrorMessage("Username must be between 3 and 30 characters.");
                return false;
            }

            if (!Regex.IsMatch(username, @"^[a-zA-Z0-9_.-]+$"))
            {
                ShowErrorMessage("Username can only contain letters, numbers, dots, dashes, and underscores.");
                return false;
            }

            // Validate email
            if (!IsValidEmail(txtEmail.Text.Trim()))
            {
                ShowErrorMessage("Please enter a valid email address.");
                return false;
            }

            // Validate password strength
            if (!IsStrongPassword(txtPassword.Text))
            {
                ShowErrorMessage("Password must be at least 8 characters long and contain letters and numbers.");
                return false;
            }

            // Validate password confirmation
            if (txtPassword.Text != txtConfirmPassword.Text)
            {
                ShowErrorMessage("Passwords do not match.");
                return false;
            }

            // Validate terms acceptance
            if (!chkTerms.Checked)
            {
                ShowErrorMessage("You must agree to the terms and conditions.");
                return false;
            }

            // Validate category
            if (hdnCategory.Value != "Teacher" && hdnCategory.Value != "Student")
            {
                ShowErrorMessage("Please select a valid role.");
                return false;
            }

            return true;
        }

        private bool IsValidEmail(string email)
        {
            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                return addr.Address == email && email.Contains("@") && email.Contains(".");
            }
            catch
            {
                return false;
            }
        }

        private bool IsStrongPassword(string password)
        {
            if (password.Length < 8)
                return false;

            // Must contain at least one letter and one number
            bool hasLetter = Regex.IsMatch(password, @"[a-zA-Z]");
            bool hasNumber = Regex.IsMatch(password, @"[0-9]");

            return hasLetter && hasNumber;
        }

        // IMPROVED: Secure password hashing using PBKDF2
        private string HashPasswordSecure(string password)
        {
            // Generate a random salt
            byte[] salt = new byte[32]; // 256-bit salt
            using (var rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(salt);
            }

            // Hash the password with PBKDF2
            using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, 10000)) // 10,000 iterations
            {
                byte[] hash = pbkdf2.GetBytes(32); // 256-bit hash

                // Combine salt and hash for storage
                byte[] hashBytes = new byte[64]; // 32 bytes salt + 32 bytes hash
                Array.Copy(salt, 0, hashBytes, 0, 32);
                Array.Copy(hash, 0, hashBytes, 32, 32);

                // Return as Base64 string
                return Convert.ToBase64String(hashBytes);
            }
        }

        // Method to verify password (you'll need this for login)
        public static bool VerifyPassword(string password, string storedHash)
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

        private bool RegisterUser(string firstName, string lastName, string username, string email, string hashedPassword, string category)
        {
            // Using the correct connection string name from Web.config
            string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // Check if username or email already exists - CASE SENSITIVE FOR USERNAME
                if (UserExists(conn, username, email))
                {
                    ShowErrorMessage("Username or email address is already taken. Please choose different ones.");
                    return false;
                }

                // FIXED: Updated query to match your actual database schema
                // Make sure to use COLLATE SQL_Latin1_General_CP1_CS_AS for case-sensitive username storage
                string insertQuery = @"
                    INSERT INTO Users (Username, Email, Password, Category, FirstName, LastName, DateRegistered) 
                    VALUES (@Username COLLATE SQL_Latin1_General_CP1_CS_AS, @Email, @Password, @Category, @FirstName, @LastName, @DateRegistered)";

                using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@Username", username); // Preserve case
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", hashedPassword);
                    cmd.Parameters.AddWithValue("@Category", category);
                    cmd.Parameters.AddWithValue("@FirstName", firstName);
                    cmd.Parameters.AddWithValue("@LastName", lastName ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@DateRegistered", DateTime.Now);

                    int rowsAffected = cmd.ExecuteNonQuery();
                    return rowsAffected > 0;
                }
            }
        }

        private bool UserExists(SqlConnection conn, string username, string email)
        {
            // CASE SENSITIVE check for username, case insensitive for email
            string checkQuery = @"
                SELECT COUNT(*) FROM Users 
                WHERE (Username = @Username COLLATE SQL_Latin1_General_CP1_CS_AS) 
                OR (LOWER(Email) = LOWER(@Email))";

            using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
            {
                checkCmd.Parameters.AddWithValue("@Username", username);
                checkCmd.Parameters.AddWithValue("@Email", email);

                int count = (int)checkCmd.ExecuteScalar();
                return count > 0;
            }
        }

        private void ShowErrorMessage(string message)
        {
            string script = $"alert('⚠️ {message.Replace("'", "\\'")}');";
            ClientScript.RegisterStartupScript(this.GetType(), "errorAlert", script, true);
        }

        private void ClearForm()
        {
            txtFirstName.Text = "";
            txtLastName.Text = "";
            txtUsername.Text = "";
            txtEmail.Text = "";
            txtPassword.Text = "";
            txtConfirmPassword.Text = "";
            hdnCategory.Value = "";
            chkTerms.Checked = false;
        }

        private void LogError(Exception ex)
        {
            // In production, implement proper logging (e.g., NLog, Serilog, or built-in logging)
            // For now, we'll just write to event log or a simple log file
            try
            {
                string logMessage = $"{DateTime.Now}: {ex.Message}\n{ex.StackTrace}\n";
                // You could write to a log file, database, or event log here
                System.Diagnostics.EventLog.WriteEntry("Application", logMessage, System.Diagnostics.EventLogEntryType.Error);
            }
            catch
            {
                // If logging fails, don't throw another exception
            }
        }
    }
}