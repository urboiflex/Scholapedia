<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="adminFeedback.aspx.cs" Inherits="WAPPSS.adminFeedback" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Feedback - Admin Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Font Awesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <link href="adminFeedback.css" rel="stylesheet" type="text/css" />
    <link href="theme-styles.css" rel="stylesheet" type="text/css" />
    <script src="theme-switcher.js"></script>
</head>
    <style>

        /* Theme-aware adminFeedback.css - Updated to match Courses design */

/* Dashboard container */
.dashboard-container {
    display: flex;
    min-height: 100vh;
}

/* Sidebar Styles */
.sidebar {
    width: 280px;
    background-color: var(--card-bg-color);
    box-shadow: 0px 0px 15px var(--shadow-color);
    height: 100vh;
    position: fixed;
    left: 0;
    top: 0;
    z-index: 1000;
    transition: all 0.3s ease;
}

.sidebar-header {
    padding: 25px 20px;
    border-bottom: 1px solid var(--border-color);
}

    .sidebar-header h3 {
        color: var(--light-purple);
        margin: 0;
        font-weight: 600;
        font-size: 1.5rem;
    }

.sidebar-menu {
    padding: 20px 0;
    display: flex;
    flex-direction: column;
    gap: 15px;
    align-items: center;
}

/* New Button Styles */
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
    color: ghostwhite;
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
    }

    .cssbuttons-io::before,
    .cssbuttons-io::after {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        z-index: 0;
    }

    .cssbuttons-io::before {
        content: "";
        background: #000;
        width: 120%;
        left: -10%;
        transform: skew(30deg);
        transition: transform 0.4s cubic-bezier(0.3, 1, 0.8, 1);
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

/* Content Area */
.content-area {
    flex: 1;
    margin-left: 280px;
    padding: 20px 30px;
    background-color: var(--bg-color);
    transition: all var(--transition-time) ease;
}

/* Top Navigation */
.top-nav {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 15px 0;
    margin-bottom: 25px;
    border-bottom: 1px solid var(--border-color);
}

.page-title {
    font-size: 1.8rem;
    font-weight: 600;
    color: var(--text-color);
    margin: 0;
}

.top-nav-actions {
    display: flex;
    align-items: center;
}

.admin-info {
    display: flex;
    align-items: center;
}

.admin-avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background-color: var(--light-purple);
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    margin-right: 12px;
    font-weight: 600;
}

.admin-name {
    font-weight: 600;
    color: var(--text-color);
}

.admin-role {
    font-size: 0.8rem;
    color: var(--text-muted);
}

/* Section Description */
.section-description {
    color: var(--text-muted);
    margin-bottom: 25px;
}

/* Feedback Container - Matching Courses Design */
.feedback-container {
    background-color: var(--card-bg-color);
    border-radius: 12px;
    padding: 25px;
    box-shadow: 0px 0px 15px var(--shadow-color);
    margin-bottom: 30px;
}

/* Filter Controls - Matching Courses Design */
.filter-container {
    display: flex;
    gap: 15px;
    margin-bottom: 25px;
    align-items: center;
}

/* Force all inputs and selects to use theme colors */
input, select, textarea, button {
    background-color: var(--input-bg) !important;
    color: var(--input-text) !important;
    border-color: var(--input-border) !important;
    transition: all 0.3s ease;
}

    input:focus, select:focus, textarea:focus {
        border-color: var(--input-focus-border) !important;
        box-shadow: 0 0 0 3px rgba(154, 123, 206, 0.25) !important;
    }

.search-box {
    flex: 1;
    padding: 12px 20px;
    background-color: var(--input-bg) !important;
    color: var(--input-text) !important;
    border: 1px solid var(--input-border);
    border-radius: 8px;
    font-size: 1rem;
    transition: all 0.3s ease;
}

    .search-box:focus {
        outline: none;
        border-color: var(--input-focus-border);
        box-shadow: 0 0 0 3px rgba(154, 123, 206, 0.25);
    }

