using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WAPPSS
{
    public partial class adminAnnouncements : System.Web.UI.Page
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
                // Clear any previous messages
                lblMessage.Text = string.Empty;

                // Load announcement history
                LoadAnnouncementHistory();

                // Load admin information in the header
                LoadAdminInfo();
            }
        }

        #region Database Methods

        private string GetConnectionString()
        {
            // Get connection string from web.config - matching register pattern
            return ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
        }

        private void LoadAdminInfo()
        {
            try
            {
                // Get admin ID from session
                if (Session["AdminID"] == null)
                {
                    ShowErrorMessage("Admin session has expired. Please log in again.");
                    Response.Redirect("adminLogin.aspx");
                    return;
                }

                int adminId = Convert.ToInt32(Session["AdminID"]);

                using (SqlConnection connection = new SqlConnection(GetConnectionString()))
                {
                    string query = "SELECT Username FROM Admins WHERE AdminID = @AdminID";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@AdminID", adminId);

                    try
                    {
                        connection.Open();
                        object result = command.ExecuteScalar();

                        if (result != null && result != DBNull.Value)
                        {
                            string username = result.ToString();

                            // Update the admin display
                            litAdminInitial.Text = username.Length > 0 ? username[0].ToString().ToUpper() : "A";
                            litAdminName.Text = username;
                        }
                        else
                        {
                            // Admin not found, redirect to login
                            Session.Clear();
                            Response.Redirect("adminLogin.aspx");
                        }
                    }
                    catch (Exception ex)
                    {
                        // Log the exception (in a production environment)
                        System.Diagnostics.Debug.WriteLine("Error loading admin info: " + ex.Message);
                        ShowErrorMessage("Error loading admin information. Please try again.");
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the exception (in a production environment)
                System.Diagnostics.Debug.WriteLine("Error in LoadAdminInfo: " + ex.Message);
                ShowErrorMessage("An error occurred. Please try again.");
            }
        }

        private void LoadAnnouncementHistory()
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(GetConnectionString()))
                {
                    string query = @"SELECT AnnouncementID, title, content, target, time 
                                   FROM Announcements
                                   ORDER BY time DESC";

                    SqlCommand command = new SqlCommand(query, connection);

                    try
                    {
                        connection.Open();
                        using (SqlDataAdapter da = new SqlDataAdapter(command))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);

                            gvAnnouncementHistory.DataSource = dt;
                            gvAnnouncementHistory.DataBind();
                        }
                    }
                    catch (Exception ex)
                    {
                        // Log the exception (in a production environment)
                        System.Diagnostics.Debug.WriteLine("Error loading announcement history: " + ex.Message);
                        ShowErrorMessage("Error loading announcement history. Please try again.");
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the exception (in a production environment)
                System.Diagnostics.Debug.WriteLine("Error in LoadAnnouncementHistory: " + ex.Message);
                ShowErrorMessage("An error occurred while loading data. Please try again.");
            }
        }

        private bool IsAnnouncementTitleExists(string title)
        {
            bool exists = false;
            string connectionString = GetConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM Announcements WHERE title = @Title";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@Title", title);

                try
                {
                    connection.Open();
                    int count = (int)command.ExecuteScalar();
                    exists = (count > 0);
                }
                catch (Exception ex)
                {
                    // Log the exception (in a production environment)
                    System.Diagnostics.Debug.WriteLine("Error checking announcement title: " + ex.Message);
                }
            }

            return exists;
        }

        private int CreateAnnouncement(string title, string content, string target, bool isDraft = false)
        {
            try
            {
                // Get admin ID from session
                if (Session["AdminID"] == null)
                {
                    ShowErrorMessage("Admin session has expired. Please log in again.");
                    return -1;
                }

                int adminId = Convert.ToInt32(Session["AdminID"]);

                // Check if announcement title already exists (optional - can be removed if duplicates are allowed)
                if (!isDraft && IsAnnouncementTitleExists(title))
                {
                    ShowErrorMessage("An announcement with this title already exists. Please choose a different title.");
                    return -1;
                }

                using (SqlConnection connection = new SqlConnection(GetConnectionString()))
                {
                    string query = @"INSERT INTO Announcements (adminID, title, content, target, time)
                                   VALUES (@AdminID, @Title, @Content, @Target, @Time);
                                   SELECT SCOPE_IDENTITY();";

                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@AdminID", adminId);
                    command.Parameters.AddWithValue("@Title", title);
                    command.Parameters.AddWithValue("@Content", content);
                    command.Parameters.AddWithValue("@Target", target);
                    command.Parameters.AddWithValue("@Time", DateTime.Now);

                    try
                    {
                        connection.Open();
                        int newAnnouncementId = Convert.ToInt32(command.ExecuteScalar());
                        return newAnnouncementId;
                    }
                    catch (Exception ex)
                    {
                        // Log the exception (in a production environment)
                        System.Diagnostics.Debug.WriteLine("Error creating announcement: " + ex.Message);
                        return -1;
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the exception (in a production environment)
                System.Diagnostics.Debug.WriteLine("Error in CreateAnnouncement: " + ex.Message);
                return -1;
            }
        }

        private bool DeleteAnnouncement(int announcementId)
        {
            bool success = false;
            string connectionString = GetConnectionString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM Announcements WHERE AnnouncementID = @AnnouncementID";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@AnnouncementID", announcementId);

                try
                {
                    connection.Open();
                    int result = command.ExecuteNonQuery();
                    success = (result > 0);
                }
                catch (Exception ex)
                {
                    // Log the exception (in a production environment)
                    System.Diagnostics.Debug.WriteLine("Error deleting announcement: " + ex.Message);
                }
            }

            return success;
        }

        private DataRow GetAnnouncementDetails(int announcementId)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(GetConnectionString()))
                {
                    string query = @"SELECT AnnouncementID, title, content, target, time
                                   FROM Announcements
                                   WHERE AnnouncementID = @AnnouncementID";

                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@AnnouncementID", announcementId);

                    try
                    {
                        connection.Open();
                        using (SqlDataAdapter da = new SqlDataAdapter(command))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);

                            if (dt.Rows.Count > 0)
                            {
                                return dt.Rows[0];
                            }
                            else
                            {
                                return null;
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        // Log the exception (in a production environment)
                        System.Diagnostics.Debug.WriteLine("Error getting announcement details: " + ex.Message);
                        return null;
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the exception (in a production environment)
                System.Diagnostics.Debug.WriteLine("Error in GetAnnouncementDetails: " + ex.Message);
                return null;
            }
        }

        #endregion

        #region Event Handlers

        protected void btnSendAnnouncement_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string title = txtAnnouncementTitle.Text.Trim();
                string content = txtAnnouncementContent.Text.Trim();
                string target = ddlTargetAudience.SelectedValue;

                // Additional validation
                if (string.IsNullOrEmpty(title))
                {
                    lblMessage.Text = "Title is required.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Visible = true;
                    return;
                }

                if (string.IsNullOrEmpty(content))
                {
                    lblMessage.Text = "Content is required.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Visible = true;
                    return;
                }

                if (title.Length > 200)
                {
                    lblMessage.Text = "Title must be less than 200 characters.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Visible = true;
                    return;
                }

                if (content.Length > 2000)
                {
                    lblMessage.Text = "Content must be less than 2000 characters.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Visible = true;
                    return;
                }

                int newId = CreateAnnouncement(title, content, target);
                if (newId > 0)
                {
                    // Clear the form
                    ClearForm();

                    // Reload the announcement history
                    LoadAnnouncementHistory();

                    // Show success message
                    lblMessage.Text = "Announcement has been sent successfully!";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    lblMessage.Visible = true;
                }
                else
                {
                    lblMessage.Text = "Failed to send announcement. Please try again.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Visible = true;
                }
            }
        }

        protected void btnSaveDraft_Click(object sender, EventArgs e)
        {
            string title = txtAnnouncementTitle.Text.Trim();
            string content = txtAnnouncementContent.Text.Trim();
            string target = ddlTargetAudience.SelectedValue;

            // For drafts, we might want to add a status field to the database
            // For now, we'll just create it normally with a "(Draft)" prefix
            if (!string.IsNullOrEmpty(title))
            {
                // Additional validation for drafts
                if (title.Length > 190) // Account for "(Draft) " prefix
                {
                    lblMessage.Text = "Title must be less than 190 characters for drafts.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Visible = true;
                    return;
                }

                title = "(Draft) " + title;
                int newId = CreateAnnouncement(title, content, target, true);
                if (newId > 0)
                {
                    // Clear the form
                    ClearForm();

                    // Reload the announcement history
                    LoadAnnouncementHistory();

                    // Show success message
                    lblMessage.Text = "Announcement draft has been saved!";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    lblMessage.Visible = true;
                }
                else
                {
                    lblMessage.Text = "Failed to save draft. Please try again.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Visible = true;
                }
            }
            else
            {
                lblMessage.Text = "Please provide at least a title for your draft.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Visible = true;
            }
        }

        protected void gvAnnouncementHistory_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (!int.TryParse(e.CommandArgument.ToString(), out int announcementId))
            {
                lblMessage.Text = "Invalid announcement ID.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Visible = true;
                return;
            }

            if (e.CommandName == "ViewAnnouncement")
            {
                DataRow row = GetAnnouncementDetails(announcementId);
                if (row != null)
                {
                    string title = row["title"].ToString();
                    string content = row["content"].ToString();
                    string target = row["target"].ToString();
                    string time = Convert.ToDateTime(row["time"]).ToString("MMM dd, yyyy hh:mm tt");

                    // Enhanced modal popup with better styling and tab persistence
                    string script = $@"
                        // Save the current tab before showing modal
                        sessionStorage.setItem('activeAnnouncementTab', '#history-tab-pane');
                        
                        // Create overlay for modal effect
                        let overlay = document.createElement('div');
                        overlay.className = 'announcement-overlay';
                        overlay.style.cssText = `
                            position: fixed;
                            top: 0;
                            left: 0;
                            width: 100%;
                            height: 100%;
                            background-color: rgba(0, 0, 0, 0.5);
                            z-index: 1000;
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            opacity: 0;
                            transition: opacity 0.3s ease;
                            backdrop-filter: blur(3px);
                        `;
                        
                        // Create modal popup
                        let popup = document.createElement('div');
                        popup.className = 'announcement-modal';
                        popup.style.cssText = `
                            background-color: var(--card-bg-color, white);
                            color: var(--text-color, #333);
                            border-radius: 12px;
                            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
                            width: 600px;
                            max-width: 90%;
                            max-height: 85vh;
                            overflow: auto;
                            transform: scale(0.9);
                            opacity: 0;
                            transition: all 0.3s ease;
                            border: 1px solid var(--border-color, #e0e0e0);
                        `;
                        
                        // Apply dark mode if active
                        if (document.documentElement.getAttribute('data-theme') === 'dark') {{
                            popup.style.backgroundColor = '#2a2d31';
                            popup.style.color = '#E9ECEF';
                            popup.style.borderColor = '#3a3d41';
                        }}
                        
                        // Create header
                        let header = document.createElement('div');
                        header.style.cssText = `
                            padding: 25px 30px 15px;
                            border-bottom: 1px solid var(--border-color, rgba(166, 141, 217, 0.2));
                            position: relative;
                            background-color: var(--card-bg-color, #fcfcff);
                        `;
                        
                        if (document.documentElement.getAttribute('data-theme') === 'dark') {{
                            header.style.backgroundColor = '#2a2d31';
                            header.style.borderBottomColor = '#3a3d41';
                        }}
                        
                        let closeBtn = document.createElement('button');
                        closeBtn.innerHTML = '&times;';
                        closeBtn.style.cssText = `
                            position: absolute;
                            right: 20px;
                            top: 20px;
                            background: none;
                            border: none;
                            font-size: 28px;
                            cursor: pointer;
                            color: var(--text-muted, #999);
                            transition: color 0.2s ease;
                        `;
                        
                        closeBtn.addEventListener('mouseover', function() {{
                            this.style.color = 'var(--text-color, #333)';
                        }});
                        closeBtn.addEventListener('mouseout', function() {{
                            this.style.color = 'var(--text-muted, #999)';
                        }});
                        
                        function closeModal() {{
                            popup.style.transform = 'scale(0.9)';
                            popup.style.opacity = '0';
                            overlay.style.opacity = '0';
                            setTimeout(function() {{
                                if (document.body.contains(overlay)) {{
                                    document.body.removeChild(overlay);
                                }}
                            }}, 300);
                        }}
                        
                        closeBtn.addEventListener('click', closeModal);
                        
                        let heading = document.createElement('h3');
                        heading.textContent = '{title.Replace("'", "\\'")}';
                        heading.style.cssText = `
                            margin: 0 0 5px 0;
                            color: var(--text-color, #333);
                            font-weight: 600;
                            font-size: 1.6rem;
                            padding-right: 40px;
                        `;
                        
                        header.appendChild(closeBtn);
                        header.appendChild(heading);
                        
                        // Create content
                        let body = document.createElement('div');
                        body.style.padding = '25px 30px';
                        
                        let metaInfo = document.createElement('div');
                        metaInfo.style.cssText = `
                            margin-bottom: 25px;
                            display: flex;
                            flex-wrap: wrap;
                            gap: 15px;
                        `;
                        
                        let sentBy = document.createElement('div');
                        sentBy.innerHTML = `
                            <div style='font-weight: 600; color: var(--text-muted, #666); margin-bottom: 5px; font-size: 0.85rem; text-transform: uppercase;'>Sent by</div>
                            <div style='color: #A68DD9; font-weight: 500; display: flex; align-items: center;'>
                                <i class='fas fa-user-shield' style='margin-right: 6px;'></i>
                                {litAdminName.Text}
                            </div>
                        `;
                        sentBy.style.cssText = 'flex: 1; min-width: 120px;';
                        
                        let sentTo = document.createElement('div');
                        sentTo.innerHTML = `
                            <div style='font-weight: 600; color: var(--text-muted, #666); margin-bottom: 5px; font-size: 0.85rem; text-transform: uppercase;'>Sent to</div>
                            <div>
                                <span style='background-color: #A68DD9; color: white; padding: 4px 10px; border-radius: 5px; font-size: 0.9em; font-weight: 500;'>
                                    {target.Replace("'", "\\'")}
                                </span>
                            </div>
                        `;
                        sentTo.style.cssText = 'flex: 1; min-width: 120px;';
                        
                        let date = document.createElement('div');
                        date.innerHTML = `
                            <div style='font-weight: 600; color: var(--text-muted, #666); margin-bottom: 5px; font-size: 0.85rem; text-transform: uppercase;'>Date</div>
                            <div style='color: var(--text-muted, #6c757d); display: flex; align-items: center;'>
                                <i class='far fa-calendar-alt' style='margin-right: 6px;'></i>
                                {time}
                            </div>
                        `;
                        date.style.cssText = 'flex: 1; min-width: 180px;';
                        
                        metaInfo.appendChild(sentBy);
                        metaInfo.appendChild(sentTo);
                        metaInfo.appendChild(date);
                        
                        let divider = document.createElement('hr');
                        divider.style.cssText = `
                            margin: 20px 0;
                            border: 0;
                            border-top: 1px solid var(--border-color, rgba(166, 141, 217, 0.2));
                        `;
                        
                        if (document.documentElement.getAttribute('data-theme') === 'dark') {{
                            divider.style.borderTopColor = '#3a3d41';
                        }}
                        
                        let contentDiv = document.createElement('div');
                        contentDiv.innerHTML = '{content.Replace("'", "\\'").Replace("\n", "<br>")}';
                        contentDiv.style.cssText = `
                            line-height: 1.7;
                            color: var(--text-color, #333);
                            font-size: 1.05rem;
                        `;
                        
                        body.appendChild(metaInfo);
                        body.appendChild(divider);
                        body.appendChild(contentDiv);
                        
                        // Add all elements to popup
                        popup.appendChild(header);
                        popup.appendChild(body);
                        overlay.appendChild(popup);
                        
                        // Add to document
                        document.body.appendChild(overlay);
                        
                        // Trigger animation
                        setTimeout(function() {{
                            overlay.style.opacity = '1';
                            popup.style.opacity = '1';
                            popup.style.transform = 'scale(1)';
                        }}, 10);

                        // Close modal when clicking on overlay
                        overlay.addEventListener('click', function(e) {{
                            if (e.target === overlay) {{
                                closeModal();
                            }}
                        }});
                        
                        // Close modal with Escape key
                        document.addEventListener('keydown', function(e) {{
                            if (e.key === 'Escape' && document.body.contains(overlay)) {{
                                closeModal();
                            }}
                        }});
                    ";

                    ScriptManager.RegisterStartupScript(this, GetType(), "viewAnnouncement", script, true);
                }
                else
                {
                    lblMessage.Text = "Announcement not found.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Visible = true;
                }
            }
            else if (e.CommandName == "DeleteAnnouncement")
            {
                bool success = DeleteAnnouncement(announcementId);
                if (success)
                {
                    // Refresh the grid
                    LoadAnnouncementHistory();

                    // Show success message and ensure we stay on history tab
                    lblMessage.Text = "Announcement has been deleted successfully.";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    lblMessage.Visible = true;

                    ScriptManager.RegisterStartupScript(this, GetType(), "announcementDeleted",
                        @"sessionStorage.setItem('activeAnnouncementTab', '#history-tab-pane');", true);
                }
                else
                {
                    lblMessage.Text = "Failed to delete announcement. Please try again.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Visible = true;
                }
            }
        }

        #endregion

        #region Helper Methods

        private void ClearForm()
        {
            txtAnnouncementTitle.Text = string.Empty;
            txtAnnouncementContent.Text = string.Empty;
            ddlTargetAudience.SelectedIndex = 0;
        }

        private void ShowErrorMessage(string message)
        {
            lblMessage.Text = message;
            lblMessage.ForeColor = System.Drawing.Color.Red;
            lblMessage.Visible = true;
        }

        private void ShowSuccessMessage(string message)
        {
            lblMessage.Text = message;
            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Visible = true;
        }

        #endregion
    }
}