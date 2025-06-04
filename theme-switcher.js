// Theme-switcher.js with enhanced input and search field support

// Initialize theme from localStorage or default to light
function initializeTheme() {
    // Check if theme is stored in localStorage
    const savedTheme = localStorage.getItem('theme');

    // Apply saved theme or default to light
    if (savedTheme === 'dark') {
        document.documentElement.setAttribute('data-theme', 'dark');
        // Update settings theme switcher if it exists
        updateSettingsThemeSwitcher(true);
    } else {
        document.documentElement.setAttribute('data-theme', 'light');
        // Update settings theme switcher if it exists
        updateSettingsThemeSwitcher(false);
    }

    // Ensure theme is applied to all components immediately
    applyThemeToElements();
}

// Helper function to update the settings theme switcher
function updateSettingsThemeSwitcher(isDark) {
    // Update settings page switcher if it exists
    const settingsSwitcher = document.getElementById('settingsThemeSwitcher');
    if (settingsSwitcher) {
        settingsSwitcher.checked = isDark;
        // Also update the text label next to the switcher
        const themeModeText = document.getElementById('themeModeText');
        if (themeModeText) {
            themeModeText.textContent = isDark ? 'Dark Mode' : 'Light Mode';
        }
    }
}

// Add this to your theme-switcher.js file

// Enhanced function to force white text in sidebar buttons
function fixSidebarButtonColors() {
    // Target all sidebar buttons
    const sidebarButtons = document.querySelectorAll('.sidebar-menu .cssbuttons-io');

    sidebarButtons.forEach(button => {
        // Force white color on the button itself
        button.style.color = 'white';

        // Force white on any span elements (which contain the text)
        const spans = button.querySelectorAll('span');
        spans.forEach(span => {
            // Direct inline style (highest priority)
            span.style.setProperty('color', 'white', 'important');

            // Also set all child elements to white
            const children = span.querySelectorAll('*');
            children.forEach(child => {
                child.style.setProperty('color', 'white', 'important');
            });
        });

        // Force white on any SVG elements
        const svgs = button.querySelectorAll('svg');
        svgs.forEach(svg => {
            svg.style.setProperty('color', 'white', 'important');
            svg.style.setProperty('fill', 'white', 'important');

            // Set all paths within SVGs
            const paths = svg.querySelectorAll('path');
            paths.forEach(path => {
                path.style.setProperty('fill', 'currentColor', 'important');
            });
        });
    });
}

// Make sure this runs whenever theme changes
const originalToggleTheme = toggleTheme;
toggleTheme = function () {
    // Call the original function
    originalToggleTheme.apply(this, arguments);

    // Then force our fix
    setTimeout(fixSidebarButtonColors, 50);
};

// Run this immediately and also on DOM load
fixSidebarButtonColors();
document.addEventListener('DOMContentLoaded', function () {
    fixSidebarButtonColors();

    // Run it again after a short delay to handle any race conditions
    setTimeout(fixSidebarButtonColors, 200);

    // Also run it on resize as some frameworks re-render on resize
    window.addEventListener('resize', function () {
        setTimeout(fixSidebarButtonColors, 50);
    });
});

// Also attach to any page interaction to ensure persistence
document.addEventListener('click', function () {
    setTimeout(fixSidebarButtonColors, 50);
});

// Call this function on initial load
document.addEventListener('DOMContentLoaded', function () {
    fixSidebarButtonColors();

    // Also run it when theme changes
    const observer = new MutationObserver(function (mutations) {
        mutations.forEach(function (mutation) {
            if (mutation.attributeName === 'data-theme') {
                fixSidebarButtonColors();
            }
        });
    });

    observer.observe(document.documentElement, { attributes: true });
});


// Toggle between light and dark themes
function toggleTheme() {
    const currentTheme = document.documentElement.getAttribute('data-theme');
    const newIsDark = currentTheme === 'light';

    if (newIsDark) {
        document.documentElement.setAttribute('data-theme', 'dark');
        localStorage.setItem('theme', 'dark');
    } else {
        document.documentElement.setAttribute('data-theme', 'light');
        localStorage.setItem('theme', 'light');
    }

    // Update settings theme switcher
    updateSettingsThemeSwitcher(newIsDark);

    // Apply theme to all elements after toggling
    applyThemeToElements();
    fixSidebarButtonColors();
}

