using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WAPPSS
{
    public partial class EditProfile : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            if (!IsPostBack)
            {
                LoadIcons();


            }
            if (Session["DarkMode"] != null && (bool)Session["DarkMode"] == true)
            {
                darkModeCss.Href = "darkmode.css"; // adjust path as needed
            }


        }


        protected void LoadProfileData()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT FirstName, LastName, Username, Email FROM Users WHERE UserID = @UserID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    txtFirstName.Text = reader["FirstName"].ToString();
                    txtLastName.Text = reader["LastName"].ToString();
                    txtUsername.Text = reader["Username"].ToString();
                    txtEmail.Text = reader["Email"].ToString();
                }
                reader.Close();

                // Load icon from ProfileTC (same as before)
                string iconQuery = "SELECT ProfilePic FROM ProfileTC WHERE UserID = @UserID";
                SqlCommand iconCmd = new SqlCommand(iconQuery, conn);
                iconCmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                object iconResult = iconCmd.ExecuteScalar();

                if (iconResult != null && iconResult != DBNull.Value)
                {
                    string iconName = iconResult.ToString();
                    imgCurrentIcon.ImageUrl = ResolveUrl("~/icons/" + iconName);
                }
                else
                {
                    imgCurrentIcon.ImageUrl = ResolveUrl("~/icons/default.png");
                }
            }
        }

        private bool ExistsInDB(string columnName, string value, SqlConnection conn)
        {
            string query = $"SELECT COUNT(*) FROM Users WHERE {columnName} = @Value AND UserID != @UserID";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@Value", value);
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                return (int)cmd.ExecuteScalar() > 0;
            }
        }
        private void ShowError(string message)
        {
            lblMessage.Text = message;
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }


        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                lblMessage.Text = "Session expired. Please log in again.";
                return;
            }

            int userId = Convert.ToInt32(Session["UserID"]);
            string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

            // Get current user info
            string selectQuery = "SELECT FirstName, LastName, Username, Email, Password FROM Users WHERE UserID = @UserID";
            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(selectQuery, con))
            {
                cmd.Parameters.AddWithValue("@UserID", userId);
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    da.Fill(dt);
                }
            }

            if (dt.Rows.Count == 0)
            {
                lblMessage.Text = "User not found.";
                return;
            }

            DataRow row = dt.Rows[0];
            string currentFirstName = row["FirstName"].ToString();
            string currentLastName = row["LastName"].ToString();
            string currentUsername = row["Username"].ToString();
            string currentEmail = row["Email"].ToString();
            string currentPassword = row["Password"].ToString();

            // New values (keep current if blank)
            string newFirstName = string.IsNullOrWhiteSpace(txtFirstName.Text) ? currentFirstName : txtFirstName.Text.Trim();
            string newLastName = string.IsNullOrWhiteSpace(txtLastName.Text) ? currentLastName : txtLastName.Text.Trim();
            string newUsername = string.IsNullOrWhiteSpace(txtUsername.Text) ? currentUsername : txtUsername.Text.Trim();
            string newEmail = string.IsNullOrWhiteSpace(txtEmail.Text) ? currentEmail : txtEmail.Text.Trim();

            // Check for username/email conflicts ONLY if changed
            if (newUsername != currentUsername || newEmail != currentEmail)
            {
                string checkQuery = "SELECT COUNT(*) FROM Users WHERE (Username = @Username OR Email = @Email) AND UserID != @UserID";
                using (SqlConnection con = new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand(checkQuery, con))
                {
                    cmd.Parameters.AddWithValue("@Username", newUsername);
                    cmd.Parameters.AddWithValue("@Email", newEmail);
                    cmd.Parameters.AddWithValue("@UserID", userId);

                    con.Open();
                    int count = (int)cmd.ExecuteScalar();
                    con.Close();

                    if (count > 0)
                    {
                        lblMessage.Text = "Username or Email already exists. Please choose a different one.";
                        return;
                    }
                }
            }

            // Password update only if current and new provided
            string newPassword = currentPassword;
            if (!string.IsNullOrWhiteSpace(txtCurrentPassword.Text) && !string.IsNullOrWhiteSpace(txtNewPassword.Text))
            {
                if (txtCurrentPassword.Text.Trim() == currentPassword) // 🔒 Ideally compare hashed passwords
                {
                    newPassword = txtNewPassword.Text.Trim();
                }
                else
                {
                    lblMessage.Text = "Current password is incorrect.";
                    return;
                }
            }

            // Final update
            string updateQuery = @"
        UPDATE Users 
        SET FirstName = @FirstName, 
            LastName = @LastName, 
            Username = @Username, 
            Email = @Email, 
            Password = @Password
        WHERE UserID = @UserID";

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(updateQuery, con))
            {
                cmd.Parameters.AddWithValue("@FirstName", newFirstName);
                cmd.Parameters.AddWithValue("@LastName", newLastName);
                cmd.Parameters.AddWithValue("@Username", newUsername);
                cmd.Parameters.AddWithValue("@Email", newEmail);
                cmd.Parameters.AddWithValue("@Password", newPassword);
                cmd.Parameters.AddWithValue("@UserID", userId);

                con.Open();
                int rowsAffected = cmd.ExecuteNonQuery();
                con.Close();

                lblMessage.Text = rowsAffected > 0 ? "Profile updated successfully." : "No changes were made.";
            }
        }





        private void LoadIcons()
        {
            List<string> icons = new List<string>
{
    "boy.png",
    "human.png",
    "man (1).png",
    "man.png",
    "profile.png",
    "woman.png"
};


            var iconData = icons.Select(i => new { IconPath = i }).ToList();
            rptIcons.DataSource = iconData;
            rptIcons.DataBind();
        }
        protected void SelectIcon_Command(object sender, CommandEventArgs e)
        {
            string selectedIcon = e.CommandArgument.ToString();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string checkQuery = "SELECT COUNT(*) FROM ProfileTC WHERE UserID = @UserID";
                SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                checkCmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                conn.Open();
                int exists = (int)checkCmd.ExecuteScalar();

                string query;
                if (exists > 0)
                {
                    query = "UPDATE ProfileTC SET ProfilePic = @Icon WHERE UserID = @UserID";
                }
                else
                {
                    query = "INSERT INTO ProfileTC (UserID, ProfilePic) VALUES (@UserID, @Icon)";
                }

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Icon", selectedIcon);
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                cmd.ExecuteNonQuery();
            }

            imgCurrentIcon.ImageUrl = ResolveUrl("~/icons/" + selectedIcon);
        }

        private bool ValidateForm()
        {
            // Add your validation logic here
            return true;
        }

        private bool VerifyCurrentPassword()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT Password FROM Users WHERE UserID = @UserID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                conn.Open();
                string storedHash = (string)cmd.ExecuteScalar();

                if (storedHash != null)
                {
                    // Convert stored hash from Base64 to byte array
                    byte[] hashBytes = Convert.FromBase64String(storedHash);

                    // Extract the salt from the first 16 bytes
                    byte[] salt = new byte[16];
                    Array.Copy(hashBytes, 0, salt, 0, 16);

                    // Extract the stored hash from the last 20 bytes
                    byte[] storedPasswordHash = new byte[20];
                    Array.Copy(hashBytes, 16, storedPasswordHash, 0, 20);

                    // Rehash the entered password with the extracted salt
                    var pbkdf2 = new Rfc2898DeriveBytes(txtCurrentPassword.Text, salt, 10000);
                    byte[] enteredPasswordHash = pbkdf2.GetBytes(20);

                    // Compare the entered hash with the stored hash
                    return storedPasswordHash.SequenceEqual(enteredPasswordHash);
                }
            }

            return false;
        }




        private string HashPassword(string password)
        {
            // Generate a random salt
            byte[] salt;
            new RNGCryptoServiceProvider().GetBytes(salt = new byte[16]);

            // Create the Rfc2898DeriveBytes and get the hash value
            var pbkdf2 = new Rfc2898DeriveBytes(password, salt, 10000);
            byte[] hash = pbkdf2.GetBytes(20);

            // Combine the salt and password bytes
            byte[] hashBytes = new byte[36];
            Array.Copy(salt, 0, hashBytes, 0, 16);
            Array.Copy(hash, 0, hashBytes, 16, 20);

            // Convert to base64
            return Convert.ToBase64String(hashBytes);
        }

        protected void txtEmail_TextChanged(object sender, EventArgs e)
        {

        }

        protected void btnUpdateIcon_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(imgCurrentIcon.ImageUrl))
            {
                lblMessage.Text = "Please select an icon first.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            string selectedIcon = imgCurrentIcon.ImageUrl.Replace(ResolveUrl("~/icons/"), "");

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string checkQuery = "SELECT COUNT(*) FROM ProfileTC WHERE UserID = @UserID";
                SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                checkCmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                conn.Open();
                int exists = (int)checkCmd.ExecuteScalar();

                string query;
                if (exists > 0)
                {
                    query = "UPDATE ProfileTC SET ProfilePic = @Icon WHERE UserID = @UserID";
                }
                else
                {
                    query = "INSERT INTO ProfileTC (UserID, ProfilePic) VALUES (@UserID, @Icon)";
                }

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Icon", selectedIcon);
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                cmd.ExecuteNonQuery();
            }

            lblMessage.Text = "Icon updated successfully!";
            lblMessage.ForeColor = System.Drawing.Color.Green;

            Response.Redirect("Student_Dashboard.aspx");
        }

    }

    }
