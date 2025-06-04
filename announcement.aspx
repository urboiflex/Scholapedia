<%@ Page Language="C#" MaintainScrollPositionOnPostBack="true" AutoEventWireup="true" CodeBehind="announcement.aspx.cs" Inherits="WAPPSS.announcement" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Announcements</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" />
    <style>
        /*--- Light Mode Styles ---*/
        body {
            background: #f9fafd;
            color: #222;
        }
        .chat-btn { background: #007bff; color: white; border-radius: 50%; width: 60px; height: 60px; font-size: 2em; display: flex; align-items: center; justify-content: center; position: fixed; bottom: 40px; right: 40px; z-index: 100; box-shadow: 0 8px 32px 0 rgba(31,38,135,0.37); cursor: pointer; transition: background 0.2s; }
        .chat-btn:hover { background: #0056b3; }
        .profile-pic { width: 40px; height: 40px; border-radius: 50%; object-fit: cover; }
        .announcement-card { margin-bottom: 30px; }
        .recipient-list { max-height: 300px; overflow-y: auto; }
        .recipient-card { display: flex; align-items: center; padding: 8px 12px; margin: 6px 0; border-radius: 10px; background: #f7fafd; box-shadow: 0px 1px 3px rgba(0,0,0,0.04); transition: background 0.2s; }
        .recipient-card:hover { background: #e7f0fc; }
        .recipient-avatar { width: 32px; height: 32px; border-radius: 50%; object-fit: cover; margin-right: 10px; background: #dee2e6; }
        .btn-group-toggle .btn.active { background: #007bff; color: #fff; }
        .delete-announcement-btn {
            color: #dc3545;
            background: none;
            border: none;
            font-size: 1.3em;
            margin-left: 10px;
            cursor: pointer;
            transition: color 0.2s;
        }
        .delete-announcement-btn:hover {
            color: #a71d2a;
        }

        /*--- Dark Mode Styles ---*/
        body.dark-mode {
            background: #151922 !important;
            color: #eee !important;
        }
        body.dark-mode .container, body.dark-mode .modal-content {
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
        body.dark-mode .chat-btn {
            background: #5ea4f3 !important;
            color: #151922 !important; /* make icon dark in dark mode */
            box-shadow: 0 8px 32px 0 rgba(31,38,135,0.51);
        }
        body.dark-mode .chat-btn:hover {
            background: #4a85c2 !important;
        }
        body.dark-mode .chat-btn i {
            color: #151922 !important; /* ensures the chat icon is visible on light blue */
            text-shadow: 0 0 2px #fff, 0 0 6px #fff;
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
        body.dark-mode .btn-outline-success {
            color: #71f9be !important;
            border-color: #2bdb7b !important;
            background: none !important;
        }
        body.dark-mode .btn-outline-success:hover {
            background: #1b8c4c !important;
            color: #fff !important;
            border-color: #1b8c4c !important;
        }
        body.dark-mode .btn-outline-info {
            color: #8ebfff !important;
            border-color: #46bfff !important;
            background: none !important;
        }
        body.dark-mode .btn-outline-info:hover {
            background: #1d4c6e !important;
            color: #fff !important;
            border-color: #1d4c6e !important;
        }
        body.dark-mode .recipient-card {
            background: #222c3c !important;
            color: #e1eaff !important;
            box-shadow: 0px 1px 3px rgba(13,16,31,0.12);
        }
        body.dark-mode .recipient-card:hover {
            background: #283048 !important;
        }
        body.dark-mode .form-control,
        body.dark-mode .modal-content {
            background: #1c2536 !important;
            color: #eee !important;
            border-color: #2d3e5e !important;
        }
        body.dark-mode .form-control:focus {
            background: #222c3c !important;
            color: #fff !important;
            border-color: #5ea4f3 !important;
        }
        body.dark-mode .modal-header,
        body.dark-mode .modal-footer {
            background: #20283a !important;
            color: #e8eaff !important;
            border-bottom: 1px solid #283250 !important;
        }
        body.dark-mode .modal-footer {
            border-top: 1px solid #283250 !important;
        }
        body.dark-mode .btn-primary {
            background: #5ea4f3 !important;
            border-color: #5ea4f3 !important;
            color: #fff !important;
        }
        body.dark-mode .btn-primary:hover, body.dark-mode .btn-primary:focus {
            background: #4a85c2 !important;
            border-color: #4a85c2 !important;
        }
        body.dark-mode .btn-danger {
            background: #d1555e !important;
            border-color: #d1555e !important;
            color: #fff !important;
        }
        body.dark-mode .btn-secondary {
            background: #353b53 !important;
            border-color: #353b53 !important;
            color: #d3d8e8 !important;
        }
        body.dark-mode .btn-close {
            filter: invert(1);
        }
        body.dark-mode .form-label,
        body.dark-mode .text-danger,
        body.dark-mode .like-count,
        body.dark-mode .bi {
            color: #5ea4f3 !important;
        }
        body.dark-mode .like-btn.btn-primary, body.dark-mode .like-btn.btn-outline-primary {
            background: #2d3e5e !important;
            border-color: #5ea4f3 !important;
            color: #5ea4f3 !important;
        }
        body.dark-mode .like-btn.btn-primary:hover {
            background: #5ea4f3 !important;
            border-color: #5ea4f3 !important;
            color: #fff !important;
        }
        body.dark-mode .like-btn.btn-outline-primary:hover {
            background: #5ea4f3 !important;
            color: #fff !important;
        }
        body.dark-mode .delete-announcement-btn {
            color: #ff6c6c !important;
        }
        body.dark-mode .delete-announcement-btn:hover {
            color: #ff3c3c !important;
        }
        body.dark-mode .btn-group-toggle .btn.active {
            background: #5ea4f3 !important;
            color: #fff !important;
        }
        body.dark-mode .img-fluid {
            border: 1.5px solid #5ea4f3 !important;
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
<body<%-- Dark mode class is toggled by JS below --%>>
    <form id="form1" runat="server" enctype="multipart/form-data" class="container mt-4">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="false" />
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="mb-0">Announcements</h2>
            <a href="Student_Dashboard.aspx" class="btn btn-outline-primary" style="font-weight:600; min-width:140px; border-radius:25px;">
                <i class="bi bi-arrow-left-circle me-2"></i>Back to Home
            </a>
        </div>
        <asp:UpdatePanel ID="upAnnouncements" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <asp:Panel ID="pnlAnnouncements" runat="server"></asp:Panel>
            </ContentTemplate>
        </asp:UpdatePanel>

        <!-- Add Announcement Modal -->
        <div class="modal fade" id="addAnnouncementModal" tabindex="-1" aria-labelledby="addAnnouncementLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addAnnouncementLabel">Create Announcement</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <asp:Label ID="lblError" runat="server" CssClass="text-danger"></asp:Label>
                        <div class="mb-3">
                            <label for="txtTitle" class="form-label">Title <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" MaxLength="150" required="required"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label for="txtDescription" class="form-label">Description</label>
                            <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label for="fuImage" class="form-label">Image</label>
                            <asp:FileUpload ID="fuImage" runat="server" CssClass="form-control" />
                        </div>
                        <asp:UpdatePanel ID="upRecipients" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <div class="mb-3">
                                    <label class="form-label">Announce To <span class="text-danger">*</span></label>
                                    <div id="recipientTypeBtns" class="btn-group btn-group-toggle mb-3" data-toggle="buttons">
                                        <asp:RadioButton ID="rbTeachers" runat="server" GroupName="announceTo" Text="Teachers" CssClass="btn-check" AutoPostBack="true" Checked="true" OnCheckedChanged="RecipientTypeChanged" />
                                        <label class="btn btn-outline-primary" for="<%= rbTeachers.ClientID %>">Teachers</label>
                                        <asp:RadioButton ID="rbStudents" runat="server" GroupName="announceTo" Text="Students" CssClass="btn-check" AutoPostBack="true" OnCheckedChanged="RecipientTypeChanged" />
                                        <label class="btn btn-outline-success" for="<%= rbStudents.ClientID %>">Students</label>
                                        <asp:RadioButton ID="rbCourses" runat="server" GroupName="announceTo" Text="Courses" CssClass="btn-check" AutoPostBack="true" OnCheckedChanged="RecipientTypeChanged" />
                                        <label class="btn btn-outline-info" for="<%= rbCourses.ClientID %>">Courses</label>
                                    </div>
                                    <asp:HiddenField ID="hfAnnounceTo" runat="server" Value="teachers" />
                                </div>
                                <asp:MultiView ID="mvRecipients" runat="server" ActiveViewIndex="0">
                                    <asp:View ID="viewTeachers" runat="server">
                                        <asp:Panel ID="pnlTeachers" runat="server"></asp:Panel>
                                    </asp:View>
                                    <asp:View ID="viewStudents" runat="server">
                                        <asp:Panel ID="pnlStudents" runat="server"></asp:Panel>
                                    </asp:View>
                                    <asp:View ID="viewCourses" runat="server">
                                        <asp:Panel ID="pnlCourses" runat="server"></asp:Panel>
                                    </asp:View>
                                </asp:MultiView>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                    <div class="modal-footer">
                        <asp:Button ID="btnSendAnnouncement" runat="server" CssClass="btn btn-primary" Text="Send" OnClick="btnSendAnnouncement_Click" />
                    </div>
                </div>
            </div>
        </div>
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
            // Like button
            $('.pnlAnnouncements, #form1').on('click', '.like-btn', function () {
                var btn = $(this);
                var annId = btn.data('annid');
                btn.prop('disabled', true);
                __doPostBack('LikeAnnouncement', annId);
            });

            // Delete button
            $('#form1').on('click', '.delete-announcement-btn', function (e) {
                e.preventDefault();
                var annId = $(this).data('annid');
                var title = $(this).data('anntitle');
                // Bootstrap modal confirmation
                $('#deleteConfirmModal .modal-ann-title').text(title);
                $('#deleteConfirmModal').data('annid', annId).modal('show');
            });

            // Confirm delete
            $('#btnConfirmDelete').on('click', function () {
                var annId = $('#deleteConfirmModal').data('annid');
                $('#deleteConfirmModal').modal('hide');
                __doPostBack('DeleteAnnouncement', annId);
            });
        });
    </script>
    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteConfirmModalLabel">Delete Announcement</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    Are you sure you want to delete the announcement "<span class="modal-ann-title"></span>"?
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="btnConfirmDelete">Delete</button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>