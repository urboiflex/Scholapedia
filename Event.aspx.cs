using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;

namespace WAPPSS
{
    public partial class Event : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["DarkMode"] != null && (bool)Session["DarkMode"])
            {
                darkModeCss.Href = "darkmode.css";
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                // Get UserID from session (assuming it's stored when user logs in)
                int userID = 0;
                if (Session["UserID"] != null)
                {
                    userID = Convert.ToInt32(Session["UserID"]);
                }
                else
                {
                    // Handle case where UserID is not in session
                    Response.Write("<script>alert('🔒 User session expired. Please log in again.'); window.location.href='Login.aspx';</script>");
                    return;
                }

                // Validate input fields
                if (string.IsNullOrEmpty(txtEventName.Text.Trim()) ||
                    string.IsNullOrEmpty(txtDate.Text))
                {
                    Response.Write("<script>alert('⚠️ Please fill in all required fields:\n• Event Name\n• Date');</script>");
                    return;
                }

                // Parse the date
                DateTime eventDate;
                if (!DateTime.TryParse(txtDate.Text, out eventDate))
                {
                    Response.Write("<script>alert('⚠️ Please enter a valid date.');</script>");
                    return;
                }

                // Get connection string from web.config
                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                // Combine description and category (since Category doesn't exist in your table)
                string fullDescription = txtDescription.Text.Trim();
                if (!string.IsNullOrEmpty(ddlCategory.SelectedValue))
                {
                    fullDescription = $"[{ddlCategory.SelectedValue}] {fullDescription}";
                }

                // SQL query to insert event
                string query = @"INSERT INTO EventSchedule (UserID, EventDate, EventTitle, EventDescription) 
                               VALUES (@UserID, @EventDate, @EventTitle, @EventDescription)";

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        // Add parameters to prevent SQL injection
                        command.Parameters.AddWithValue("@UserID", userID);
                        command.Parameters.AddWithValue("@EventDate", eventDate);
                        command.Parameters.AddWithValue("@EventTitle", txtEventName.Text.Trim());
                        command.Parameters.AddWithValue("@EventDescription", fullDescription);

                        // Open connection and execute query
                        connection.Open();
                        int rowsAffected = command.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            // Success - show confirmation and redirect
                            string script = @"
                                <script type='text/javascript'>
                                    alert('✅ Event Created Successfully!\n\nEvent: ' + '" + txtEventName.Text.Replace("'", "\\'") + @"' + '\nDate: ' + '" + eventDate.ToString("MMM dd, yyyy") + @"');
                                    window.location.href = 'Student_Dashboard.aspx';
                                </script>";
                            Response.Write(script);
                        }
                        else
                        {
                            Response.Write("<script>alert('❌ Failed to save event. Please try again.');</script>");
                        }
                    }
                }
            }
            catch (SqlException sqlEx)
            {
                // Handle SQL specific errors
                Response.Write($"<script>alert('❌ Database Error:\\n\\nUnable to save event to database.\\nPlease contact administrator if this persists.\\n\\nError Code: {sqlEx.Number}');</script>");
            }
            catch (Exception ex)
            {
                // Handle general errors
                Response.Write($"<script>alert('❌ Unexpected Error:\\n\\nFailed to save event. Please try again.\\n\\nIf problem persists, contact support.');</script>");
            }
        }

        // Define a class to represent an event (ideally move this to a separate file)
        [Serializable]
        public class EventData
        {
            public string Name { get; set; }
            public string Description { get; set; }
            public string Category { get; set; }
            public DateTime Date { get; set; }
        }
    }
}