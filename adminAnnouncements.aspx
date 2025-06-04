<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="adminAnnouncements.aspx.cs" Inherits="WAPPSS.adminAnnouncements" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Announcements - Admin Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Font Awesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    
    <link href="adminAnnouncements.css?v=123" rel="stylesheet" type="text/css" />
    <link href="theme-styles.css" rel="stylesheet" type="text/css" />
<!-- Theme Switcher JS -->
<script src="theme-switcher.js"></script>
    <style>

        .button-name {
 appearance: none;
 background-color: transparent;
 border: 0.125em solid #1A1A1A;
 border-radius: 0.9375em;
 box-sizing: border-box;
 color: #3B3B3B;
 cursor: pointer;
 display: inline-block;
 font-family: Roobert,-apple-system,BlinkMacSystemFont,"Segoe UI",Helvetica,Arial,sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol";
 font-size: 16px;
 font-weight: 600;
 line-height: normal;
 margin: 0;
 min-height: 3.75em;
 min-width: 0;
 outline: none;
 padding: 1em 2.3em;
 text-align: center;
 text-decoration: none;
 transition: all 300ms cubic-bezier(.23, 1, 0.32, 1);
 user-select: none;
 -webkit-user-select: none;
 touch-action: manipulation;
 will-change: transform;
}
.button-name:disabled {
 pointer-events: none;
}
.button-name:hover {
 color: #fff;
 background-color: #9A7BCE;
 box-shadow: rgba(154, 123, 206, 0.25) 0 8px 15px;
 transform: translateY(-2px);
}
.button-name:active {
 box-shadow: none;
 transform: translateY(0);
}

    /* Direct fixes for form elements in dark mode */
    [data-theme="dark"] input[type="text"],
    [data-theme="dark"] textarea,
    [data-theme="dark"] select {
        background-color: #2a2d31 !important; /* Hard-coded dark bg color */
        color: #E9ECEF !important; /* Hard-coded light text color */
    }
    
    /* Style form container in dark mode */
    [data-theme="dark"] .announcement-form-container {
        background-color: #2a2d31;
        box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.3);
    }
    
    /* Fix buttons in dark mode */
    [data-theme="dark"] .btn-draft {
        background-color: #2a2d31 !important;
        color: #E9ECEF !important;
        border-color: #3a3d41 !important;
    }
    
    [data-theme="dark"] .btn-send {
        background-color: #9A7BCE !important;
        color: white !important;
    }
    
    /* Fix tabs in dark mode */
    [data-theme="dark"] .nav-tabs {
        border-bottom-color: #3a3d41;
    }
    
    [data-theme="dark"] .nav-tabs .nav-link {
        color: #E9ECEF;
    }
    
    [data-theme="dark"] .nav-tabs .nav-link:hover {
        background-color: #3a3d41;
        border-bottom-color: #3a3d41;
    }
    
    [data-theme="dark"] .nav-tabs .nav-link.active {
        color: #9A7BCE;
        border-bottom-color: #9A7BCE;
    }
    
    /* Fix table in dark mode */
    [data-theme="dark"] .history-table th {
    background-color: #1a1d21 !important; /* Much darker/blacker */
    color: #E9ECEF;
    border-bottom-color: #3a3d41;
}

[data-theme="dark"] .history-table td {
    color: #E9ECEF;
    border-bottom-color: #3a3d41;
}

[data-theme="dark"] .history-table tr:hover {
    background-color: rgba(154, 123, 206, 0.1);
}

