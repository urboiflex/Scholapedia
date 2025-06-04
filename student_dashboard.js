


    document.addEventListener("DOMContentLoaded", function () {
        const eventData = JSON.parse(document.getElementById('<%= hiddenEventData.ClientID %>').value || "[]");
        const calendarGrid = document.getElementById("calendarDays");
        const currentMonthYear = document.getElementById("currentMonthYear");
        const prevMonthBtn = document.getElementById("prevMonth");
        const nextMonthBtn = document.getElementById("nextMonth");
        const eventsList = document.getElementById("eventsList");

        let currentDate = new Date();

        function renderCalendar() {
            const year = currentDate.getFullYear();
            const month = currentDate.getMonth();

            const firstDay = new Date(year, month, 1);
            const lastDay = new Date(year, month + 1, 0);

            // Clear existing calendar
            calendarGrid.innerHTML = "";

            // Add weekday headers
            const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
            dayNames.forEach(day => {
                const dayHeader = document.createElement("div");
                dayHeader.className = "calendar-day-header";
                dayHeader.textContent = day;
                calendarGrid.appendChild(dayHeader);
            });

            // Empty cells before first day
            for (let i = 0; i < firstDay.getDay(); i++) {
                calendarGrid.innerHTML += '<div class="calendar-day empty"></div>';
            }

            // Render days
            for (let d = 1; d <= lastDay.getDate(); d++) {
                const dateStr = `${year}-${String(month + 1).padStart(2, '0')}-${String(d).padStart(2, '0')}`;
                const dayEvents = eventData.filter(e => e.date === dateStr);
                const hasEvent = dayEvents.length > 0;

                const dayDiv = document.createElement("div");
                dayDiv.className = "calendar-day" + (hasEvent ? " has-event" : "");
                dayDiv.setAttribute("data-date", dateStr);
                dayDiv.innerHTML = `<span>${d}</span>`;

                dayDiv.addEventListener("click", () => {
                    showEventsForDay(dateStr);
                });

                calendarGrid.appendChild(dayDiv);
            }

            // Update header
            currentMonthYear.textContent = currentDate.toLocaleString("default", {
                month: "long",
                year: "numeric"
            });

            // Default: Show today's events if visible
            const todayStr = new Date().toISOString().split('T')[0];
            if (todayStr.startsWith(`${year}-${String(month + 1).padStart(2, '0')}`)) {
                showEventsForDay(todayStr);
            } else {
                eventsList.innerHTML = "<li>Click a day to view events</li>";
            }
        }

        function showEventsForDay(dateStr) {
            const dayEvents = eventData.filter(e => e.date === dateStr);
            eventsList.innerHTML = "";

            if (dayEvents.length === 0) {
                eventsList.innerHTML = "<li>No events scheduled</li>";
            } else {
                dayEvents.forEach(evt => {
                    const li = document.createElement("li");
                    li.innerHTML = `<strong>${evt.title}</strong> (${evt.category})<br>${evt.description}`;
                    eventsList.appendChild(li);
                });
            }
        }

        // Navigation
        prevMonthBtn.addEventListener("click", () => {
            currentDate.setMonth(currentDate.getMonth() - 1);
            renderCalendar();
        });

        nextMonthBtn.addEventListener("click", () => {
            currentDate.setMonth(currentDate.getMonth() + 1);
            renderCalendar();
        });

        renderCalendar(); // Initial load
    });





