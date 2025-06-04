<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TeacherAnnouncements.aspx.cs" Inherits="WAPPSS.TeacherAnnouncements" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Lecturer Announcements</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" />
    <style>
        /*--- Light Mode Styles ---*/
        body {
            background: #f9fafd;
            color: #222;
        }
        .announcement-card { 
            margin-bottom: 30px; 
            border: 1px solid #e3e6f0;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        }
        .profile-pic { 
            width: 40px; 
            height: 40px; 
            border-radius: 50%; 
            object-fit: cover; 
        }
        .admin-badge {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8em;
            font-weight: 500;
        }
        .target-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.75em;
            font-weight: 500;
        }
        .target-teachers {
            background: #e7f3ff;
            color: #0066cc;
            border: 1px solid #b3d9ff;
        }
        .target-all {
            background: #f0f9e8;
            color: #2d7d32;
            border: 1px solid #c8e6c9;
        }
        .time-text {
            color: #6c757d;
            font-size: 0.9em;
        }

        /*--- Dark Mode Styles ---*/
        body.dark-mode {
            background: #151922 !important;
            color: #eee !important;
        }
        body.dark-mode .container {
            background: #1c2230 !important;
            color: #eee !important;
        }
        body.dark-mode .announcement-card {
            background: #232b3e !important;
            border: 1px solid #2b3552 !important;
            color: #f0f2fa !important;
            box-shadow: 0 6px 22px 0 rgba(25,30,65,0.19);
        }
        body.dark-mode .announcement-card .card-header {
            background: #20283a !important;
            color: #e8eaff !important;
            border-bottom: 1px solid #283250 !important;
        }
        body.dark-mode .announcement-card .card-title,
        body.dark-mode .announcement-card .card-text {
            color: #fff !important;
        }
        body.dark-mode .announcement-card .card-body {
            color: #f0f2fa !important;
        }
        body.dark-mode .announcement-card .card-footer {
            background: #1a2332 !important;
            border-top: 1px solid #283250 !important;
            color: #a0aec0 !important;
        }
        body.dark-mode .btn-outline-primary {
            color: #5ea4f3 !important;
            border-color: #5ea4f3 !important;
            background: none !important;
        }
        body.dark-mode .btn-outline-primary:hover {
            background: #5ea4f3 !important;
            color: #fff !important;
            border-color: #5ea4f3 !important;
        }
        body.dark-mode .target-teachers {
            background: #1a365d !important;
            color: #90cdf4 !important;
            border: 1px solid #2c5282 !important;
        }
        body.dark-mode .target-all {
            background: #1a365d !important;
            color: #68d391 !important;
            border: 1px solid #2f855a !important;
        }
        body.dark-mode .time-text {
            color: #a0aec0 !important;
        }
        body.dark-mode .admin-badge {
            background: linear-gradient(135deg, #4299e1 0%, #667eea 100%) !important;
            color: #fff !important;
        }
        body.dark-mode h2, 
        body.dark-mode h4, 
        body.dark-mode h5 {
            color: #fff !important;
        }
        body.dark-mode p {
            color: #d1d5db !important;
        }
        body.dark-mode .text-muted {
            color: #9ca3af !important;
        }
        body.dark-mode .card .text-muted {
            color: #a0aec0 !important;
        }
        /* Make scrollbars nice in dark */
        body.dark-mode ::-webkit-scrollbar {
            width: 10px;
            background: #232b3e;
        }
        body.dark-mode ::-webkit-scrollbar-thumb {
            background: #395184;
            border-radius: 5px;
        }
        body.dark-mode ::selection {
            background: #5ea4f3;
            color: #fff;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" class="container mt-4">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="false" />
        
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="mb-0">
                    <i class="bi bi-megaphone-fill me-2"></i>Lecturer Announcements
                </h2>
                <p class="text-muted mb-0">View announcements from administrators</p>
            </div>
            <a href="course.aspx" class="btn btn-outline-primary" style="font-weight:600; min-width:140px; border-radius:25px;">
                <i class="bi bi-arrow-left-circle me-2"></i>Back to Dashboard
            </a>
        </div>

        <!-- Announcements Panel -->
        <asp:UpdatePanel ID="upAnnouncements" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <asp:Panel ID="pnlAnnouncements" runat="server">
                    <!-- Announcements will be loaded here -->
                </asp:Panel>
                
                <!-- No Announcements Message -->
                <asp:Panel ID="pnlNoAnnouncements" runat="server" Visible="false" CssClass="text-center py-5">
                    <div class="card">
                        <div class="card-body py-5">
                            <i class="bi bi-megaphone display-1 text-muted mb-3"></i>
                            <h4 class="text-muted">No Announcements</h4>
                            <p class="text-muted">There are currently no announcements for lecturers.</p>
                        </div>
                    </div>
                </asp:Panel>
            </ContentTemplate>
        </asp:UpdatePanel>

    </form>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script>
        // Set dark mode if needed
        $(document).ready(function () {
            var modeType = '<%= ModeTypeFromDB %>'; // Provided from code-behind
            if (modeType === "dark") {
                $('body').addClass('dark-mode');
            } else {
                $('body').removeClass('dark-mode');
            }
        });
    </script>
</body>
</html>