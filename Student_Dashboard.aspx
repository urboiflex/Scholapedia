<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Student_Dashboard.aspx.cs" Inherits="WAPPSS.Student_Dashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="stylesheet" href="student_dashboard.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link id="darkModeCss" runat="server" rel="stylesheet" href="" />

    <script src="student_dashboard.js"></script>

    <title>Scholapedia</title>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
   .slider-container {
  margin-bottom: 150px; /* Adds space below the entire slider */
}

        .slider-wrapper {
            position: relative;
            width: 1230px;
            height: 500px;
            
            overflow: hidden;
            margin-top: 100px;
            border-radius: 10px;
            border: 2px solid #007BFF;
        }

.slider-track {
  position: relative;
  width: 100%;
  height: 100%;
}

.slide {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-size: cover;
  background-position: center;
  opacity: 0;
  transform: scale(1.05);
  transition: opacity 1s ease, transform 1s ease;
  z-index: 0;
}

.slide.active {
  opacity: 1;
  transform: scale(1);
  z-index: 1;
}


.overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.4);
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  padding-bottom: 80px; /* Space inside each slide, pushes content up slightly */
  color: white;
  text-align: center;
}

.subject-label {
  font-size: 2em;
  font-weight: bold;
  margin-bottom: 20px;
  text-shadow: 1px 1px 5px #000;
}

.view-button {
  padding: 12px 24px;
  font-size: 1em;
  background-color: rgba(255, 255, 255, 0.8);
  color: #000;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background 0.3s ease;
}

