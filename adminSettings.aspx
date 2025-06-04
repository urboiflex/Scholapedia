<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="adminSettings.aspx.cs" Inherits="WAPPSS.adminSettings" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Settings - E-Learning Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Font Awesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <!-- Theme CSS -->
    <link href="theme-styles.css" rel="stylesheet" type="text/css" />
    <!-- Settings CSS -->
    <link href="adminSettings.css" rel="stylesheet" type="text/css" />
    <!-- Theme Switcher JS -->
    <script src="theme-switcher.js"></script>
</head>
<style>
    /* Direct fixes for sidebar buttons - exact match to dashboard CSS */
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
                <svg viewBox="0 0 24 24" width="1.2em" height="1.2em"><path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z" fill="currentColor"></path></svg>
                Dashboard
            </span>
        </a>
        <a href="adminManageUsers.aspx" class="cssbuttons-io">
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
        <a href="adminSettings.aspx" class="cssbuttons-io active">
            <span>
                <svg viewBox="0 0 24 24" width="1.2em" height="1.2em"><path d="M19.14 12.94c.04-.3.06-.61.06-.94 0-.32-.02-.64-.07-.94l2.03-1.58c.18-.14.23-.41.12-.61l-1.92-3.32c-.12-.22-.37-.29-.59-.22l-2.39.96c-.5-.38-1.03-.7-1.62-.94l-.36-2.54c-.04-.24-.24-.41-.48-.41h-3.84c-.24 0-.43.17-.47.41l-.36 2.54c-.59.24-1.13.57-1.62.94l-2.39-.96c-.22-.08-.47 0-.59.22L2.74 8.87c-.12.21-.08.47.12.61l2.03 1.58c-.05.3-.09.63-.09.94s.02.64.07.94l-2.03 1.58c-.18.14-.23.41-.12.61l1.92 3.32c.12.22.37.29.59.22l2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.24.24.41.48.41h3.84c.24 0 .44-.17.47-.41l.36-2.54c.59-.24 1.13-.56 1.62-.94l2.39.96c.22.08.47 0 .59-.22l1.92-3.32c.12-.22.07-.47-.12-.61l-2.01-1.58zM12 15.6c-1.98 0-3.6-1.62-3.6-3.6s1.62-3.6 3.6-3.6 3.6 1.62 3.6 3.6-1.62 3.6-3.6 3.6z" fill="currentColor"></path></svg>
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
                    <h1 class="page-title">Account Settings</h1>
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
                <p class="section-description">Manage your account settings and preferences.</p>

                <!-- Message Area (matching register pattern) -->
                <asp:Label ID="lblMessage" runat="server" CssClass="message-label" Visible="false"></asp:Label>

                <!-- UI Preferences Section -->
                <div class="settings-form-container">
                    <h2 class="settings-title">UI Preferences</h2>
                    <p class="settings-subtitle">Customize your user interface experience.</p>

                    <div class="form-group">
                        <div class="theme-toggle">
                            <span class="theme-toggle-label">Theme Mode:</span>
                            <div>
                                <label class="settings-theme-switch">
                                    <input type="checkbox" id="settingsThemeSwitcher">
                                    <span class="settings-theme-slider"></span>
                                </label>
                                <span class="theme-mode-text" id="themeModeText">Light Mode</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Account Settings Section -->
                <div class="settings-form-container">
                    <h2 class="settings-title">Profile Information</h2>
                    <p class="settings-subtitle">Update your account details.</p>

                    <div class="form-group">
                        <asp:Label ID="lblUsername" runat="server" Text="Username *" CssClass="form-label" AssociatedControlID="txtUsername"></asp:Label>
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Enter your username" MaxLength="50"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="txtUsername"
                            ErrorMessage="Username is required" Display="Dynamic" CssClass="validation-error" ValidationGroup="ProfileGroup"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revUsernameLength" runat="server" ControlToValidate="txtUsername"
                            ErrorMessage="Username must be between 3 and 50 characters" Display="Dynamic" CssClass="validation-error"
                            ValidationExpression="^.{3,50}$" ValidationGroup="ProfileGroup"></asp:RegularExpressionValidator>
                    </div>

                    <div class="text-end">
                        <asp:Button ID="btnUpdateProfile" runat="server" Text="Update Profile" CssClass="btn-update" 
                            OnClick="btnUpdateProfile_Click" ValidationGroup="ProfileGroup">
                        </asp:Button>
                    </div>

                    <!-- Profile Validation Summary -->
                    <asp:ValidationSummary ID="vsProfile" runat="server" ValidationGroup="ProfileGroup" 
                        CssClass="validation-summary" DisplayMode="BulletList" ShowSummary="true" 
                        HeaderText="Please correct the following errors:" />

                    <hr class="divider" />

                    <h2 class="settings-title">Change Password</h2>
                    <p class="settings-subtitle">Ensure your account is secure by using a strong password.</p>

                    <div class="form-group">
                        <asp:Label ID="lblCurrentPassword" runat="server" Text="Current Password *" CssClass="form-label" AssociatedControlID="txtCurrentPassword"></asp:Label>
                        <asp:TextBox ID="txtCurrentPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter your current password"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvCurrentPassword" runat="server" ControlToValidate="txtCurrentPassword"
                            ErrorMessage="Current password is required" Display="Dynamic" CssClass="validation-error" ValidationGroup="PasswordGroup"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <asp:Label ID="lblNewPassword" runat="server" Text="New Password *" CssClass="form-label" AssociatedControlID="txtNewPassword"></asp:Label>
                        <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter your new password"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvNewPassword" runat="server" ControlToValidate="txtNewPassword"
                            ErrorMessage="New password is required" Display="Dynamic" CssClass="validation-error" ValidationGroup="PasswordGroup"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revPasswordLength" runat="server" ControlToValidate="txtNewPassword"
                            ErrorMessage="Password must be at least 6 characters long" Display="Dynamic" CssClass="validation-error"
                            ValidationExpression="^.{6,}$" ValidationGroup="PasswordGroup"></asp:RegularExpressionValidator>
                        <small class="form-text text-muted">Minimum 6 characters</small>
                    </div>

                    <div class="form-group">
                        <asp:Label ID="lblConfirmPassword" runat="server" Text="Confirm Password *" CssClass="form-label" AssociatedControlID="txtConfirmPassword"></asp:Label>
                        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Confirm your new password"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword"
                            ErrorMessage="Confirm password is required" Display="Dynamic" CssClass="validation-error" ValidationGroup="PasswordGroup"></asp:RequiredFieldValidator>
                        <asp:CompareValidator ID="cvPassword" runat="server" ControlToValidate="txtConfirmPassword" ControlToCompare="txtNewPassword"
                            ErrorMessage="Passwords do not match" Display="Dynamic" CssClass="validation-error" ValidationGroup="PasswordGroup"></asp:CompareValidator>
                    </div>

                    <div class="text-end">
                        <asp:Button ID="btnChangePassword" runat="server" Text="Change Password" CssClass="btn-update" 
                            OnClick="btnChangePassword_Click" ValidationGroup="PasswordGroup">
                        </asp:Button>
                    </div>

                    <!-- Password Validation Summary -->
                    <asp:ValidationSummary ID="vsPassword" runat="server" ValidationGroup="PasswordGroup" 
                        CssClass="validation-summary" DisplayMode="BulletList" ShowSummary="true" 
                        HeaderText="Please correct the following errors:" />

                    <hr class="divider" />

                    <h2 class="settings-title">Account Actions</h2>
                    <p class="settings-subtitle">Log out of your account or perform other account-related actions.</p>

                    <div class="text-end">
                        <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-danger" 
                            OnClick="btnLogout_Click" OnClientClick="return confirm('Are you sure you want to log out?');">
                        </asp:Button>
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

                // Theme Switcher in Settings
                const settingsThemeSwitcher = document.getElementById('settingsThemeSwitcher');
                const themeModeText = document.getElementById('themeModeText');
                const sidebarThemeSwitcher = document.getElementById('themeSwitcher');

                // Initialize the settings switcher based on current theme
                const currentTheme = document.documentElement.getAttribute('data-theme');
                if (currentTheme === 'dark') {
                    settingsThemeSwitcher.checked = true;
                    themeModeText.textContent = 'Dark Mode';
                } else {
                    settingsThemeSwitcher.checked = false;
                    themeModeText.textContent = 'Light Mode';
                }

                // Sync the settings switcher with the theme
                settingsThemeSwitcher.addEventListener('change', function () {
                    if (this.checked) {
                        document.documentElement.setAttribute('data-theme', 'dark');
                        localStorage.setItem('theme', 'dark');
                        themeModeText.textContent = 'Dark Mode';
                        // Sync with sidebar switcher if it exists
                        if (sidebarThemeSwitcher) sidebarThemeSwitcher.checked = true;
                    } else {
                        document.documentElement.setAttribute('data-theme', 'light');
                        localStorage.setItem('theme', 'light');
                        themeModeText.textContent = 'Light Mode';
                        // Sync with sidebar switcher if it exists
                        if (sidebarThemeSwitcher) sidebarThemeSwitcher.checked = false;
                    }

                    // Apply theme to all elements after toggling
                    if (typeof applyThemeToElements === 'function') {
                        applyThemeToElements();
                    }

                    // Apply theme to dashboard components if on dashboard
                    if (typeof applyThemeToDashboardComponents === 'function') {
                        applyThemeToDashboardComponents();
                    }
                });

                // Clear form validation on input (matching register pattern)
                $('#<%= txtUsername.ClientID %>, #<%= txtCurrentPassword.ClientID %>, #<%= txtNewPassword.ClientID %>, #<%= txtConfirmPassword.ClientID %>').on('input', function() {
                    $(this).removeClass('is-invalid');
                    $(this).siblings('.validation-error').hide();
                });

                // Real-time password matching validation
                $('#<%= txtConfirmPassword.ClientID %>').on('input', function() {
                    var newPassword = $('#<%= txtNewPassword.ClientID %>').val();
                    var confirmPassword = $(this).val();
                    
                    if (confirmPassword && newPassword !== confirmPassword) {
                        $(this).addClass('is-invalid');
                    } else {
                        $(this).removeClass('is-invalid');
                    }
                });
            });
        </script>
    </form>
</body>
</html>