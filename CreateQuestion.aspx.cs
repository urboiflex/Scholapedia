using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WAPPSS
{
    public partial class CreateQuestion : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is logged in
                if (Session["UserID"] == null)
                {
                    Response.Redirect("Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.ToString()));
                    return;
                }

                string subjectName = "";
                int subjectId = 0;

                // Check for SubjectName parameter (new approach)
                if (Request.QueryString["SubjectName"] != null)
                {
                    subjectName = Request.QueryString["SubjectName"];
                    // Get or create SubjectID for this subject name
                    subjectId = GetOrCreateSubjectId(subjectName);
                }
                // Check for legacy SubjectID parameter
                else if (Request.QueryString["SubjectID"] != null)
                {
                    try
                    {
                        subjectId = Convert.ToInt32(Request.QueryString["SubjectID"]);
                        subjectName = GetSubjectName(subjectId);

                        if (string.IsNullOrEmpty(subjectName))
                        {
                            // If subject doesn't exist, redirect back to forum
                            Response.Redirect("DiscussionForum.aspx");
                            return;
                        }
                    }
                    catch
                    {
                        Response.Redirect("DiscussionForum.aspx");
                        return;
                    }
                }
                else
                {
                    // No subject specified, redirect back to forum
                    Response.Redirect("DiscussionForum.aspx");
                    return;
                }

                // Set the subject information
                lblSubject.Text = subjectName;
                ViewState["SubjectID"] = subjectId;
                ViewState["SubjectName"] = subjectName;
            }

            if (Session["DarkMode"] != null && (bool)Session["DarkMode"])
            {
                darkModeCss.Href = "darkmode.css";
            }
        }

        private string GetSubjectName(int subjectId)
        {
            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "SELECT SubjectName FROM Subjects WHERE SubjectID = @SubjectID";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@SubjectID", subjectId);

                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    return result?.ToString() ?? string.Empty;
                }
            }
            catch (Exception ex)
            {
                // Log error if needed
                return string.Empty;
            }
        }

        private int GetOrCreateSubjectId(string courseName)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                // First, check if the subject already exists
                string checkQuery = "SELECT SubjectID FROM Subjects WHERE SubjectName = @SubjectName";
                SqlCommand checkCmd = new SqlCommand(checkQuery, con);
                checkCmd.Parameters.AddWithValue("@SubjectName", courseName);

                object result = checkCmd.ExecuteScalar();

                if (result != null)
                {
                    // Subject exists, return the ID
                    return Convert.ToInt32(result);
                }
                else
                {
                    // Subject doesn't exist, create it
                    string insertQuery = "INSERT INTO Subjects (SubjectName) VALUES (@SubjectName); SELECT SCOPE_IDENTITY();";
                    SqlCommand insertCmd = new SqlCommand(insertQuery, con);
                    insertCmd.Parameters.AddWithValue("@SubjectName", courseName);

                    result = insertCmd.ExecuteScalar();
                    return Convert.ToInt32(result);
                }
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            // Check if controls exist
            if (txtTitle == null || txtContent == null)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert",
                    "alert('Error: Form controls not found. Please refresh the page and try again.');", true);
                return;
            }

            // Validate input
            if (string.IsNullOrWhiteSpace(txtTitle.Text) || string.IsNullOrWhiteSpace(txtContent.Text))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert",
                    "alert('Please fill in all fields.');", true);
                return;
            }

            if (ViewState["SubjectID"] == null || Session["UserID"] == null)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert",
                    "alert('Session expired. Please refresh and try again.');", true);
                return;
            }

            try
            {
                int subjectId = (int)ViewState["SubjectID"];
                int userId = Convert.ToInt32(Session["UserID"]);
                string title = txtTitle.Text.Trim();
                string content = txtContent.Text.Trim();

                string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"
                        INSERT INTO Questions (UserID, SubjectID, Title, Content, PostDate)
                        VALUES (@UserID, @SubjectID, @Title, @Content, GETDATE())";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    cmd.Parameters.AddWithValue("@SubjectID", subjectId);
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@Content", content);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                // Redirect back to discussion forum with the subject name
                string subjectName = ViewState["SubjectName"]?.ToString();
                if (!string.IsNullOrEmpty(subjectName))
                {
                    Response.Redirect($"DiscussionForum.aspx?SubjectName={Server.UrlEncode(subjectName)}");
                }
                else
                {
                    Response.Redirect("DiscussionForum.aspx");
                }
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert",
                    "alert('Error posting question. Please try again.');", true);
                // Log the exception if you have logging setup
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            try
            {
                string subjectName = ViewState["SubjectName"]?.ToString();
                if (!string.IsNullOrEmpty(subjectName))
                {
                    Response.Redirect($"DiscussionForum.aspx?SubjectName={Server.UrlEncode(subjectName)}");
                }
                else
                {
                    Response.Redirect("DiscussionForum.aspx");
                }
            }
            catch
            {
                Response.Redirect("DiscussionForum.aspx");
            }
        }
    }
}