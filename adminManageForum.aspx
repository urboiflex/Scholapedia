<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="adminManageForum.aspx.cs" Inherits="WAPPSS.adminManageForum" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Forum Discussions - Admin Panel</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Font Awesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <!-- Theme CSS -->
    <link href="adminManageForum.css" rel="stylesheet" type="text/css" />
    <link href="theme-styles.css" rel="stylesheet" type="text/css" />
    <!-- Dashboard CSS -->
    <link href="adminDashboard2.css" rel="stylesheet" type="text/css" />
    <!-- Forum Discussion CSS -->
    
    <!-- Theme Switcher JS -->
    <script src="theme-switcher.js"></script>
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

        /* Loading spinner for filters */
        .loading-spinner {
            display: none;
            margin-left: 10px;
        }

        .search-filter-section {
            position: relative;
        }

        /* Enhanced filter styling */
        .search-filter-row {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
            margin-bottom: 20px;
        }

        .search-input, .filter-select {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }

        .search-input {
            flex: 1;
            min-width: 200px;
        }

        .filter-select {
            min-width: 150px;
        }

        .btn-refresh {
            padding: 8px 16px;
            background: #8e2de2;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .btn-refresh:hover {
            background: #7a25c4;
        }

        /* Results info */
        .results-info {
            margin: 10px 0;
            font-size: 0.9rem;
            color: #666;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true" />
        <div class="dashboard-container">
            <!-- Sidebar -->
            <div class="sidebar">
                <div class="sidebar-header">
                    <h3 class="admin-panel-title">Admin Panel</h3>
                </div>
                <div class="sidebar-menu">
                    <a href="adminDashboard.aspx" class="cssbuttons-io">
                        <span>
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="icon">
                                <path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z" fill="currentColor"></path>
                            </svg>
                            Dashboard
                        </span>
                    </a>
                    <a href="adminManageUsers.aspx" class="cssbuttons-io">
                        <span>
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="icon">
                                <path d="M16 17v2H2v-2s0-4 7-4 7 4 7 4zm-7-9a4 4 0 1 0 0-8 4 4 0 0 0 0 8zm8 0a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm0 2c-2.33 0-7 1.17-7 3.5V16h14v-2.5c0-2.33-4.67-3.5-7-3.5z" fill="currentColor"></path>
                            </svg>
                            Manage Users
                        </span>
                    </a>
                    <a href="adminManageCourses.aspx" class="cssbuttons-io">
                        <span>
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="icon">
                                <path d="M18 2H6c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zM6 4h5v8l-2.5-1.5L6 12V4z" fill="currentColor"></path>
                            </svg>
                            Manage Courses
                        </span>
                    </a>
                    <a href="adminManageForum.aspx" class="cssbuttons-io">
                        <span>
                            <svg xmlns="http://www.w3.org/2000/svg" class="icon" viewBox="0 0 24 24">
                                <path fill="currentColor" d="M4 4h16v12H5.17L4 17.17V4m0-2a2 2 0 0 0-2 2v20l4-4h14a2 2 0 0 0 2-2V4a2 2 0 0 0-2-2H4z" />
                            </svg>
                            Manage Forums
                        </span>
                    </a>
                   
                    <a href="adminAnnouncements.aspx" class="cssbuttons-io">
                        <span>
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="icon">
                                <path d="M20 2v3h-2v-.5c0-.28-.22-.5-.5-.5h-13c-.28 0-.5.22-.5.5V9h13.5c.28 0 .5.22.5.5v.5h2v3h-2v.5c0 .28-.22.5-.5.5H4v4.5c0 .28-.22.5-.5.5h-2C1.22 18 1 17.78 1 17.5v-13C1 3.67 1.67 3 2.5 3h9.69L20 2z" fill="currentColor"></path>
                            </svg>
                            Announcement
                        </span>
                    </a>
                    <a href="adminFeedback.aspx" class="cssbuttons-io">
                        <span>
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="icon">
                                <path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm0 14H6l-2 2V4h16v12z" fill="currentColor"></path>
                            </svg>
                            Feedback
                        </span>
                    </a>
                    <a href="adminSettings.aspx" class="cssbuttons-io">
                        <span>
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="icon">
                                <path d="M19.14 12.94c.04-.3.06-.61.06-.94 0-.32-.02-.64-.07-.94l2.03-1.58c.18-.14.23-.41.12-.61l-1.92-3.32c-.12-.22-.37-.29-.59-.22l-2.39.96c-.5-.38-1.03-.7-1.62-.94l-.36-2.54c-.04-.24-.24-.41-.48-.41h-3.84c-.24 0-.43.17-.47.41l-.36 2.54c-.59.24-1.13.57-1.62.94l-2.39-.96c-.22-.08-.47 0-.59.22L2.74 8.87c-.12.21-.08.47.12.61l2.03 1.58c-.05.3-.09.63-.09.94s.02.64.07.94l-2.03 1.58c-.18.14-.23.41-.12.61l1.92 3.32c.12.22.37.29.59.22l2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.24.24.41.48.41h3.84c.24 0 .44-.17.47-.41l.36-2.54c.59-.24 1.13-.56 1.62-.94l2.39.96c.22.08.47 0 .59-.22l1.92-3.32c.12-.22.07-.47-.12-.61l-2.01-1.58zM12 15.6c-1.98 0-3.6-1.62-3.6-3.6s1.62-3.6 3.6-3.6 3.6 1.62 3.6 3.6-1.62 3.6-3.6 3.6z" fill="currentColor"></path>
                            </svg>
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
                    <h1 class="page-title">Forum Discussions</h1>
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
                <p class="section-description">Monitor and moderate forum discussions, manage questions and replies across all subjects.</p>

                <!-- Message Area -->
                <asp:Label ID="lblMessage" runat="server" CssClass="message-label" Visible="false"></asp:Label>

                <!-- Discussion Statistics -->
                <div class="discussion-stats">
                    <div class="stat-item">
                        <div class="stat-number">
                            <asp:Literal ID="litTotalQuestions" runat="server">0</asp:Literal>
                        </div>
                        <div class="stat-label">Total Questions</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">
                            <asp:Literal ID="litTotalReplies" runat="server">0</asp:Literal>
                        </div>
                        <div class="stat-label">Total Replies</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">
                            <asp:Literal ID="litActiveSubjects" runat="server">0</asp:Literal>
                        </div>
                        <div class="stat-label">Active Subjects</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">
                            <asp:Literal ID="litTotalLikes" runat="server">0</asp:Literal>
                        </div>
                        <div class="stat-label">Total Likes</div>
                    </div>
                </div>

                <!-- Search and Filter Section with UpdatePanel for better UX -->
                <asp:UpdatePanel ID="upFilters" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <div class="search-filter-section">
                            <div class="search-filter-row">
                                <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" 
                                    placeholder="Search questions, content, or authors..." 
                                    AutoPostBack="true" OnTextChanged="txtSearch_TextChanged" />
                                <asp:DropDownList ID="ddlFilterSubject" runat="server" CssClass="filter-select"
                                    AutoPostBack="true" OnSelectedIndexChanged="ddlFilterSubject_SelectedIndexChanged">
                                    <asp:ListItem Text="All Subjects" Value=""></asp:ListItem>
                                </asp:DropDownList>
                                <asp:DropDownList ID="ddlFilterSort" runat="server" CssClass="filter-select"
                                    AutoPostBack="true" OnSelectedIndexChanged="ddlFilterSort_SelectedIndexChanged">
                                    <asp:ListItem Text="Latest Questions" Value="latest"></asp:ListItem>
                                    <asp:ListItem Text="Most Replies" Value="replies"></asp:ListItem>
                                    <asp:ListItem Text="Most Liked" Value="likes"></asp:ListItem>
                                    <asp:ListItem Text="Oldest Questions" Value="oldest"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:Button ID="btnRefresh" runat="server" Text="Refresh" CssClass="btn-refresh" OnClick="btnRefresh_Click" />
                                <div class="loading-spinner">
                                    <i class="fas fa-spinner fa-spin"></i>
                                </div>
                            </div>
                            <div class="results-info">
                                <span class="question-count">
                                    <asp:Literal ID="litQuestionCount" runat="server">0</asp:Literal> questions found
                                </span>
                                <span id="filterStatus" style="margin-left: 15px; font-style: italic;"></span>
                            </div>
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="txtSearch" EventName="TextChanged" />
                        <asp:AsyncPostBackTrigger ControlID="ddlFilterSubject" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="ddlFilterSort" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="btnRefresh" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>

                <!-- Questions List Section -->
                <asp:UpdatePanel ID="upQuestions" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <div class="discussion-container">
                            <div class="discussion-header">
                                <h2 class="discussion-title">Recent Questions & Discussions</h2>
                            </div>

                            <!-- Questions Repeater -->
                            <asp:Repeater ID="rptQuestions" runat="server" OnItemCommand="rptQuestions_ItemCommand">
                                <HeaderTemplate>
                                    <div class="questions-list">
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <div class="question-card" data-question-id='<%# Eval("QuestionID") %>'>
                                        <div class="question-header">
                                            <div class="question-meta">
                                                <span class="subject-badge" style="background-color: <%# GetSubjectColor(Container.DataItem) %>">
                                                    <%# Eval("SubjectName") ?? "General" %>
                                                </span>
                                                <span class="question-date">
                                                    <i class="fas fa-clock"></i>
                                                    <%# Eval("PostDate", "{0:MMM dd, yyyy HH:mm}") %>
                                                </span>
                                                <span class="question-author">
                                                    <i class="fas fa-user"></i>
                                                    <%# Eval("Username") ?? "Anonymous" %>
                                                </span>
                                            </div>
                                            <div class="question-actions">
                                                <asp:LinkButton ID="btnDeleteQuestion" runat="server" 
                                                    CssClass="btn-action btn-delete" 
                                                    CommandName="DeleteQuestion" 
                                                    CommandArgument='<%# Eval("QuestionID") %>'
                                                    OnClientClick="return confirm('Are you sure you want to delete this question and all its replies?');"
                                                    ToolTip="Delete Question">
                                                    <i class="fas fa-trash"></i>
                                                </asp:LinkButton>
                                            </div>
                                        </div>
                                        <div class="question-content">
                                            <h3 class="question-title"><%# Eval("Title") %></h3>
                                            <div class="question-text">
                                                <%# TruncateText(Eval("Content").ToString(), 200) %>
                                            </div>
                                        </div>
                                        <div class="question-footer">
                                            <div class="question-stats">
                                                <span class="stat-item">
                                                    <i class="fas fa-reply"></i>
                                                    <%# Eval("ReplyCount") %> replies
                                                </span>
                                                <span class="stat-item">
                                                    <i class="fas fa-heart"></i>
                                                    <%# Eval("TotalLikes") %> likes
                                                </span>
                                                <%# Convert.ToInt32(Eval("BestReplyCount")) > 0 ? 
                                                    "<span class=\"stat-item best-answer\"><i class=\"fas fa-check-circle\"></i> Has best answer</span>" : "" %>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </div>
                                </FooterTemplate>
                            </asp:Repeater>

                            <!-- Empty State -->
                            <asp:Panel ID="pnlEmptyState" runat="server" CssClass="empty-state" Visible="false">
                                <div class="empty-state-content">
                                    <i class="fas fa-comments fa-4x"></i>
                                    <h3>No Discussions Found</h3>
                                    <p>There are no forum discussions matching your current filters.</p>
                                    <asp:Button ID="btnClearFilters" runat="server" Text="Clear Filters" CssClass="btn-clear-filters" OnClick="btnClearFilters_Click" />
                                </div>
                            </asp:Panel>
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="txtSearch" EventName="TextChanged" />
                        <asp:AsyncPostBackTrigger ControlID="ddlFilterSubject" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="ddlFilterSort" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="btnRefresh" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="btnClearFilters" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>

                <!-- Recent Replies Section -->
                <div class="discussion-container">
                    <div class="discussion-header">
                        <h2 class="discussion-title">Recent Replies</h2>
                    </div>

                    <!-- Recent Replies Repeater -->
                    <asp:Repeater ID="rptRecentReplies" runat="server" OnItemCommand="rptRecentReplies_ItemCommand">
                        <HeaderTemplate>
                            <div class="replies-list">
                        </HeaderTemplate>
                        <ItemTemplate>
                            <div class="reply-card">
                                <div class="reply-header">
                                    <div class="reply-meta">
                                        <span class="reply-author">
                                            <i class="fas fa-user"></i>
                                            <%# Eval("RepliedBy") %>
                                        </span>
                                        <span class="reply-date">
                                            <i class="fas fa-clock"></i>
                                            <%# Eval("CreatedAt", "{0:MMM dd, yyyy HH:mm}") %>
                                        </span>
                                        <span class="reply-question">
                                            <i class="fas fa-question-circle"></i>
                                            <%# TruncateText(Eval("QuestionTitle").ToString(), 50) %>
                                        </span>
                                    </div>
                                    <div class="reply-actions">
                                        <%# Convert.ToBoolean(Eval("IsBest")) ? 
                                            "<span class=\"best-reply-badge\"><i class=\"fas fa-star\"></i> Best Answer</span>" : "" %>
                                        <asp:LinkButton ID="btnMarkBest" runat="server" 
                                            CssClass='<%# Convert.ToBoolean(Eval("IsBest")) ? "btn-action btn-unmark-best" : "btn-action btn-mark-best" %>' 
                                            CommandName="ToggleBest" 
                                            CommandArgument='<%# Eval("ReplyID") %>'
                                            ToolTip='<%# Convert.ToBoolean(Eval("IsBest")) ? "Unmark as Best Answer" : "Mark as Best Answer" %>'>
                                            <i class='<%# Convert.ToBoolean(Eval("IsBest")) ? "fas fa-star-half-alt" : "fas fa-star" %>'></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnDeleteReply" runat="server" 
                                            CssClass="btn-action btn-delete" 
                                            CommandName="DeleteReply" 
                                            CommandArgument='<%# Eval("ReplyID") %>'
                                            OnClientClick="return confirm('Are you sure you want to delete this reply?');"
                                            ToolTip="Delete Reply">
                                            <i class="fas fa-trash"></i>
                                        </asp:LinkButton>
                                    </div>
                                </div>
                                <div class="reply-content">
                                    <div class="reply-text">
                                        <%# TruncateText(Eval("ReplyText").ToString(), 150) %>
                                    </div>
                                </div>
                                <div class="reply-footer">
                                    <div class="reply-stats">
                                        <span class="stat-item">
                                            <i class="fas fa-heart"></i>
                                            <%# Eval("Likes") %> likes
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                        <FooterTemplate>
                            </div>
                        </FooterTemplate>
                    </asp:Repeater>
                </div>

                <!-- Subject Management Section -->
                <div class="discussion-container">
                    <div class="discussion-header">
                        <h2 class="discussion-title">Subject Management</h2>
                        
                    </div>

                    <!-- Add Subject Form -->
                    <asp:Panel ID="pnlAddSubject" runat="server" CssClass="add-subject-panel" Visible="false">
                        <div class="form-row">
                            <div class="form-group">
                                <asp:Label ID="lblSubjectName" runat="server" Text="Subject Name" CssClass="form-label"></asp:Label>
                                <asp:TextBox ID="txtSubjectName" runat="server" CssClass="form-control" placeholder="Enter subject name" MaxLength="100"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvSubjectName" runat="server" ControlToValidate="txtSubjectName"
                                    ErrorMessage="Subject name is required" Display="Dynamic" CssClass="validation-error" ValidationGroup="SubjectGroup"></asp:RequiredFieldValidator>
                            </div>
                            <div class="form-actions">
                                <asp:Button ID="btnSaveSubject" runat="server" Text="Save Subject" CssClass="btn-save-subject" OnClick="btnSaveSubject_Click" ValidationGroup="SubjectGroup" />
                                <asp:Button ID="btnCancelSubject" runat="server" Text="Cancel" CssClass="btn-cancel-subject" OnClick="btnCancelSubject_Click" />
                            </div>
                        </div>
                    </asp:Panel>

                    <!-- Subjects List -->
                    <div class="subjects-grid">
                        <asp:Repeater ID="rptSubjects" runat="server" OnItemCommand="rptSubjects_ItemCommand">
                            <ItemTemplate>
                                <div class="subject-card">
                                    <div class="subject-header">
                                        <h4 class="subject-name"><%# Eval("SubjectName") %></h4>
                                        <div class="subject-actions">
                                            <asp:LinkButton ID="btnDeleteSubject" runat="server" 
                                                CssClass="btn-action btn-delete" 
                                                CommandName="DeleteSubject" 
                                                CommandArgument='<%# Eval("SubjectID") %>'
                                                OnClientClick="return confirm('Are you sure you want to delete this subject? This may affect existing questions.');"
                                                ToolTip="Delete Subject">
                                                <i class="fas fa-trash"></i>
                                            </asp:LinkButton>
                                        </div>
                                    </div>
                                    <div class="subject-stats">
                                        <span class="subject-stat">
                                            <i class="fas fa-question-circle"></i>
                                            <%# Eval("QuestionCount") %> questions
                                        </span>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
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

                // Enhanced search with debouncing for better performance
                var searchTimeout;
                $('#<%= txtSearch.ClientID %>').on('input', function() {
                    clearTimeout(searchTimeout);
                    var searchBox = $(this);
                    
                    // Show loading indicator
                    $('.loading-spinner').show();
                    
                    // Debounce the search to avoid too many server calls
                    searchTimeout = setTimeout(function() {
                        updateFilterStatus();
                    }, 500);
                });

                // Update filter status display
                function updateFilterStatus() {
                    var searchText = $('#<%= txtSearch.ClientID %>').val();
                    var selectedSubject = $('#<%= ddlFilterSubject.ClientID %> option:selected').text();
                    var selectedSort = $('#<%= ddlFilterSort.ClientID %> option:selected').text();
                    
                    var statusParts = [];
                    
                    if (searchText && searchText.trim() !== '') {
                        statusParts.push('Search: "' + searchText.trim() + '"');
                    }
                    
                    if (selectedSubject && selectedSubject !== 'All Subjects') {
                        statusParts.push('Subject: ' + selectedSubject);
                    }
                    
                    if (selectedSort && selectedSort !== 'Latest Questions') {
                        statusParts.push('Sort: ' + selectedSort);
                    }
                    
                    var statusText = statusParts.length > 0 ? 'Filters: ' + statusParts.join(' | ') : '';
                    $('#filterStatus').text(statusText);
                }

                // Update status on page load
                updateFilterStatus();

                // Handle dropdown changes
                $('#<%= ddlFilterSubject.ClientID %>, #<%= ddlFilterSort.ClientID %>').on('change', function() {
                    $('.loading-spinner').show();
                    updateFilterStatus();
                });

                // Hide loading spinner when UpdatePanel finishes
                var prm = Sys.WebForms.PageRequestManager.getInstance();
                prm.add_endRequest(function (sender, e) {
                    $('.loading-spinner').hide();
                    updateFilterStatus();
                    
                    // Re-apply any client-side enhancements after partial postback
                    applyClientSideEnhancements();
                });

                prm.add_beginRequest(function (sender, e) {
                    $('.loading-spinner').show();
                });

                // Apply client-side enhancements
                function applyClientSideEnhancements() {
                    // Add hover effects to question cards
                    $('.question-card').hover(
                        function() { $(this).addClass('hover-effect'); },
                        function() { $(this).removeClass('hover-effect'); }
                    );
                    
                    // Add click-to-expand functionality for long content
                    $('.question-text, .reply-text').each(function() {
                        if ($(this).text().endsWith('...')) {
                            $(this).css('cursor', 'pointer').attr('title', 'Click to view full content');
                        }
                    });
                }

                // Initial application of enhancements
                applyClientSideEnhancements();

                // Auto-hide messages after 5 seconds
                setTimeout(function () {
                    $('.message-label').fadeOut('slow');
                }, 5000);

                // Add keyboard shortcuts
                $(document).keydown(function(e) {
                    // Ctrl+F or Cmd+F to focus search
                    if ((e.ctrlKey || e.metaKey) && e.keyCode === 70) {
                        e.preventDefault();
                        $('#<%= txtSearch.ClientID %>').focus();
                    }
                    
                    // Escape to clear search
                    if (e.keyCode === 27) {
                        $('#<%= txtSearch.ClientID %>').val('').trigger('input');
                    }
                });

                // Add visual feedback for actions
                $('.btn-action').on('click', function () {
                    $(this).addClass('processing');
                    setTimeout(function () {
                        $('.btn-action').removeClass('processing');
                    }, 2000);
                });
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