// Apply theme immediately to prevent flash of wrong theme
(function () {
    initializeTheme();
})();

// Set up event listeners when DOM is ready
document.addEventListener('DOMContentLoaded', function () {
    // Add event listener to theme switcher in settings page
    const settingsThemeSwitcher = document.getElementById('settingsThemeSwitcher');
    if (settingsThemeSwitcher) {
        settingsThemeSwitcher.addEventListener('change', function () {
            toggleTheme();
        });
    }

    // Make sure all elements have proper theming
    applyThemeToElements();

    // Apply specific styles based on current page
    if (document.querySelector('.dashboard-cards')) {
        applyThemeToDashboardComponents();
    }

    if (document.querySelector('.feedback-container')) {
        applyThemeToFeedbackComponents();
    }
});

// Function to apply theme to specific element types that might be hard-coded
function applyThemeToElements() {
    // Check current theme
    const isDarkMode = document.documentElement.getAttribute('data-theme') === 'dark';

    // Force correct text colors for various elements that might have hardcoded colors
    if (isDarkMode) {
        // Fix any elements that might have hardcoded colors
        document.querySelectorAll('p, span, div, h1, h2, h3, h4, h5, h6, th, td, label').forEach(el => {
            // Skip elements with explicit theme colors or elements inside the theme switcher
            if (!el.classList.contains('theme-icon') && !el.classList.contains('fa') &&
                !el.classList.contains('fas') && !el.classList.contains('far')) {

                const style = window.getComputedStyle(el);
                // Only fix if the color is close to black (RGB < 50)
                const color = style.color;
                const rgb = color.match(/\d+/g);

                if (rgb && rgb.length >= 3) {
                    const r = parseInt(rgb[0]);
                    const g = parseInt(rgb[1]);
                    const b = parseInt(rgb[2]);

                    // If color is close to black, change it to the theme's text color
                    if (r < 50 && g < 50 && b < 50) {
                        el.style.color = 'var(--text-color)';
                    }
                }
            }
        });
    }

    // Apply theme to all input elements, search fields and selects
    applyThemeToInputElements();

    // Apply theme to page-specific elements
    applyThemeToSettingsElements();

    // Apply theme to all pages with feedback-specific components
    if (document.querySelector('.feedback-container')) {
        applyThemeToFeedbackComponents();
    }

    // Apply theme to all pages with dashboard cards
    if (document.querySelector('.dashboard-cards')) {
        applyThemeToDashboardComponents();
    }
}

// Apply theme to all input elements (global)
function applyThemeToInputElements() {
    // Apply theme to all standard input elements
    document.querySelectorAll('input, select, textarea').forEach(input => {
        if (input.type !== 'checkbox' && input.type !== 'radio' && input.type !== 'submit' && input.type !== 'button') {
            input.style.backgroundColor = 'var(--input-bg)';
            input.style.color = 'var(--input-text)';
            input.style.borderColor = 'var(--input-border)';
        }
    });

    // Target specific search inputs and dropdowns that might be styled differently
    document.querySelectorAll('input[type="text"], input[type="search"]').forEach(input => {
        input.style.backgroundColor = 'var(--input-bg)';
        input.style.color = 'var(--input-text)';
        input.style.borderColor = 'var(--input-border)';
    });

    // Handle select elements
    document.querySelectorAll('select').forEach(select => {
        select.style.backgroundColor = 'var(--input-bg)';
        select.style.color = 'var(--input-text)';
        select.style.borderColor = 'var(--input-border)';
    });

    // Handle specific IDs
    const searchInput = document.getElementById('txtSearch');
    if (searchInput) {
        searchInput.style.backgroundColor = 'var(--input-bg)';
        searchInput.style.color = 'var(--input-text)';
        searchInput.style.borderColor = 'var(--input-border)';
    }

    const categoryDropdown = document.getElementById('ddlCategories');
    if (categoryDropdown) {
        categoryDropdown.style.backgroundColor = 'var(--input-bg)';
        categoryDropdown.style.color = 'var(--input-text)';
        categoryDropdown.style.borderColor = 'var(--input-border)';
    }
}

