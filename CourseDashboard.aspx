<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CourseDashboard.aspx.cs" Inherits="WAPPSS.CourseDashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link id="darkModeCss" rel="stylesheet" runat="server" />
    <style>
         /* Reset default margins */
 body {
     margin: 0;
     padding: 0;
     font-family: Arial, sans-serif;
 }

 /* Header Styles */
 .header {
     display: flex;
     justify-content: space-between;
     align-items: center;
     padding: 0 30px;
     background-color: #fff;
     box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
     position: fixed;
     top: 0;
     left: 0;
     right: 0;
     height: 60px;
     z-index: 1000;
 }

 .logo {
     font-size: 24px;
     font-weight: bold;
     color: #3c40c1;
 }

 /* Right Side Controls - All in one row */
 .header-controls {
     display: flex;
     align-items: center;
     gap: 20px;
 }

 /* User Info */
 .user-info {
     display: flex;
     align-items: center;
     gap: 10px;
     cursor: pointer;
 }

 .user-icon {
     width: 32px;
     height: 32px;
     border-radius: 50%;
     background-color: #3c40c1;
     color: white;
     display: flex;
     align-items: center;
     justify-content: center;
     font-size: 14px;
 }

 .user-name {
     font-weight: 600;
     color: #333;
 }

 /* Hamburger Menu */
 .hamburger-btn {
     cursor: pointer;
     display: flex;
     flex-direction: column;
     gap: 5px;
     padding: 10px;
 }

 .hamburger-line {
     width: 25px;
     height: 3px;
     background-color: #3c40c1;
     transition: all 0.3s ease;
 }

 .hamburger-btn.active .hamburger-line:nth-child(1) {
     transform: rotate(45deg) translate(5px, 6px);
 }

 .hamburger-btn.active .hamburger-line:nth-child(2) {
     opacity: 0;
 }

 .hamburger-btn.active .hamburger-line:nth-child(3) {
     transform: rotate(-45deg) translate(5px, -6px);
 }

 /* Settings Button */
 .settings-btn {
     cursor: pointer;
     font-size: 20px;
     color: #3c40c1;
     transition: transform 0.3s;
     padding: 10px;
 }

 .settings-btn:hover {
     transform: rotate(90deg);
 }

 /* Dropdown Menus */
 .dropdown-menu {
     display: none;
     position: absolute;
     top: 60px;
     right: 30px;
     background: white;
     box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
     border-radius: 8px;
     width: 200px;
     z-index: 1001;
 }

 .dropdown-menu a {
     display: block;
     padding: 12px 20px;
     color: #333;
     text-decoration: none;
     border-bottom: 1px solid #f0f0f0;
     transition: background 0.2s;
 }

 .dropdown-menu a:hover {
     background: #f8f8f8;
 }

 .dropdown-menu a i {
     margin-right: 10px;
     width: 20px;
     text-align: center;
 }

 .logout {
     color: #e74c3c !important;
 }

 /* Show menus when active */
 .show {
     display: block !important;
 }
        .course-card {
    border: 1px solid #ccc;
    padding: 16px;
    margin: 12px;
    border-radius: 10px;
    width: 250px;
    display: inline-block;
    vertical-align: top;
    background-color: #fff;
    box-shadow: 2px 2px 8px rgba(0,0,0,0.1);
    margin-top:100px;
}
.course-card img {
    width: 100%;
    height: 150px;
    object-fit: cover;
}
.course-card h3 {
    margin-top: 10px;
    font-size: 1.2em;
}
.course-card p {
    margin: 4px 0;
    color: #555;
}
/* Container for all cards wrapper */
#courseCardsWrapper {
  display: flex;
  flex-wrap: wrap;
  gap: 20px; /* spacing between cards */
  justify-content: center;
  overflow-x: auto;
  width: 100%;
  padding-bottom: 20px;
  opacity: 1;
  transform: none;
  transition: opacity 1.5s ease, transform 1.5s ease;
  scrollbar-width: thin;
  scrollbar-color: #3c40c1 #e0e0e0;
}

