using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WAPPSS
{
    public partial class TeacherDiscussionForum : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindSubjects();

                // Check if coming from a subject selection
                if (Request.QueryString["SubjectName"] != null)
                {
                    string subjectName = Request.QueryString["SubjectName"];
                    ddlSubjects.SelectedValue = subjectName;
                    LoadQuestionsForSubject(subjectName);
                }
                else if (Request.QueryString["SubjectID"] != null)
                {
                    // Handle legacy SubjectID parameter by converting to subject name
                    int subjectId = Convert.ToInt32(Request.QueryString["SubjectID"]);
                    string subjectName = GetSubjectNameById(subjectId);
                    if (!string.IsNullOrEmpty(subjectName))
                    {
                        ddlSubjects.SelectedValue = subjectName;
                        LoadQuestionsForSubject(subjectName);
                    }
                }
            }

            // Apply dark mode detection from database
            ApplyDarkModeIfNeeded();
        }

        private void ApplyDarkModeIfNeeded()
        {
            string modeType = "light";

            // Only check dark mode for the current user
            if (Session["UserID"] != null)
            {
                string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                try
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        string query = "SELECT ModeType FROM Mode WHERE UserID = @UserID";
                        SqlCommand cmd = new SqlCommand(query, conn);
                        cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                        conn.Open();
                        object result = cmd.ExecuteScalar();
                        if (result != null)
                        {
                            modeType = result.ToString().ToLower();
                        }
                    }
                }
                catch (Exception ex)
                {
                    // If Mode table doesn't exist or any error occurs, default to light mode
                    System.Diagnostics.Debug.WriteLine($"Error loading mode: {ex.Message}");
                }
            }

            // Set dark mode class and CSS
            if (modeType == "dark")
            {
                // Set session for body class in ASPX
                Session["DarkMode"] = true;
                darkModeCss.Href = "darkmode.css";
            }
            else
            {
                Session["DarkMode"] = false;
            }
        }

        protected void rptQuestions_ItemCommand(object source, RepeaterCommandEventArgs e)
        {

        }

        private void BindSubjects()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                // Get distinct course names from TeacherCourses table
                string query = "SELECT DISTINCT TC_CourseName FROM TeacherCourses ORDER BY TC_CourseName";
                SqlCommand cmd = new SqlCommand(query, con);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlSubjects.DataSource = dt;
                ddlSubjects.DataTextField = "TC_CourseName";
                ddlSubjects.DataValueField = "TC_CourseName";
                ddlSubjects.DataBind();
            }
        }

        protected void ddlSubjects_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlSubjects.SelectedValue != "0" && !string.IsNullOrEmpty(ddlSubjects.SelectedValue))
            {
                LoadQuestionsForSubject(ddlSubjects.SelectedValue);
            }
            else
            {
                rptQuestions.DataSource = null;
                rptQuestions.DataBind();
                lblNoQuestions.Visible = true;
            }
        }

        private void LoadQuestionsForSubject(string courseName)
        {
            // First, get or create the SubjectID for this course
            int subjectId = GetOrCreateSubjectId(courseName);

            string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
            SELECT 
                q.QuestionID, 
                q.Title, 
                u.Username, 
                u.Category as UserType,
                q.PostDate, 
                (SELECT COUNT(*) FROM Replies r WHERE r.QuestionID = q.QuestionID) as ReplyCount,
                (SELECT COUNT(*) FROM Replies r WHERE r.QuestionID = q.QuestionID AND r.IsBest = 1) as HasBestAnswer
            FROM Questions q
            INNER JOIN Users u ON q.UserID = u.UserID
            WHERE q.SubjectID = @SubjectID
            ORDER BY q.PostDate DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@SubjectID", subjectId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    rptQuestions.DataSource = dt;
                    rptQuestions.DataBind();
                    lblNoQuestions.Visible = false;
                }
                else
                {
                    rptQuestions.DataSource = null;
                    rptQuestions.DataBind();
                    lblNoQuestions.Visible = true;
                }
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

        private string GetSubjectNameById(int subjectId)
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

        protected void btnAddQuestion_Click(object sender, EventArgs e)
        {
            if (ddlSubjects.SelectedValue == "0")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Please select a subject first.');", true);
            }
            else if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.ToString()));
            }
            else
            {
                // FIX: Pass the course name as SubjectName parameter instead of SubjectID
                Response.Redirect("CreateQuestion.aspx?SubjectName=" + Server.UrlEncode(ddlSubjects.SelectedValue));
            }
        }

        protected void rptQuestions_ItemCommand1(object source, RepeaterCommandEventArgs e)
        {

        }
    }
}