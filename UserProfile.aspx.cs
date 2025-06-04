using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.Services;
using System.Diagnostics; // For debugging
using System.Security.Cryptography; // Added for PBKDF2 hashing

namespace WAPPSS
{
    public partial class UserProfile : System.Web.UI.Page
    {
        protected bool isDarkMode = false; // For setting body CSS class

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadCurrentProfilePic();
                LoadProfileIcons();
                LoadUserPersonalInfo();
                LoadDarkModeSetting();
            }
            // Do NOT call LoadDarkModeSetting on every postback!

            // Uncomment the line below to test password hashing (for debugging only)
            // TestPasswordHashing();
        }

        private void LoadUserPersonalInfo()
        {
            string userId = Session["UserID"]?.ToString();
            if (string.IsNullOrEmpty(userId)) return;

            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (var cmd = new SqlCommand("SELECT FirstName, LastName, Username, Email FROM Users WHERE UserID=@UserID", conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            txtFirstName.Text = reader["FirstName"]?.ToString() ?? "";
                            txtLastName.Text = reader["LastName"]?.ToString() ?? "";
                            txtUsername.Text = reader["Username"]?.ToString() ?? "";
                            txtEmail.Text = reader["Email"]?.ToString() ?? "";
                        }
                    }
                }
            }
        }

        private void LoadDarkModeSetting()
        {
            string userId = Session["UserID"]?.ToString();
            if (string.IsNullOrEmpty(userId)) return;

            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (var cmd = new SqlCommand("SELECT ModeType FROM Mode WHERE UserID=@UserID", conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    var result = cmd.ExecuteScalar();
                    string modeType = result != null ? result.ToString() : "light";

                    isDarkMode = modeType == "dark";
                    chkDarkMode.Checked = isDarkMode;
                }
            }
        }

        [WebMethod]
        public static void SaveDarkModePreference(bool isDarkMode)
        {
            try
            {
                // Get user ID from session
                if (System.Web.HttpContext.Current.Session["UserID"] == null)
                    return;

                string userId = System.Web.HttpContext.Current.Session["UserID"].ToString();
                string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                string newMode = isDarkMode ? "dark" : "light";

                using (var conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    // Upsert: Insert or Update the mode
                    using (var cmd = new SqlCommand(@"
                        IF EXISTS (SELECT 1 FROM Mode WHERE UserID=@UserID)
                            UPDATE Mode SET ModeType=@ModeType WHERE UserID=@UserID
                        ELSE
                            INSERT INTO Mode (UserID, ModeType) VALUES (@UserID, @ModeType)
                    ", conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.Parameters.AddWithValue("@ModeType", newMode);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception)
            {
                // Log error if needed, but don't throw to client
            }
        }

        private void LoadCurrentProfilePic()
        {
            // Default image - Fixed path to match the Profiles folder
            string imagePath = "images/Profiles/default.jpg";
            if (Session["UserID"] != null)
            {
                string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                using (var conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    using (var cmd = new SqlCommand("SELECT ProfilePic FROM ProfileTC WHERE UserID=@UserID", conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                        var result = cmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            imagePath = result.ToString();
                        }
                    }
                }
            }
            imgCurrentIcon.ImageUrl = imagePath;
        }

        private void LoadProfileIcons()
        {
            try
            {
                // Try multiple possible paths
                string[] possiblePaths = {
                    "~/images/Profiles/",
                    "~/Images/Profiles/",
                    "~/images/profiles/",
                    "~/Images/profiles/"
                };

                DataTable dt = new DataTable();
                dt.Columns.Add("IconPath");
                bool foundPath = false;
                string workingPath = "";

                foreach (string testPath in possiblePaths)
                {
                    string folderPath = Server.MapPath(testPath);
                    System.Diagnostics.Debug.WriteLine($"Testing path: {folderPath}");

                    if (Directory.Exists(folderPath))
                    {
                        foundPath = true;
                        workingPath = folderPath;
                        System.Diagnostics.Debug.WriteLine($"Found directory: {folderPath}");

                        var files = Directory.GetFiles(folderPath);
                        System.Diagnostics.Debug.WriteLine($"Found {files.Length} files in directory");

                        foreach (string file in files)
                        {
                            string ext = Path.GetExtension(file).ToLower();
                            System.Diagnostics.Debug.WriteLine($"Checking file: {file}, Extension: {ext}");

                            if (ext == ".jpg" || ext == ".png" || ext == ".jpeg" || ext == ".gif")
                            {
                                // Use the relative path that matches the working directory
                                string relPath = testPath.Replace("~/", "").Replace("\\", "/") + Path.GetFileName(file);
                                System.Diagnostics.Debug.WriteLine($"Adding icon: {relPath}");
                                dt.Rows.Add(relPath);
                            }
                        }
                        break; // Found working path, stop trying others
                    }
                }

                if (!foundPath)
                {
                    System.Diagnostics.Debug.WriteLine("No profile images directory found!");
                    // Show error message to user
                    ClientScript.RegisterStartupScript(this.GetType(), "NoIconsFound",
                        "showMessage('Profile images directory not found. Please check that images/Profiles/ folder exists.', false);", true);
                }
                else
                {
                    System.Diagnostics.Debug.WriteLine($"Total icons loaded: {dt.Rows.Count}");
                    if (dt.Rows.Count == 0)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "NoIcons",
                            "showMessage('No profile images found in the directory. Please add some .jpg, .png, .jpeg, or .gif files.', false);", true);
                    }
                }

                rptIcons.DataSource = dt;
                rptIcons.DataBind();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading profile icons: {ex.Message}");
                ClientScript.RegisterStartupScript(this.GetType(), "IconLoadError",
                    $"showMessage('Error loading profile icons: {ex.Message}', false);", true);
            }
        }

        protected void SelectIcon_Command(object sender, CommandEventArgs e)
        {
            // Preview the selected icon (no DB update yet)
            string iconPath = e.CommandArgument.ToString();
            imgCurrentIcon.ImageUrl = iconPath;
            // Save to session in case user "Save Changes" later
            Session["SelectedProfilePic"] = iconPath;

            // Show a temporary message using client script
            ClientScript.RegisterStartupScript(this.GetType(), "IconSelected",
                "showMessage('Profile picture selected. Click Save Changes to update!', true);", true);
        }

        protected void btnSaveChanges_Click(object sender, EventArgs e)
        {
            string userId = Session["UserID"]?.ToString();
            if (string.IsNullOrEmpty(userId))
            {
                ShowMessage("Session expired. Please log in again.", false);
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                bool hasChanges = false;
                string successMessage = "";

                // --- 1. Profile Picture Update ---
                string selectedPic = Session["SelectedProfilePic"] as string;
                if (!string.IsNullOrEmpty(selectedPic))
                {
                    // Update or insert profile picture
                    using (var cmd = new SqlCommand(@"
                        IF EXISTS (SELECT 1 FROM ProfileTC WHERE UserID=@UserID) 
                            UPDATE ProfileTC SET ProfilePic=@ProfilePic WHERE UserID=@UserID 
                        ELSE 
                            INSERT INTO ProfileTC(UserID,ProfilePic) VALUES(@UserID,@ProfilePic)", conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.Parameters.AddWithValue("@ProfilePic", selectedPic);
                        cmd.ExecuteNonQuery();
                    }
                    imgCurrentIcon.ImageUrl = selectedPic;
                    hasChanges = true;
                    successMessage += "Profile picture updated. ";
                    Session.Remove("SelectedProfilePic");
                }

                // --- 2. Personal Information Update ---
                string firstName = txtFirstName.Text.Trim();
                string lastName = txtLastName.Text.Trim();
                string username = txtUsername.Text.Trim();
                string email = txtEmail.Text.Trim();

                // Validation
                if (string.IsNullOrEmpty(firstName))
                {
                    ShowMessage("First name is required.", false);
                    return;
                }

                if (string.IsNullOrEmpty(username))
                {
                    ShowMessage("Username is required.", false);
                    return;
                }

                if (string.IsNullOrEmpty(email))
                {
                    ShowMessage("Email address is required.", false);
                    return;
                }

                // Basic email validation
                if (!IsValidEmail(email))
                {
                    ShowMessage("Please enter a valid email address.", false);
                    return;
                }

                // Check if username already exists for another user
                using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Username=@Username AND UserID!=@UserID", conn))
                {
                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    int count = (int)cmd.ExecuteScalar();
                    if (count > 0)
                    {
                        ShowMessage("This username is already taken. Please choose another one.", false);
                        return;
                    }
                }

                // Check if email already exists for another user
                using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Email=@Email AND UserID!=@UserID", conn))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    int count = (int)cmd.ExecuteScalar();
                    if (count > 0)
                    {
                        ShowMessage("This email address is already in use by another account.", false);
                        return;
                    }
                }

                // Update user information
                using (var cmd = new SqlCommand(@"
                    UPDATE Users 
                    SET FirstName=@FirstName, LastName=@LastName, Username=@Username, Email=@Email 
                    WHERE UserID=@UserID", conn))
                {
                    cmd.Parameters.AddWithValue("@FirstName", firstName);
                    cmd.Parameters.AddWithValue("@LastName", lastName);
                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@UserID", userId);

                    int rowsAffected = cmd.ExecuteNonQuery();
                    if (rowsAffected > 0)
                    {
                        hasChanges = true;
                        successMessage += "Personal information updated successfully.";
                    }
                }

                // Show result message
                if (hasChanges)
                {
                    ShowMessage(successMessage, true);
                }
                else
                {
                    ShowMessage("No changes were made.", false);
                }
            }
        }

        protected void btnUpdatePassword_Click(object sender, EventArgs e)
        {
            string userId = Session["UserID"]?.ToString();
            if (string.IsNullOrEmpty(userId))
            {
                ShowPasswordMessage("Session expired. Please log in again.", false);
                return;
            }

            string currentPassword = txtCurrentPassword.Text.Trim();
            string newPassword = txtNewPassword.Text.Trim();
            string confirmPassword = txtConfirmPassword.Text.Trim();

            // Validation
            if (string.IsNullOrEmpty(currentPassword))
            {
                ShowPasswordMessage("Please enter your current password.", false);
                return;
            }

            if (string.IsNullOrEmpty(newPassword))
            {
                ShowPasswordMessage("Please enter your new password.", false);
                return;
            }

            if (string.IsNullOrEmpty(confirmPassword))
            {
                ShowPasswordMessage("Please confirm your new password.", false);
                return;
            }

            if (newPassword != confirmPassword)
            {
                ShowPasswordMessage("New password and confirmation do not match.", false);
                return;
            }

            // Password strength validation
            if (!IsValidPassword(newPassword))
            {
                ShowPasswordMessage("Password must be at least 8 characters long and include uppercase, lowercase, and numbers.", false);
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Get stored password hash from database
                string storedPasswordHash = "";
                using (var cmd = new SqlCommand("SELECT Password FROM Users WHERE UserID=@UserID", conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    storedPasswordHash = cmd.ExecuteScalar() as string;
                }

                if (string.IsNullOrEmpty(storedPasswordHash))
                {
                    ShowPasswordMessage("User password not found.", false);
                    return;
                }

                // Verify current password using PBKDF2 verification
                if (!VerifyPassword(currentPassword, storedPasswordHash))
                {
                    ShowPasswordMessage("Current password is incorrect.", false);
                    return;
                }

                // Check if new password is the same as current
                if (VerifyPassword(newPassword, storedPasswordHash))
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "SamePasswordAlert",
                        "alert('The new password cannot be the same as your current password.');", true);
                    return;
                }

                // Generate new hash for the new password
                string newPasswordHash = HashPassword(newPassword);

                // Update password with new hash
                using (var cmd = new SqlCommand("UPDATE Users SET Password=@Password WHERE UserID=@UserID", conn))
                {
                    cmd.Parameters.AddWithValue("@Password", newPasswordHash);
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    int rowsAffected = cmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        ShowPasswordMessage("Password updated successfully!", true);
                        // Clear password fields
                        txtCurrentPassword.Text = "";
                        txtNewPassword.Text = "";
                        txtConfirmPassword.Text = "";
                    }
                    else
                    {
                        ShowPasswordMessage("Failed to update password. Please try again.", false);
                    }
                }
            }
        }

        // Helper methods for password hashing - PBKDF2 (matches register.aspx.cs)
        private string HashPassword(string password)
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

        // Method to verify password against stored PBKDF2 hash
        private bool VerifyPassword(string password, string storedHash)
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

        // Method to test password verification against your known password
        private void TestPasswordHashing()
        {
            string testPassword = "Jovan123";
            string expectedHash = "H89hzXxNeVcLYX0LrnONnLK//Grqqk2xQxUesyAiFEwCi4KR3FtQte665ExWNrzmGA5JRoTkMrz6OeJm1S2I/A==";
            bool isValid = VerifyPassword(testPassword, expectedHash);

            System.Diagnostics.Debug.WriteLine($"Testing password: {testPassword}");
            System.Diagnostics.Debug.WriteLine($"Against hash: {expectedHash}");
            System.Diagnostics.Debug.WriteLine($"Password verification result: {isValid}");
        }

        private void ShowMessage(string message, bool isSuccess)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = $"message-label {(isSuccess ? "success" : "error")}";
            lblMessage.Visible = true;
        }

        private void ShowPasswordMessage(string message, bool isSuccess)
        {
            lblPasswordMessage.Text = message;
            lblPasswordMessage.CssClass = $"message-label {(isSuccess ? "success" : "error")}";
            lblPasswordMessage.Visible = true;
        }

        private bool IsValidEmail(string email)
        {
            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                return addr.Address == email;
            }
            catch
            {
                return false;
            }
        }

        private bool IsValidPassword(string password)
        {
            if (password.Length < 8) return false;

            bool hasUpper = false;
            bool hasLower = false;
            bool hasDigit = false;

            foreach (char c in password)
            {
                if (char.IsUpper(c)) hasUpper = true;
                if (char.IsLower(c)) hasLower = true;
                if (char.IsDigit(c)) hasDigit = true;
            }

            return hasUpper && hasLower && hasDigit;
        }
    }
}