using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Text; // Added for Encoding
using System.Security.Cryptography; // Added for hashing

namespace WAPPSS
{
    public partial class Profile : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
        protected bool isDarkMode = false;

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

                int userId = Convert.ToInt32(Session["UserID"]);

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand("SELECT ModeType FROM Mode WHERE UserID = @UserID", con);
                    cmd.Parameters.AddWithValue("@UserID", userId);

                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        bool isDark = result.ToString() == "dark";
                        Session["DarkMode"] = isDark;
                        chkDarkMode.Checked = isDark;
                    }
                }
            }

            if (Session["DarkMode"] != null && (bool)Session["DarkMode"])
            {
                darkModeCss.Href = "darkmode.css";
            }

            // Uncomment the line below to test password hashing (for debugging only)
            // TestPasswordHashing();
        }

        private void LoadUserPersonalInfo()
        {
            string username = Session["Username"]?.ToString();

            if (string.IsNullOrEmpty(username))
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                // Join Users with ProfileTC to get the ProfilePic if exists
                string query = @"
                    SELECT u.FirstName, u.LastName, u.Username, u.Email, u.Category,
                           p.ProfilePic
                    FROM Users u
                    LEFT JOIN ProfileTC p ON u.UserID = p.UserID
                    WHERE u.Username = @Username";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Username", username);
                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    txtFirstName.Text = reader["FirstName"]?.ToString() ?? "";
                    txtLastName.Text = reader["LastName"]?.ToString() ?? "";
                    txtUsername.Text = reader["Username"]?.ToString() ?? "";
                    txtEmail.Text = reader["Email"]?.ToString() ?? "";

                    // Use profile picture if exists, else default - Fixed path
                    string iconUrl = reader["ProfilePic"] != DBNull.Value ?
                        reader["ProfilePic"].ToString() : "icons/default.jpg";
                    userIcon.Src = iconUrl;
                }
            }
        }

        private void LoadCurrentProfilePic()
        {
            // Default image - Fixed path to match your folder structure
            string imagePath = "icons/default.jpg";
            if (Session["UserID"] != null)
            {
                using (var conn = new SqlConnection(connectionString))
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
            userIcon.Src = imagePath;
        }

        private void LoadProfileIcons()
        {
            try
            {
                // Try multiple possible paths for icons
                string[] possiblePaths = {
                    "~/icons/",
                    "~/Icons/",
                    "~/images/Profile/",
                    "~/Images/Profile/",
                    "~/images/Profiles/",
                    "~/Images/Profiles/"
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
                        "showMessage('Profile images directory not found. Please check that icons/ folder exists.', false);", true);
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
            userIcon.Src = iconPath;
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

            using (SqlConnection conn = new SqlConnection(connectionString))
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
                    userIcon.Src = selectedPic;
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
                        // Update session username if it was changed
                        Session["Username"] = username;
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

            using (SqlConnection conn = new SqlConnection(connectionString))
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

        protected void btnSaveMode_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            string mode = chkDarkMode.Checked ? "dark" : "light";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // Check if entry already exists
                string checkQuery = "SELECT COUNT(*) FROM Mode WHERE UserID = @UserID";
                SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                checkCmd.Parameters.AddWithValue("@UserID", userId);
                int count = (int)checkCmd.ExecuteScalar();

                if (count > 0)
                {
                    // Update existing mode
                    string updateQuery = "UPDATE Mode SET ModeType = @ModeType WHERE UserID = @UserID";
                    SqlCommand updateCmd = new SqlCommand(updateQuery, conn);
                    updateCmd.Parameters.AddWithValue("@ModeType", mode);
                    updateCmd.Parameters.AddWithValue("@UserID", userId);
                    updateCmd.ExecuteNonQuery();
                }
                else
                {
                    // Insert new mode
                    string insertQuery = "INSERT INTO Mode (UserID, ModeType) VALUES (@UserID, @ModeType)";
                    SqlCommand insertCmd = new SqlCommand(insertQuery, conn);
                    insertCmd.Parameters.AddWithValue("@UserID", userId);
                    insertCmd.Parameters.AddWithValue("@ModeType", mode);
                    insertCmd.ExecuteNonQuery();
                }
            }

            // Set session so dark mode applies on redirect
            Session["DarkMode"] = (mode == "dark");

            // Redirect back to dashboard
            Response.Redirect("Student_Dashboard.aspx");
        }

        private void LoadDarkModeSetting()
        {
            if (Session["UserID"] == null) return;

            int userId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                using (var cmd = new SqlCommand("SELECT ModeType FROM Mode WHERE UserID=@UserID", conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    var result = cmd.ExecuteScalar();
                    string modeType = result != null ? result.ToString() : "light";

                    isDarkMode = modeType == "dark";
                    chkDarkMode.Checked = isDarkMode;
                    Session["DarkMode"] = isDarkMode;
                }
            }
        }

        protected void chkDarkMode_CheckedChanged(object sender, EventArgs e)
        {
            bool isDark = chkDarkMode.Checked;
            Session["DarkMode"] = isDark;

            string mode = isDark ? "dark" : "light";
            int userId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    IF EXISTS (SELECT 1 FROM Mode WHERE UserID = @UserID)
                        UPDATE Mode SET ModeType = @ModeType WHERE UserID = @UserID
                    ELSE
                        INSERT INTO Mode (UserID, ModeType) VALUES (@UserID, @ModeType)", con);

                cmd.Parameters.AddWithValue("@UserID", userId);
                cmd.Parameters.AddWithValue("@ModeType", mode);
                cmd.ExecuteNonQuery();
            }

            Response.Redirect(Request.RawUrl); // Refresh to apply the change
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

        private int GetCurrentUserID()
        {
            return Convert.ToInt32(Session["UserID"]);
        }

        // Helper methods for password hashing - PBKDF2 (matches register.aspx.cs)
        private string HashPassword(string password)
        {
            // Generate a random salt
            byte[] salt = new byte[32]; // 256-bit salt
            using (var rng = System.Security.Cryptography.RandomNumberGenerator.Create())
            {
                rng.GetBytes(salt);
            }

            // Hash the password with PBKDF2
            using (var pbkdf2 = new System.Security.Cryptography.Rfc2898DeriveBytes(password, salt, 10000)) // 10,000 iterations
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
                using (var pbkdf2 = new System.Security.Cryptography.Rfc2898DeriveBytes(password, salt, 10000))
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
    }
}