.view-button:hover {
  background-color: #fff;
}

        /* Custom Calendar Styles */
        .custom-calendar {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            padding: 20px;
            border: 2px solid #007BFF;
            margin-bottom: 10px;
            
        }

        .calendar-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .nav-btn {
            background: #007BFF;
            color: white;
            border: none;
            border-radius: 5px;
            width: 30px;
            height: 30px;
            cursor: pointer;
            font-size: 16px;
            transition: background 0.3s;
        }

        .nav-btn:hover {
            background: #0056b3;
        }

        #monthYear {
            font-size: 18px;
            font-weight: bold;
            color: #333;
        }

        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 5px;
        }

        .day-header {
            text-align: center;
            font-weight: bold;
            color: #666;
            padding: 5px;
            font-size: 12px;
        }

        .calendar-day {
            text-align: center;
            padding: 8px 4px;
            border-radius: 5px;
            cursor: default;
            position: relative;
            min-height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
        }

        .calendar-day.empty {
            cursor: default;
        }

        .calendar-day.today {
            background: #007BFF;
            color: white;
            font-weight: bold;
        }

        .calendar-day.has-event {
            background: #e8f4f8;
            border: 1px solid #007BFF;
            cursor: pointer;
        }

        .calendar-day.has-event:hover {
            background: #d1ecf1;
        }

        .event-dot {
            position: absolute;
            top: 2px;
            right: 2px;
            width: 6px;
            height: 6px;
            background: #dc3545;
            border-radius: 50%;
        }

        /* Event Modal Styles */
        .event-modal {
            display: none;
            position: fixed;
            z-index: 2000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
        }

        .modal-content {
            background-color: white;
            margin: 10% auto;
            padding: 0;
            border-radius: 10px;
            width: 80%;
            max-width: 600px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
            animation: modalSlideIn 0.3s ease;
        }

        @keyframes modalSlideIn {
            from { transform: translateY(-50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        .modal-header {
            background: #007BFF;
            color: white;
            padding: 15px 20px;
            border-radius: 10px 10px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-header h2 {
            margin: 0;
            font-size: 18px;
        }

        .close-modal {
            font-size: 24px;
            cursor: pointer;
            color: white;
        }

        .close-modal:hover {
            opacity: 0.7;
        }

        .modal-body {
            padding: 20px;
            max-height: 400px;
            overflow-y: auto;
        }

        .event-details-list {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .event-item {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            border-left: 4px solid #007BFF;
        }

        .event-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 10px;
        }

        .event-title {
            font-size: 16px;
            font-weight: bold;
            color: #333;
            margin: 0;
        }

        .event-description {
            color: #666;
            font-size: 14px;
            line-height: 1.4;
        }

        .loading-container {
            text-align: center;
            padding: 20px;
        }

        .loading-spinner {
            border: 3px solid #f3f3f3;
            border-top: 3px solid #007BFF;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            animation: spin 1s linear infinite;
            margin: 0 auto 15px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Dark mode support */
        .dark-theme .custom-calendar {
            background: #2d3748;
            color: #e2e8f0;
        }

        .dark-theme .calendar-day.has-event {
            background: #2a4a5c;
            border-color: #4299e1;
        }

        .dark-theme .modal-content {
            background: #2d3748;
            color: #e2e8f0;
        }

        .dark-theme .event-title{
            color: #fff;
        }

        .dark-theme .event-description{
            color: #fff;
        }
        .dark-theme #monthYear{
            color: #fff;
        }

        .dark-theme .day-header{
            color: #fff;
        }

        .dark-theme .calendar-events h3 {
            color: #f7fafc;
            border-bottom: 1px solid #4a5568;
        }

        .dark-theme .event-item {
            background: #374151;
        }

    </style>

 
</head>
<body class='<%= (Session["DarkMode"] != null && (bool)Session["DarkMode"]) ? "dark-theme" : "" %>'>

    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" />

        <div class="dashboard-container">
 <header class="header">

<a href="Student_Dashboard.aspx">
    <div class="logo">
        <img src="images/scholapedia.png" alt="Scholapedia Logo" style="height: 40px;">
    </div>
</a>

        
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
            <!-- Main Content -->
            <div class="main-content">
    <!-- Top Section: Welcome Box and Calendar side by side -->
    <div class="top-section">
        <!-- Welcome Box and Calendar Container -->
        <div class="welcome-box-container">
            <div class="welcome-box">
                <div class="welcome-content">
                    <h1><span class="typing-container">Hello, <asp:Label ID="lblUserName" runat="server"></asp:Label>!</span></h1>
                    <p class="welcome-message">Let's learn something today</p>
                    <p class="sub-message">Set your study plan and grow with community</p>
                </div>
            </div>
            <div class="particles"></div>
        </div>
            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    const particlesContainer = document.querySelector('.particles');
                    const numParticles = 30; // You can adjust this number

                    for (let i = 0; i < numParticles; i++) {
                        const particle = document.createElement('div');
                        particle.classList.add('particle');

                        // Random position
                        particle.style.top = Math.random() * 100 + '%';
                        particle.style.left = Math.random() * 100 + '%';

                        // Random size
                        const size = Math.random() * 8 + 4; // 4px to 12px
                        particle.style.width = size + 'px';
                        particle.style.height = size + 'px';

                        // Random animation duration and delay
                        particle.style.animationDuration = (Math.random() * 3 + 2) + 's'; // 2s to 5s
                        particle.style.animationDelay = (Math.random() * 3) + 's'; // 0s to 3s

                        particlesContainer.appendChild(particle);
                    }
                });
            </script>


<asp:HiddenField ID="hiddenEventData" runat="server" />
        
        <!-- Calendar -->
        <div class="calendar-container">
            <!-- Custom Calendar -->
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
            <div class="calendar-events">
                <h3>Today's Events</h3>
                <ul id="eventsList">
                    <li>No events scheduled</li>
                </ul>
            </div>
        </div>
    </div>


        <!-- Event Details Modal -->
        <div id="eventDetailsModal" class="event-modal" style="display: none;">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 id="modalDate">Event Details</h2>
                    <span class="close-modal" onclick="closeEventModal()">&times;</span>
                </div>
                <div class="modal-body">
                    <div id="eventDetailsContent">
                        <!-- Event details will be loaded here -->
                    </div>
                </div>
            </div>
        </div>

        <!-- Pass event dates from server to client -->
        <script type="text/javascript">
            // Event dates will be injected here by the server
            window.eventScheduleDates = <%= GetEventDatesJson() %>;
        </script>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                // Get events from hidden field (this is the only way we'll get events now)
                let eventData = [];
                try {
                    const hiddenData = document.getElementById('<%= hiddenEventData.ClientID %>').value;
                    if (hiddenData && hiddenData !== '[]' && hiddenData !== '') {
                        eventData = JSON.parse(hiddenData);
                    }
                } catch (e) {
                    console.error("Error parsing events:", e);
                    eventData = [];
                }

                const today = new Date().toISOString().split('T')[0];
                const eventsList = document.getElementById("eventsList");

                // Clear old items
                eventsList.innerHTML = "";

                // Process events and highlight dates for today
                const todayEvents = eventData.filter(ev => ev.Date === today);

                if (todayEvents.length === 0) {
                    eventsList.innerHTML = "<li>No events scheduled</li>";
                } else {
                    todayEvents.forEach(ev => {
                        const li = document.createElement("li");
                        li.innerHTML = `
                            <div><strong>Event Name:</strong> ${ev.Name}</div>
                            <div><strong>Event Description:</strong> ${ev.Description}</div>
                            <div><strong>Category:</strong> ${ev.Category}</div>
                        `;

                        // Add category styling
                        if (ev.Category === "Deadline") {
                            li.classList.add("deadline-event");
                        } else if (ev.Category === "Meeting") {
                            li.classList.add("meeting-event");
                        } else if (ev.Category === "Assessment") {
                            li.classList.add("assessment-event");
                        }

                        eventsList.appendChild(li);
                    });
                }

                // Custom Calendar rendering logic
                let currentCalendarDate = new Date();
                const calendarGrid = document.querySelector(".calendar-grid");
                const currentMonthYear = document.getElementById("monthYear");
                const prevMonthBtn = document.getElementById("prevMonth");
                const nextMonthBtn = document.getElementById("nextMonth");

                // Initialize the selected date
                let selectedDate = `${currentCalendarDate.getFullYear()}-${String(currentCalendarDate.getMonth() + 1).padStart(2, '0')}-${String(currentCalendarDate.getDate()).padStart(2, '0')}`;

                // Function to render the calendar grid
                function renderCustomCalendar() {
                    const year = currentCalendarDate.getFullYear();
                    const month = currentCalendarDate.getMonth();
                    const firstDay = new Date(year, month, 1);
                    const lastDay = new Date(year, month + 1, 0);

                    // Clear existing days (keep headers)
                    const dayHeaders = calendarGrid.querySelectorAll('.day-header');
                    calendarGrid.innerHTML = '';
                    dayHeaders.forEach(header => calendarGrid.appendChild(header));

                    // Empty cells before the 1st of the month
                    for (let i = 0; i < firstDay.getDay(); i++) {
                        const emptyDiv = document.createElement("div");
                        emptyDiv.className = "calendar-day empty";
                        calendarGrid.appendChild(emptyDiv);
                    }

                    // Date cells
                    for (let d = 1; d <= lastDay.getDate(); d++) {
                        const dateStr = `${year}-${String(month + 1).padStart(2, '0')}-${String(d).padStart(2, '0')}`;
                        const hasEvents = window.eventScheduleDates && window.eventScheduleDates.includes(dateStr);

                        const dayDiv = document.createElement("div");
                        dayDiv.className = "calendar-day";
                        dayDiv.setAttribute("data-date", dateStr);
                        dayDiv.innerHTML = `<span>${d}</span>`;

                        // Highlight today
                        const isToday =
                            d === new Date().getDate() &&
                            month === new Date().getMonth() &&
                            year === new Date().getFullYear();

                        if (isToday) {
                            dayDiv.classList.add("today");
                        }

                        if (hasEvents) {
                            dayDiv.classList.add("has-event");

                            // Add event dot
                            const dot = document.createElement("div");
                            dot.classList.add("event-dot");
                            dayDiv.appendChild(dot);
                            dayDiv.title = "Click to view events";
                        }

                        // Highlight selected date
                        if (dateStr === selectedDate) {
                            dayDiv.classList.add("selected");
                        }

                        // Clickable date if has events
                        if (hasEvents) {
                            dayDiv.addEventListener("click", () => {
                                selectedDate = dateStr;
                                renderCustomCalendar();
                                getEventDetails(dateStr);
                            });
                        }

                        calendarGrid.appendChild(dayDiv);
                    }

                    // Update month-year heading
                    currentMonthYear.textContent = currentCalendarDate.toLocaleString("default", {
                        month: "long",
                        year: "numeric"
                    });
                }

                // Event navigation for previous and next month
                prevMonthBtn.addEventListener("click", () => {
                    currentCalendarDate.setMonth(currentCalendarDate.getMonth() - 1);
                    renderCustomCalendar();
                });

                nextMonthBtn.addEventListener("click", () => {
                    currentCalendarDate.setMonth(currentCalendarDate.getMonth() + 1);
                    renderCustomCalendar();
                });

                // Initial calendar render
                renderCustomCalendar();
            });

            // Modal functions
            function showEventModal(date, eventDetails) {
                document.getElementById('modalDate').innerText = 'Events on ' + date;
                document.getElementById('eventDetailsContent').innerHTML = eventDetails;
                document.getElementById('eventDetailsModal').style.display = 'block';
                document.body.style.overflow = 'hidden';
            }

            function closeEventModal() {
                document.getElementById('eventDetailsModal').style.display = 'none';
                document.body.style.overflow = 'auto';
            }

            // Close modal when clicking outside
            $(document).ready(function () {
                $('#eventDetailsModal').on('click', function (e) {
                    if (e.target === this) {
                        closeEventModal();
                    }
                });
            });

            // AJAX function to get event details
            function getEventDetails(dateString) {
                showLoadingModal();

                $.ajax({
                    type: "POST",
                    url: "Student_Dashboard.aspx/GetEventDetailsForDate",
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
                        showEventModal(formattedDate, response.d);
                    },
                    error: function (xhr, status, error) {
                        console.error('AJAX Error:', error);
                        showEventModal('Error', '<p>Unable to load event details. Please try again later.</p>');
                    }
                });
            }

            function showLoadingModal() {
                const loadingHtml = `
                    <div class="loading-container">
                        <div class="loading-spinner"></div>
                        <p>Loading event details...</p>
                    </div>
                `;
                showEventModal('Loading...', loadingHtml);
            }
        </script>
           
   