/* Scrollbar styles */
#courseCardsWrapper::-webkit-scrollbar {
  height: 10px;
}

#courseCardsWrapper::-webkit-scrollbar-thumb {
  background-color: #3c40c1;
  border-radius: 5px;
}

/* Individual Course Card */
.course-card {
  background: rgba(255, 255, 255, 0.9);
  border-radius: 25px;
  box-shadow: 0 20px 30px rgba(0, 0, 0, 0.1);
  width: 300px;
  padding: 20px;
  text-align: center;
  position: relative;
  border: 1px solid transparent;
  background-clip: padding-box;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  overflow: hidden; /* for the sliding button */
}

/* Hover effect: lift card and add shadow */
.course-card:hover {
  transform: translateY(-12px) scale(1.02);
  box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
  border: 1px solid #3c40c133;
  backdrop-filter: blur(8px);
}

/* Top label for synchronous/asynchronous */
.course-mode {
  position: absolute;
  top: 15px;
  left: 15px;
  padding: 6px 14px;
  border-radius: 20px;
  font-size: 0.75rem;
  font-weight: bold;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  color: white;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
  background-color: #3c40c1; /* default blue */
}

/* Green for synchronous */
.course-mode.synchronous {
  background-color: #20bf6b;
}

/* Red for asynchronous */
.course-mode.asynchronous {
  background-color: #eb3b5a;
}

/* Course image style */
.course-card img {
  width: 100%;
  height: 180px;
  object-fit: cover;
  border-radius: 14px;
  margin-bottom: 18px;
  border: 1px solid #ccc;
}

/* Course title */
.course-card h3 {
  font-size: 1.4rem;
  color: #333;
  margin: 0;
  font-weight: 700;
}

/* Course info like duration */
.course-info {
  font-size: 1rem;
  margin-top: 12px;
  color: #333;
  font-weight: 600;
}

/* View details container: hidden at bottom initially */
.view-details-container {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 20px;
  background: linear-gradient(to top, rgba(0,0,0,0.7) 0%, transparent 100%);
  transform: translateY(100%);
  transition: transform 0.3s ease;
  text-align: center;
}

/* Slide up view details container on hover */
.course-card:hover .view-details-container {
  transform: translateY(0);
}

/* View Details button styling */
.view-details-btn {
  display: inline-block;
  padding: 10px 20px;
  background-color: #3c40c1;
  color: white;
  border: none;
  border-radius: 25px;
  font-weight: bold;
  cursor: pointer;
  transition: background-color 0.3s ease, transform 0.3s ease;
  box-shadow: 0 4px 8px rgba(0,0,0,0.2);
  text-decoration: none;
}

/* Button hover */
.view-details-btn:hover {
  background-color: #2f32a3;
  transform: scale(1.05);
}

/* Dark mode overrides */
body.dark-mode .course-card {
  background-color: #1e1e1e;
  border: 1px solid #444;
}

body.dark-mode .course-mode {
  box-shadow: none;
  color: white;
}

body.dark-mode .course-mode.synchronous {
  background-color: #20bf6b;
}

body.dark-mode .course-mode.asynchronous {
  background-color: #eb3b5a;
}

body.dark-mode .course-card h3,
body.dark-mode .course-info {
  color: white;
}

body.dark-mode .view-details-container {
  background: linear-gradient(to top, rgba(0,0,0,0.9) 0%, transparent 100%);
}

body.dark-mode .view-details-btn {
  background-color: #4b50e6;
}

body.dark-mode .view-details-btn:hover {
  background-color: #3c40c1;
}

/* No Courses Message Styles */
.no-courses-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 4rem 2rem;
    margin-top: 100px;
    text-align: center;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border-radius: 20px;
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
    max-width: 600px;
    margin-left: auto;
    margin-right: auto;
    color: white;
}

.no-courses-icon {
    font-size: 5rem;
    color: rgba(255, 255, 255, 0.8);
    margin-bottom: 1.5rem;
    animation: bounce 2s infinite;
}

@keyframes bounce {
    0%, 20%, 50%, 80%, 100% {
        transform: translateY(0);
    }
    40% {
        transform: translateY(-10px);
    }
    60% {
        transform: translateY(-5px);
    }
}