// Function to apply theme to settings page elements
function applyThemeToSettingsElements() {
    // Apply theme to settings containers
    document.querySelectorAll('.settings-form-container').forEach(container => {
        container.style.backgroundColor = 'var(--card-bg-color)';
        container.style.boxShadow = '0px 0px 15px var(--shadow-color)';
    });

    // Apply theme to form controls
    document.querySelectorAll('.form-control').forEach(input => {
        input.style.backgroundColor = 'var(--input-bg)';
        input.style.color = 'var(--input-text)';
        input.style.borderColor = 'var(--input-border)';
    });

    // Apply theme to text elements
    document.querySelectorAll('.settings-title, .form-label').forEach(text => {
        text.style.color = 'var(--text-color)';
    });

    document.querySelectorAll('.settings-subtitle, .admin-role').forEach(text => {
        text.style.color = 'var(--text-muted)';
    });

    // Apply theme to dividers
    document.querySelectorAll('.divider').forEach(divider => {
        divider.style.borderTopColor = 'var(--border-color)';
    });
}

// Special function to handle dashboard-specific components
function applyThemeToDashboardComponents() {
    // Explicitly apply theme to dashboard cards
    document.querySelectorAll('.dashboard-card').forEach(card => {
        card.style.backgroundColor = 'var(--card-bg-color)';
        card.style.boxShadow = '0px 0px 10px var(--shadow-color)';
    });

    // Force all text elements to use theme colors
    document.querySelectorAll('.card-content h3, .page-title, .admin-name, .welcome-message p').forEach(el => {
        el.style.color = 'var(--text-color)';
    });

    document.querySelectorAll('.admin-role, .card-header span, .card-header i').forEach(el => {
        el.style.color = 'var(--text-muted)';
    });
}

// Special function to handle feedback-specific components
function applyThemeToFeedbackComponents() {
    // Apply theme to feedback container
    document.querySelectorAll('.feedback-container').forEach(container => {
        container.style.backgroundColor = 'var(--card-bg-color)';
        container.style.boxShadow = '0px 0px 15px var(--shadow-color)';
    });

    // Apply theme to search and filter inputs
    document.querySelectorAll('.search-box, .dropdown-filter, #txtSearch, #ddlCategories').forEach(input => {
        if (input) {
            input.style.backgroundColor = 'var(--input-bg)';
            input.style.color = 'var(--input-text)';
            input.style.borderColor = 'var(--input-border)';
        }
    });

    // Apply theme to table elements
    document.querySelectorAll('.feedback-table th').forEach(header => {
        header.style.backgroundColor = 'var(--panel-header-bg)';
        header.style.borderBottomColor = 'var(--border-color)';
        header.style.color = 'var(--text-color)';
    });

    document.querySelectorAll('.feedback-table td').forEach(cell => {
        cell.style.borderBottomColor = 'var(--border-color)';
        cell.style.color = 'var(--text-color)';
    });

    // Apply theme to feedback modal
    const modalContent = document.querySelector('.modal-content');
    if (modalContent) {
        modalContent.style.backgroundColor = 'var(--card-bg-color)';
        modalContent.style.boxShadow = '0px 5px 15px var(--shadow-color)';
    }

    document.querySelectorAll('.modal-title, .detail-value').forEach(text => {
        text.style.color = 'var(--text-color)';
    });

    document.querySelectorAll('.detail-label, .close-btn').forEach(text => {
        text.style.color = 'var(--text-muted)';
    });

    const feedbackContent = document.getElementById('feedbackContent');
    if (feedbackContent) {
        feedbackContent.style.backgroundColor = 'var(--hover-bg)';
        feedbackContent.style.color = 'var(--text-color)';
    }

    // Apply theme to user info elements
    document.querySelectorAll('.user-name').forEach(name => {
        name.style.color = 'var(--text-color)';
    });

    document.querySelectorAll('.user-email').forEach(email => {
        email.style.color = 'var(--text-muted)';
    });
}

