<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="adminDashboard.aspx.cs" Inherits="WAPPSS.adminDashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />

    <link href="adminDashboard2.css" rel="stylesheet" type="text/css" />
    <link href="theme-styles.css" rel="stylesheet" type="text/css" />
    <script src="theme-switcher.js"></script>
    
</head>
    <style>
        /* Extreme priority force for white text in sidebar buttons */
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

/* Import fancy fonts */
@import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@700&family=Orbitron:wght@700&display=swap');

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

    /* Dashboard Tables Styling */
    .dashboard-tables {
        display: grid;
        grid-template-columns: 1fr;
        gap: 30px;
        margin-top: 30px;
    }

    .dashboard-table-section {
        background-color: var(--card-bg-color);
        border-radius: 12px;
        padding: 25px;
        box-shadow: 0px 0px 15px var(--shadow-color);
    }

    .table-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
    }

    .table-title {
        font-size: 1.2rem;
        font-weight: 600;
        color: var(--text-color);
        margin: 0;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .table-title i {
        color: var(--light-purple);
        font-size: 1.1rem;
    }

    .view-all-link {
        color: var(--light-purple);
        font-weight: 500;
        text-decoration: none;
        font-size: 0.9rem;
        transition: all 0.2s ease;
    }

    .view-all-link:hover {
        text-decoration: underline;
    }

    /* Dashboard GridView Styling */
    .dashboard-grid {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0;
        background-color: var(--card-bg-color);
        border-radius: 8px;
        overflow: hidden;
    }

    .dashboard-grid th {
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

    .dashboard-grid td {
        padding: 12px 15px;
        border-bottom: 1px solid var(--border-color);
        vertical-align: middle;
        color: var(--text-color);
        font-size: 0.9rem;
    }

    .dashboard-grid tr:hover {
        background-color: var(--table-row-hover);
        transition: background-color 0.2s ease;
    }

    .dashboard-grid tr:last-child td {
        border-bottom: none;
    }

    /* User avatar in tables */
    .user-avatar {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        background-color: var(--light-purple);
        display: inline-flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 600;
        font-size: 0.8rem;
        margin-right: 10px;
    }

    .user-info {
        display: flex;
        align-items: center;
    }

    .username {
        font-weight: 600;
        color: var(--text-color);
    }

    /* Course thumbnail in tables */
    .course-thumbnail-small {
        width: 32px;
        height: 32px;
        object-fit: cover;
        border-radius: 6px;
        border: 1px solid var(--border-color);
        margin-right: 10px;
    }

    .course-info {
        display: flex;
        align-items: center;
    }

    .course-name {
        font-weight: 600;
        color: var(--text-color);
    }

    /* Feedback text styling */
    .feedback-text {
        max-width: 300px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        color: var(--text-muted);
    }

    /* Date styling */
    .date-text {
        color: var(--text-muted);
        font-size: 0.85rem;
    }

    /* Enrollment count styling */
    .enrollment-count {
        background-color: var(--light-purple);
        color: white;
        padding: 4px 12px;
        border-radius: 12px;
        font-size: 0.8rem;
        font-weight: 600;
    }

    /* Empty data styling */
    .empty-data {
        text-align: center;
        padding: 40px 20px;
        color: var(--text-muted);
    }

    .empty-data i {
        font-size: 2rem;
        margin-bottom: 10px;
        opacity: 0.3;
    }

    .empty-data p {
        font-size: 0.9rem;
        margin: 0;
    }

    /* Dark mode table styling */
    [data-theme="dark"] .dashboard-grid th {
        background-color: #161b22 !important;
        color: #E9ECEF !important;
    }

    [data-theme="dark"] .dashboard-grid tr:hover {
        background-color: rgba(154, 123, 206, 0.1);
    }

    [data-theme="dark"] .dashboard-grid td {
        color: #E9ECEF;
        border-color: #3a3d41;
    }

    [data-theme="dark"] .dashboard-table-section {
        background-color: #2a2d31;
    }

    /* Responsive design for tables */
    @media (max-width: 768px) {
        .dashboard-tables {
            grid-template-columns: 1fr;
        }
        
        .feedback-text {
            max-width: 150px;
        }
        
        .user-info, .course-info {
            flex-direction: column;
            align-items: flex-start;
            gap: 5px;
        }
        
        .user-avatar, .course-thumbnail-small {
            margin-right: 0;
            margin-bottom: 5px;
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
        <a href="adminDashboard.aspx" class="cssbuttons-io active">
            <span>
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="icon"><path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z" fill="currentColor"></path></svg>
                Dashboard
            </span>
        </a>
        <a href="adminManageUsers.aspx" class="cssbuttons-io">
            <span>
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="icon"><path d="M16 17v2H2v-2s0-4 7-4 7 4 7 4zm-7-9a4 4 0 1 0 0-8 4 4 0 0 0 0 8zm8 0a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm0 2c-2.33 0-7 1.17-7 3.5V16h14v-2.5c0-2.33-4.67-3.5-7-3.5z" fill="currentColor"></path></svg>
                Manage Users
            </span>
        </a>

        <a href="adminManageCourses.aspx" class="cssbuttons-io">
            <span>
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="icon"><path d="M18 2H6c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zM6 4h5v8l-2.5-1.5L6 12V4z" fill="currentColor"></path></svg>
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
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="icon"><path d="M20 2v3h-2v-.5c0-.28-.22-.5-.5-.5h-13c-.28 0-.5.22-.5.5V9h13.5c.28 0 .5.22.5.5v.5h2v3h-2v.5c0 .28-.22.5-.5.5H4v4.5c0 .28-.22.5-.5.5h-2C1.22 18 1 17.78 1 17.5v-13C1 3.67 1.67 3 2.5 3h9.69L20 2z" fill="currentColor"></path></svg>
               Announcement
            </span>
        </a>
        <a href="adminFeedback.aspx" class="cssbuttons-io">
            <span>
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="icon"><path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm0 14H6l-2 2V4h16v12z" fill="currentColor"></path></svg>
                Feedback
            </span>
        </a>
        <a href="adminSettings.aspx" class="cssbuttons-io">
            <span>
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="icon"><path d="M19.14 12.94c.04-.3.06-.61.06-.94 0-.32-.02-.64-.07-.94l2.03-1.58c.18-.14.23-.41.12-.61l-1.92-3.32c-.12-.22-.37-.29-.59-.22l-2.39.96c-.5-.38-1.03-.7-1.62-.94l-.36-2.54c-.04-.24-.24-.41-.48-.41h-3.84c-.24 0-.43.17-.47.41l-.36 2.54c-.59.24-1.13.57-1.62.94l-2.39-.96c-.22-.08-.47 0-.59.22L2.74 8.87c-.12.21-.08.47.12.61l2.03 1.58c-.05.3-.09.63-.09.94s.02.64.07.94l-2.03 1.58c-.18.14-.23.41-.12.61l1.92 3.32c.12.22.37.29.59.22l2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.24.24.41.48.41h3.84c.24 0 .44-.17.47-.41l.36-2.54c.59-.24 1.13-.56 1.62-.94l2.39.96c.22.08.47 0 .59-.22l1.92-3.32c.12-.22.07-.47-.12-.61l-2.01-1.58zM12 15.6c-1.98 0-3.6-1.62-3.6-3.6s1.62-3.6 3.6-3.6 3.6 1.62 3.6 3.6-1.62 3.6-3.6 3.6z" fill="currentColor"></path></svg>
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
                    <h1 class="page-title">Dashboard</h1>
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

                <!-- Dashboard Welcome Message -->
                <div class="welcome-message mb-4">
                    <p class="text-muted fs-5">Welcome to the Scholapedia Admin Dashboard.</p>
                </div>
                
                <!-- Dashboard Cards -->
                <div class="dashboard-cards">
                    <div class="dashboard-card">
                        <div class="card-header">
                            <span>Total Users</span>
                            <i class="fas fa-users text-muted"></i>
                        </div>
                        <div class="card-content">
                            <h3><asp:Literal ID="litTotalUsers" runat="server">0</asp:Literal></h3>
                            <p class="text-success">+100% from last week</p>
                        </div>
                    </div>
                    <div class="dashboard-card">
                        <div class="card-header">
                            <span>Active Courses</span>
                            <i class="fas fa-book text-muted"></i>
                        </div>
                        <div class="card-content">
                            <h3><asp:Literal ID="litTotalCourses" runat="server">0</asp:Literal></h3>
                            <p class="text-success">+2 new this week</p>
                        </div>
                    </div>
                    <div class="dashboard-card">
                        <div class="card-header">
                            <span>Announcements</span>
                            <i class="fas fa-bullhorn text-muted"></i>
                        </div>
                        <div class="card-content">
                            <h3><asp:Literal ID="litTotalAnnouncements" runat="server">0</asp:Literal></h3>
                            <p class="text-muted">Sent this month</p>
                        </div>
                    </div>
                    <div class="dashboard-card">
                        <div class="card-header">
                            <span>User Feedback</span>
                            <i class="fas fa-comment-alt text-muted"></i>
                        </div>
                        <div class="card-content">
                            <h3><asp:Literal ID="litTotalFeedback" runat="server">0</asp:Literal></h3>
                            <p class="text-muted">+7 new feedbacks this week</p>
                        </div>
                    </div>
                </div>

                <!-- Dashboard Tables -->
                <div class="dashboard-tables">
                    <!-- Recent Feedbacks Table -->
                    <div class="dashboard-table-section">
                        <div class="table-header">
                            <h2 class="table-title">
                                <i class="fas fa-comment-dots"></i>
                                Recent Feedbacks
                            </h2>
                            <a href="adminFeedback.aspx" class="view-all-link">View All</a>
                        </div>
                        <asp:GridView ID="gvRecentFeedbacks" runat="server" AutoGenerateColumns="false" CssClass="dashboard-grid">
                            <Columns>
                                <asp:TemplateField HeaderText="User">
                                    <ItemTemplate>
                                        <div class="user-info">
                                            <div class="user-avatar">
                                                <%# GetUserInitial(Eval("Username")) %>
                                            </div>
                                            <span class="username"><%# Eval("Username") %></span>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Feedback">
                                    <ItemTemplate>
                                        <div class="feedback-text" title='<%# Eval("FeedbackText") %>'>
                                            <%# TruncateText(Eval("FeedbackText").ToString(), 50) %>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Rating">
                                    <ItemTemplate>
                                        <%# GenerateStars(Convert.ToInt32(Eval("Rating"))) %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Date">
                                    <ItemTemplate>
                                        <span class="date-text"><%# FormatDateTime(Eval("SubmissionDate")) %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="empty-data">
                                    <i class="fas fa-comment-slash"></i>
                                    <p>No recent feedbacks found.</p>
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>

                    <!-- Recent Users Table -->
                    <div class="dashboard-table-section">
                        <div class="table-header">
                            <h2 class="table-title">
                                <i class="fas fa-user-plus"></i>
                                Recent Registrations
                            </h2>
                            <a href="adminManageUsers.aspx" class="view-all-link">View All</a>
                        </div>
                        <asp:GridView ID="gvRecentUsers" runat="server" AutoGenerateColumns="false" CssClass="dashboard-grid">
                            <Columns>
                                <asp:TemplateField HeaderText="User">
                                    <ItemTemplate>
                                        <div class="user-info">
                                            <div class="user-avatar">
                                                <%# GetUserInitial(Eval("Username")) %>
                                            </div>
                                            <span class="username"><%# Eval("Username") %></span>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Email" HeaderText="Email" />
                                <asp:TemplateField HeaderText="Registered">
                                    <ItemTemplate>
                                        <span class="date-text"><%# FormatDateTime(Eval("RegistrationDate")) %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Status" HeaderText="Status" />
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="empty-data">
                                    <i class="fas fa-user-slash"></i>
                                    <p>No recent users found.</p>
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>

                    <!-- Recent Courses Table -->
                    <div class="dashboard-table-section">
                        <div class="table-header">
                            <h2 class="table-title">
                                <i class="fas fa-clock"></i>
                                Recent Courses
                            </h2>
                            <a href="adminManageCourses.aspx" class="view-all-link">View All</a>
                        </div>
                        <asp:GridView ID="gvPopularCourses" runat="server" AutoGenerateColumns="false" CssClass="dashboard-grid">
                            <Columns>
                                <asp:TemplateField HeaderText="Course">
                                    <ItemTemplate>
                                        <div class="course-info">
                                            <asp:Image ID="imgCourse" runat="server" CssClass="course-thumbnail-small" 
                                                ImageUrl='<%# GetCourseImage(Eval("CoverImage")) %>' 
                                                AlternateText='<%# Eval("CourseName") %>' />
                                            <span class="course-name"><%# Eval("CourseName") %></span>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="CreatorUsername" HeaderText="Creator" />
                                <asp:TemplateField HeaderText="Course ID">
                                    <ItemTemplate>
                                        <span class="enrollment-count"><%# Eval("EnrollmentCount") %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="SkillLevel" HeaderText="Level" />
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="empty-data">
                                    <i class="fas fa-book-open"></i>
                                    <p>No courses found.</p>
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
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
            });

            function forceSidebarWhiteText() {
                // Run with a slight delay to let the DOM fully render
                setTimeout(function () {
                    // Get all sidebar buttons
                    var buttons = document.querySelectorAll('.sidebar-menu .cssbuttons-io');

                    // Force white text on all button components
                    buttons.forEach(function (button) {
                        // Direct inline style for the button text
                        var spans = button.querySelectorAll('span');
                        spans.forEach(function (span) {
                            span.style.setProperty('color', 'white', 'important');

                            // Also target any nested spans
                            var innerSpans = span.querySelectorAll('span');
                            innerSpans.forEach(function (innerSpan) {
                                innerSpan.style.setProperty('color', 'white', 'important');
                            });
                        });

                        // Handle SVG elements
                        var svgs = button.querySelectorAll('svg');
                        svgs.forEach(function (svg) {
                            svg.style.setProperty('color', 'white', 'important');
                            svg.style.setProperty('fill', 'white', 'important');

                            // Handle paths within SVGs
                            var paths = svg.querySelectorAll('path');
                            paths.forEach(function (path) {
                                path.style.setProperty('fill', 'currentColor', 'important');
                                path.setAttribute('fill', 'currentColor');
                            });
                        });
                    });
                }, 50);
            }

            // Run on page load
            document.addEventListener('DOMContentLoaded', forceSidebarWhiteText);

            // Also run on any theme changes
            var observer = new MutationObserver(function (mutations) {
                mutations.forEach(function (mutation) {
                    if (mutation.attributeName === 'data-theme') {
                        forceSidebarWhiteText();
                        // Run multiple times to ensure it sticks
                        setTimeout(forceSidebarWhiteText, 100);
                        setTimeout(forceSidebarWhiteText, 300);
                    }
                });
            });

            observer.observe(document.documentElement, { attributes: true });

            // Run immediately in case the page has already loaded
            forceSidebarWhiteText();
        </script>
    </form>
</body>
</html>