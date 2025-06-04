// All interactive scripts for course.aspx

$(document).ready(function () {
    // Settings dropdown logic
    const $settingsBtn = $('#settingsBtn');
    const $settingsMenu = $('#settingsMenu');
    const $themeToggle = $('#themeToggle');
    const $themeIcon = $themeToggle && $themeToggle.find('i');
    let darkMode = false;

    // SETTINGS DROPDOWN BEHAVIOR & STYLING
    $settingsBtn.on('click', function (e) {
        e.stopPropagation();
        $settingsMenu.toggle();
        $(this).toggleClass('open');
    });

    // Hide dropdown if click outside
    $(document).on('click', function (e) {
        if (!$(e.target).closest('#settingsBtn').length) {
            $settingsBtn.removeClass('open');
            $settingsMenu.hide();
        }
    });

    // Prevent close if clicking inside dropdown
    $settingsMenu.on('click', function (e) {
        e.stopPropagation();
    });

    // THEME TOGGLE (optional)
    if ($themeToggle && $themeIcon) {
        $themeToggle.on('click', function () {
            $('body').toggleClass('dark-mode');
            darkMode = !darkMode;
            $themeIcon
                .removeClass(darkMode ? 'fa-sun' : 'fa-moon')
                .addClass(darkMode ? 'fa-moon' : 'fa-sun');
        });
    }

    // Hamburger toggle
    const hamburger = $('#hamburgerBtn');
    const hamburgerMenu = $('#hamburgerMenu');
    hamburger.on('click', function (e) {
        e.stopPropagation();
        $(this).toggleClass('active');
        hamburgerMenu.slideToggle(200);
    });

    $(document).on('click', function (e) {
        if (!hamburger.is(e.target) && hamburger.has(e.target).length === 0) {
            hamburger.removeClass('active');
            hamburgerMenu.slideUp(200);
        }
    });

    hamburgerMenu.on('click', function (e) {
        e.stopPropagation();
    });

    // Navbar user info
    $("#navbarFirstName").text($('#navbarFirstName').text() || 'User');
    $("#navbarProfilePic").attr("src", $("#navbarProfilePic").attr("src") || 'Images/Profile/default.jpg');
});

// Custom Calendar Variables
let currentDate = new Date();
let classScheduleDates = [];

// Initialize custom calendar
function initializeCustomCalendar() {
    // Get class dates from server-side variable
    if (typeof window.classScheduleDates !== 'undefined') {
        classScheduleDates = window.classScheduleDates || [];
    }

    renderCalendar();

    // Add event listeners for navigation
    const prevBtn = document.getElementById('prevMonth');
    const nextBtn = document.getElementById('nextMonth');

    if (prevBtn) {
        prevBtn.addEventListener('click', function () {
            currentDate.setMonth(currentDate.getMonth() - 1);
            renderCalendar();
        });
    }

    if (nextBtn) {
        nextBtn.addEventListener('click', function () {
            currentDate.setMonth(currentDate.getMonth() + 1);
            renderCalendar();
        });
    }
}

