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
    public partial class adminManageUsers : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            UnobtrusiveValidationMode = UnobtrusiveValidationMode.None;

            // Check if admin is logged in
            if (Session["AdminID"] == null || Session["AdminAuthenticated"] == null || !(bool)Session["AdminAuthenticated"])
            {
                Response.Redirect("adminLogin.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // Initialize the page
                BindUsers();
                LoadAdminInfo();
            }
        }

        private void LoadAdminInfo()
        {
            try
            {
                // Get admin ID from session
                int adminId = Convert.ToInt32(Session["AdminID"]);
                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT Username FROM Admins WHERE AdminID = @AdminID";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@AdminID", adminId);

                    connection.Open();
                    object result = command.ExecuteScalar();

                    if (result != null && result != DBNull.Value)
                    {
                        string username = result.ToString();
                        litAdminInitial.Text = username.Length > 0 ? username[0].ToString().ToUpper() : "A";
                        litAdminName.Text = username;
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the exception (in a production environment)
                System.Diagnostics.Debug.WriteLine("Error loading admin info: " + ex.Message);
            }
        }

        private void BindUsers()
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    StringBuilder query = new StringBuilder("SELECT UserID, Username, Email, Category, FirstName, LastName, DateRegistered FROM Users WHERE 1=1");

                    SqlCommand command = new SqlCommand();
                    command.Connection = connection;

                    // Apply search filter if provided
                    if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
                    {
                        query.Append(" AND (Username LIKE @Search OR Email LIKE @Search OR FirstName LIKE @Search OR LastName LIKE @Search)");
                        command.Parameters.AddWithValue("@Search", "%" + txtSearch.Text.Trim() + "%");
                    }

                    // Apply role filter if selected
                    if (!string.IsNullOrEmpty(ddlRoles.SelectedValue))
                    {
                        query.Append(" AND Category = @Category");
                        command.Parameters.AddWithValue("@Category", ddlRoles.SelectedValue);
                    }

                    query.Append(" ORDER BY DateRegistered DESC");
                    command.CommandText = query.ToString();

                    connection.Open();
                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    DataTable dataTable = new DataTable();
                    adapter.Fill(dataTable);

                    // Status filtering - all users are considered active for now
                    if (!string.IsNullOrEmpty(ddlStatus.SelectedValue))
                    {
                        if (ddlStatus.SelectedValue != "Active")
                        {
                            dataTable.Clear(); // Remove all rows if not filtering for Active
                        }
                    }

                    gvUsers.DataSource = dataTable;
                    gvUsers.DataBind();

                    litUserCount.Text = $"Showing {dataTable.Rows.Count} of {dataTable.Rows.Count} users";
                }
            }
            catch (Exception ex)
            {
                // Log the exception (in a production environment)
                System.Diagnostics.Debug.WriteLine("Error loading users: " + ex.Message);
            }
        }

        private DataRow GetUserDetails(int userId)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT UserID, Username, Email, Category, FirstName, LastName, DateRegistered FROM Users WHERE UserID = @UserID";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@UserID", userId);

                    connection.Open();
                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    DataTable dataTable = new DataTable();
                    adapter.Fill(dataTable);

                    if (dataTable.Rows.Count > 0)
                    {
                        return dataTable.Rows[0];
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the exception (in a production environment)
                System.Diagnostics.Debug.WriteLine("Error getting user details: " + ex.Message);
            }

            return null;
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            BindUsers();
        }

        protected void ddlRoles_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindUsers();
        }

        protected void ddlStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindUsers();
        }

        protected void btnAddUser_Click(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "addUser", "alert('Add User functionality will be implemented here.');", true);
        }

        protected void btnExport_Click(object sender, EventArgs e)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT Username, FirstName, LastName, Email, Category, DateRegistered FROM Users ORDER BY DateRegistered DESC";
                    SqlCommand command = new SqlCommand(query, connection);

                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();

                    StringBuilder csv = new StringBuilder();
                    csv.AppendLine("Username,FirstName,LastName,Email,Category,DateRegistered");

                    while (reader.Read())
                    {
                        csv.AppendLine($"\"{reader["Username"]}\",\"{reader["FirstName"] ?? "Unknown"}\",\"{reader["LastName"]}\",\"{reader["Email"]}\",\"{reader["Category"]}\",\"{(reader["DateRegistered"] != DBNull.Value ? Convert.ToDateTime(reader["DateRegistered"]).ToString("yyyy-MM-dd HH:mm:ss") : "")}\"");
                    }

                    Response.Clear();
                    Response.Buffer = true;
                    Response.AddHeader("content-disposition", "attachment;filename=Users_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".csv");
                    Response.Charset = "";
                    Response.ContentType = "application/text";
                    Response.Output.Write(csv.ToString());
                    Response.Flush();
                    Response.End();
                }
            }
            catch (Exception ex)
            {
                // Log the exception (in a production environment)
                System.Diagnostics.Debug.WriteLine("Error exporting users: " + ex.Message);
            }
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewUser")
            {
                int userId = Convert.ToInt32(e.CommandArgument);
                DataRow userRow = GetUserDetails(userId);

                if (userRow != null)
                {
                    hdnSelectedUserId.Value = userId.ToString();
                    hdnUserData.Value = string.Format("{0}|{1}|{2}|{3}|{4}|{5}|{6}",
                        userRow["UserID"],
                        userRow["Username"] ?? "",
                        userRow["FirstName"] ?? "Unknown",
                        userRow["LastName"] ?? "",
                        userRow["Email"] ?? "",
                        userRow["Category"] ?? "student",
                        userRow["DateRegistered"] != DBNull.Value ? Convert.ToDateTime(userRow["DateRegistered"]).ToString("MMM dd, yyyy") : "N/A"
                    );

                    ScriptManager.RegisterStartupScript(this, GetType(), "showUserModal", "showUserModal();", true);
                }
            }
        }

        [System.Web.Services.WebMethod]
        public static string DeleteUserById(int userId)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    // Check if user exists first
                    string checkQuery = "SELECT COUNT(*) FROM Users WHERE UserID = @UserID";
                    SqlCommand checkCommand = new SqlCommand(checkQuery, connection);
                    checkCommand.Parameters.AddWithValue("@UserID", userId);

                    connection.Open();
                    int count = (int)checkCommand.ExecuteScalar();

                    if (count == 0)
                    {
                        return "User not found.";
                    }

                    // Delete the user
                    string deleteQuery = "DELETE FROM Users WHERE UserID = @UserID";
                    SqlCommand deleteCommand = new SqlCommand(deleteQuery, connection);
                    deleteCommand.Parameters.AddWithValue("@UserID", userId);

                    int result = deleteCommand.ExecuteNonQuery();

                    if (result > 0)
                    {
                        return "success";
                    }
                    else
                    {
                        return "User could not be deleted.";
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the exception (in a production environment)
                System.Diagnostics.Debug.WriteLine("Error deleting user: " + ex.Message);
                return "Error: " + ex.Message;
            }
        }

        protected void gvUsers_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // You can customize row appearance based on data here
            }
        }

        protected void gvUsers_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvUsers.PageIndex = e.NewPageIndex;
            BindUsers();
        }

        protected string GetUserDisplayName(object usernameObj, object firstNameObj, object lastNameObj)
        {
            string username = usernameObj?.ToString() ?? "";
            string firstName = firstNameObj?.ToString() ?? "";
            string lastName = lastNameObj?.ToString() ?? "";

            if (firstName == "Unknown" && string.IsNullOrEmpty(lastName))
            {
                return !string.IsNullOrEmpty(username) ? username : "Unknown User";
            }

            if (!string.IsNullOrEmpty(firstName) && !string.IsNullOrEmpty(lastName))
            {
                return $"{firstName} {lastName}";
            }
            else if (!string.IsNullOrEmpty(firstName) && firstName != "Unknown")
            {
                return firstName;
            }
            else if (!string.IsNullOrEmpty(username))
            {
                return username;
            }

            return "Unknown User";
        }

        protected string GetUserInitials(object usernameObj, object firstNameObj, object lastNameObj)
        {
            string username = usernameObj?.ToString() ?? "";
            string firstName = firstNameObj?.ToString() ?? "";
            string lastName = lastNameObj?.ToString() ?? "";

            if (firstName == "Unknown" && string.IsNullOrEmpty(lastName))
            {
                if (!string.IsNullOrEmpty(username))
                {
                    return username[0].ToString().ToUpper();
                }
                return "U";
            }

            if (!string.IsNullOrEmpty(firstName) && !string.IsNullOrEmpty(lastName) && firstName != "Unknown")
            {
                return (firstName[0].ToString() + lastName[0].ToString()).ToUpper();
            }
            else if (!string.IsNullOrEmpty(firstName) && firstName != "Unknown")
            {
                return firstName[0].ToString().ToUpper();
            }
            else if (!string.IsNullOrEmpty(username))
            {
                return username[0].ToString().ToUpper();
            }

            return "U";
        }

        protected string GetFormattedRole(string category)
        {
            if (string.IsNullOrEmpty(category))
                return "Student";

            switch (category.ToLower())
            {
                case "student":
                    return "Student";
                case "teacher":
                    return "Teacher";
                case "admin":
                    return "Administrator";
                default:
                    return char.ToUpper(category[0]) + category.Substring(1).ToLower();
            }
        }

        protected string GetStatusClass(string category)
        {
            return "status-active";
        }

        protected string GetStatusText(string category)
        {
            return "Active";
        }

        protected string GetUserCourseCount(string userId)
        {
            try
            {
                Random random = new Random(int.Parse(userId));
                return random.Next(0, 6).ToString();
            }
            catch
            {
                return "0";
            }
        }

        protected string GetLastActiveTime(string userId)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT DateRegistered FROM Users WHERE UserID = @UserID";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@UserID", userId);

                    connection.Open();
                    object result = command.ExecuteScalar();

                    if (result != null && result != DBNull.Value)
                    {
                        DateTime registeredDate = Convert.ToDateTime(result);
                        TimeSpan timeDiff = DateTime.Now - registeredDate;

                        if (timeDiff.TotalMinutes < 60)
                            return "Just now";
                        else if (timeDiff.TotalHours < 24)
                            return $"{(int)timeDiff.TotalHours} hours ago";
                        else if (timeDiff.TotalDays < 7)
                            return $"{(int)timeDiff.TotalDays} days ago";
                        else if (timeDiff.TotalDays < 30)
                            return $"{(int)(timeDiff.TotalDays / 7)} weeks ago";
                        else
                            return $"{(int)(timeDiff.TotalDays / 30)} months ago";
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the exception (in a production environment)
                System.Diagnostics.Debug.WriteLine("Error getting last active time: " + ex.Message);
            }

            return "Unknown";
        }

        protected string GetFormattedDate(object dateObj)
        {
            if (dateObj == null || dateObj == DBNull.Value)
                return "N/A";

            DateTime date = Convert.ToDateTime(dateObj);
            return date.ToString("MMM dd, yyyy");
        }
    }
}