<div class="slider-wrapper">
  <div class="slider-track" id="sliderTrack">
    <div class="slide" style="background-image: url('images/img1.jpg')">
      <div class="overlay">
        <div class="subject-label">Development with Java</div>
        <a href="CourseDashboard.aspx" class="view-button">View Details</a>
      </div>
    </div>
    <div class="slide" style="background-image: url('images/img2.jpg')">
      <div class="overlay">
        <div class="subject-label">SQL Learning</div>
        <a href="CourseDashboard.aspx" class="view-button">View Details</a>
      </div>
    </div>
    <div class="slide" style="background-image: url('images/img3.jpg')">
      <div class="overlay">
        <div class="subject-label">Web Applications</div>
        <a href="CourseDashboard.aspx" class="view-button">View Details</a>
      </div>
    </div>
    <div class="slide" style="background-image: url('images/img4.jpg')">
      <div class="overlay">
        <div class="subject-label">Programming with Python</div>
        <a href="CourseDashboard.aspx" class="view-button">View Details</a>
      </div>
    </div>
  </div>
</div>


<script>
    const slides = document.querySelectorAll('.slide');
    let currentIndex = 0;

    function showSlide(index) {
        slides.forEach((slide, i) => {
            slide.classList.remove('active');
            if (i === index) {
                slide.classList.add('active');
            }
        });
    }

    function nextSlide() {
        currentIndex = (currentIndex + 1) % slides.length;
        showSlide(currentIndex);
    }

    // Initial display
    showSlide(currentIndex);

    // Change slide every 4 seconds
    setInterval(nextSlide, 4000);
