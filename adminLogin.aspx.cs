using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;

namespace WAPPSS
{
    public partial class adminLogin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            UnobtrusiveValidationMode = UnobtrusiveValidationMode.None;

            if (!IsPostBack)
            {
                // Clear any previous messages
                lblMessage.Text = string.Empty;

                // Check if admin is already logged in
                if (Session["AdminAuthenticated"] != null && (bool)Session["AdminAuthenticated"])
                {
                    Response.Redirect("adminDashboard.aspx");
                    return;
                }

                // Check if there's a remember me cookie
                HttpCookie cookie = Request.Cookies["AdminLoginCookie"];
                if (cookie != null && !string.IsNullOrEmpty(cookie["Username"]))
                {
                    txtUsername.Text = cookie["Username"];
                    chkRememberMe.Checked = true;
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string username = txtUsername.Text.Trim();
                string password = txtPassword.Text;

                try
                {
                    // Authenticate the admin and get the admin ID
                    int adminId = AuthenticateAdmin(username, password);
                    if (adminId > 0)
                    {
                        // Set session variables
                        Session["AdminUsername"] = username;
                        Session["AdminID"] = adminId;
                        Session["AdminAuthenticated"] = true;

                        // Handle remember me functionality
                        if (chkRememberMe.Checked)
                        {
                            HttpCookie cookie = new HttpCookie("AdminLoginCookie");
                            cookie["Username"] = username;
                            cookie.Expires = DateTime.Now.AddDays(30); // Cookie expires in 30 days
                            Response.Cookies.Add(cookie);
                        }
                        else
                        {
                            // Remove the cookie if exists
                            if (Request.Cookies["AdminLoginCookie"] != null)
                            {
                                HttpCookie cookie = new HttpCookie("AdminLoginCookie");
                                cookie.Expires = DateTime.Now.AddDays(-1); // Expire the cookie
                                Response.Cookies.Add(cookie);
                            }
                        }

                        lblMessage.Text = "Login successful! Redirecting to dashboard...";
                        lblMessage.ForeColor = System.Drawing.Color.Green;

                        // Redirect to admin dashboard
                        Response.Redirect("adminDashboard.aspx");
                    }
                    else
                    {
                        lblMessage.Text = "Invalid username or password. Please try again.";
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                    }
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Login error: " + ex.Message;
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    System.Diagnostics.Debug.WriteLine("Login error: " + ex.ToString());
                }
            }
        }

        private int AuthenticateAdmin(string username, string password)
        {
            int adminId = -1;

            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    // First get the stored password for the username
                    string query = "SELECT AdminID, Password FROM Admins WHERE Username = @Username";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@Username", username);

                    connection.Open();
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            int storedAdminId = Convert.ToInt32(reader["AdminID"]);
                            string storedBase64Password = reader["Password"].ToString();

                            // Verify the password
                            if (VerifyPassword(password, storedBase64Password))
                            {
                                adminId = storedAdminId;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error authenticating admin: " + ex.ToString());
                throw new Exception("Database connection failed during authentication: " + ex.Message);
            }

            return adminId;
        }

        private bool VerifyPassword(string enteredPassword, string storedBase64Password)
        {
            try
            {
                // Method 1: Encode entered password to Base64 and compare
                string encodedEnteredPassword = EncodePassword(enteredPassword);
                bool isMatch = encodedEnteredPassword == storedBase64Password;

                // Debug info
                System.Diagnostics.Debug.WriteLine("Entered password: " + enteredPassword);
                System.Diagnostics.Debug.WriteLine("Encoded entered password: " + encodedEnteredPassword);
                System.Diagnostics.Debug.WriteLine("Stored Base64 password: " + storedBase64Password);
                System.Diagnostics.Debug.WriteLine("Password match: " + isMatch);

                return isMatch;

                // Alternative Method 2: Decode stored password and compare
                /*
                byte[] decodedBytes = Convert.FromBase64String(storedBase64Password);
                string decodedPassword = Encoding.UTF8.GetString(decodedBytes);
                return enteredPassword == decodedPassword;
                */
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error verifying password: " + ex.ToString());
                return false;
            }
        }

        private string EncodePassword(string password)
        {
            // Convert password to Base64 encoding (same as registration)
            byte[] passwordBytes = Encoding.UTF8.GetBytes(password);
            string base64Password = Convert.ToBase64String(passwordBytes);
            return base64Password;
        }
    }
}