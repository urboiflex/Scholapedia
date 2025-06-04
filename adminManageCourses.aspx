<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="adminManageCourses.aspx.cs" Inherits="WAPPSS.adminManageCourses" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Courses - Admin Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Font Awesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    
    <link href="adminManageCourses.css" rel="stylesheet" type="text/css" />
    <link href="theme-styles.css" rel="stylesheet" type="text/css" />
<!-- Theme Switcher JS -->
<script src="theme-switcher.js"></script>
</head>
    <style>
    /* Direct fixes for search bar and dropdown visibility in dark mode */
    [data-theme="dark"] input[type="text"],
    [data-theme="dark"] input[type="search"],
    [data-theme="dark"] select {
        background-color: #2a2d31 !important; /* Hard-coded dark bg color */
        color: #E9ECEF !important; /* Hard-coded light text color */
    }
    
    /* Style search box and dropdown even if theme variables fail */
    [data-theme="dark"] #txtSearch,
    [data-theme="dark"] #ContentPlaceHolder1_txtSearch {
        background-color: #2a2d31 !important;
        color: #E9ECEF !important;
    }
    
    [data-theme="dark"] #ddlCreator,
    [data-theme="dark"] #ContentPlaceHolder1_ddlCreator {
        background-color: #2a2d31 !important;
        color: #E9ECEF !important;
    }
    
    /* Fix search container in dark mode */
    [data-theme="dark"] .search-container {
        background-color: #2a2d31;
        border-color: #3a3d41;
    }
    
    /* Fix for table in dark mode */
    [data-theme="dark"] .courses-section {
        background-color: #2a2d31;
    }
    
    [data-theme="dark"] .courses-table th,
    [data-theme="dark"] .courses-table td {
        color: #E9ECEF;
        border-color: #3a3d41;
    }

    [data-theme="dark"] .export-button,
    [data-theme="dark"] #btnExport,
    [data-theme="dark"] #ContentPlaceHolder1_btnExport,
    [data-theme="dark"] #MainContent_btnExport,
    [data-theme="dark"] a[id*="Export"] {
        background-color: #2a2d31 !important;
        color: #9A7BCE !important;
        border-color: #3a3d41 !important;
    }
    
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

    .courses-table th {
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
        <a href="adminManageCourses.aspx" class="cssbuttons-io active">
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
                    <h1 class="page-title">Courses</h1>
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
                <p class="section-description">Manage and view all courses on the platform.</p>

                <!-- Filter Controls -->
                <div class="filter-controls">
                    <div class="search-container">
                        <i class="fas fa-search"></i>
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search courses..." OnTextChanged="txtSearch_TextChanged" AutoPostBack="true"></asp:TextBox>
                    </div>
                    <asp:DropDownList ID="ddlCreator" runat="server" CssClass="filter-dropdown" AutoPostBack="true" OnSelectedIndexChanged="ddlCreator_SelectedIndexChanged">
                        <asp:ListItem Text="All Creators" Value=""></asp:ListItem>
                    </asp:DropDownList>
                    <asp:Button ID="btnAddCourse" runat="server" Text="Add Course" CssClass="add-button" OnClick="btnAddCourse_Click" />
                </div>

                <!-- Courses List -->
                <div class="courses-section">
                    <div class="courses-header">
                        <div>
                            <h2 class="courses-title">Courses</h2>
                            <p class="courses-subtitle">
                                <asp:Literal ID="litCourseCount" runat="server"></asp:Literal>
                            </p>
                        </div>
                        <asp:LinkButton ID="btnExport" runat="server" CssClass="export-button" OnClick="btnExport_Click">
                            <i class="fas fa-download"></i> Export
                        </asp:LinkButton>
                    </div>

                    <asp:GridView ID="gvCourses" runat="server" AutoGenerateColumns="false" CssClass="courses-table" 
    OnRowCommand="gvCourses_RowCommand" OnRowDataBound="gvCourses_RowDataBound"
    DataKeyNames="CourseID" AllowPaging="true" PageSize="10" OnPageIndexChanging="gvCourses_PageIndexChanging">
    <Columns>
        <asp:TemplateField HeaderText="Course Name">
            <ItemTemplate>
                <div class="course-name-cell">
                    <asp:Image ID="imgCourse" runat="server" CssClass="course-thumbnail" 
                        ImageUrl='<%# GetCourseImage(Eval("CoverImage")) %>' 
                        AlternateText='<%# Eval("CourseName") %>' />
                    <span class="course-title"><%# Eval("CourseName") %></span>
                </div>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:BoundField DataField="ModuleType" HeaderText="Module Type" />
        <asp:BoundField DataField="Duration" HeaderText="Duration" />
        <asp:BoundField DataField="SkillLevel" HeaderText="Skill Level" />
        <asp:BoundField DataField="Language" HeaderText="Language" />
        <asp:TemplateField HeaderText="Published">
            <ItemTemplate>
                <%# FormatPublishDate(Eval("PublishDate"), Eval("PublishTime")) %>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Actions" HeaderStyle-Width="150px">
            <ItemTemplate>
                <div class="actions-cell">
                    <asp:LinkButton ID="btnView" runat="server" CssClass="action-button action-view" 
                        CommandName="ViewCourse" CommandArgument='<%# Eval("CourseID") %>' 
                        ToolTip="View Course">
                        <i class="fas fa-eye"></i>
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnEdit" runat="server" CssClass="action-button action-edit" 
                        CommandName="EditCourse" CommandArgument='<%# Eval("CourseID") %>' 
                        ToolTip="Edit Course">
                        <i class="fas fa-pencil-alt"></i>
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnDelete" runat="server" CssClass="action-button action-delete" 
                        CommandName="DeleteCourse" CommandArgument='<%# Eval("CourseID") %>' 
                        ToolTip="Delete Course" 
                        OnClientClick="return confirm('Are you sure you want to delete this course?');">
                        <i class="fas fa-trash-alt"></i>
                    </asp:LinkButton>
                </div>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
    <EmptyDataTemplate>
        <div class="empty-data">
            <i class="fas fa-inbox fa-3x"></i>
            <p>No courses found.</p>
        </div>
    </EmptyDataTemplate>
    <PagerStyle CssClass="pagination-container" />
</asp:GridView>
                </div>
            </div>
        </div>

        <!-- View Course Modal -->
        <div class="modal fade" id="viewCourseModal" tabindex="-1" aria-labelledby="viewCourseModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="viewCourseModalLabel">Course Details</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-4">
                                <asp:Image ID="imgViewCourse" runat="server" CssClass="img-fluid rounded" />
                            </div>
                            <div class="col-md-8">
                                <h4><asp:Literal ID="litViewCourseName" runat="server"></asp:Literal></h4>
                                <hr />
                                <div class="row mb-2">
                                    <div class="col-sm-4"><strong>Module Type:</strong></div>
                                    <div class="col-sm-8"><asp:Literal ID="litViewModuleType" runat="server"></asp:Literal></div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4"><strong>Duration:</strong></div>
                                    <div class="col-sm-8"><asp:Literal ID="litViewDuration" runat="server"></asp:Literal></div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4"><strong>Skill Level:</strong></div>
                                    <div class="col-sm-8"><asp:Literal ID="litViewSkillLevel" runat="server"></asp:Literal></div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4"><strong>Language:</strong></div>
                                    <div class="col-sm-8"><asp:Literal ID="litViewLanguage" runat="server"></asp:Literal></div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4"><strong>Published:</strong></div>
                                    <div class="col-sm-8"><asp:Literal ID="litViewPublished" runat="server"></asp:Literal></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Edit Course Modal -->
        <div class="modal fade" id="editCourseModal" tabindex="-1" aria-labelledby="editCourseModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editCourseModalLabel">Edit Course</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <asp:HiddenField ID="hdnEditCourseId" runat="server" />
                        <div class="row">
                            <div class="col-md-4">
                                <asp:Image ID="imgEditCourse" runat="server" CssClass="img-fluid rounded mb-3" />
                                <div class="mb-3">
                                    <label class="form-label">Course Image</label>
                                    <asp:FileUpload ID="fuEditCourseImage" runat="server" CssClass="form-control" />
                                </div>
                            </div>
                            <div class="col-md-8">
                                <div class="mb-3">
                                    <label class="form-label">Course Name</label>
                                    <asp:TextBox ID="txtEditCourseName" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Module Type</label>
                                    <asp:DropDownList ID="ddlEditModuleType" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Video" Value="Video"></asp:ListItem>
                                        <asp:ListItem Text="Document" Value="Document"></asp:ListItem>
                                        <asp:ListItem Text="Interactive" Value="Interactive"></asp:ListItem>
                                        <asp:ListItem Text="Quiz" Value="Quiz"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Duration</label>
                                    <asp:TextBox ID="txtEditDuration" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Skill Level</label>
                                    <asp:DropDownList ID="ddlEditSkillLevel" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Beginner" Value="Beginner"></asp:ListItem>
                                        <asp:ListItem Text="Intermediate" Value="Intermediate"></asp:ListItem>
                                        <asp:ListItem Text="Advanced" Value="Advanced"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Language</label>
                                    <asp:DropDownList ID="ddlEditLanguage" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="English" Value="English"></asp:ListItem>
                                        <asp:ListItem Text="Japanese" Value="Japanese"></asp:ListItem>
                                        <asp:ListItem Text="Chinese" Value="Chinese"></asp:ListItem>
                                        <asp:ListItem Text="Spanish" Value="Spanish"></asp:ListItem>
                                        <asp:ListItem Text="French" Value="French"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <asp:Button ID="btnSaveChanges" runat="server" Text="Save Changes" CssClass="btn btn-primary" OnClick="btnSaveChanges_Click" />
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
        </script>
    </form>
    <script>
        // Direct manual fix for search inputs and tables
        function fixCoursePageElements() {
            // Apply dark styles directly to search elements
            if (document.documentElement.getAttribute('data-theme') === 'dark') {
                // Fix search input
                var searchInput = document.getElementById('txtSearch');
                if (searchInput) {
                    searchInput.style.backgroundColor = '#2a2d31';
                    searchInput.style.color = '#E9ECEF';
                }

                // Fix dropdown
                var creatorDropdown = document.getElementById('ddlCreator');
                if (creatorDropdown) {
                    creatorDropdown.style.backgroundColor = '#2a2d31';
                    creatorDropdown.style.color = '#E9ECEF';
                }

                // Fix search container
                var searchContainer = document.querySelector('.search-container');
                if (searchContainer) {
                    searchContainer.style.backgroundColor = '#2a2d31';
                    searchContainer.style.borderColor = '#3a3d41';
                }

                // Fix courses section
                var coursesSection = document.querySelector('.courses-section');
                if (coursesSection) {
                    coursesSection.style.backgroundColor = '#2a2d31';
                }

                // Fix table headers and cells
                document.querySelectorAll('.courses-table th, .courses-table td').forEach(function (el) {
                    el.style.borderColor = '#3a3d41';
                    el.style.color = '#E9ECEF';
                });

                // Fix course titles and creator names
                document.querySelectorAll('.course-title, .creator-name').forEach(function (el) {
                    el.style.color = '#E9ECEF';
                });
            }
        }

        // Run on page load
        document.addEventListener('DOMContentLoaded', function () {
            fixCoursePageElements();

            // Also try after a slight delay for dynamic elements
            setTimeout(fixCoursePageElements, 500);
        });

        // Add this to the existing document ready function in your adminManageCourses.aspx
        $(document).ready(function () {
            // Your existing jQuery code is here...

            // Add observer for theme changes
            const observer = new MutationObserver(function (mutations) {
                mutations.forEach(function (mutation) {
                    if (mutation.attributeName === 'data-theme') {
                        fixCoursePageElements();
                    }
                });
            });

            observer.observe(document.documentElement, { attributes: true });
        });

        function fixExportButton() {
            if (document.documentElement.getAttribute('data-theme') === 'dark') {
                // Try all possible export button selectors
                var exportSelectors = [
                    '#btnExport',
                    '.export-button',
                    '#ContentPlaceHolder1_btnExport',
                    '#MainContent_btnExport',
                    'a[id*="Export"]',
                    'a[id*="export"]',
                    '[class*="export"]'
                ];

                exportSelectors.forEach(function (selector) {
                    var elements = document.querySelectorAll(selector);
                    elements.forEach(function (el) {
                        el.style.backgroundColor = '#2a2d31';
                        el.style.color = '#9A7BCE';
                        el.style.borderColor = '#3a3d41';
                    });
                });
            }
        }

        // Run immediately and on every theme change
        document.addEventListener('DOMContentLoaded', function () {
            fixExportButton();

            // Set up observer to detect theme changes
            var observer = new MutationObserver(function (mutations) {
                mutations.forEach(function (mutation) {
                    if (mutation.attributeName === 'data-theme') {
                        fixExportButton();
                    }
                });
            });

            observer.observe(document.documentElement, { attributes: true });

            // Also run after a slight delay for buttons that might load dynamically
            setTimeout(fixExportButton, 300);
        });
    </script>
</body>
</html>