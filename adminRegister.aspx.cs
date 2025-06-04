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
    public partial class adminRegister : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            UnobtrusiveValidationMode = UnobtrusiveValidationMode.None;

            if (!IsPostBack)
            {
                // Clear any previous messages
                lblMessage.Text = string.Empty;
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string username = txtUsername.Text.Trim();
                string password = txtPassword.Text;

                try
                {
                    // Check if the username already exists
                    if (IsUsernameExists(username))
                    {
                        lblMessage.Text = "Username already exists. Please choose a different username.";
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                        return;
                    }

                    // Register the new admin
                    if (RegisterAdmin(username, password))
                    {
                        lblMessage.Text = "Registration successful! You can now log in.";
                        lblMessage.ForeColor = System.Drawing.Color.Green;

                        // Clear the form
                        txtUsername.Text = string.Empty;
                        txtPassword.Text = string.Empty;
                        txtConfirmPassword.Text = string.Empty;
                    }
                    else
                    {
                        lblMessage.Text = "Registration failed. Please try again later.";
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                    }
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Error: " + ex.Message;
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    System.Diagnostics.Debug.WriteLine("Registration error: " + ex.ToString());
                }
            }
        }

        private bool IsUsernameExists(string username)
        {
            bool exists = false;

            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT COUNT(*) FROM Admins WHERE Username = @Username";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@Username", username);

                    connection.Open();
                    int count = (int)command.ExecuteScalar();
                    exists = (count > 0);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error checking username: " + ex.ToString());
                throw new Exception("Database connection failed while checking username: " + ex.Message);
            }

            return exists;
        }

        private bool RegisterAdmin(string username, string password)
        {
            bool success = false;

            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                // Encode the password using Base64
                string encodedPassword = HashPassword(password);

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "INSERT INTO Admins (Username, Password) VALUES (@Username, @Password)";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@Username", username);
                    command.Parameters.AddWithValue("@Password", encodedPassword);

                    connection.Open();
                    int result = command.ExecuteNonQuery();
                    success = (result > 0);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error registering admin: " + ex.ToString());
                throw new Exception("Database connection failed during registration: " + ex.Message);
            }

            return success;
        }

        private string HashPassword(string password)
        {
            // Convert password to Base64 encoding
            byte[] passwordBytes = Encoding.UTF8.GetBytes(password);
            string base64Password = Convert.ToBase64String(passwordBytes);
            return base64Password;
        }
    }
}