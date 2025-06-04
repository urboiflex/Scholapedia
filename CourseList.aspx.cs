using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace WAPPSS
{
    public partial class CourseList : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

        // Navbar/profile/theme values
        protected string NavbarUserName = "User";
        protected string NavbarProfilePic = "Images/Profile/default.jpg";
        protected string NavbarProfilePicResolved = "/Images/Profile/default.jpg";
        protected string ModeTypeFromDB = "light"; // Default to light

        protected void Page_Init(object sender, EventArgs e)
        {
            if (Session["UserID"] != null)
            {
                using (var conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    // Get user's name and profile pic (same as course.aspx)
                    using (var cmd = new SqlCommand(
                        "SELECT u.FirstName, pt.ProfilePic FROM Users u LEFT JOIN ProfileTC pt ON u.UserID = pt.UserID WHERE u.UserID = @UserID", conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                        using (var rdr = cmd.ExecuteReader())
                        {
                            if (rdr.Read())
                            {
                                NavbarUserName = (rdr["FirstName"] != DBNull.Value && rdr["FirstName"] != null)
                                    ? rdr["FirstName"].ToString()
                                    : "User";
                                NavbarProfilePic = rdr["ProfilePic"] != DBNull.Value && !string.IsNullOrEmpty(rdr["ProfilePic"].ToString())
                                    ? rdr["ProfilePic"].ToString()
                                    : "Images/Profile/default.jpg";
                            }
                        }
                    }
                    NavbarProfilePicResolved = ResolveUrl("~/" + NavbarProfilePic.TrimStart('~', '/'));

                    // Get ModeType from Mode table for logged in user
                    using (var cmd = new SqlCommand("SELECT ModeType FROM Mode WHERE UserID = @UserID", conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                        object modeTypeObj = cmd.ExecuteScalar();
                        if (modeTypeObj != null && modeTypeObj != DBNull.Value)
                        {
                            ModeTypeFromDB = modeTypeObj.ToString().ToLower() == "dark" ? "dark" : "light";
                        }
                    }
                }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Theme is now set in JS from ModeTypeFromDB
            if (!IsPostBack)
            {
                LoadCourses();
            }
        }

        private void LoadCourses()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        TC_ID AS CourseID,
                        TC_CourseName AS CourseName,
                        TC_ModuleType AS ModuleType,
                        TC_PublishDate AS PublishDate,
                        TC_Duration AS Duration,
                        TC_SkillLevel AS SkillLevel,
                        TC_Language AS Language
                    FROM TeacherCourses";

                SqlCommand cmd = new SqlCommand(query, conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // Add RowNumber column to DataTable if needed
                if (!dt.Columns.Contains("RowNumber"))
                    dt.Columns.Add("RowNumber", typeof(int));
                int rowNumber = 1;
                foreach (DataRow row in dt.Rows)
                {
                    row["RowNumber"] = rowNumber++;
                }

                gvCourses.DataSource = dt;
                gvCourses.DataBind();
            }
        }

        protected void gvCourses_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string courseId = e.CommandArgument.ToString();
            if (e.CommandName == "DeleteCourse")
            {
                DeleteCourse(courseId);
                LoadCourses(); // refresh after delete
            }
            else if (e.CommandName == "EditCourse")
            {
                Response.Redirect("EditCourse.aspx?id=" + courseId);
            }
            else if (e.CommandName == "AddQuiz")
            {
                Response.Redirect("AddQuiz.aspx?courseId=" + courseId);
            }
        }

        private void BindCourses()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM TeacherCourses";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    gvCourses.DataSource = reader;
                    gvCourses.DataBind();
                    reader.Close();
                }
            }
        }

        /// <summary>
        /// Deletes dependent rows in FlashcardDecks, ClassSchedule, and CourseStudents before deleting the course.
        /// </summary>
        /// <param name="courseId"></param>
        private void DeleteCourse(string courseId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // 1. Delete all Flashcards belonging to decks in this course
                using (SqlCommand cmd = new SqlCommand(
                    @"DELETE FROM Flashcards WHERE DeckID IN (SELECT DeckID FROM FlashcardDecks WHERE TC_ID = @ID)", conn))
                {
                    cmd.Parameters.AddWithValue("@ID", courseId);
                    cmd.ExecuteNonQuery();
                }

                // 2. Delete FlashcardDecks for this course
                using (SqlCommand cmd = new SqlCommand("DELETE FROM FlashcardDecks WHERE TC_ID = @ID", conn))
                {
                    cmd.Parameters.AddWithValue("@ID", courseId);
                    cmd.ExecuteNonQuery();
                }

                // 3. Delete all TestOptions for questions in tests for this course
                using (SqlCommand cmd = new SqlCommand(
                    @"DELETE FROM TestOptions WHERE QuestionID IN 
                (SELECT QuestionID FROM TestQuestions WHERE TestID IN 
                    (SELECT TestID FROM Test WHERE TC_ID = @ID))", conn))
                {
                    cmd.Parameters.AddWithValue("@ID", courseId);
                    cmd.ExecuteNonQuery();
                }

                // 4. Delete all TestQuestions for tests in this course
                using (SqlCommand cmd = new SqlCommand(
                    @"DELETE FROM TestQuestions WHERE TestID IN 
                (SELECT TestID FROM Test WHERE TC_ID = @ID)", conn))
                {
                    cmd.Parameters.AddWithValue("@ID", courseId);
                    cmd.ExecuteNonQuery();
                }

                // 5. Delete all Tests for this course
                using (SqlCommand cmd = new SqlCommand(
                    "DELETE FROM Test WHERE TC_ID = @ID", conn))
                {
                    cmd.Parameters.AddWithValue("@ID", courseId);
                    cmd.ExecuteNonQuery();
                }

                // 6. Delete dependent records in ClassSchedule
                using (SqlCommand cmd = new SqlCommand("DELETE FROM ClassSchedule WHERE TC_ID = @ID", conn))
                {
                    cmd.Parameters.AddWithValue("@ID", courseId);
                    cmd.ExecuteNonQuery();
                }

                // 7. Delete dependent records in CourseStudents
                using (SqlCommand cmd = new SqlCommand("DELETE FROM CourseStudents WHERE TC_ID = @ID", conn))
                {
                    cmd.Parameters.AddWithValue("@ID", courseId);
                    cmd.ExecuteNonQuery();
                }

                // 8. Delete the course itself
                using (SqlCommand cmd = new SqlCommand("DELETE FROM TeacherCourses WHERE TC_ID = @ID", conn))
                {
                    cmd.Parameters.AddWithValue("@ID", courseId);
                    cmd.ExecuteNonQuery();
                }
            }
        }
    }
}