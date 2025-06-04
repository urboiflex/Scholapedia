<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="course.aspx.cs" Inherits="WAPPSS.course" EnableEventValidation="false" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <title>Scholapedia - Courses</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Bungee&display=swap" rel="stylesheet">

    <!-- CSS Files -->
    <link rel="stylesheet" href="header.css">
    <link rel="stylesheet" href="course.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet" />
    <link href="css/style.css" rel="stylesheet" />
    <link href="img/favicon.ico" rel="icon" />
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet" /> 
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body id="bodyTag" runat="server">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" />
        
        <!-- NAVIGATION BAR W/ LOGO INSIDE -->
        <div 
            class="navbar-encapsulate" 
            style="position:fixed;top:0;left:0;width:100vw;height:62px;min-height:62px;display:flex;align-items:center;justify-content:space-between;z-index:2000;background:rgba(255,255,255,0.97);box-shadow:0 2px 12px rgba(60,64,193,0.09);border-bottom:1px solid #e3e7fa;">
            
            <!-- Scholapedia Logo (left, inside bar) -->
            <div style="display:flex;align-items:center;height:100%;">
                <img src="Images/scholapedia.png" alt="Scholapedia Logo"
                    style="height:40px;width:auto;margin-left:22px;margin-right:22px;display:block;" />
            </div>
            
            <!-- Right Section: Settings, Profile, Name, Hamburger -->
            <div style="display:flex;align-items:center;gap:20px;height:100%;margin-right:36px;">
                <div id="settingsBtn" class="settings-icon" style="position:relative;">
                    <i class="fas fa-gear"></i>
                    <div class="dropdown-settings" id="settingsMenu">
                        <a href="UserProfile.aspx"><i class="fas fa-user"></i> Profile</a>
                        <a href="login.aspx" style="color:#e74c3c;"><i class="fas fa-sign-out-alt"></i> Log Out</a>
                    </div>
                </div>
                <div id="userNavBarProfile" style="display:flex;align-items:center;gap:7px;padding:0 12px;">
                    <img id="navbarProfilePic" src="" alt="Profile" style="width:32px;height:32px;border-radius:50%;object-fit:cover;border:2px solid #e3e7fa;">
                    <span id="navbarFirstName" style="font-weight:600;">User</span>
                </div>
                <div id="hamburgerBtn" class="hamburger-menu" style="margin-left:10px;">
                    <div class="hamburger-line line1"></div>
                    <div class="hamburger-line line2"></div>
                    <div class="hamburger-line line3"></div>
                    <div class="dropdown-menu" id="hamburgerMenu">
                        <a href="CourseList.aspx"><i class="fas fa-book"></i>Courses</a>
                        <a href="AddCourse.aspx"><i class="fas fa-plus-circle"></i>Add Course</a>
                        <a href="TeacherDiscussionForum.aspx"><i class="fas fa-comments"></i>Discussion</a>
                        <a href="TeacherAnnouncements.aspx"><i class="fas fa-volume-up"></i>Announcements</a>
                        <a href="feedbackForm.aspx"><i class="fas fa-envelope"></i>Feedbacks</a>

                    </div>
                </div>
            </div>
        </div>
        <!-- END NAVIGATION BAR -->
        
        <div class="header-main-flex">
            <div class="welcome-box-container">
                <div class="welcome-box">
                    <div class="welcome-content">
                        <h1>
                            <span class="typing-container">
                                Hello, <asp:Label ID="lblUserName" runat="server" />!
                            </span>
                        </h1>
                    </div>
                </div>
                <div class="particles"></div>
            </div>
            <div class="calendar-box-container">
                <!-- Custom Calendar - NO ASP.NET Calendar Control -->
                <div id="customCalendar" class="custom-calendar">
                    <div class="calendar-header">
                        <button type="button" id="prevMonth" class="nav-btn">&lt;</button>
                        <span id="monthYear"></span>
                        <button type="button" id="nextMonth" class="nav-btn">&gt;</button>
                    </div>
                    <div class="calendar-grid">
                        <div class="day-header">Sun</div>
                        <div class="day-header">Mon</div>
                        <div class="day-header">Tue</div>
                        <div class="day-header">Wed</div>
                        <div class="day-header">Thu</div>
                        <div class="day-header">Fri</div>
                        <div class="day-header">Sat</div>
                        <!-- Days will be populated by JavaScript -->
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Class Details Modal -->
        <div id="classDetailsModal" class="class-modal" style="display: none;">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 id="modalDate">Class Details</h2>
                    <span class="close-modal" onclick="closeClassModal()">&times;</span>
                </div>
                <div class="modal-body">
                    <div id="classDetailsContent">
                        <!-- Class details will be loaded here -->
                    </div>
                </div>
            </div>
        </div>

        <section class="courses-intro-section" id="stats-section">
            <div class="container text-center">
                <h1 class="intro-title">
                    <span id="typewriter" class="animated-heading">First Choice for Online Education Anywhere</span>
                </h1>
                <div class="stats-container">
                    <div class="stat-box" style="background-color: #f39c12;">
                        <div class="count-up" data-count="70">0</div>
                        <p>Available Subjects</p>
                    </div>
                    <div class="stat-box" style="background-color: #16a085;">
                        <div class="count-up" data-count="100">0</div>
                        <p>Online Courses</p>
                    </div>
                    <div class="stat-box" style="background-color: #e74c3c;">
                        <div class="count-up" data-count="70">0</div>
                        <p>Skilled Instructors</p>
                    </div>
                    <div class="stat-box" style="background-color: #9b59b6;">
                        <div class="count-up" data-count="256">0</div>
                        <p>Happy Students</p>
                    </div>
                </div>
                <div class="decorative-circles">
                    <div class="circle circle1"></div>
                    <div class="circle circle2"></div>
                    <div class="circle circle3"></div>
                    <div class="circle circle4"></div>
                </div>
            </div>
        </section>
        <section id="coursesSection" class="courses-section">
            <h2 class="courses-heading animate-heading" id="yourCoursesHeading">Your Courses</h2>
            <div class="courses-actions animate-buttons" id="coursesActions">
                <a href="CourseList.aspx"><i class="fa fa-pencil" id="editIcon"></i></a>
                <a href="AddCourse.aspx"><i class="fa fa-plus" id="addIcon"></i></a>
            </div>
            <div class="course-cards-wrapper" id="courseCardsWrapper" runat="server">
                <!-- Cards will be added here programmatically -->
            </div>
        </section>
    </form>

    <!-- Pass class dates from server to client -->
    <script type="text/javascript">
        // Class dates will be injected here by the server
        window.classScheduleDates = <%= GetClassDatesJson() %>;
    </script>

    <!-- SCRIPTS -->
    <script src="course.js"></script>
    
    <script>
        $(document).ready(function () {
            // Set navbar profile information
            $("#navbarFirstName").text('<%= NavbarUserName %>');

            // Set profile picture with error handling
            var profilePicSrc = '<%= NavbarProfilePicResolved %>';
            console.log('Profile picture source:', profilePicSrc); // Debug log
            
            if (profilePicSrc && profilePicSrc.trim() !== '') {
                $("#navbarProfilePic").attr("src", profilePicSrc);
            } else {
                // Fallback to default image
                $("#navbarProfilePic").attr("src", '<%= ResolveUrl("~/images/Profiles/default.jpg") %>');
            }
            
            // Handle image load error
            $("#navbarProfilePic").on('error', function() {
                console.log('Profile picture failed to load, using default');
                $(this).attr("src", '<%= ResolveUrl("~/images/Profiles/default.jpg") %>');
            });

            // Initialize custom calendar when page loads
            if (typeof initializeCustomCalendar === 'function') {
                initializeCustomCalendar();
            }
        });

        // Modal functions
        function showClassModal(date, classDetails) {
            document.getElementById('modalDate').innerText = 'Classes on ' + date;
            document.getElementById('classDetailsContent').innerHTML = classDetails;
            document.getElementById('classDetailsModal').style.display = 'block';
            document.body.style.overflow = 'hidden';
        }

        function closeClassModal() {
            document.getElementById('classDetailsModal').style.display = 'none';
            document.body.style.overflow = 'auto';
        }

        // Close modal when clicking outside
        $(document).ready(function () {
            $('#classDetailsModal').on('click', function (e) {
                if (e.target === this) {
                    closeClassModal();
                }
            });
        });

        // AJAX function to get class details
        function getClassDetails(dateString) {
            showLoadingModal();

            $.ajax({
                type: "POST",
                url: "course.aspx/GetClassDetailsForDate",
                data: JSON.stringify({ dateString: dateString }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    const formattedDate = new Date(dateString).toLocaleDateString('en-US', {
                        weekday: 'long',
                        year: 'numeric',
                        month: 'long',
                        day: 'numeric'
                    });
                    showClassModal(formattedDate, response.d);
                },
                error: function (xhr, status, error) {
                    console.error('AJAX Error:', error);
                    showClassModal('Error', '<p>Unable to load class details. Please try again later.</p>');
                }
            });
        }

        function showLoadingModal() {
            const loadingHtml = `
                <div class="loading-container">
                    <div class="loading-spinner"></div>
                    <p>Loading class details...</p>
                </div>
            `;
            showClassModal('Loading...', loadingHtml);
        }
    </script>
</body>
</html>