// Render the calendar
function renderCalendar() {
    const monthYear = document.getElementById('monthYear');
    const calendarGrid = document.querySelector('.calendar-grid');

    if (!monthYear || !calendarGrid) {
        console.error('Calendar elements not found');
        return;
    }

    // Clear existing days (keep headers)
    const dayElements = calendarGrid.querySelectorAll('.day-cell');
    dayElements.forEach(el => el.remove());

    // Set month/year display
    const months = ['January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'];
    monthYear.textContent = `${months[currentDate.getMonth()]} ${currentDate.getFullYear()}`;

    // Get first day of month and number of days
    const firstDay = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
    const lastDay = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0);
    const startDay = firstDay.getDay(); // 0 = Sunday
    const numDays = lastDay.getDate();

    // Add empty cells for days before month starts
    for (let i = 0; i < startDay; i++) {
        const emptyCell = document.createElement('div');
        emptyCell.className = 'day-cell empty';
        calendarGrid.appendChild(emptyCell);
    }

    // Add days of the month
    for (let day = 1; day <= numDays; day++) {
        const dayCell = document.createElement('div');
        dayCell.className = 'day-cell';
        dayCell.textContent = day;

        // Check if this date has classes
        const dateString = `${currentDate.getFullYear()}-${String(currentDate.getMonth() + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`;

        if (classScheduleDates.includes(dateString)) {
            dayCell.classList.add('has-class');
            dayCell.style.cursor = 'pointer';
            dayCell.title = 'Click to view class details';

            // Add click event
            dayCell.addEventListener('click', function () {
                getClassDetails(dateString);
            });

            // Add hover effects
            dayCell.addEventListener('mouseenter', function () {
                this.style.transform = 'scale(1.1)';
                this.style.transition = 'all 0.3s ease';
            });

            dayCell.addEventListener('mouseleave', function () {
                this.style.transform = 'scale(1)';
            });
        }

        // Highlight today
        const today = new Date();
        if (currentDate.getFullYear() === today.getFullYear() &&
            currentDate.getMonth() === today.getMonth() &&
            day === today.getDate()) {
            dayCell.classList.add('today');
        }

        calendarGrid.appendChild(dayCell);
    }
}

// Modal Functions
function showClassModal(date, classDetails) {
    const modal = document.getElementById('classDetailsModal');
    const modalDate = document.getElementById('modalDate');
    const modalContent = document.getElementById('classDetailsContent');

    if (modal && modalDate && modalContent) {
        modalDate.textContent = 'Classes on ' + date;
        modalContent.innerHTML = classDetails;
        modal.style.display = 'block';
        document.body.style.overflow = 'hidden';

        // Add entrance animation
        modal.style.animation = 'fadeInModal 0.3s ease-out';
        const content = modal.querySelector('.modal-content');
        if (content) {
            content.style.animation = 'slideInModal 0.4s ease-out';
        }
    }
}

function closeClassModal() {
    const modal = document.getElementById('classDetailsModal');
    if (modal) {
        modal.style.display = 'none';
        document.body.style.overflow = 'auto';
    }
}

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
            let errorMessage = '<p>Unable to load class details. Please try again later.</p>';

            if (xhr.status === 500) {
                errorMessage = '<p>Server error occurred. Please contact support if this continues.</p>';
            } else if (xhr.status === 401) {
                errorMessage = '<p>Your session has expired. Please <a href="login.aspx">login again</a>.</p>';
            }

            showClassModal('Error', errorMessage);
        }
    });
}

// Loading modal for better UX
function showLoadingModal() {
    const loadingHtml = `
        <div class="loading-container">
            <div class="loading-spinner"></div>
            <p>Loading class details...</p>
        </div>
    `;
    showClassModal('Loading...', loadingHtml);
}

// Close modal when clicking outside or pressing Escape
document.addEventListener('DOMContentLoaded', function () {
    const modal = document.getElementById('classDetailsModal');

    if (modal) {
        // Close when clicking outside
        modal.addEventListener('click', function (e) {
            if (e.target === modal) {
                closeClassModal();
            }
        });

        // Close with Escape key
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' && modal.style.display === 'block') {
                closeClassModal();
            }
        });
    }

    // Add loading CSS if not already present
    addLoadingCSS();
});

// Stats & animated headings (existing functionality)
let statsAnimated = false;
let headingAnimated = false;
let circlesAnimated = false;

function isInView(element) {
    if (!element) return false;
    const rect = element.getBoundingClientRect();
    return rect.top < window.innerHeight && rect.bottom >= 0;
}

function startCountUp() {
    const counters = document.querySelectorAll(".count-up");
    counters.forEach(counter => {
        const target = +counter.getAttribute("data-count");
        let count = 0;
        const duration = 2000;
        const increment = target / (duration / 60);

        const updateCount = () => {
            count += increment;
            if (count < target) {
                counter.innerText = Math.floor(count);
                requestAnimationFrame(updateCount);
            } else {
                counter.innerText = target;
            }
        };
        updateCount();
    });
}

function animateCircles() {
    const circles = document.querySelectorAll(".circle");
    circles.forEach((circle, index) => {
        setTimeout(() => {
            circle.style.animation = "circleAppear 1s ease-out forwards";
        }, index * 300);
    });
}