</script>

<!-- Chart Container with Enhanced Features -->
<div id="chartContainer" style="margin-top: 40px; background: #fff; height: 500px; width: 1200px; padding: 20px; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); overflow: hidden; z-index: 0; position: relative;border: 2px solid #007BFF; /* small blue border */; box-shadow: 0 6px 12px rgba(0, 123, 255, 0.2), 0 4px 8px rgba(0,0,0,0.1);">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; width: 900px;">
        <h3 style="font-size: 18px; color: #333; margin: 0;">Student Performance Overview</h3>
        <select id="yearSelector" onchange="updateChart()" style="padding: 5px 10px; font-size: 14px; border-radius: 4px; border: 1px solid #ddd;">
            <option value="2024-2025">2024 - 2025</option>
            <option value="2023-2024">2023 - 2024</option>
            <option value="2022-2023">2022 - 2023</option>
        </select>
    </div>
    <div style="width: 100%; overflow-x: auto; padding-bottom: 10px;">
        <canvas id="studentPerformanceChart" width="1200" height="400"></canvas>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const ctx = document.getElementById('studentPerformanceChart').getContext('2d');
    let studentPerformanceChart;

    // Mock data for different years
    const chartDataByYear = {
        "2022-2023": {
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
            assessmentScores: [72, 78, 81, 75, 70, 85, 88, 82, 79, 84, 87, 90],
            logins: [8, 10, 9, 12, 11, 13, 15, 14, 12, 16, 15, 18]
        },
        "2023-2024": {
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
            assessmentScores: [80, 82, 79, 88, 91, 85, 87, 89, 86, 92, 90, 94],
            logins: [10, 12, 11, 14, 13, 15, 16, 15, 14, 17, 16, 19]
        },
        "2024-2025": {
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
            assessmentScores: [85, 89, 87, 90, 92, 91, 93, 94, 92, 95, 94, 96],
            logins: [12, 14, 13, 16, 15, 17, 18, 17, 16, 19, 18, 20]
        }
    };

    function createChart(year) {
        const data = chartDataByYear[year];
        const isDark = document.body.classList.contains('dark-theme'); // detect dark mode

        if (studentPerformanceChart) {
            studentPerformanceChart.destroy();
        }

        studentPerformanceChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: data.labels,
                datasets: [
                    {
                        label: 'Avg. Assessment Score',
                        data: data.assessmentScores,
                        fill: {
                            target: 'origin',
                            above: 'rgba(54, 162, 235, 0.1)'
                        },
                        borderColor: '#36A2EB',
                        backgroundColor: '#36A2EB',
                        tension: 0.3,
                        borderWidth: 2,
                        pointRadius: 4
                    },
                    {
                        label: 'Avg. Logins',
                        data: data.logins,
                        fill: {
                            target: 'origin',
                            above: 'rgba(255, 99, 132, 0.1)'
                        },
                        borderColor: '#0d1b4c',
                        backgroundColor: '#1e2d6d',
                        tension: 0.3,
                        borderWidth: 2,
                        pointRadius: 4
                    }
                ]
            },
            options: {
                responsive: false,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'top',
                        labels: {
                            color: isDark ? '#ffffff' : '#333333', // legend text color
                            boxWidth: 12,
                            padding: 10,
                            font: {
                                size: 12
                            }
                        }
                    },
                    tooltip: {
                        mode: 'index',
                        intersect: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: false,
                        ticks: {
                            color: isDark ? '#ffffff' : '#333333', // Y-axis labels
                            font: {
                                size: 11
                            }
                        },
                        title: {
                            display: true,
                            text: 'Value',
                            color: isDark ? '#ffffff' : '#333333', // Y-axis title
                            font: {
                                size: 12
                            }
                        }
                    },
                    x: {
                        ticks: {
                            color: isDark ? '#ffffff' : '#333333', // X-axis labels
                            font: {
                                size: 11
                            }
                        },
                        title: {
                            display: true,
                            text: 'Month',
                            color: isDark ? '#ffffff' : '#333333', // X-axis title
                            font: {
                                size: 12
                            }
                        }
                    }
                }
            }
        });
    }

    // Update chart when year changes
    function updateChart() {
        const selectedYear = document.getElementById('yearSelector').value;
        createChart(selectedYear);
    }

    // Keyboard navigation
    document.addEventListener('keydown', (e) => {
        const chartContainer = document.querySelector('#chartContainer div');
        if (e.key === 'ArrowLeft') {
            chartContainer.scrollBy({ left: -100, behavior: 'smooth' });
        } else if (e.key === 'ArrowRight') {
            chartContainer.scrollBy({ left: 100, behavior: 'smooth' });
        }
    });

    // Initialize
    window.addEventListener('load', () => {
        updateChart(); // Initialize the chart after everything is loaded
    });
</script>

        </div>
    </div>
</div>

    </form>
</body>
</html>