// Apply theme to sidebar (common in all admin pages)
function applyThemeToSidebar() {
    // Explicitly apply theme to sidebar
    const sidebar = document.querySelector('.sidebar');
    if (sidebar) {
        sidebar.style.backgroundColor = 'var(--card-bg-color)';
        sidebar.style.boxShadow = '0px 0px 15px var(--shadow-color)';
    }

    // Apply theme to notification dropdown
    const notificationDropdown = document.querySelector('.notification-dropdown');
    if (notificationDropdown) {
        notificationDropdown.style.backgroundColor = 'var(--card-bg-color)';
        notificationDropdown.style.boxShadow = '0px 0px 15px var(--shadow-color)';
    }
}

// Reapply theme and fix element colors when page content changes
// This helps with AJAX updates or dynamically loaded content
const observer = new MutationObserver(function (mutations) {
    applyThemeToElements();
    applyThemeToSidebar();
});

// Start observing once DOM is loaded
document.addEventListener('DOMContentLoaded', function () {
    observer.observe(document.body, { childList: true, subtree: true });

    // Apply theme to sidebar initially
    applyThemeToSidebar();
});

function fixSearchAndDropdowns() {
    // Get all input elements and selects on the page
    const inputs = document.querySelectorAll('input[type="text"], input[type="search"]');
    const selects = document.querySelectorAll('select');

    // Force the right background and text color for inputs
    inputs.forEach(input => {
        input.style.backgroundColor = 'var(--input-bg)';
        input.style.color = 'var(--input-text)';
        input.style.borderColor = 'var(--input-border)';
    });

    // Force the right background and text color for selects/dropdowns
    selects.forEach(select => {
        select.style.backgroundColor = 'var(--input-bg)';
        select.style.color = 'var(--input-text)';
        select.style.borderColor = 'var(--input-border)';
    });

    // Specifically target the feedback page elements by ID
    const searchBox = document.getElementById('txtSearch');
    if (searchBox) {
        searchBox.style.backgroundColor = 'var(--card-bg-color)';
        searchBox.style.color = 'var(--text-color)';
    }

    const categoryDropdown = document.getElementById('ddlCategories');
    if (categoryDropdown) {
        categoryDropdown.style.backgroundColor = 'var(--card-bg-color)';
        categoryDropdown.style.color = 'var(--text-color)';
    }
}

// Call this function directly when the theme changes
function toggleTheme() {
    const currentTheme = document.documentElement.getAttribute('data-theme');
    const newIsDark = currentTheme === 'light';

    if (newIsDark) {
        document.documentElement.setAttribute('data-theme', 'dark');
        localStorage.setItem('theme', 'dark');
    } else {
        document.documentElement.setAttribute('data-theme', 'light');
        localStorage.setItem('theme', 'light');
    }

    // Update settings theme switcher
    updateSettingsThemeSwitcher(newIsDark);

    // Apply theme to all elements after toggling
    applyThemeToElements();

    // Directly fix search and dropdown elements
    fixSearchAndDropdowns();
}

// Make sure this runs on initial load too
document.addEventListener('DOMContentLoaded', function () {
    fixSearchAndDropdowns();

    // Re-apply whenever a search input might be dynamically added
    const observer = new MutationObserver(function (mutations) {
        fixSearchAndDropdowns();
    });

    observer.observe(document.body, { childList: true, subtree: true });
});

