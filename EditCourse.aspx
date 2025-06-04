<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditCourse.aspx.cs" Inherits="WAPPSS.EditCourse" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Edit Course</title>
    <link href="site.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
body {
    background: #f5f7fb; /* LIGHT background behind container */
    font-family: 'Segoe UI', sans-serif;
    margin: 0;
    padding: 0;
    transition: background 0.4s, color 0.4s;
}

.form-container {
    max-width: 800px;
    margin: 80px auto 40px auto;
    padding: 40px;
    background: #fff;
    border-radius: 15px;
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
    border-left: 8px solid #3c40c1;
    transition: background 0.4s, border-color 0.4s;
}

h2 {
    color: #3c40c1;
    margin-bottom: 25px;
    text-align: center;
    font-size: 28px;
    transition: color 0.4s;
}

.course-image {
    display: block;
    margin: 0 auto 12px auto;
    width: 220px;
    height: auto;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

.resource-link {
    font-size: 15px;
    color: #3c40c1;
    text-decoration: underline;
    font-weight: 500;
    margin-right: 8px;
}

.file-label {
    font-size: 13px;
    color: #666;
    margin-left: 4px;
}

label {
    display: block;
    margin-top: 18px;
    font-weight: 600;
    color: #333;
    transition: color 0.4s;
}

.input-text, .input-select, input[type="time"] {
    width: 100%;
    padding: 10px 12px;
    margin-top: 6px;
    font-size: 15px;
    box-sizing: border-box;
    border: 1px solid #ccc;
    border-radius: 6px;
    transition: border-color 0.3s, background 0.35s, color 0.35s;
}

.input-text:focus, .input-select:focus, input[type="time"]:focus {
    border-color: #3c40c1;
    outline: none;
}

.btn {
    margin-top: 30px;
    background-color: #3c40c1;
    color: white;
    border: none;
    padding: 12px 20px;
    border-radius: 6px;
    font-size: 16px;
    cursor: pointer;
    width: 100%;
    transition: background-color 0.3s ease, color 0.3s;
}

.btn:hover {
    background-color: #2b2fb5;
}

.back-link {
    display: block;
    margin-top: 25px;
    text-align: center;
    color: #3c40c1;
    text-decoration: none;
    transition: color 0.3s;
}

.back-link:hover {
    text-decoration: underline;
}

.modern-calendar {
    border-collapse: separate;
    border-spacing: 5px;
    width: 100%;
    margin-top: 10px;
}
.modern-calendar th, .modern-calendar td {
    padding: 10px;
    text-align: center;
    border-radius: 8px;
    transition: background 0.25s, color 0.25s;
}
.modern-calendar .TitleStyle {
    font-size: 18px !important;
    padding: 10px 0;
    color: #fff !important;
    font-weight: bold;
    background-color: #3c40c1 !important; /* AddCourse: purple */
    border-radius: 0 !important;
    border: none !important;
}
.modern-calendar .NextPrevStyle {
    color: #fff !important;
    background-color: #3c40c1 !important; /* AddCourse: purple */
    border-radius: 0 !important;
    border: none !important;
    font-size: 22px !important;
    font-weight: bold;
}
.modern-calendar th {
    background-color: #e1e8fa; /* AddCourse: light blue */
    color: #3c40c1;
    font-size: 1.08em;
    border-radius: 8px;
}
.modern-calendar td {
    background-color: #f5f7fb; /* AddCourse: very light blue */
    color: #222f3e;
    border: 1px solid #c7d4f8;
    border-radius: 8px;
    transition: background 0.25s, color 0.25s;
}
.modern-calendar td:hover {
    background-color: #d6e3fa !important; /* AddCourse: hover */
}
.modern-calendar .SelectedDayStyle,
.modern-calendar .TodayDayStyle {
    background-color: #3c40c1 !important; /* AddCourse: purple */
    color: #fff !important;
    font-weight: bold;
}
.modern-calendar .OtherMonthDayStyle {
    color: #b2b2b2 !important;
}
@media (max-width: 900px) {
    .form-container {margin: 100px 8px 40px 8px; padding: 20px;}
    .settings-container {padding: 8px 10px;}
}

/* Navigation Bar Styles (copied/adapted from AddCourse, with transparency) */
.settings-container {
    position: fixed;
    top: 18px;
    right: 18px;
    display: flex;
    gap: 25px;
    z-index: 1500;
    background: rgba(255,255,255,0.70);
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
    background: #181818 !important;
    color: #f0f0f0 !important;
}
body.dark-mode .form-container {
    background-color: #20202b !important;
    border-left-color: #cccccc !important;
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3);
}
body.dark-mode h2,
body.dark-mode label {
    color: #fff !important;
}
body.dark-mode .input-text,
body.dark-mode .input-select,
body.dark-mode input[type="time"] {
    background-color: #2d2d38 !important;
    color: #fff !important;
    border-color: #444 !important;
}
body.dark-mode .input-text:focus,
body.dark-mode .input-select:focus,
body.dark-mode input[type="time"]:focus {
    border-color: #cccccc !important;
}
body.dark-mode .modern-calendar .TitleStyle,
body.dark-mode .modern-calendar .NextPrevStyle {
    background-color: #3c40c1 !important;
    color: #fff !important;
}
body.dark-mode .modern-calendar th {
    background-color: #323a4c !important;
    color: #fff !important;
    border-radius: 8px !important;
}
body.dark-mode .modern-calendar td {
    background-color: #23233a !important;
    color: #fff !important;
    border: 1px solid #353555 !important;
    border-radius: 8px !important;
}
body.dark-mode .modern-calendar td:hover {
    background-color: #36365a !important;
}
body.dark-mode .modern-calendar .SelectedDayStyle,
body.dark-mode .modern-calendar .TodayDayStyle {
    background-color: #3c40c1 !important;
    color: #fff !important;
    font-weight: bold;
}
body.dark-mode .modern-calendar .OtherMonthDayStyle {
    color: #888 !important;
}
body.dark-mode .dropdown-settings,
body.dark-mode .dropdown-menu {
    background-color: #232336 !important;
    border-color: #444 !important;
}
body.dark-mode .dropdown-settings a,
body.dark-mode .dropdown-menu a {
    color: #fff !important;
}
body.dark-mode .dropdown-settings a:hover,
body.dark-mode .dropdown-menu a:hover {
    background-color: #17172a !important;
}
body.dark-mode .hamburger-line {
    background-color: #fff !important;
}
body.dark-mode .settings-icon,
body.dark-mode .theme-toggle-icon {
    color: #fff !important;
}
body.dark-mode .btn {
    background-color: #cccccc !important;
    color: #23233a !important;
}
body.dark-mode .btn:hover {
    background-color: #b0b0b0 !important;
}
body.dark-mode .back-link {
    color: #cccccc !important;
}
body.dark-mode #navbarFirstName {
    background: none !important;
    color: #fff !important;
    -webkit-background-clip: unset !important;
    -webkit-text-fill-color: #fff !important;
    background-clip: unset !important;
    text-fill-color: #fff !important;
}
.remove-file-btn {
    color: #e74c3c !important;
    background: none;
    border: none;
    padding: 0 0 0 8px;
    font-size: 14px;
    cursor: pointer;
    outline: none;
    vertical-align: middle;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 3px;
    transition: color 0.2s;
}
.remove-file-btn:hover {
    color: #c0392b !important;
    text-decoration: underline;
}
.remove-file-btn i {
    margin-right: 3px;
    font-size: 15px;
    vertical-align: middle;
}
    </style>
