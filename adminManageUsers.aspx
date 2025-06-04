<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="adminManageUsers.aspx.cs" Inherits="WAPPSS.adminManageUsers" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Users - Admin Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <link href="adminManageUsers.css?v=123" rel="stylesheet" type="text/css" />
    <link href="theme-styles.css" rel="stylesheet" type="text/css" />
<!-- Theme Switcher JS -->
<script src="theme-switcher.js"></script>
</head>
    <style>
    /* Direct fixes for search bar and dropdowns visibility in dark mode */
    [data-theme="dark"] input[type="text"],
    [data-theme="dark"] input[type="search"],
    [data-theme="dark"] select {
        background-color: #2a2d31 !important; 
        color: #E9ECEF !important; 
    }
    
    [data-theme="dark"] #txtSearch,
    [data-theme="dark"] #ContentPlaceHolder1_txtSearch {
        background-color: #2a2d31 !important;
        color: #E9ECEF !important;
    }
    
    [data-theme="dark"] #ddlRoles,
    [data-theme="dark"] #ContentPlaceHolder1_ddlRoles,
    [data-theme="dark"] #ddlStatus,
    [data-theme="dark"] #ContentPlaceHolder1_ddlStatus {
        background-color: #2a2d31 !important;
        color: #E9ECEF !important;
    }

    /* Modal Styles */
    .user-modal {
        display: none;
        position: fixed;
        z-index: 9999;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        backdrop-filter: blur(4px);
    }

    .modal-content {
        background-color: var(--card-bg-color);
        margin: 5% auto;
        padding: 0;
        border-radius: 12px;
        width: 90%;
        max-width: 500px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        transform: scale(0.8);
        opacity: 0;
        transition: all 0.3s ease;
    }

    .user-modal.show .modal-content {
        transform: scale(1);
        opacity: 1;
    }

    .modal-header {
        padding: 25px 30px 20px;
        border-bottom: 1px solid var(--border-color);
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .modal-title {
        font-size: 1.4rem;
        font-weight: 600;
        color: var(--text-color);
        margin: 0;
    }

    .close-btn {
        background: none;
        border: none;
        font-size: 1.5rem;
        color: var(--text-muted);
        cursor: pointer;
        padding: 0;
        width: 30px;
        height: 30px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
        transition: all 0.3s ease;
    }

    .close-btn:hover {
        background-color: var(--hover-bg);
        color: var(--text-color);
    }

    .modal-body {
        padding: 20px 30px;
    }

    .user-profile-section {
        display: flex;
        align-items: center;
        margin-bottom: 25px;
        padding: 20px;
        background-color: var(--lighter-bg);
        border-radius: 10px;
    }

    .user-profile-avatar {
        width: 60px;
        height: 60px;
        border-radius: 50%;
        background: linear-gradient(135deg, #8e2de2, #4a00e0);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 1.5rem;
        font-weight: 600;
        margin-right: 20px;
    }

    .user-profile-info h3 {
        margin: 0 0 5px 0;
        color: var(--text-color);
        font-size: 1.2rem;
        font-weight: 600;
    }

    .user-profile-info p {
        margin: 0;
        color: var(--text-muted);
        font-size: 0.9rem;
    }

    .user-details-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
        margin-bottom: 25px;
    }

    .detail-item {
        background-color: var(--lighter-bg);
        padding: 15px;
        border-radius: 8px;
    }

    .detail-label {
        font-size: 0.8rem;
        font-weight: 500;
        color: var(--text-muted);
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin-bottom: 5px;
    }

    .detail-value {
        font-size: 1rem;
        font-weight: 500;
        color: var(--text-color);
        word-break: break-word;
    }

    /* Status badge in modal */
    .detail-value .status-badge {
        font-size: 0.85rem;
        padding: 4px 12px;
        border-radius: 20px;
        font-weight: 500;
    }

    .detail-value .status-active {
        background-color: rgba(40, 167, 69, 0.1);
        color: #28a745;
        border: 1px solid rgba(40, 167, 69, 0.2);
    }

    .modal-footer {
        padding: 20px 30px 25px;
        display: flex;
        justify-content: flex-end;
        gap: 15px;
        border-top: 1px solid var(--border-color);
    }

    .btn-secondary {
        background-color: var(--hover-bg);
        color: var(--text-color);
        border: 1px solid var(--border-color);
        padding: 10px 20px;
        border-radius: 8px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .btn-secondary:hover {
        background-color: var(--border-color);
    }

    .btn-danger {
        background-color: #dc3545;
        color: white;
        border: 1px solid #dc3545;
        padding: 10px 20px;
        border-radius: 8px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .btn-danger:hover {
        background-color: #c82333;
        border-color: #bd2130;
    }

    /* Loading state */
    .btn-danger.loading {
        opacity: 0.7;
        pointer-events: none;
    }

    .btn-danger.loading::after {
        content: "";
        display: inline-block;
        width: 12px;
        height: 12px;
        margin-left: 8px;
        border: 2px solid transparent;
        border-top: 2px solid white;
        border-radius: 50%;
        animation: spin 1s linear infinite;
    }

    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }

    /* Responsive modal */
    @media (max-width: 768px) {
        .modal-content {
            width: 95%;
            margin: 10% auto;
        }

        .user-details-grid {
            grid-template-columns: 1fr;
            gap: 15px;
        }

        .modal-header,
        .modal-body,
        .modal-footer {
            padding-left: 20px;
            padding-right: 20px;
        }
        
        .user-profile-section {
            flex-direction: column;
            text-align: center;
        }
        
        .user-profile-avatar {
            margin-right: 0;
            margin-bottom: 15px;
        }
    }

    /* All the existing styles from the original file... */
    .sidebar-menu {
        padding: 20px 0;
        display: flex;
        flex-direction: column;
        gap: 15px;
        align-items: center;
    }
    
    .cssbuttons-io {
        position: relative;
        font-family: inherit;
        font-weight: 500;
        font-size: 18px;
        letter-spacing: 0.05em;
        border-radius: 0.8em;
        cursor: pointer;
        border: none;
        background: linear-gradient(to right, #8e2de2, #4a00e0);
        color: ghostwhite !important;
        overflow: hidden;
        width: 90%;
        text-decoration: none;
        display: block;
    }

    .cssbuttons-io svg {
        width: 1.2em;
        height: 1.2em;
        margin-right: 0.5em;
    }

    .cssbuttons-io span {
        position: relative;
        z-index: 10;
        transition: color 0.4s;
        display: inline-flex;
        align-items: center;
        padding: 0.8em 1.2em 0.8em 1.05em;
        color: ghostwhite !important;
    }

    .cssbuttons-io::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        width: 120%;
        height: 100%;
        background: #000;
        z-index: 0;
        transform: skew(30deg);
        transition: transform 0.4s cubic-bezier(0.3, 1, 0.8, 1);
        left: -10%;
    }

    .cssbuttons-io:hover::before {
        transform: translate3d(100%, 0, 0);
    }
    
    .cssbuttons-io:active {
        transform: scale(0.95);
    }

    .cssbuttons-io.active {
        background: linear-gradient(to right, #b366ff, #7733ff);
        box-shadow: 0 0 15px rgba(142, 45, 226, 0.6);
    }

    .cssbuttons-io.active::before {
        background: #000;
        transform: translate3d(100%, 0, 0);
    }

    body .sidebar-menu .cssbuttons-io span,
    .sidebar-menu .cssbuttons-io span,
    .cssbuttons-io span {
        color: white !important;
    }
    
    .cssbuttons-io svg,
    .cssbuttons-io svg path {
        color: white !important;
        fill: white !important;
    }
    
    .cssbuttons-io span span {
        color: white !important;
    }
    
    .cssbuttons-io {
        background: linear-gradient(to right, #8e2de2, #4a00e0) !important;
    }
    
    .cssbuttons-io.active {
        background: linear-gradient(to right, #b366ff, #7733ff) !important;
    }
    
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
    
    .sidebar {
        display: flex;
        flex-direction: column;
    }
    
    @media (max-width: 768px) {
        .scholapedia-logo {
            font-size: 0;
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

    .users-table th {
    background-color: #161b22 !important; /* Dark for light theme */
    color: #E9ECEF !important;
    font-weight: 600;
    padding: 15px;
    text-align: left;
    border-bottom: 2px solid var(--border-color);
    font-size: 0.9rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

</style>
<body>
    <form id="form1" runat="server">
        <!-- Hidden fields for storing user data -->
        <asp:HiddenField ID="hdnSelectedUserId" runat="server" />
        <asp:HiddenField ID="hdnUserData" runat="server" />
        
        <div class="dashboard-container">
            <!-- Sidebar -->
            <div class="sidebar">
    <div class="sidebar-header">
        <h3 class="admin-panel-title">Admin Panel</h3>
    </div>
    <div class="sidebar-menu">
        <a href="adminDashboard.aspx" class="cssbuttons-io">
            <span>
                <svg viewBox="0 0 24 24" width="1.2em" height="1.2em"><path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z" fill="currentColor"></path></svg>
                Dashboard
            </span>
        </a>
        <a href="adminManageUsers.aspx" class="cssbuttons-io active">
            <span>
                <svg viewBox="0 0 24 24" width="1.2em" height="1.2em"><path d="M16 17v2H2v-2s0-4 7-4 7 4 7 4zm-7-9a4 4 0 1 0 0-8 4 4 0 0 0 0 8zm8 0a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm0 2c-2.33 0-7 1.17-7 3.5V16h14v-2.5c0-2.33-4.67-3.5-7-3.5z" fill="currentColor"></path></svg>
                Manage Users
            </span>
        </a>
        <a href="adminManageCourses.aspx" class="cssbuttons-io">
            <span>
                <svg viewBox="0 0 24 24" width="1.2em" height="1.2em"><path d="M18 2H6c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zM6 4h5v8l-2.5-1.5L6 12V4z" fill="currentColor"></path></svg>
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
        <a href="adminAnnouncements.aspx" class="cssbuttons-io">
            <span>
                <svg viewBox="0 0 24 24" width="1.2em" height="1.2em"><path d="M20 2v3h-2v-.5c0-.28-.22-.5-.5-.5h-13c-.28 0-.5.22-.5.5V9h13.5c.28 0 .5.22.5.5v.5h2v3h-2v.5c0 .28-.22.5-.5.5H4v4.5c0 .28-.22.5-.5.5h-2C1.22 18 1 17.78 1 17.5v-13C1 3.67 1.67 3 2.5 3h9.69L20 2z" fill="currentColor"></path></svg>
                Announcement
            </span>
        </a>
        <a href="adminFeedback.aspx" class="cssbuttons-io">
            <span>
                <svg viewBox="0 0 24 24" width="1.2em" height="1.2em"><path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm0 14H6l-2 2V4h16v12z" fill="currentColor"></path></svg>
                Feedback
            </span>
        </a>
        <a href="adminSettings.aspx" class="cssbuttons-io">
            <span>
                <svg viewBox="0 0 24 24" width="1.2em" height="1.2em"><path d="M19.14 12.94c.04-.3.06-.61.06-.94 0-.32-.02-.64-.07-.94l2.03-1.58c.18-.14.23-.41.12-.61l-1.92-3.32c-.12-.22-.37-.29-.59-.22l-2.39.96c-.5-.38-1.03-.7-1.62-.94l-.36-2.54c-.04-.24-.24-.41-.48-.41h-3.84c-.24 0-.43.17-.47.41l-.36 2.54c-.59.24-1.13.57-1.62.94l-2.39-.96c-.22-.08-.47 0-.59.22L2.74 8.87c-.12.21-.08.47.12.61l2.03 1.58c-.05.3-.09.63-.09.94s.02.64.07.94l-2.03 1.58c-.18.14-.23.41-.12.61l1.92 3.32c.12.22.37.29.59.22l2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.24.24.41.48.41h3.84c.24 0 .44-.17.47-.41l.36-2.54c.59-.24 1.13-.56 1.62-.94l2.39.96c.22.08.47 0 .59-.22l1.92-3.32c.12-.22.07-.47-.12-.61l-2.01-1.58zM12 15.6c-1.98 0-3.6-1.62-3.6-3.6s1.62-3.6 3.6-3.6 3.6 1.62 3.6 3.6-1.62 3.6-3.6 3.6z" fill="currentColor"></path></svg>
                Settings
            </span>
        </a>
    </div>
    <div class="sidebar-footer">
        <div class="scholapedia-logo">scholapedia</div>
        <div class="scholapedia-tagline">E-Learning Platform</div>
    </div>
</div>

            <!-- Content Area -->
<div class="content-area">
    <!-- Top Navigation -->
    <div class="top-nav">
        <h1 class="page-title">Users</h1>
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
                <p class="section-description">Manage and view all users on the platform.</p>

                <!-- Filter Controls -->
                <div class="filter-controls">
                    <div class="search-container">
                        <i class="fas fa-search"></i>
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search users..." OnTextChanged="txtSearch_TextChanged" AutoPostBack="true"></asp:TextBox>
                    </div>
                    <asp:DropDownList ID="ddlRoles" runat="server" CssClass="filter-dropdown" AutoPostBack="true" OnSelectedIndexChanged="ddlRoles_SelectedIndexChanged">
                        <asp:ListItem Text="All Roles" Value=""></asp:ListItem>
                        <asp:ListItem Text="Student" Value="student"></asp:ListItem>
                        <asp:ListItem Text="Teacher" Value="Teacher"></asp:ListItem>
                        <asp:ListItem Text="Admin" Value="admin"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="filter-dropdown" AutoPostBack="true" OnSelectedIndexChanged="ddlStatus_SelectedIndexChanged">
                        <asp:ListItem Text="All Statuses" Value=""></asp:ListItem>
                        <asp:ListItem Text="Active" Value="Active"></asp:ListItem>
                        <asp:ListItem Text="Inactive" Value="Inactive"></asp:ListItem>
                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:Button ID="btnAddUser" runat="server" Text="Add User" CssClass="add-button" OnClick="btnAddUser_Click" />
                </div>

                <!-- Users List -->
                <div class="users-section">
                    <div class="users-header">
                        <div>
                            <h2 class="users-title">Users</h2>
                            <p class="users-subtitle">
                                <asp:Literal ID="litUserCount" runat="server"></asp:Literal>
                            </p>
                        </div>
                        <asp:LinkButton ID="btnExport" runat="server" CssClass="export-button" OnClick="btnExport_Click">
                            <i class="fas fa-download"></i> Export
                        </asp:LinkButton>
                    </div>

                    <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="false" CssClass="users-table" 
                        OnRowCommand="gvUsers_RowCommand" OnRowDataBound="gvUsers_RowDataBound"
                        DataKeyNames="UserID" AllowPaging="true" PageSize="10" OnPageIndexChanging="gvUsers_PageIndexChanging">
                        <Columns>
                            <asp:TemplateField HeaderText="User">
                                <ItemTemplate>
                                    <div class="user-info">
                                        <div class="user-avatar"><%# GetUserInitials(Eval("Username"), Eval("FirstName"), Eval("LastName")) %></div>
                                        <div class="user-details">
                                            <div class="user-name"><%# GetUserDisplayName(Eval("Username"), Eval("FirstName"), Eval("LastName")) %></div>
                                            <div class="user-email"><%# Eval("Email") %></div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Role">
                                <ItemTemplate>
                                    <%# GetFormattedRole(Eval("Category").ToString()) %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <span class="status-badge <%# GetStatusClass(Eval("Category").ToString()) %>">
                                        <%# GetStatusText(Eval("Category").ToString()) %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Registered">
                                <ItemTemplate>
                                    <%# GetFormattedDate(Eval("DateRegistered")) %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Courses">
                                <ItemTemplate>
                                    <%# GetUserCourseCount(Eval("UserID").ToString()) %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Last Active">
                                <ItemTemplate>
                                    <%# GetLastActiveTime(Eval("UserID").ToString()) %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <div class="actions-cell">
                                        <asp:LinkButton ID="btnViewUser" runat="server" CssClass="action-button" CommandName="ViewUser" CommandArgument='<%# Eval("UserID") %>' ToolTip="View/Manage User">
                                            <i class="fas fa-ellipsis-v"></i>
                                        </asp:LinkButton>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="text-center p-4">
                                <p class="text-muted">No users found.</p>
                            </div>
                        </EmptyDataTemplate>
                        <PagerStyle CssClass="pagination-container" />
                    </asp:GridView>
                </div>
            </div>
        </div>

        <!-- User Modal -->
        <div id="userModal" class="user-modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title">User Details</h2>
                    <button type="button" class="close-btn" onclick="closeUserModal()">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                
                <div class="modal-body">
                    <div class="user-profile-section">
                        <div class="user-profile-avatar" id="modalUserAvatar">U</div>
                        <div class="user-profile-info">
                            <h3 id="modalUserName">User Name</h3>
                            <p id="modalUserEmail">user@email.com</p>
                        </div>
                    </div>
                    
                    <div class="user-details-grid">
                        <div class="detail-item">
                            <div class="detail-label">User ID</div>
                            <div class="detail-value" id="modalUserId">1</div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Username</div>
                            <div class="detail-value" id="modalUsername">username</div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Email Address</div>
                            <div class="detail-value" id="modalUserEmailDetail">user@email.com</div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">First Name</div>
                            <div class="detail-value" id="modalFirstName">John</div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Last Name</div>
                            <div class="detail-value" id="modalLastName">Doe</div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Role/Category</div>
                            <div class="detail-value" id="modalUserRole">Student</div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Date Registered</div>
                            <div class="detail-value" id="modalDateRegistered">Jan 01, 2024</div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Account Status</div>
                            <div class="detail-value" id="modalAccountStatus">
                                <span class="status-badge status-active">Active</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeUserModal()">Close</button>
                    <button type="button" class="btn-danger" id="btnDeleteUser" onclick="confirmDeleteUser()">
                        Delete User
                    </button>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            $(document).ready(function () {
                // Your existing jQuery code...
                $(".notification-bell").click(function (e) {
                    e.stopPropagation();
                    $(".notification-dropdown").toggleClass("show");
                });

                $(document).click(function () {
                    $(".notification-dropdown").removeClass("show");
                });

                var currentUrl = window.location.href;
                var currentPage = window.location.pathname.split("/").pop();

                if (currentPage && currentPage !== "") {
                    $(".cssbuttons-io").removeClass("active");
                    $(".cssbuttons-io[href='" + currentPage + "']").addClass("active");
                }
                else if (currentUrl.endsWith('/') ||
                    currentUrl.indexOf('Default') > -1 ||
                    currentPage === "") {
                    $(".cssbuttons-io").removeClass("active");
                    $(".cssbuttons-io[href='adminDashboard.aspx']").addClass("active");
                }
            });

            // Modal Functions
            function showUserModal() {
                const modal = document.getElementById('userModal');
                const userData = document.getElementById('<%= hdnUserData.ClientID %>').value;

                if (userData) {
                    const data = userData.split('|');
                    const userId = data[0];
                    const username = data[1];
                    const firstName = data[2];
                    const lastName = data[3];
                    const email = data[4];
                    const category = data[5];
                    const dateRegistered = data[6];

                    // Populate modal with complete user data
                    document.getElementById('modalUserId').textContent = userId || 'N/A';
                    document.getElementById('modalUsername').textContent = username || 'N/A';
                    document.getElementById('modalUserEmail').textContent = email || 'N/A';
                    document.getElementById('modalUserEmailDetail').textContent = email || 'N/A';
                    document.getElementById('modalFirstName').textContent = (firstName && firstName !== 'Unknown') ? firstName : 'Not provided';
                    document.getElementById('modalLastName').textContent = lastName || 'Not provided';
                    document.getElementById('modalDateRegistered').textContent = dateRegistered || 'N/A';

                    // Display name handling for updated database structure
                    let displayName = '';
                    if (firstName && lastName && firstName !== 'Unknown') {
                        displayName = firstName + ' ' + lastName;
                    } else if (firstName && firstName !== 'Unknown') {
                        displayName = firstName;
                    } else if (username) {
                        displayName = username;
                    } else {
                        displayName = 'Unknown User';
                    }
                    document.getElementById('modalUserName').textContent = displayName;

                    // User initials for avatar - handle "Unknown" default value
                    let initials = '';
                    if (firstName && lastName && firstName !== 'Unknown') {
                        initials = firstName[0] + lastName[0];
                    } else if (firstName && firstName !== 'Unknown') {
                        initials = firstName[0];
                    } else if (username) {
                        initials = username[0];
                    } else {
                        initials = 'U';
                    }
                    document.getElementById('modalUserAvatar').textContent = initials.toUpperCase();

                    // Format role
                    let formattedRole = '';
                    switch (category.toLowerCase()) {
                        case 'student':
                            formattedRole = 'Student';
                            break;
                        case 'teacher':
                            formattedRole = 'Teacher';
                            break;
                        case 'admin':
                            formattedRole = 'Administrator';
                            break;
                        default:
                            formattedRole = category.charAt(0).toUpperCase() + category.slice(1).toLowerCase();
                    }
                    document.getElementById('modalUserRole').textContent = formattedRole;

                    // Set account status (for now, all users are active)
                    document.getElementById('modalAccountStatus').innerHTML = '<span class="status-badge status-active">Active</span>';
                }

                modal.style.display = 'block';
                setTimeout(() => {
                    modal.classList.add('show');
                }, 10);
            }

            function closeUserModal() {
                const modal = document.getElementById('userModal');
                modal.classList.remove('show');
                setTimeout(() => {
                    modal.style.display = 'none';
                }, 300);
            }

            function confirmDeleteUser() {
                const userId = document.getElementById('<%= hdnSelectedUserId.ClientID %>').value;
                const userName = document.getElementById('modalUserName').textContent;

                if (confirm(`Are you sure you want to delete user "${userName}"? This action cannot be undone.`)) {
                    deleteUser(userId);
                }
            }

            function deleteUser(userId) {
                const deleteBtn = document.getElementById('btnDeleteUser');
                deleteBtn.classList.add('loading');
                deleteBtn.textContent = 'Deleting...';

                // Call the server-side delete method
                $.ajax({
                    type: "POST",
                    url: "adminManageUsers.aspx/DeleteUserById",
                    data: JSON.stringify({ userId: parseInt(userId) }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            alert("User deleted successfully!");
                            closeUserModal();
                            // Refresh the page to update the user list
                            window.location.reload();
                        } else {
                            alert("Error deleting user: " + response.d);
                        }
                    },
                    error: function (xhr, status, error) {
                        alert("Error deleting user: " + error);
                    },
                    complete: function () {
                        deleteBtn.classList.remove('loading');
                        deleteBtn.textContent = 'Delete User';
                    }
                });
            }

            // Close modal when clicking outside
            window.onclick = function (event) {
                const modal = document.getElementById('userModal');
                if (event.target === modal) {
                    closeUserModal();
                }
            }

            // Close modal with Escape key
            document.addEventListener('keydown', function (event) {
                if (event.key === 'Escape') {
                    closeUserModal();
                }
            });
        </script>
        
        <!-- Dark mode fix script -->
        <script>
            function fixUsersPageElements() {
                if (document.documentElement.getAttribute('data-theme') === 'dark') {
                    var searchInput = document.getElementById('txtSearch');
                    if (searchInput) {
                        searchInput.style.backgroundColor = '#2a2d31';
                        searchInput.style.color = '#E9ECEF';
                    }

                    var roleDropdown = document.getElementById('ddlRoles');
                    if (roleDropdown) {
                        roleDropdown.style.backgroundColor = '#2a2d31';
                        roleDropdown.style.color = '#E9ECEF';
                    }

                    var statusDropdown = document.getElementById('ddlStatus');
                    if (statusDropdown) {
                        statusDropdown.style.backgroundColor = '#2a2d31';
                        statusDropdown.style.color = '#E9ECEF';
                    }
                }
            }

            document.addEventListener('DOMContentLoaded', function () {
                fixUsersPageElements();
                setTimeout(fixUsersPageElements, 500);

                const observer = new MutationObserver(function (mutations) {
                    mutations.forEach(function (mutation) {
                        if (mutation.attributeName === 'data-theme') {
                            fixUsersPageElements();
                        }
                    });
                });

                observer.observe(document.documentElement, { attributes: true });
            });
        </script>
    </form>
</body>
</html>