function fixExportButtons() {
    if (document.documentElement.getAttribute('data-theme') === 'dark') {
        // Target by ID
        const exportButton = document.getElementById('btnExport');
        if (exportButton) {
            exportButton.style.backgroundColor = '#2a2d31';
            exportButton.style.color = '#9A7BCE';
            exportButton.style.borderColor = '#3a3d41';
        }

        // Target by class
        document.querySelectorAll('.export-button').forEach(button => {
            button.style.backgroundColor = '#2a2d31';
            button.style.color = '#9A7BCE';
            button.style.borderColor = '#3a3d41';
        });

        // Target by partial class name
        document.querySelectorAll('[class*="export"]').forEach(button => {
            button.style.backgroundColor = '#2a2d31';
            button.style.color = '#9A7BCE';
            button.style.borderColor = '#3a3d41';
        });

        // Target LinkButtons that might be export buttons
        document.querySelectorAll('a[id*="Export"], a[id*="export"]').forEach(link => {
            link.style.backgroundColor = '#2a2d31';
            link.style.color = '#9A7BCE';
            link.style.borderColor = '#3a3d41';
        });

        // Target ContentPlaceHolder variations
        document.querySelectorAll('#ContentPlaceHolder1_btnExport, #MainContent_btnExport').forEach(button => {
            button.style.backgroundColor = '#2a2d31';
            button.style.color = '#9A7BCE';
            button.style.borderColor = '#3a3d41';
        });
    }
}

// Add this line inside the applyThemeToCoursesPage function
function applyThemeToCoursesPage() {
    // Existing code...

    // Fix export buttons
    fixExportButtons();
}

// Also call it directly when theme changes
function toggleTheme() {
    // Existing code...

    // Fix export buttons
    fixExportButtons();
}

// Call on page load
document.addEventListener('DOMContentLoaded', function () {
    fixExportButtons();
    // Try again after a slight delay for buttons that might load dynamically
    setTimeout(fixExportButtons, 300);
});

function applyThemeToUsersPage() {
    // Check if we're on the users page
    if (!document.querySelector('.users-section')) return;

    // Apply theme to users container
    const usersSection = document.querySelector('.users-section');
    if (usersSection) {
        usersSection.style.backgroundColor = 'var(--card-bg-color)';
        usersSection.style.boxShadow = '0px 0px 15px var(--shadow-color)';
    }

    // Apply theme to search container and input
    const searchContainer = document.querySelector('.search-container');
    if (searchContainer) {
        searchContainer.style.backgroundColor = 'var(--input-bg)';
        searchContainer.style.borderColor = 'var(--input-border)';
    }

    const searchInput = document.getElementById('txtSearch');
    if (searchInput) {
        searchInput.style.backgroundColor = 'var(--input-bg)';
        searchInput.style.color = 'var(--input-text)';
    }

    // Apply theme to dropdowns
    const dropdowns = document.querySelectorAll('.filter-dropdown');
    dropdowns.forEach(dropdown => {
        dropdown.style.backgroundColor = 'var(--input-bg)';
        dropdown.style.color = 'var(--input-text)';
        dropdown.style.borderColor = 'var(--input-border)';
    });

    // Apply theme specifically to roles and status dropdowns
    const roleDropdown = document.getElementById('ddlRoles');
    if (roleDropdown) {
        roleDropdown.style.backgroundColor = 'var(--input-bg)';
        roleDropdown.style.color = 'var(--input-text)';
        roleDropdown.style.borderColor = 'var(--input-border)';
    }

    const statusDropdown = document.getElementById('ddlStatus');
    if (statusDropdown) {
        statusDropdown.style.backgroundColor = 'var(--input-bg)';
        statusDropdown.style.color = 'var(--input-text)';
        statusDropdown.style.borderColor = 'var(--input-border)';
    }

    // Apply theme to table
    document.querySelectorAll('.users-table th').forEach(header => {
        header.style.color = 'var(--text-color)';
        header.style.borderBottomColor = 'var(--border-color)';
    });

    document.querySelectorAll('.users-table td').forEach(cell => {
        cell.style.color = 'var(--text-color)';
        cell.style.borderBottomColor = 'var(--border-color)';
    });

    // Apply theme to user info text
    document.querySelectorAll('.user-name').forEach(name => {
        name.style.color = 'var(--text-color)';
    });

    document.querySelectorAll('.user-email').forEach(email => {
        email.style.color = 'var(--text-muted)';
    });

    // Apply theme to action buttons
    document.querySelectorAll('.action-button').forEach(btn => {
        btn.style.color = 'var(--text-muted)';
    });

    // Apply theme to export button
    const exportButton = document.getElementById('btnExport');
    if (exportButton) {
        exportButton.style.backgroundColor = 'var(--card-bg-color)';
        exportButton.style.color = 'var(--light-purple)';
        exportButton.style.borderColor = 'var(--border-color)';
    }

    // Apply theme to add user button
    const addButton = document.getElementById('btnAddUser');
    if (addButton) {
        addButton.style.backgroundColor = 'var(--light-purple)';
        addButton.style.color = 'white';
    }

    // Handle status badges
    const isDarkMode = document.documentElement.getAttribute('data-theme') === 'dark';

    document.querySelectorAll('.status-active').forEach(badge => {
        if (isDarkMode) {
            badge.style.backgroundColor = 'rgba(40, 167, 69, 0.3)';
            badge.style.color = '#5ecc77';
        } else {
            badge.style.backgroundColor = 'rgba(40, 167, 69, 0.15)';
            badge.style.color = '#28a745';
        }
    });

    document.querySelectorAll('.status-inactive').forEach(badge => {
        if (isDarkMode) {
            badge.style.backgroundColor = 'rgba(108, 117, 125, 0.3)';
            badge.style.color = '#adb5bd';
        } else {
            badge.style.backgroundColor = 'rgba(108, 117, 125, 0.15)';
            badge.style.color = '#6c757d';
        }
    });

    document.querySelectorAll('.status-pending').forEach(badge => {
        if (isDarkMode) {
            badge.style.backgroundColor = 'rgba(255, 193, 7, 0.3)';
            badge.style.color = '#ffdc5f';
        } else {
            badge.style.backgroundColor = 'rgba(255, 193, 7, 0.15)';
            badge.style.color = '#ffc107';
        }
    });
}

