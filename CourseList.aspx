<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CourseList.aspx.cs" Inherits="WAPPSS.CourseList" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Course List</title>
    <!-- Google Fonts and Icons -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Bungee&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            font-family: 'Nunito', 'Roboto', sans-serif;
            background-color: #f0f2f5;
            margin: 0;
            padding: 40px;
            color: #333;
            transition: background-color 0.4s;
        }
        .container {
            max-width: 1200px;
            margin: 120px auto 0 auto;
            background: rgba(255,255,255,0.87); /* More transparent white */
            padding: 40px;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.10);
            transition: background 0.4s;
        }
        h2 {
            color: #3c40c1;
            font-size: 2.4rem;
            font-weight: 800;
            margin-bottom: 30px;
            border-bottom: 3px solid #3498db;
            padding-bottom: 15px;
            letter-spacing: 1px;
            transition: color 0.4s;
        }
        /* Add Course Button */
        .btn-add {
            background-color: #3498db;
            color: white;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: background-color 0.3s;
            display: inline-block;
            margin-bottom: 30px;
            font-size: 18px;
        }
        .btn-add:hover {
            background-color: #2980b9;
        }
        /* Back to Home Button */
        .btn-back-home {
            background-color: #6c5ce7;
            color: #fff;
            padding: 12px 28px;
            border-radius: 8px;
            font-weight: 700;
            font-size: 18px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 12px;
            box-shadow: 0 4px 18px rgba(108,92,231, 0.06);
            border: none;
            transition: background 0.3s, transform 0.2s;
            margin-bottom: 34px;
            margin-right: 16px;
        }
        .btn-back-home:hover {
            background: linear-gradient(90deg,#4b6cb7 0%,#182848 100%);
            color: #fff;
            transform: translateY(-2px) scale(1.03);
            box-shadow: 0 8px 24px rgba(108,92,231,0.13);
        }
        .btn-back-home i {
            font-size: 19px;
        }
        /* Table */
        .gridview {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
            font-size: 16px;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.05);
        }
        .gridview th, .gridview td {
            padding: 16px;
            text-align: left;
            vertical-align: middle;
            border-bottom: 2px solid #f4f4f4;
        }
        .gridview th {
            background-color: #3498db;
            color: white;
            font-size: 18px;
            font-weight: 600;
        }
        .gridview td {
            background-color: rgba(250,250,250,0.85);
            font-size: 16px;
        }
        .gridview tr:nth-child(even) td {
            background-color: rgba(248,248,248,0.85);
        }
        .gridview tr:hover td {
            background-color: #ecf0f1;
        }
        .gridview .action-buttons {
            display: flex;
            justify-content: space-evenly;
            gap: 10px;
        }
        .gridview .btn-delete,
        .gridview .btn-edit {
            padding: 10px 20px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-weight: 600;
            font-size: 15px;
            transition: background-color 0.3s;
            display: inline-block;
        }
        .gridview .btn-delete { background-color: #e74c3c; color: white; }
        .gridview .btn-edit { background-color: #f39c12; color: white; }
        .gridview .btn-delete:hover { background-color: #c0392b; }
        .gridview .btn-edit:hover { background-color: #d68910; }

        /* Responsive */
        @media (max-width: 768px) {
            body{padding:20px;}
            .container{padding:20px;}
            h2{font-size: 1.6rem;}
            .gridview th, .gridview td {padding: 10px; font-size: 14px;}
            .btn-add, .btn-back-home {font-size: 16px;}
        }

        /* NAVIGATION BAR (copied/adapted from course.aspx, with transparency) */
        .settings-container {
            position: fixed;
            top: 18px;
            right: 18px;
            display: flex;
            gap: 25px;
            z-index: 1500;
            background: rgba(255,255,255,0.70); /* semi-transparent background */
            box-shadow: 0 2px 12px rgba(60,64,193,0.04);
            border-radius: 28px;
            padding: 10px 18px 10px 16px;
            align-items: center;
            min-height: 54px;
        }
        .settings-icon, .theme-toggle-icon {
            font-size: 22px;
            color: #3c40c1;
            cursor: pointer;
            transition: transform 0.3s, color 0.3s;
            position: relative;
        }
        .settings-icon:hover, .theme-toggle-icon:hover { transform: scale(1.15);}
        .settings-icon.spin i { transform: rotate(90deg);}
        .settings-icon i { display: inline-block; transition: transform 0.4s; }
        .dropdown-settings {
            display: none;
            position: absolute;
            top: 38px;
            right: 0;
            background-color: white;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-shadow: 0 6px 12px rgba(0,0,0,0.11);
            padding: 6px 0;
            width: 128px;
            animation: fadeIn 0.3s;
            z-index: 2000;
        }
        .dropdown-settings a {
            display: block;
            padding: 8px 16px;
            font-size: 15px;
            color: #333;
            text-decoration: none;
            transition: background 0.2s;
        }
        .dropdown-settings a:hover { background-color: #f0f0f0;}
        @keyframes fadeIn {
            from {opacity:0;transform: translateY(-10px);}
            to {opacity:1;transform: translateY(0);}
        }
        /* Profile pic/name */
        #userNavBarProfile {
            display: flex;
            align-items: center;
            gap: 7px;
            padding: 0 9px;
            min-width: 70px;
        }
        #navbarProfilePic {
            width: 32px; height: 32px; border-radius: 50%; object-fit: cover; border: 1.5px solid #c5c5ff;
        }
        #navbarFirstName {
            font-family: 'Nunito', 'Jost', 'Segoe UI', Arial, sans-serif;
            letter-spacing: 1.2px;
            font-weight: 700;
            font-size: 1.09rem;
            background: linear-gradient(90deg, #3c40c1 40%, #6658ea 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-fill-color: transparent;
            padding-left: 2px;
        }
        /* Hamburger Icon */
        .hamburger-menu {
            position: relative;
            width: 22px;
            height: 18px;
            cursor: pointer;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            z-index: 1002;
            transition: transform 0.3s;
            margin-top: 6px;
        }
        .hamburger-line {
            height: 2px;
            background-color: #3c40c1;
            border-radius: 1px;
            transition: all 0.4s;
        }
        .hamburger-menu.active .line1 {
            transform: rotate(45deg) translate(5px, 5px);
        }
        .hamburger-menu.active .line2 { opacity: 0;}
        .hamburger-menu.active .line3 {
            transform: rotate(-45deg) translate(6px, -6px);
        }
        .dropdown-menu {
            position: absolute;
            top: 40px;
            right: 0;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.15);
            display: none;
            flex-direction: column;
            padding: 10px 0;
            min-width: 160px;
            z-index: 2001;
            animation: fadeIn 0.3s;
        }
        .dropdown-menu a {
            display: flex;
            align-items: center;
            padding: 10px 20px;
            color: #3c40c1;
            text-decoration: none;
            font-weight: 600;
            gap: 10px;
            transition: background 0.2s, transform 0.2s;
        }
        .dropdown-menu a:hover {
            background-color: #f4f4f4;
            transform: translateX(5px);
        }
        .dropdown-menu i {
            font-size: 18px;
            animation: bounce 1.5s infinite;
        }
        @keyframes bounce {
            0%,100% { transform: translateY(0);}
            50% { transform: translateY(-3px);}
        }
        /* DARK MODE */
        body.dark-mode {
            background-color: #10101a !important;
            color: #f0f0f0 !important;
        }
        body.dark-mode .container {
            background: rgba(30,30,30,0.92);
        }
        body.dark-mode h2 {
            color: #fff;
            border-bottom: 3px solid #b0b0b0;
        }
        body.dark-mode .btn-add {
            background-color: #4b50e6;
            color: #fff;
        }
        body.dark-mode .btn-add:hover {
            background-color: #3c40c1;
        }
        body.dark-mode .gridview th {
            background-color: #b0b0b0;
            color: #000;
        }
        body.dark-mode .gridview td {
            background-color: #232336;
            color: #fff;
        }
        body.dark-mode .gridview tr:nth-child(even) td {
            background-color: #17172a;
        }
        body.dark-mode .gridview tr:hover td {
            background-color: #232336;
        }
        body.dark-mode .settings-container {
            background: rgba(30,30,30,0.77);
            box-shadow: 0 2px 12px rgba(20,20,40,0.06);
        }
        body.dark-mode .dropdown-settings,
        body.dark-mode .dropdown-menu { background-color: #232336; border-color: #444;}
        body.dark-mode .dropdown-settings a,
        body.dark-mode .dropdown-menu a { color: #fff;}
        body.dark-mode .dropdown-settings a:hover,
        body.dark-mode .dropdown-menu a:hover { background-color: #17172a;}
        body.dark-mode .hamburger-line {background: #fff;}
        body.dark-mode #navbarFirstName {background: linear-gradient(90deg,#fff 40%,#b0b0b0 100%);-webkit-text-fill-color:transparent;}

        body.dark-mode .btn-back-home {
            background: #232336;
            color: #fff;
        }
        body.dark-mode .btn-back-home:hover {
            background: linear-gradient(90deg,#232336 0%,#3c40c1 100%);
        }

        body.dark-mode #navbarFirstName {
            background: none !important;
            color: #fff !important;
            -webkit-background-clip: unset !important;
            -webkit-text-fill-color: #fff !important;
            background-clip: unset !important;
            text-fill-color: #fff !important;
        }
    </style>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        // NAVBAR Scripts (profile, hamburger, settings)
        $(document).ready(function () {
            const $settingsBtn = $('#settingsBtn');
            const $settingsMenu = $('#settingsMenu');
            const hamburger = $('#hamburgerBtn');
            const hamburgerMenu = $('#hamburgerMenu');
            let darkMode = false;
            function setDarkMode(on) {
                if (on) {
                    $('body').addClass('dark-mode');
                } else {
                    $('body').removeClass('dark-mode');
                }
            }
            // Check DB-selected mode type from code-behind
            var userModeType = '<%= ModeTypeFromDB %>';
            if (userModeType === "dark") {
                setDarkMode(true);
            } else {
                setDarkMode(false);
            }
            // Allow user to toggle theme (optional - can remove if you want only DB-driven)
            // (If you want to DISABLE manual toggle, just hide/remove theme toggle icon below)
            $('#themeToggle').on('click', function () {
                darkMode = !$('body').hasClass('dark-mode');
                setDarkMode(darkMode);
            });
            // Profile name/pic
            $("#navbarFirstName").text('<%= NavbarUserName %>');
            $("#navbarProfilePic").attr("src", '<%= NavbarProfilePicResolved %>');
            // Settings menu
            $settingsBtn.on('click', function () {
                $(this).toggleClass('spin'); $settingsMenu.toggle();
            });
            $(document).on('click', function (e) {
                if (!$(e.target).closest('#settingsBtn').length) {
                    $settingsBtn.removeClass('spin'); $settingsMenu.hide();
                }
            });
            // Hamburger
            hamburger.on('click', function () {
                $(this).toggleClass('active'); hamburgerMenu.slideToggle(200);
            });
            $(document).on('click', function (e) {
                if (!hamburger.is(e.target) && hamburger.has(e.target).length === 0 && !hamburgerMenu.is(e.target) && hamburgerMenu.has(e.target).length === 0) {
                    hamburger.removeClass('active'); hamburgerMenu.slideUp(200);
                }
            });
        });
    </script>
</head>
<body>
    <div class="settings-container">
        <div id="settingsBtn" class="settings-icon">
            <i class="fas fa-gear"></i>
            <div class="dropdown-settings" id="settingsMenu">
                <a href="UserProfile.aspx"><i class="fas fa-user"></i> Profile</a>
                <a href="index.html" style="color:#e74c3c;"><i class="fas fa-sign-out-alt"></i> Log Out</a>
            </div>
        </div>
        <div id="userNavBarProfile">
            <img id="navbarProfilePic"  style="width:32px;height:32px;border-radius:50%;object-fit:cover;">
            <span id="navbarFirstName" style="font-weight:600;">User</span>
        </div>
        <div id="hamburgerBtn" class="hamburger-menu">
            <div class="hamburger-line line1"></div>
            <div class="hamburger-line line2"></div>
            <div class="hamburger-line line3"></div>
            <div class="dropdown-menu" id="hamburgerMenu">
                <a href="CourseList.aspx"><i class="fas fa-book"></i>Courses</a>
                <a href="AddCourse.aspx"><i class="fas fa-plus-circle"></i>Add Course</a>
                <a href="DiscussionForum.aspx"><i class="fas fa-comments"></i>Discussion</a>
                <a href="TeacherAnnouncements.aspx"><i class="fas fa-volume-up"></i>Announcements</a>
                <a href="feedbackForm.aspx"><i class="fas fa-envelope"></i>Feedbacks</a>
                
            </div>
        </div>
    </div>
    <form id="form1" runat="server">
        <div class="container">
            <a href="course.aspx" class="btn-back-home"><i class="fas fa-arrow-left"></i>Back to Home</a>
            <h2>My Courses</h2>
            <a href="AddCourse.aspx" class="btn-add">+ Add Course</a>
            <asp:GridView ID="gvCourses" runat="server" CssClass="gridview" AutoGenerateColumns="False" OnRowCommand="gvCourses_RowCommand">
                <Columns>
                    <asp:BoundField DataField="CourseID" HeaderText="Course ID" />
                    <asp:BoundField DataField="CourseName" HeaderText="Course Name" />
                    <asp:BoundField DataField="ModuleType" HeaderText="Module Type" />
                    <asp:BoundField DataField="PublishDate" HeaderText="Published Date" DataFormatString="{0:yyyy-MM-dd}" HtmlEncode="false" />
                    <asp:BoundField DataField="Duration" HeaderText="Course Duration" />
                    <asp:BoundField DataField="SkillLevel" HeaderText="Skill Level" />
                    <asp:BoundField DataField="Language" HeaderText="Language" />
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <div class="action-buttons">
                                <asp:Button ID="btnEdit" runat="server" Text="Edit" CssClass="btn-edit" CommandName="EditCourse" CommandArgument='<%# Eval("CourseID") %>' />
                                <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="btn-delete" CommandName="DeleteCourse" CommandArgument='<%# Eval("CourseID") %>' OnClientClick="return confirm('Are you sure you want to delete this course?');" />
                                <%-- "Add Quiz" button removed as requested --%>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </form>
    <script type="text/javascript">
        function confirmDelete(courseId) {
            if (confirm("Are you sure you want to delete this course?")) {
                __doPostBack('DeleteCourse', courseId);
            }
        }
        function confirmEdit(courseId) {
            if (confirm("Are you sure you want to edit this course?")) {
                window.location.href = 'AddCourse.aspx?id=' + courseId;
            }
        }
    </script>
</body>
</html>