function triggerAnimations() {
    const heading = document.getElementById("typewriter");
    if (!headingAnimated && heading && isInView(heading)) {
        heading.classList.add("typing");
        headingAnimated = true;
        setTimeout(() => {
            if (!statsAnimated) {
                startCountUp();
                statsAnimated = true;
            }
            setTimeout(() => {
                if (!circlesAnimated) {
                    animateCircles();
                    circlesAnimated = true;
                }
            }, 2000);
        }, 3000);
    }
}

window.addEventListener("scroll", triggerAnimations);

// Course cards animation
document.addEventListener("DOMContentLoaded", function () {
    const heading = document.getElementById("yourCoursesHeading");
    if (heading) heading.style.opacity = "1";

    setTimeout(() => {
        const buttons = document.getElementById("coursesActions");
        if (buttons) buttons.style.opacity = "1";
    }, 300);

    const cardsWrapper = document.getElementById("courseCardsWrapper");
    if (!cardsWrapper) return;

    cardsWrapper.style.opacity = "1";
    cardsWrapper.style.transform = "none";

    const cards = cardsWrapper.querySelectorAll('.course-card');
    if (cards.length === 0) return;

    cards.forEach(card => {
        card.classList.remove('animate-card');
        card.style.opacity = "0";
        card.style.animation = "none";
    });

    function animateCards(entries, observer) {
        entries.forEach((entry, idx) => {
            if (entry.isIntersecting) {
                const card = entry.target;
                if (!card.classList.contains('animate-card')) {
                    card.classList.add('animate-card');
                    card.style.animation = `cardFlipIn 1.2s cubic-bezier(0.175, 0.885, 0.32, 1.275) forwards`;
                    const delay = Array.from(cards).indexOf(card) * 0.18;
                    card.style.animationDelay = `${delay}s`;
                    observer.unobserve(card);
                }
            }
        });
    }

    const observer = new IntersectionObserver(animateCards, { threshold: 0.2 });
    cards.forEach(card => observer.observe(card));
});

// Enhanced particle effect
function random(min, max) {
    return Math.random() * (max - min) + min;
}

function createParticles(container, count) {
    if (!container) return;

    for (let i = 0; i < count; i++) {
        let p = document.createElement('div');
        p.className = 'particle';
        let s = random(8, 28);
        p.style.width = s + 'px';
        p.style.height = s + 'px';
        p.style.left = random(0, 90) + '%';
        p.style.top = random(0, 90) + '%';
        p.style.opacity = random(0.13, 0.22);
        p.style.animationDuration = random(2, 5) + 's';
        p.style.animationDelay = random(0, 1.5) + 's';
        container.appendChild(p);
    }
}

document.addEventListener("DOMContentLoaded", function () {
    var particles = document.querySelector('.welcome-box-container .particles');
    if (particles) createParticles(particles, 13);
});

// Transparent nav on scroll
$(window).on('scroll', function () {
    if ($(window).scrollTop() > 18) {
        $('.settings-container').addClass('scrolled');
    } else {
        $('.settings-container').removeClass('scrolled');
    }
});

// Add loading spinner CSS dynamically
function addLoadingCSS() {
    if (!document.querySelector('#loadingCSS')) {
        const style = document.createElement('style');
        style.id = 'loadingCSS';
        style.textContent = `
            .loading-container {
                text-align: center;
                padding: 40px 20px;
                color: #3c40c1;
            }

            .loading-spinner {
                border: 4px solid #f3f3f3;
                border-top: 4px solid #3c40c1;
                border-radius: 50%;
                width: 50px;
                height: 50px;
                animation: spin 1s linear infinite;
                margin: 0 auto 20px;
            }

            @keyframes spin {
                0% { transform: rotate(0deg); }
                100% { transform: rotate(360deg); }
            }

            body.dark-mode .loading-container {
                color: #59bbff;
            }

            body.dark-mode .loading-spinner {
                border: 4px solid #23263a;
                border-top: 4px solid #59bbff;
            }
        `;
        document.head.appendChild(style);
    }
}