// Add these lines inside your existing applyThemeToElements function
function applyThemeToElements() {
    // Your existing code...

    // Apply theme to users page if on that page
    if (document.querySelector('.users-section')) {
        applyThemeToUsersPage();
    }
}

// Modify the existing toggleTheme function to ensure users page elements are updated
function toggleTheme() {
    const currentTheme = document.documentElement.getAttribute('data-theme');
    const newIsDark = currentTheme === 'light';

    if (newIsDark) {
        document.documentElement.setAttribute('data-theme', 'dark');
        localStorage.setItem('theme', 'dark');
    } else {
        document.documentElement.setAttribute('data-theme', 'light');
        localStorage.setItem('theme', 'light');
    }

    // Update settings theme switcher
    updateSettingsThemeSwitcher(newIsDark);

    // Apply theme to all elements after toggling
    applyThemeToElements();

    // Specifically apply to users page elements
    if (document.querySelector('.users-section')) {
        applyThemeToUsersPage();
    }
}

function applyThemeToAnnouncementsPage() {
    // Check if we're on the announcements page
    if (!document.querySelector('.announcement-form-container')) return;

    // Apply theme to announcement containers
    const announcementContainers = document.querySelectorAll('.announcement-form-container');
    announcementContainers.forEach(container => {
        container.style.backgroundColor = 'var(--card-bg-color)';
        container.style.boxShadow = '0px 0px 15px var(--shadow-color)';
    });

    // Apply theme to form labels and titles
    document.querySelectorAll('.announcement-title, .form-label').forEach(el => {
        el.style.color = 'var(--text-color)';
    });

    document.querySelectorAll('.announcement-subtitle').forEach(el => {
        el.style.color = 'var(--text-muted)';
    });

    // Apply theme to form inputs
    document.querySelectorAll('input[type="text"], textarea, select').forEach(input => {
        input.style.backgroundColor = 'var(--input-bg)';
        input.style.color = 'var(--input-text)';
        input.style.borderColor = 'var(--input-border)';
    });

    // Apply theme to tab navigation
    document.querySelectorAll('.nav-tabs').forEach(navTab => {
        navTab.style.borderBottomColor = 'var(--border-color)';
    });

    document.querySelectorAll('.nav-tabs .nav-link').forEach(navLink => {
        navLink.style.color = 'var(--text-color)';
    });

    document.querySelectorAll('.nav-tabs .nav-link.active').forEach(activeLink => {
        activeLink.style.color = 'var(--light-purple)';
        activeLink.style.borderBottomColor = 'var(--light-purple)';
    });

    // Apply theme to buttons
    const draftButton = document.querySelector('.btn-draft');
    if (draftButton) {
        draftButton.style.backgroundColor = 'var(--card-bg-color)';
        draftButton.style.color = 'var(--text-color)';
        draftButton.style.borderColor = 'var(--border-color)';
    }

    const sendButton = document.querySelector('.btn-send');
    if (sendButton) {
        sendButton.style.backgroundColor = 'var(--light-purple)';
        sendButton.style.color = 'white';
    }

    // Apply theme to history table
    document.querySelectorAll('.history-table th').forEach(header => {
        header.style.backgroundColor = 'var(--panel-header-bg)';
        header.style.color = 'var(--text-color)';
        header.style.borderBottomColor = 'var(--border-color)';
    });

    document.querySelectorAll('.history-table td').forEach(cell => {
        cell.style.color = 'var(--text-color)';
        cell.style.borderBottomColor = 'var(--border-color)';
    });

    // Apply theme to badges
    document.querySelectorAll('.target-badge').forEach(badge => {
        const isDarkMode = document.documentElement.getAttribute('data-theme') === 'dark';
        badge.style.backgroundColor = isDarkMode ? 'rgba(154, 123, 206, 0.3)' : 'rgba(166, 141, 217, 0.2)';
        badge.style.color = isDarkMode ? '#c6b4e8' : 'var(--light-purple)';
    });

    document.querySelectorAll('.admin-badge').forEach(badge => {
        badge.style.backgroundColor = 'var(--light-purple)';
        badge.style.color = 'white';
        badge.style.boxShadow = '0 2px 5px var(--shadow-color)';
    });

    // Apply theme to action buttons
    document.querySelectorAll('.action-button').forEach(btn => {
        btn.style.backgroundColor = 'var(--hover-bg)';
        btn.style.boxShadow = '0 2px 5px var(--shadow-color)';
    });

    document.querySelectorAll('.action-button i').forEach(icon => {
        if (!icon.classList.contains('fa-trash-alt')) {
            icon.style.color = 'var(--text-muted)';
        }
    });
}