.history-table th {
    background-color: #161b22 !important; /* Dark for light theme too */
    color: #E9ECEF !important;
    font-weight: 600;
    padding: 15px;
    text-align: left;
    border-bottom: 2px solid var(--border-color);
    font-size: 0.9rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}
    
    /* Fix badges in dark mode */
    [data-theme="dark"] .target-badge {
        background-color: rgba(154, 123, 206, 0.3);
        color: #c6b4e8;
    }
    
    [data-theme="dark"] .admin-badge {
        background-color: #9A7BCE;
        color: white;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
    }
    
    /* Action Buttons Enhanced - exactly matching courses page */
    .actions-cell {
        display: flex;
        gap: 8px;
        justify-content: center;
    }

    .action-button {
        width: 36px;
        height: 36px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border-radius: 8px;
        background-color: transparent;
        border: 1px solid transparent;
        transition: all 0.2s ease;
        text-decoration: none;
    }

        .action-button i {
            font-size: 1rem;
            color: var(--text-color, rgba(0, 0, 0, 0.3)); /* Black icons by default */
        }

    .action-view:hover {
        background-color: rgba(23, 162, 184, 0.1);
        border-color: #17a2b8;
    }

        .action-view:hover i {
            color: #17a2b8;
        }


    /* Dark mode fixes for action buttons */
    [data-theme="dark"] .action-button i {
        color: #E9ECEF; /* Light icons in dark mode */
    }

    [data-theme="dark"] .action-view:hover {
        background-color: rgba(23, 162, 184, 0.1);
        border-color: #17a2b8;
    }

    [data-theme="dark"] .action-view:hover i {
        color: #17a2b8;
    }

    [data-theme="dark"] .action-delete:hover {
        background-color: rgba(220, 53, 69, 0.1);
        border-color: #dc3545;
    }

    [data-theme="dark"] .action-delete:hover i {
        color: #dc3545;
    }

     body .sidebar-menu .cssbuttons-io span,
    .sidebar-menu .cssbuttons-io span,
    .cssbuttons-io span {
        color: white !important;
    }
    
    /* Force white color for SVG icons too */
    .cssbuttons-io svg,
    .cssbuttons-io svg path {
        color: white !important;
        fill: white !important;
    }
    
    /* Also target the specific text spans */
    .cssbuttons-io span span {
        color: white !important;
    }
    
    /* Ensure gradient background doesn't get affected by theme */
    .cssbuttons-io {
        background: linear-gradient(to right, #8e2de2, #4a00e0) !important;
    }
    
    .cssbuttons-io.active {
        background: linear-gradient(to right, #b366ff, #7733ff) !important;
    }
    
    /* Ensure no theme color inheritance */
    .sidebar-menu * {
        color-scheme: dark;
    }

    .admin-panel-title {
        color: #8e2de2;
        margin: 0;
        font-weight: 600;
        font-size: 1.5rem;
        text-align: center;
        position: relative;
        padding-bottom: 5px;
    }
    
    .admin-panel-title:after {
        content: "";
        position: absolute;
        bottom: 0;
        left: 25%;
        width: 50%;
        height: 2px;
        background: linear-gradient(to right, transparent, #8e2de2, transparent);
    }
    
    /* Optional hover effect */
    .admin-panel-title:hover {
        text-shadow: 0 0 8px rgba(142, 45, 226, 0.5);
        transition: text-shadow 0.3s ease;
    }

    .sidebar-footer {
        margin-top: auto;
        padding: 20px 15px;
        text-align: center;
        border-top: 1px solid var(--border-color);
    }
    
    .scholapedia-logo {
        font-size: 1.8rem;
        font-weight: bold;
        color: #4a49ca;
        letter-spacing: -0.5px;
        margin-bottom: 5px;
    }
    
    .scholapedia-tagline {
        font-size: 0.8rem;
        color: var(--text-muted);
    }
    
    /* Make the sidebar a flex container to push footer to bottom */
    .sidebar {
        display: flex;
        flex-direction: column;
    }
    
    /* Responsive adjustments */
    @media (max-width: 768px) {
        .scholapedia-logo {
            font-size: 0; /* Hide the text on small screens */
        }
        
        .scholapedia-logo::before {
            content: "S";
            font-size: 1.5rem;
            display: block;
        }
        
        .scholapedia-tagline {
            display: none;
        }
    }

</style>
</head>   
<body>
    <form id="form1" runat="server">
        <div class="dashboard-container">
            <!-- Sidebar -->
            <div class="sidebar">
    <div class="sidebar-header">
        <h3 class="admin-panel-title">Admin Panel</h3>
    </div>
    <div class="sidebar-menu">
        <a href="adminDashboard.aspx" class="cssbuttons-io">
            <span>
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z" fill="currentColor"></path></svg>
                Dashboard
            </span>
        </a>
        <a href="adminManageUsers.aspx" class="cssbuttons-io">
            <span>
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M16 17v2H2v-2s0-4 7-4 7 4 7 4zm-7-9a4 4 0 1 0 0-8 4 4 0 0 0 0 8zm8 0a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm0 2c-2.33 0-7 1.17-7 3.5V16h14v-2.5c0-2.33-4.67-3.5-7-3.5z" fill="currentColor"></path></svg>
                Manage Users
            </span>
        </a>
        <a href="adminManageCourses.aspx" class="cssbuttons-io">
            <span>
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M18 2H6c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zM6 4h5v8l-2.5-1.5L6 12V4z" fill="currentColor"></path></svg>
                Manage Courses
            </span>
        </a>
        <a href="adminManageForum.aspx" class="cssbuttons-io">
    <span>
        <svg xmlns="http://www.w3.org/2000/svg" class="icon" viewBox="0 0 24 24">
            <path fill="currentColor" d="M4 4h16v12H5.17L4 17.17V4m0-2a2 2 0 0 0-2 2v20l4-4h14a2 2 0 0 0 2-2V4a2 2 0 0 0-2-2H4z"/>
        </svg>
        Manage Forums
    </span>
</a>
        <a href="adminAnnouncements.aspx" class="cssbuttons-io active">
            <span>
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M20 2v3h-2v-.5c0-.28-.22-.5-.5-.5h-13c-.28 0-.5.22-.5.5V9h13.5c.28 0 .5.22.5.5v.5h2v3h-2v.5c0 .28-.22.5-.5.5H4v4.5c0 .28-.22.5-.5.5h-2C1.22 18 1 17.78 1 17.5v-13C1 3.67 1.67 3 2.5 3h9.69L20 2z" fill="currentColor"></path></svg>
                Announcement
            </span>
        </a>
        <a href="adminFeedback.aspx" class="cssbuttons-io">
            <span>
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm0 14H6l-2 2V4h16v12z" fill="currentColor"></path></svg>
                Feedback
            </span>
        </a>
        <a href="adminSettings.aspx" class="cssbuttons-io">
            <span>
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M19.14 12.94c.04-.3.06-.61.06-.94 0-.32-.02-.64-.07-.94l2.03-1.58c.18-.14.23-.41.12-.61l-1.92-3.32c-.12-.22-.37-.29-.59-.22l-2.39.96c-.5-.38-1.03-.7-1.62-.94l-.36-2.54c-.04-.24-.24-.41-.48-.41h-3.84c-.24 0-.43.17-.47.41l-.36 2.54c-.59.24-1.13.57-1.62.94l-2.39-.96c-.22-.08-.47 0-.59.22L2.74 8.87c-.12.21-.08.47.12.61l2.03 1.58c-.05.3-.09.63-.09.94s.02.64.07.94l-2.03 1.58c-.18.14-.23.41-.12.61l1.92 3.32c.12.22.37.29.59.22l2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.24.24.41.48.41h3.84c.24 0 .44-.17.47-.41l.36-2.54c.59-.24 1.13-.56 1.62-.94l2.39.96c.22.08.47 0 .59-.22l1.92-3.32c.12-.22.07-.47-.12-.61l-2.01-1.58zM12 15.6c-1.98 0-3.6-1.62-3.6-3.6s1.62-3.6 3.6-3.6 3.6 1.62 3.6 3.6-1.62 3.6-3.6 3.6z" fill="currentColor"></path></svg>
                Settings
            </span>
        </a>
    </div>
    <!-- Add the Scholapedia logo section at the bottom of the sidebar -->
    <div class="sidebar-footer">
        <div class="scholapedia-logo">scholapedia</div>
        <div class="scholapedia-tagline">E-Learning Platform</div>
    </div>
</div>

            <!-- Content Area -->
            <div class="content-area">
                <!-- Top Navigation -->
                <div class="top-nav">
                    <h1 class="page-title">Announcements</h1>
                    <div class="top-nav-actions">
                        
                        <div class="admin-info">
                            <div class="admin-avatar">
                                <asp:Literal ID="litAdminInitial" runat="server"></asp:Literal>
                            </div>
                            <div>
                                <div class="admin-name">
                                    <asp:Literal ID="litAdminName" runat="server"></asp:Literal>
                                </div>
                                <div class="admin-role">Administrator</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Section Description -->
                <p class="section-description">Create and manage announcements for your users.</p>

                <!-- Message Area (matching register pattern) -->
                <asp:Label ID="lblMessage" runat="server" CssClass="message-label" Visible="false"></asp:Label>

                <!-- Tab Navigation -->
                <ul class="nav nav-tabs" id="announcementTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="create-tab" data-bs-toggle="tab" data-bs-target="#create-tab-pane" type="button" role="tab">Create Announcement</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="history-tab" data-bs-toggle="tab" data-bs-target="#history-tab-pane" type="button" role="tab">Announcement History</button>
                    </li>
                </ul>

                <!-- Tab Content -->
                <div class="tab-content" id="announcementTabsContent">
                    <!-- Create Announcement Tab -->
                    <div class="tab-pane fade show active" id="create-tab-pane" role="tabpanel" aria-labelledby="create-tab" tabindex="0">
                        <div class="announcement-form-container">
                            <h2 class="announcement-title">New Announcement</h2>
                            <p class="announcement-subtitle">Create a new announcement to send to your users.</p>

                            <div class="form-group">
                                <label for="txtAnnouncementTitle" class="form-label">Title *</label>
                                <asp:TextBox ID="txtAnnouncementTitle" runat="server" CssClass="form-control" placeholder="Enter announcement title" MaxLength="200"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtAnnouncementTitle" 
                                    ErrorMessage="Title is required" Display="Dynamic" CssClass="validation-error" ValidationGroup="AnnouncementForm"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revTitleLength" runat="server" ControlToValidate="txtAnnouncementTitle"
                                    ErrorMessage="Title must be less than 200 characters" Display="Dynamic" CssClass="validation-error"
                                    ValidationExpression="^.{1,200}$" ValidationGroup="AnnouncementForm"></asp:RegularExpressionValidator>
                            </div>

                            <div class="form-group">
                                <label for="txtAnnouncementContent" class="form-label">Content *</label>
                                <asp:TextBox ID="txtAnnouncementContent" runat="server" CssClass="form-control" TextMode="MultiLine" 
                                    placeholder="Enter announcement content" Rows="6" MaxLength="2000"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvContent" runat="server" ControlToValidate="txtAnnouncementContent" 
                                    ErrorMessage="Content is required" Display="Dynamic" CssClass="validation-error" ValidationGroup="AnnouncementForm"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revContentLength" runat="server" ControlToValidate="txtAnnouncementContent"
                                    ErrorMessage="Content must be less than 2000 characters" Display="Dynamic" CssClass="validation-error"
                                    ValidationExpression="^[\s\S]{1,2000}$" ValidationGroup="AnnouncementForm"></asp:RegularExpressionValidator>
                                <small class="form-text text-muted">Maximum 2000 characters</small>
                            </div>

                            <div class="form-group">
                                <label for="ddlTargetAudience" class="form-label">Target Audience</label>
                                <asp:DropDownList ID="ddlTargetAudience" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="All Users" Value="All Users" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="Students Only" Value="Students Only"></asp:ListItem>
                                    <asp:ListItem Text="Lecturers Only" Value="Lecturers Only"></asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <div class="action-buttons">
                                <asp:Button ID="btnSendAnnouncement" runat="server" Text="Send Announcement" 
                                CssClass="button-name" OnClick="btnSendAnnouncement_Click" 
                                ValidationGroup="AnnouncementForm">
                                </asp:Button>
                            </div>

                            <!-- Summary of validation errors (matching register pattern) -->
                            <asp:ValidationSummary ID="vsAnnouncement" runat="server" ValidationGroup="AnnouncementForm" 
                                CssClass="validation-summary" DisplayMode="BulletList" ShowSummary="true" 
                                HeaderText="Please correct the following errors:" />
                        </div>
                    </div>

                    <!-- Announcement History Tab -->
                    <div class="tab-pane fade" id="history-tab-pane" role="tabpanel" aria-labelledby="history-tab" tabindex="0">
                        <div class="announcement-form-container">
                            <h2 class="announcement-title mb-4">Announcement History</h2>
                            
                            <asp:GridView ID="gvAnnouncementHistory" runat="server" AutoGenerateColumns="false" CssClass="history-table" 
                                OnRowCommand="gvAnnouncementHistory_RowCommand" DataKeyNames="AnnouncementID" Width="100%">
                                <Columns>
                                    <asp:TemplateField HeaderText="Title">
                                        <ItemTemplate>
                                            <span class="announcement-title-cell"><%# Eval("title") %></span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Created By">
                                        <ItemTemplate>
                                            <span class="admin-badge">Admin</span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Target">
                                        <ItemTemplate>
                                            <span class="target-badge"><%# Eval("target") %></span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Date">
                                        <ItemTemplate>
                                            <span class="time-cell"><%# Eval("time", "{0:MMM dd, yyyy hh:mm tt}") %></span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Actions" HeaderStyle-Width="150px">
                                        <ItemTemplate>
                                            <div class="actions-cell">
                                                <asp:LinkButton ID="btnView" runat="server" CssClass="action-button action-view" CommandName="ViewAnnouncement" CommandArgument='<%# Eval("AnnouncementID") %>'
                                                    ToolTip="View Announcement">
                                                    <i class="fas fa-eye"></i>
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="btnDelete" runat="server" CssClass="action-button action-delete" CommandName="DeleteAnnouncement" CommandArgument='<%# Eval("AnnouncementID") %>'
                                                    OnClientClick="return confirm('Are you sure you want to delete this announcement? This action cannot be undone.');"
                                                    ToolTip="Delete Announcement">
                                                    <i class="fas fa-trash-alt"></i>
                                                </asp:LinkButton>
                                            </div>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <div class="text-center p-4">
                                        <i class="fas fa-bullhorn fa-3x text-muted"></i>
                                        <p class="text-muted mt-3">No announcements found.</p>
                                        <p class="text-muted small">Create your first announcement using the "Create Announcement" tab.</p>
                                    </div>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            $(document).ready(function () {
                // Highlight current page button based on URL
                var currentUrl = window.location.href;
                var currentPage = window.location.pathname.split("/").pop();

                // If we're on a specific page, highlight that button
                if (currentPage && currentPage !== "") {
                    $(".cssbuttons-io").removeClass("active");
                    $(".cssbuttons-io[href='" + currentPage + "']").addClass("active");
                }
                // If we're on the root or default page, highlight dashboard
                else if (currentUrl.endsWith('/') ||
                    currentUrl.indexOf('Default') > -1 ||
                    currentPage === "") {
                    $(".cssbuttons-io").removeClass("active");
                    $(".cssbuttons-io[href='adminDashboard.aspx']").addClass("active");
                }

                // Tab persistence functionality
                // Save active tab when clicked
                $('button[data-bs-toggle="tab"]').on('click', function() {
                    var activeTab = $(this).attr('data-bs-target');
                    sessionStorage.setItem('activeAnnouncementTab', activeTab);
                });

                // Restore active tab on page load
                var savedTab = sessionStorage.getItem('activeAnnouncementTab');
                if (savedTab) {
                    // Remove active classes from all tabs
                    $('button[data-bs-toggle="tab"]').removeClass('active');
                    $('.tab-pane').removeClass('show active');
                    
                    // Activate the saved tab
                    $('button[data-bs-target="' + savedTab + '"]').addClass('active');
                    $(savedTab).addClass('show active');
                }

                // Character counter for textarea (matching modern patterns)
                $('#<%= txtAnnouncementContent.ClientID %>').on('input', function() {
                    var currentLength = $(this).val().length;
                    var maxLength = 2000;
                    var remaining = maxLength - currentLength;
                    
                    // Find or create counter element
                    var counter = $(this).siblings('.char-counter');
                    if (counter.length === 0) {
                        counter = $('<small class="form-text text-muted char-counter"></small>');
                        $(this).after(counter);
                    }
                    
                    counter.text(remaining + ' characters remaining');
                    
                    // Change color when approaching limit
                    if (remaining < 100) {
                        counter.addClass('text-warning').removeClass('text-muted text-danger');
                    } else if (remaining < 0) {
                        counter.addClass('text-danger').removeClass('text-muted text-warning');
                    } else {
                        counter.addClass('text-muted').removeClass('text-warning text-danger');
                    }
                });

                // Clear form validation on input (matching register pattern)
                $('#<%= txtAnnouncementTitle.ClientID %>, #<%= txtAnnouncementContent.ClientID %>').on('input', function() {
                    $(this).removeClass('is-invalid');
                    $(this).siblings('.validation-error').hide();
                });
            });
        </script>
    </form>
    <script>
        // Direct manual fix for announcement page elements
        function fixAnnouncementPageElements() {
            // Apply dark styles directly if in dark mode
            if (document.documentElement.getAttribute('data-theme') === 'dark') {
                // Fix form inputs
                document.querySelectorAll('input[type="text"], textarea, select').forEach(function (el) {
                    el.style.backgroundColor = '#2a2d31';
                    el.style.color = '#E9ECEF';
                    el.style.borderColor = '#3a3d41';
                });

                // Fix form container
                document.querySelectorAll('.announcement-form-container').forEach(function (el) {
                    el.style.backgroundColor = '#2a2d31';
                    el.style.boxShadow = '0px 0px 15px rgba(0, 0, 0, 0.3)';
                });

                // Fix tab navigation
                document.querySelectorAll('.nav-tabs').forEach(function (el) {
                    el.style.borderBottomColor = '#3a3d41';
                });

                document.querySelectorAll('.nav-tabs .nav-link').forEach(function (el) {
                    el.style.color = '#E9ECEF';
                });

                document.querySelectorAll('.nav-tabs .nav-link.active').forEach(function (el) {
                    el.style.color = '#9A7BCE';
                    el.style.borderBottomColor = '#9A7BCE';
                });

                // Fix buttons
                document.querySelectorAll('.btn-draft').forEach(function (el) {
                    el.style.backgroundColor = '#2a2d31';
                    el.style.color = '#E9ECEF';
                    el.style.borderColor = '#3a3d41';
                });

                document.querySelectorAll('.btn-send').forEach(function (el) {
                    el.style.backgroundColor = '#9A7BCE';
                    el.style.color = 'white';
                });

                // Fix table headers and cells
                document.querySelectorAll('.history-table th').forEach(function (el) {
                    el.style.backgroundColor = '#272b30';
                    el.style.color = '#E9ECEF';
                    el.style.borderBottomColor = '#3a3d41';
                });

                document.querySelectorAll('.history-table td').forEach(function (el) {
                    el.style.color = '#E9ECEF';
                    el.style.borderBottomColor = '#3a3d41';
                });

                // Fix badges
                document.querySelectorAll('.target-badge').forEach(function (el) {
                    el.style.backgroundColor = 'rgba(154, 123, 206, 0.3)';
                    el.style.color = '#c6b4e8';
                });

                // Fix action buttons
                document.querySelectorAll('.action-button').forEach(function (el) {
                    el.style.backgroundColor = '#3a3d41';
                });

                document.querySelectorAll('.action-button i').forEach(function (el) {
                    if (!el.classList.contains('fa-trash-alt')) {
                        el.style.color = '#ADB5BD';
                    }
                });
            }
        }

        // Run on page load
        document.addEventListener('DOMContentLoaded', function () {
            fixAnnouncementPageElements();

            // Also apply when switching tabs
            document.querySelectorAll('.nav-link').forEach(function (tab) {
                tab.addEventListener('click', function () {
                    setTimeout(fixAnnouncementPageElements, 100);
                });
            });

            // Set up observer to detect theme changes
            const observer = new MutationObserver(function (mutations) {
                mutations.forEach(function (mutation) {
                    if (mutation.attributeName === 'data-theme') {
                        fixAnnouncementPageElements();
                    }
                });
            });

            observer.observe(document.documentElement, { attributes: true });
        });

        // Add this to your existing document ready function
        $(document).ready(function () {
            // Your existing jQuery code...

            // Also make sure to fix elements after tab switch
            $('button[data-bs-toggle="tab"]').on('shown.bs.tab', function () {
                setTimeout(fixAnnouncementPageElements, 100);
            });
        });
    </script>
</body>
</html>