.no-courses-title {
    font-size: 2.5rem;
    font-weight: 700;
    margin-bottom: 1rem;
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
}

.no-courses-subtitle {
    font-size: 1.2rem;
    margin-bottom: 2rem;
    opacity: 0.9;
    line-height: 1.6;
}

.browse-courses-btn {
    background: rgba(255, 255, 255, 0.2);
    border: 2px solid rgba(255, 255, 255, 0.5);
    color: white;
    padding: 1rem 2rem;
    border-radius: 50px;
    font-size: 1.1rem;
    font-weight: 600;
    text-decoration: none;
    transition: all 0.3s ease;
    backdrop-filter: blur(10px);
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
}

.browse-courses-btn:hover {
    background: rgba(255, 255, 255, 0.3);
    border-color: rgba(255, 255, 255, 0.8);
    transform: translateY(-2px);
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
    color: white;
    text-decoration: none;
}

.browse-courses-btn i {
    font-size: 1.2rem;
}

/* Dark mode adjustments for no courses message */
body.dark-theme .no-courses-container {
    background: linear-gradient(135deg, #2d3748 0%, #4a5568 100%);
    border: 1px solid #4a5568;
}

body.dark-theme .no-courses-title {
    color: #e2e8f0;
}

body.dark-theme .no-courses-subtitle {
    color: #cbd5e0;
}

body.dark-theme .browse-courses-btn {
    background: rgba(255, 255, 255, 0.1);
    border-color: rgba(255, 255, 255, 0.3);
    color: #e2e8f0;
}

body.dark-theme .browse-courses-btn:hover {
    background: rgba(255, 255, 255, 0.2);
    border-color: rgba(255, 255, 255, 0.5);
    color: white;
}

    </style>
</head>
<body class="<%= (Session["DarkMode"] != null && (bool)Session["DarkMode"]) ? "dark-theme" : "" %>">
    <form id="form1" runat="server">
         <header class="header">
<a href="Student_Dashboard.aspx">
    <div class="logo">
        <img src="images/scholapedia.png" alt="Scholapedia Logo" style="height: 40px;">
    </div>
</a>
<!-- GHOST ONLY: Place this wherever you want the ghost mascot to appear -->
<div class="ghost-container">
    <div id="ghost">
        <div id="blue">
            <div id="pupil"></div>
            <div id="pupil1"></div>
            <div id="eye"></div>
            <div id="eye1"></div>
            <div id="top0"></div>
            <div id="top1"></div>
            <div id="top2"></div>
            <div id="top3"></div>
            <div id="top4"></div>
            <div id="st0"></div>
            <div id="st1"></div>
            <div id="st2"></div>
            <div id="st3"></div>
            <div id="st4"></div>
            <div id="st5"></div>
            <div id="an1"></div>
            <div id="an2"></div>
            <div id="an3"></div>
            <div id="an4"></div>
            <div id="an5"></div>
            <div id="an6"></div>
            <div id="an7"></div>
            <div id="an8"></div>
            <div id="an9"></div>
            <div id="an10"></div>
            <div id="an11"></div>
            <div id="an12"></div>
            <div id="an13"></div>
            <div id="an14"></div>
            <div id="an15"></div>
            <div id="an16"></div>
            <div id="an17"></div>
            <div id="an18"></div>
        </div>
        <div id="shadow"></div>
    </div>
</div>

        
        <div class="header-controls">
                        <!-- Settings Button -->
            <div class="settings-btn" id="settingsBtn">
                <i class="fas fa-gear"></i>
            </div>
            <!-- User Info -->
<div class="user-info">
    <asp:Image ID="userIcon" runat="server" CssClass="user-icon" />
    <asp:Label ID="lblStudentName" runat="server" CssClass="user-name" Text="Student Name"></asp:Label>
</div>

            

            
            <!-- Hamburger Button -->
            <div class="hamburger-btn" id="hamburgerBtn">
                <div class="hamburger-line"></div>
                <div class="hamburger-line"></div>
                <div class="hamburger-line"></div>
            </div>
        </div>
        
        <!-- Settings Menu Dropdown -->
        <div class="dropdown-menu" id="settingsMenu">
            <a href="Profile.aspx"><i class="fas fa-user"></i>Profile</a>
            <a href="login.aspx" class="logout"><i class="fas fa-sign-out-alt"></i>Logout</a>
        </div>
        
        <!-- Hamburger Menu Dropdown -->
        <div class="dropdown-menu" id="hamburgerMenu">
<a href="Event.aspx"><i class="fas fa-calendar-plus"></i>Add Event</a>
<a href="Profile.aspx"><i class="fas fa-user-edit"></i>Edit Profile</a>

            <a href="CourseDashboard.aspx"><i class="fas fa-book"></i>Courses</a>
            <a href="DiscussionForum.aspx"><i class="fas fa-comments"></i>Discussions</a>
            <a href="StudentAnnouncements.aspx"><i class="fas fa-bullhorn"></i>Announcements</a>
             <a href="studentFeedbackForm.aspx"><i class="fas fa-envelope"></i>Feedbacks</a>
        </div>
    </header>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function () {
            // Hamburger Menu Toggle
            $('#hamburgerBtn').click(function (e) {
                e.stopPropagation();
                $(this).toggleClass('active');
                $('#hamburgerMenu').toggleClass('show');
                $('#settingsMenu').removeClass('show');
            });

            // Settings Menu Toggle
            $('#settingsBtn').click(function (e) {
                e.stopPropagation();
                $('#settingsMenu').toggleClass('show');
                $('#hamburgerMenu').removeClass('show');
                $('#hamburgerBtn').removeClass('active');
            });

            // Close menus when clicking outside
            $(document).click(function () {
                $('#hamburgerMenu').removeClass('show');
                $('#settingsMenu').removeClass('show');
                $('#hamburgerBtn').removeClass('active');
            });

            // Prevent clicks inside menus from closing them
            $('.dropdown-menu').click(function (e) {
                e.stopPropagation();
            });
        });
    </script>   