// Add these lines inside your existing applyThemeToElements function
function applyThemeToElements() {
    // Your existing code...

    // Apply theme to announcements page if on that page
    if (document.querySelector('.announcement-form-container')) {
        applyThemeToAnnouncementsPage();
    }
}

// Modify the existing toggleTheme function to ensure announcements page elements are updated
function toggleTheme() {
    const currentTheme = document.documentElement.getAttribute('data-theme');
    const newIsDark = currentTheme === 'light';

    if (newIsDark) {
        document.documentElement.setAttribute('data-theme', 'dark');
        localStorage.setItem('theme', 'dark');
    } else {
        document.documentElement.setAttribute('data-theme', 'light');
        localStorage.setItem('theme', 'light');
    }

    // Update settings theme switcher if it exists
    if (typeof updateSettingsThemeSwitcher === 'function') {
        updateSettingsThemeSwitcher(newIsDark);
    }

    // Apply theme to all elements after toggling
    applyThemeToElements();

    // Specifically apply to announcements page elements
    if (document.querySelector('.announcement-form-container')) {
        applyThemeToAnnouncementsPage();
    }
}

// Add this code to handle tab changes
document.addEventListener('DOMContentLoaded', function () {
    // Check if we're on the announcements page with tabs
    const tabButtons = document.querySelectorAll('button[data-bs-toggle="tab"]');

    if (tabButtons.length > 0) {
        // Add event listeners to the tab buttons
        tabButtons.forEach(button => {
            button.addEventListener('shown.bs.tab', function () {
                // Apply theme to announcements page after tab change
                setTimeout(applyThemeToAnnouncementsPage, 100);
            });
        });
    }
});