.dropdown-filter {
    min-width: 150px;
    padding: 12px 20px;
    border: 1px solid var(--input-border);
    border-radius: 8px;
    font-size: 1rem;
    transition: all 0.3s ease;
    background-color: var(--input-bg);
    color: var(--input-text);
    cursor: pointer;
}

    .dropdown-filter:focus {
        outline: none;
        border-color: var(--input-focus-border);
        box-shadow: 0 0 0 3px rgba(154, 123, 206, 0.25);
    }

.search-btn {
    background-color: var(--light-purple) !important;
    color: white !important;
    border: none;
    border-radius: 8px;
    padding: 12px 25px;
    font-size: 1rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    gap: 10px;
}

    .search-btn:hover {
        background-color: var(--lighter-purple) !important;
        transform: translateY(-2px);
    }

/* Feedback Header - Matching Courses Design */
.feedback-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}

.feedback-title {
    font-size: 1.2rem;
    font-weight: 600;
    color: var(--text-color);
    margin: 0;
}

.feedback-count {
    font-size: 0.9rem;
    color: var(--text-muted);
    margin: 0;
}

/* UPDATED Feedback Table - Exact Match to Courses Design */
.feedback-table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0;
    background-color: var(--card-bg-color);
    border-radius: 8px;
    overflow: hidden;
}

    /* Table Headers - EXACT MATCH to Courses */
    .feedback-table th {
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

    /* Table Cells - EXACT MATCH to Courses */
    .feedback-table td {
        padding: 15px;
        border-bottom: 1px solid var(--border-color);
        vertical-align: middle;
        color: var(--text-color);
        font-size: 0.95rem;
    }

    /* Hover Effect - EXACT MATCH to Courses */
    .feedback-table tr:hover {
        background-color: var(--table-row-hover);
        transition: background-color 0.2s ease;
    }

    .feedback-table tr:last-child td {
        border-bottom: none;
    }

/* User Info Cell - Updated to Match Courses Style */
.user-info {
    display: flex;
    align-items: center;
    gap: 12px;
}

.user-icon {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background-color: var(--light-purple);
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-weight: 600;
    font-size: 1rem;
}

.user-details {
    display: flex;
    flex-direction: column;
}

.user-name {
    font-weight: 600;
    color: var(--text-color);
    margin-bottom: 2px;
    font-size: 0.95rem;
}

.user-email {
    font-size: 0.85rem;
    color: var(--text-muted);
}

/* Actions Cell - EXACT MATCH to Courses Design */
.actions-cell {
    display: flex;
    gap: 8px;
    justify-content: center;
}

/* Action Button - EXACT MATCH to Courses Design */
.view-btn, .action-button {
    width: 36px;
    height: 36px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    border-radius: 8px;
    background-color: #3a3d41; /* Dark grayish background like screenshot */
    border: 1px solid transparent;
    transition: all 0.2s ease;
    text-decoration: none;
    color: #9ca3af; /* Muted gray text color */
}

    .view-btn i {
        font-size: 1rem;
    }

    .view-btn:hover {
        background-color: rgba(23, 162, 184, 0.1); /* 10% opacity of teal */
        border-color: #17a2b8;
        color: #17a2b8;
        text-decoration: none;
    }

/* Empty Data Style */
.empty-data {
    text-align: center;
    padding: 60px 20px;
    color: var(--text-muted);
}

    .empty-data i {
        margin-bottom: 20px;
        opacity: 0.3;
    }

    .empty-data p {
        font-size: 1.1rem;
        margin: 0;
    }

/* Dark Mode Table Enhancements - EXACT MATCH to Courses */
[data-theme="dark"] .feedback-table th {
    background-color: #1a1d21 !important;
}

[data-theme="dark"] .feedback-table tr:hover {
    background-color: rgba(154, 123, 206, 0.1);
}

/* Pagination Style - EXACT MATCH to Courses */
.pagination-container {
    display: flex;
    justify-content: center;
    margin-top: 20px;
    gap: 5px;
}

    .pagination-container a,
    .pagination-container span {
        padding: 8px 12px;
        border: 1px solid var(--border-color);
        border-radius: 6px;
        color: var(--text-color);
        text-decoration: none;
        transition: all 0.2s ease;
    }

        .pagination-container a:hover {
            background-color: var(--light-purple);
            color: white;
            border-color: var(--light-purple);
        }

    .pagination-container span {
        background-color: var(--light-purple);
        color: white;
        border-color: var(--light-purple);
    }

/* Modal Styling - Updated to match theme */
.modal {
    display: none;
    position: fixed;
    z-index: 9999;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgba(0, 0, 0, 0.5);
    backdrop-filter: blur(4px);
}

.modal-content {
    background-color: var(--card-bg-color);
    margin: 5% auto;
    padding: 0;
    border-radius: 12px;
    width: 90%;
    max-width: 700px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
    position: relative;
    transform: scale(0.8);
    opacity: 0;
    transition: all 0.3s ease;
}

.modal.show .modal-content {
    transform: scale(1);
    opacity: 1;
}

.close-btn {
    position: absolute;
    top: 15px;
    right: 20px;
    font-size: 1.5rem;
    font-weight: 700;
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
    background: none;
    border: none;
}

    .close-btn:hover {
        background-color: var(--hover-bg);
        color: var(--text-color);
    }

.modal-header {
    padding: 25px 30px 20px;
    border-bottom: 1px solid var(--border-color);
    margin-bottom: 0;
}

.modal-title {
    font-size: 1.4rem;
    font-weight: 600;
    color: var(--text-color);
    margin: 0;
}

.modal-body {
    padding: 20px 30px 25px;
}

.detail-row {
    margin-bottom: 20px;
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

#feedbackContent {
    background-color: var(--lighter-bg);
    padding: 15px;
    border-radius: 8px;
    margin-top: 5px;
    white-space: pre-wrap;
    color: var(--text-color);
    font-size: 1rem;
    line-height: 1.5;
}

/* Fix for search placeholder text to ensure it's visible */
input::placeholder {
    color: var(--text-muted) !important;
    opacity: 0.7;
}

/* Direct fixes for search bar and dropdown visibility in dark mode */
html[data-theme="dark"] input[type="text"],
html[data-theme="dark"] input[type="search"],
html[data-theme="dark"] select {
    background-color: #2a2d31 !important;
    color: #E9ECEF !important;
}

html[data-theme="dark"] #txtSearch,
html[data-theme="dark"] #ContentPlaceHolder1_txtSearch {
    background-color: #2a2d31 !important;
    color: #E9ECEF !important;
}