<!-- No Courses Message Panel -->
<asp:Panel ID="pnlNoCourses" runat="server" Visible="false">
    <div class="no-courses-container">
        <div class="no-courses-icon">
            <i class="fas fa-graduation-cap"></i>
        </div>
        <h2 class="no-courses-title">No Courses Yet</h2>
        <p class="no-courses-subtitle">
            You are not enrolled in any courses at the moment.<br>
            Start your learning journey by browsing available courses!
        </p>
        <a href="Student_Dashboard.aspx" class="browse-courses-btn">
            <i class="fas fa-search"></i>
            Explore Courses
        </a>
    </div>
</asp:Panel>

<!-- Courses Repeater -->
<asp:Repeater ID="rptCourses" runat="server" OnItemCommand="rptCourses_ItemCommand">
    <ItemTemplate>
        <div class="course-card">
            <%-- Top label based on TC_ModuleType --%>
            <asp:Literal ID="litModuleType" runat="server" 
                Text='<%# GetModuleTypeLabel(Eval("TC_ModuleType").ToString()) %>' 
                EnableViewState="false" />
            
            <img src='<%# Eval("TC_CoverImage") %>' alt="Course Cover" />
            <h3><%# Eval("TC_CourseName") %></h3>
<div class="course-info">
    <span>Instructor Name: <%# Eval("InstructorName") %></span>
</div>


            <%-- View details container with button --%>
        <div class="view-details-container">
            <!-- Simple button with no data binding -->
            <a href='<%# "StudentCourseDetails.aspx?id=" + Eval("TC_ID") %>' class="view-details-btn">View Details</a>

        </div>
        </div>
    </ItemTemplate>
</asp:Repeater>

<script runat="server">
    protected override void OnPreRender(EventArgs e)
    {
        base.OnPreRender(e);
        Page.ClientScript.RegisterStartupScript(this.GetType(), "setBodyClass", 
            "document.body.classList.add('edit-profile-bg');", true);
    }
</script>


    </form>
</body>
</html>