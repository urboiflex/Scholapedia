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
using System.IO;

namespace WAPPSS
{
    public partial class studentTest : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            UnobtrusiveValidationMode = UnobtrusiveValidationMode.None;

            if (!IsPostBack)
            {
                // Clear any previous messages
                lblMessage.Text = string.Empty;

                // Set default category to student
                ddlCategory.SelectedValue = "student";
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    // Get form values
                    string firstName = txtFirstName.Text.Trim();
                    string lastName = txtLastName.Text.Trim();
                    string username = txtUsername.Text.Trim();
                    string email = txtEmail.Text.Trim().ToLower();
                    string password = txtPassword.Text;
                    string category = ddlCategory.SelectedValue;

                    // Check if username already exists (only if username is provided)
                    if (!string.IsNullOrEmpty(username) && IsUsernameExists(username))
                    {
                        lblMessage.Text = "Username already exists. Please choose a different username.";
                        lblMessage.CssClass = "error-message";
                        return;
                    }

                    // Check if email already exists (only if email is provided)
                    if (!string.IsNullOrEmpty(email) && IsEmailExists(email))
                    {
                        lblMessage.Text = "Email address already registered. Please use a different email or try logging in.";
                        lblMessage.CssClass = "error-message";
                        return;
                    }

                    // Register the new user
                    if (RegisterUser(firstName, lastName, username, email, password, category))
                    {
                        lblMessage.Text = "Registration successful! You can now log in with your credentials.";
                        lblMessage.CssClass = "success-message";
                        ClearForm();
                    }
                    else
                    {
                        lblMessage.Text = "Registration failed. Please try again later.";
                        lblMessage.CssClass = "error-message";
                    }
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Error: " + ex.Message;
                    lblMessage.CssClass = "error-message";
                    System.Diagnostics.Debug.WriteLine("Registration error: " + ex.ToString());
                }
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        private bool IsUsernameExists(string username)
        {
            bool exists = false;

            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT COUNT(*) FROM Users WHERE Username = @Username";
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

        private bool IsEmailExists(string email)
        {
            bool exists = false;

            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT COUNT(*) FROM Users WHERE Email = @Email";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@Email", email);

                    connection.Open();
                    int count = (int)command.ExecuteScalar();
                    exists = (count > 0);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error checking email: " + ex.ToString());
                throw new Exception("Database connection failed while checking email: " + ex.Message);
            }

            return exists;
        }

        private bool RegisterUser(string firstName, string lastName, string username, string email, string password, string category)
        {
            bool success = false;

            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                // Encode the password using Base64 (consistent with admin registration)
                string encodedPassword = EncodePassword(password);

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"INSERT INTO Users 
                                   (FirstName, LastName, Username, Email, Password, Category, DateRegistered) 
                                   VALUES 
                                   (@FirstName, @LastName, @Username, @Email, @Password, @Category, @DateRegistered)";

                    SqlCommand command = new SqlCommand(query, connection);

                    // Add parameters
                    command.Parameters.AddWithValue("@FirstName", firstName);
                    command.Parameters.AddWithValue("@LastName", string.IsNullOrEmpty(lastName) ? (object)DBNull.Value : lastName);
                    command.Parameters.AddWithValue("@Username", string.IsNullOrEmpty(username) ? (object)DBNull.Value : username);
                    command.Parameters.AddWithValue("@Email", string.IsNullOrEmpty(email) ? (object)DBNull.Value : email);
                    command.Parameters.AddWithValue("@Password", encodedPassword);
                    command.Parameters.AddWithValue("@Category", category);
                    command.Parameters.AddWithValue("@DateRegistered", DateTime.Now);

                    connection.Open();
                    int result = command.ExecuteNonQuery();
                    success = (result > 0);

                    System.Diagnostics.Debug.WriteLine("User registered successfully. Rows affected: " + result);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error registering user: " + ex.ToString());
                throw new Exception("Database connection failed during registration: " + ex.Message);
            }

            return success;
        }

        private string EncodePassword(string password)
        {
            // Convert password to Base64 encoding (consistent with admin registration)
            byte[] passwordBytes = Encoding.UTF8.GetBytes(password);
            string base64Password = Convert.ToBase64String(passwordBytes);
            return base64Password;
        }

        private void ClearForm()
        {
            txtFirstName.Text = string.Empty;
            txtLastName.Text = string.Empty;
            txtUsername.Text = string.Empty;
            txtEmail.Text = string.Empty;
            txtPassword.Text = string.Empty;
            txtConfirmPassword.Text = string.Empty;
            ddlCategory.SelectedValue = "student";
            lblMessage.Text = string.Empty;
        }
    }
}