</head>
<body>
    <!-- Navigation Bar HTML -->
    <div class="settings-container">
    <div id="settingsBtn" class="settings-icon">
        <i class="fas fa-gear"></i>
        <div class="dropdown-settings" id="settingsMenu">
            <a href="UserProfile.aspx"><i class="fas fa-user"></i> Profile</a>
            <a href="index.html" style="color:#e74c3c;"><i class="fas fa-sign-out-alt"></i> Log Out</a>
        </div>
    </div>
    <div id="userNavBarProfile">
        <img id="navbarProfilePic" style="width:32px;height:32px;border-radius:50%;object-fit:cover;">
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
            <a href="announcement.aspx"><i class="fas fa-volume-up"></i>Announcements</a>
        </div>
    </div>
</div>

<form id="form1" runat="server" enctype="multipart/form-data">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <div class="form-container">
            <h2>Edit Course</h2>
            <img src="Images/courses.jpg" alt="Course Image" class="course-image" />
            <label for="courseName">Course Name:</label>
            <asp:TextBox ID="txtCourseName" runat="server" CssClass="input-text" />
            <label for="duration">Duration:</label>
            <div style="display: flex; gap: 10px;">
                <asp:TextBox ID="txtDurationHours" runat="server" CssClass="input-text" Width="48%" placeholder="Hours" TextMode="Number" />
                <asp:TextBox ID="txtDurationMinutes" runat="server" CssClass="input-text" Width="48%" placeholder="Minutes" TextMode="Number" />
            </div>
            <label for="skillLevel">Skill Level:</label>
            <asp:DropDownList ID="ddlSkillLevel" runat="server" CssClass="input-select">
                <asp:ListItem Text="Select Skill Level" Value="" />
                <asp:ListItem Text="Beginner" Value="Beginner" />
                <asp:ListItem Text="Intermediate" Value="Intermediate" />
                <asp:ListItem Text="All Levels" Value="All Levels" />
            </asp:DropDownList>
            <label for="language">Language:</label>
            <asp:DropDownList ID="ddlLanguage" runat="server" CssClass="input-select">
                <asp:ListItem Text="Select Language" Value="" />
                <asp:ListItem Text="English" Value="English" />
                <asp:ListItem Text="Spanish" Value="Spanish" />
                <asp:ListItem Text="Chinese" Value="Chinese" />
            </asp:DropDownList>

            <!-- Cover Image Preview -->
            <div style="margin-bottom:20px; text-align:center;">
                <asp:Image ID="imgCoverPreview" runat="server" CssClass="course-image" Visible="false" />
                <br />
                <asp:Label ID="lblCoverImageName" runat="server" CssClass="file-label" />
                <asp:LinkButton ID="btnRemoveCover" runat="server" CssClass="remove-file-btn" OnClick="btnRemoveCover_Click" ToolTip="Remove Cover Image" Visible="false">
                    <i class="fas fa-trash-alt"></i> Remove
                </asp:LinkButton>
                <br />
                <asp:FileUpload ID="fuCover" runat="server" />
                <span id="coverError" style="display:none; color:red; font-weight:bold;"></span>
            </div>

            <!-- Resource File Section -->
            <div style="margin-bottom:20px;">
                <label>Resource File:</label>
                <div style="display:flex;align-items:center;gap:10px;">
                    <asp:HyperLink ID="lnkResourceFile" runat="server" Visible="false" Target="_blank" CssClass="resource-link" />
                    <asp:Label ID="lblResourceFileName" runat="server" CssClass="file-label" />
                    <asp:LinkButton ID="btnRemoveResource" runat="server" CssClass="remove-file-btn" OnClick="btnRemoveResource_Click" ToolTip="Remove Resource File" Visible="false">
                        <i class="fas fa-trash-alt"></i> Remove
                    </asp:LinkButton>
                </div>
                <asp:FileUpload ID="fuResources" runat="server" AllowMultiple="false" />
                <span id="resourceError" style="display:none; color:red; font-weight:bold;"></span>
            </div>
            <label for="calendarPublish">Publish Date:</label>
            <asp:UpdatePanel ID="UpdatePanelCalendar" runat="server">
                <ContentTemplate>
                    <asp:Calendar ID="calendarPublish" runat="server" CssClass="modern-calendar"
                        OnSelectionChanged="calendarPublish_SelectionChanged">
                        
                        <DayStyle BackColor="#f5f7fb" BorderColor="#c7d4f8" BorderStyle="Solid" BorderWidth="1px" />
                        <TodayDayStyle CssClass="TodayDayStyle" />
                        <SelectedDayStyle CssClass="SelectedDayStyle" />
                        <OtherMonthDayStyle CssClass="OtherMonthDayStyle" />
                        <NextPrevStyle CssClass="NextPrevStyle" Font-Bold="true" />
                        <TitleStyle CssClass="TitleStyle" />
                    </asp:Calendar>
                </ContentTemplate>
            </asp:UpdatePanel>
            <label for="timePublish">Publish Time:</label>
            <input type="time" id="timePublish" runat="server" name="timePublish" />
            <label for="ddlModuleType">Module Type:</label>
            <asp:DropDownList ID="ddlModuleType" runat="server" CssClass="input-select">
                <asp:ListItem Text="Asynchronous" Value="Asynchronous" />
                <asp:ListItem Text="Synchronous" Value="Synchronous" />
            </asp:DropDownList>
            <asp:Button ID="btnSave" runat="server" CssClass="btn" Text="Save Course" OnClick="BtnSave_Click" />
            <asp:Label ID="lblStatus" runat="server" ForeColor="Red" />
            <a href="CourseList.aspx" class="back-link">← Back to Course List</a>
        </div>
    </form>    
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
   <script>
       $(document).ready(function () {
           const $settingsBtn = $('#settingsBtn');
           const $settingsMenu = $('#settingsMenu');
           const hamburger = $('#hamburgerBtn');
           const hamburgerMenu = $('#hamburgerMenu');

           // Navbar/profile/theme values from code-behind
           var userModeType = '<%= ModeTypeFromDB %>';
           // Set dark mode from DB
           function setDarkMode(on) {
               if (on) {
                   $('body').addClass('dark-mode');
               } else {
                   $('body').removeClass('dark-mode');
               }
           }
           if (userModeType === "dark") setDarkMode(true); else setDarkMode(false);

           // ====== COVER IMAGE VALIDATION ======
           $('input[type="file"][id*="fuCover"]').on('change', function () {
               const file = this.files[0];
               $('#coverError').hide().text('');
               if (file) {
                   const allowedImageTypes = [
                       'image/jpeg',
                       'image/png',
                       'image/gif',
                       'image/bmp',
                       'image/webp'
                   ];
                   const allowedExtensions = /\.(jpg|jpeg|png|gif|bmp|webp)$/i;
                   // Some browsers only set the extension, so double-check
                   if (
                       allowedImageTypes.indexOf(file.type) === -1 &&
                       !allowedExtensions.test(file.name)
                   ) {
                       $('#coverError').show().text('Error: Only image files (JPG, PNG, GIF, BMP, WEBP) are allowed for cover.');
                       this.value = '';
                       window.alert('Error Wrong Format');
                   }
               }
           });

           // ====== RESOURCE UPLOAD VALIDATION ======
           $('#fuResources').on('change', function () {
               const allowed = [
                   'application/pdf',
                   'application/vnd.ms-powerpoint',
                   'application/vnd.openxmlformats-officedocument.presentationml.presentation',
                   'video/mp4',
                   'video/x-msvideo',
                   'video/quicktime',
                   'video/x-matroska',
                   'video/webm',
                   'video/ogg'
               ];
               let errorShown = false;
               $('#resourceError').hide().text('');
               for (const file of this.files) {
                   // block image types in any form
                   if (
                       file.type.startsWith('image/') ||
                       /\.(jpg|jpeg|png|gif|bmp|webp)$/i.test(file.name) ||
                       (
                           allowed.indexOf(file.type) === -1 &&
                           !file.name.match(/\.(pdf|ppt|pptx)$/i) // fallback for browsers that don't send type for ppt/pptx
                       )
                   ) {
                       $('#resourceError').show().text('Error: Only PDF, PPT, or Video files are allowed. Images are not allowed.');
                       this.value = '';
                       window.alert('Error Wrong Format');
                       errorShown = true;
                       break;
                   }
               }
               if (!errorShown) {
                   $('#resourceError').hide().text('');
               }
           });


           // FirstName/profile pic
           $("#navbarFirstName").text('<%= NavbarUserName %>');
           $("#navbarProfilePic").attr("src", '<%= NavbarProfilePicResolved %>');

           $settingsBtn.on('click', function () {
               $(this).toggleClass('spin'); $settingsMenu.toggle();
           });
           $(document).on('click', function (e) {
               if (!$(e.target).closest('#settingsBtn').length) {
                   $settingsBtn.removeClass('spin'); $settingsMenu.hide();
               }
           });
           hamburger.on('click', function () {
               $(this).toggleClass('active'); hamburgerMenu.slideToggle(200);
           });
           $(document).on('click', function (e) {
               if (!hamburger.is(e.target) && hamburger.has(e.target).length === 0 && !hamburgerMenu.is(e.target) && hamburgerMenu.has(e.target).length === 0) {
                   hamburger.removeClass('active'); hamburgerMenu.slideUp(200);
               }
           });

           // ====== RESOURCE UPLOAD VALIDATION ======
           $('#fuResources').on('change', function () {
               const allowed = [
                   'application/pdf',
                   'application/vnd.ms-powerpoint',
                   'application/vnd.openxmlformats-officedocument.presentationml.presentation',
                   'video/mp4',
                   'video/x-msvideo',
                   'video/quicktime',
                   'video/x-matroska',
                   'video/webm',
                   'video/ogg'
               ];
               let errorShown = false;
               $('#resourceError').hide().text('');
               for (const file of this.files) {
                   if (
                       allowed.indexOf(file.type) === -1 &&
                       !file.name.match(/\.(pdf|ppt|pptx)$/i) // fallback for browsers that don't send type for ppt/pptx
                   ) {
                       $('#resourceError').show().text('Error: Only PDF, PPT, or Video files are allowed.');
                       this.value = '';
                       errorShown = true;
                       break;
                   }
               }
               if (!errorShown) {
                   $('#resourceError').hide().text('');
               }
           })

        // Block previous dates visually (gray out) & block selection
        // This only disables on client, ASP Calendar may still need server-side check
        // We trigger on the calendar's cells
        setTimeout(function () {
            // Wait for calendar to render
            $('.modern-calendar td').each(function () {
                var $cell = $(this);
                var cellText = $.trim($cell.text());
                if (!cellText || isNaN(cellText)) return;
                // Find current month/year from calendar header
                var $calendar = $cell.closest('.modern-calendar');
                var $header = $calendar.find('.TitleStyle').first();
                if ($header.length === 0) return;
                var headerText = $header.text(); // e.g., "May 2025"
                var parts = headerText.split(' ');
                if (parts.length < 2) return;
                var month = new Date(Date.parse(parts[0] + " 1, 2012")).getMonth() + 1; // 1-based
                var year = parseInt(parts[1]);
                var day = parseInt(cellText);
                if (!isDateAfterToday(year, month, day)) {
                    $cell.css('color', '#bbb').css('pointer-events', 'none').css('background-color', '#eee');
                }
            });
        }, 500);



    });
</script>

</body>
</html>