html[data-theme="dark"] #ddlCategories,
html[data-theme="dark"] #ContentPlaceHolder1_ddlCategories {
    background-color: #2a2d31 !important;
    color: #E9ECEF !important;
}

/* Sidebar button fixes - ensure consistent styling */
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

.cssbuttons-io {
    background: linear-gradient(to right, #8e2de2, #4a00e0) !important;
}

    .cssbuttons-io.active {
        background: linear-gradient(to right, #b366ff, #7733ff) !important;
    }

/* Responsive Layout */
@media (max-width: 1200px) {
    .filter-container {
        flex-wrap: wrap;
    }

    .search-box {
        flex: 1 1 100%;
        margin-bottom: 15px;
    }
}

@media (max-width: 992px) {
    .filter-container {
        flex-direction: column;
        align-items: stretch;
    }

    .dropdown-filter, .search-btn {
        width: 100%;
    }
}

@media (max-width: 768px) {
    .sidebar {
        width: 80px;
    }

    .content-area {
        margin-left: 80px;
    }

    .feedback-table thead {
        display: none;
    }

    .feedback-table, .feedback-table tbody, .feedback-table tr, .feedback-table td {
        display: block;
        width: 100%;
    }

        .feedback-table tr {
            margin-bottom: 15px;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 15px;
        }

            .feedback-table tr:last-child {
                margin-bottom: 0;
                border-bottom: none;
                padding-bottom: 0;
            }

        .feedback-table td {
            border-bottom: none;
            padding: 8px 0;
            text-align: left;
            position: relative;
        }

    .actions-cell {
        text-align: center;
    }

    .modal-content {
        width: 95%;
        margin: 10% auto;
    }

    .modal-header,
    .modal-body {
        padding-left: 20px;
        padding-right: 20px;
    }

    .user-info {
        flex-direction: column;
        text-align: center;
        gap: 8px;
    }
}

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
    
    [data-theme="dark"] #ddlCategories,
    [data-theme="dark"] #ContentPlaceHolder1_ddlCategories {
        background-color: #2a2d31 !important;
        color: #E9ECEF !important;
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
        <a href="adminAnnouncements.aspx" class="cssbuttons-io">
            <span>
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M20 2v3h-2v-.5c0-.28-.22-.5-.5-.5h-13c-.28 0-.5.22-.5.5V9h13.5c.28 0 .5.22.5.5v.5h2v3h-2v.5c0 .28-.22.5-.5.5H4v4.5c0 .28-.22.5-.5.5h-2C1.22 18 1 17.78 1 17.5v-13C1 3.67 1.67 3 2.5 3h9.69L20 2z" fill="currentColor"></path></svg>
                Announcement
            </span>
        </a>
        <a href="adminFeedback.aspx" class="cssbuttons-io active">
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
                    <h1 class="page-title">Feedback</h1>
                    <div class="top-nav-actions">
                        <!-- Notification bell has been removed -->
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
                <p class="section-description">View and manage feedback from your users.</p>

                <!-- Feedback Container -->
                <div class="feedback-container">
                    <!-- Filter Controls -->
                    <div class="filter-container">
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="search-box" placeholder="Search feedback..."></asp:TextBox>
                        <asp:DropDownList ID="ddlCategories" runat="server" CssClass="dropdown-filter" AutoPostBack="true" OnSelectedIndexChanged="ddlCategories_SelectedIndexChanged">
                            <asp:ListItem Text="All Categories" Value=""></asp:ListItem>
                            <asp:ListItem Value="Bug Report">Bug Report</asp:ListItem>
<asp:ListItem Value="Feature Request">Feature Request</asp:ListItem>
<asp:ListItem Value="User Experience">User Experience</asp:ListItem>
<asp:ListItem Value="Performance">Performance</asp:ListItem>
<asp:ListItem Value="Content Quality">Content Quality</asp:ListItem>
<asp:ListItem Value="General Feedback">General Feedback</asp:ListItem>
<asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                        <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" CssClass="search-btn" />
                    </div>

                    <!-- Feedback List Header -->
                    <div class="feedback-header">
                        <h2 class="feedback-title">User Feedback</h2>
                        <div class="feedback-count">
                            <asp:Label ID="lblFeedbackCount" runat="server" Text=""></asp:Label>
                        </div>
                    </div>

                    <!-- Feedback Grid -->
                    <asp:GridView ID="gvFeedback" runat="server" AutoGenerateColumns="False" CssClass="feedback-table"
                        AllowPaging="True" PageSize="10" 
                        OnPageIndexChanging="gvFeedback_PageIndexChanging" OnRowCommand="gvFeedback_RowCommand">
                        <Columns>
                            <asp:TemplateField HeaderText="User">
                                <ItemTemplate>
                                    <div class="user-info">
                                        <div class="user-icon">
                                            <i class="fas fa-user"></i>
                                        </div>
                                        <div class="user-details">
                                            <div class="user-name"><%# Eval("UserName") %></div>
                                            <div class="user-email"><%# Eval("Email") %></div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Content">
                                <ItemTemplate>
                                    <div><%# TruncateContent(Eval("Content").ToString(), 100) %></div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Category" HeaderText="Category" />
                            <asp:BoundField DataField="From" HeaderText="From" />
                            <asp:BoundField DataField="FeedbackDate" HeaderText="Date" DataFormatString="{0:MMM dd, yyyy}" />
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <div class="actions-cell">
                                        <asp:LinkButton ID="lnkViewDetails" runat="server" CssClass="view-btn" 
                                            CommandName="ViewDetails" CommandArgument='<%# Eval("FeedbackId") %>' ToolTip="View Details">
                                            <i class="fas fa-eye"></i>
                                        </asp:LinkButton>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="text-center p-4">
                                <p class="text-muted">No feedback records found.</p>
                            </div>
                        </EmptyDataTemplate>
                        <PagerStyle CssClass="pagination-container" />
                    </asp:GridView>
                </div>
            </div>
        </div>

        <!-- Feedback Details Modal -->
        <div id="feedbackModal" class="modal">
            <div class="modal-content">
                <span class="close-btn" onclick="closeModal()">&times;</span>
                <div class="modal-header">
                    <h3 class="modal-title">Feedback Details</h3>
                </div>
                <div class="modal-body">
                    <div class="detail-row">
                        <div class="detail-label">From:</div>
                        <div class="detail-value" id="feedbackUser"></div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Category:</div>
                        <div class="detail-value" id="feedbackCategory"></div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Date:</div>
                        <div class="detail-value" id="feedbackDate"></div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Feedback:</div>
                        <div class="detail-value" id="feedbackContent"></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            $(document).ready(function () {
                // Notification bell code has been removed

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

            // Modal functions
            function showFeedbackDetails(user, category, date, content) {
                document.getElementById("feedbackUser").innerText = user;
                document.getElementById("feedbackCategory").innerText = category;
                document.getElementById("feedbackDate").innerText = date;
                document.getElementById("feedbackContent").innerText = content;
                const modal = document.getElementById("feedbackModal");
                modal.style.display = "block";
                setTimeout(() => {
                    modal.classList.add('show');
                }, 10);
            }

            function closeModal() {
                const modal = document.getElementById("feedbackModal");
                modal.classList.remove('show');
                setTimeout(() => {
                    modal.style.display = "none";
                }, 300);
            }

            // Close modal when clicking outside
            window.onclick = function (event) {
                var modal = document.getElementById("feedbackModal");
                if (event.target == modal) {
                    closeModal();
                }
            }

            // Close modal with Escape key
            document.addEventListener('keydown', function (event) {
                if (event.key === 'Escape') {
                    closeModal();
                }
            });
        </script>
    </form>
    <script>
        // Direct manual fix for search inputs
        function fixSearchInputs() {
            // Apply dark styles directly to search elements
            if (document.documentElement.getAttribute('data-theme') === 'dark') {
                // Try various ways to find the search input
                var searchInputs = document.querySelectorAll('input[type="text"], input[type="search"]');
                searchInputs.forEach(function (input) {
                    input.style.backgroundColor = '#2a2d31';
                    input.style.color = '#E9ECEF';
                });

                // Try to find selects/dropdowns
                var selects = document.querySelectorAll('select');
                selects.forEach(function (select) {
                    select.style.backgroundColor = '#2a2d31';
                    select.style.color = '#E9ECEF';
                });

                // Try by ID with various naming patterns
                var possibleSearchIds = ['txtSearch', 'ContentPlaceHolder1_txtSearch', 'MainContent_txtSearch'];
                possibleSearchIds.forEach(function (id) {
                    var el = document.getElementById(id);
                    if (el) {
                        el.style.backgroundColor = '#2a2d31';
                        el.style.color = '#E9ECEF';
                    }
                });

                var possibleDropdownIds = ['ddlCategories', 'ContentPlaceHolder1_ddlCategories', 'MainContent_ddlCategories'];
                possibleDropdownIds.forEach(function (id) {
                    var el = document.getElementById(id);
                    if (el) {
                        el.style.backgroundColor = '#2a2d31';
                        el.style.color = '#E9ECEF';
                    }
                });
            }
        }

        // Run this function on page load
        document.addEventListener('DOMContentLoaded', fixSearchInputs);

        // Also try to run it after a slight delay to ensure it catches dynamically loaded elements
        setTimeout(fixSearchInputs, 500);

        // And run it whenever the theme changes
        var origToggleTheme = toggleTheme;
        if (typeof toggleTheme === 'function') {
            toggleTheme = function () {
                origToggleTheme.apply(this, arguments);
                setTimeout(fixSearchInputs, 100);
            };
        }
    </script>
</body>
</html>