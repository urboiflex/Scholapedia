<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="WAPPSS.Profile" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Account Settings</title>
    <link id="darkModeCss" rel="stylesheet" runat="server" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f8fafc;
            color: #334155;
            min-height: 100vh;
            line-height: 1.6;
            transition: all 0.3s ease;
        }
        
        .dark-mode {
            background: #0f172a;
            color: #e2e8f0;
        }
        
        .main-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }
        
        .header {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .header h1 {
            color: #1e293b;
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .header p {
            color: #64748b;
            font-size: 1.1rem;
        }
        
        .dark-mode .header h1 {
            color: #f1f5f9;
        }
        
        .dark-mode .header p {
            color: #94a3b8;
        }
        
        .profile-grid {
            display: grid;
            grid-template-columns: 400px 1fr;
            gap: 2rem;
            margin-bottom: 2rem;
        }
        
        .right-column-container {
            display: flex;
            flex-direction: column;
            gap: 2rem;
            width: 100%;
        }
        
        .profile-picture-section,
        .personal-info-section,
        .security-section,
        .preferences-section {
            background: white;
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
            transition: background-color 0.3s ease, border-color 0.3s ease;
        }
        
        .dark-mode .profile-picture-section,
        .dark-mode .personal-info-section,
        .dark-mode .security-section {
            background: #1e293b;
            border-color: #334155;
        }
        
        .preferences-section {
            background: #f0f9ff;
            border: 1px solid #e0f2fe;
        }
        
        .dark-mode .preferences-section {
            background: #0f172a;
            border-color: #1e293b;
        }
        
        .profile-picture-section {
            text-align: center;
            height: fit-content;
        }
        
        .profile-pic-container {
            position: relative;
            display: inline-block;
            margin-bottom: 1.5rem;
        }
        
        .profile-pic {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #e2e8f0;
            background: #f1f5f9;
            transition: border-color 0.3s ease;
        }
        
        .dark-mode .profile-pic {
            border-color: #475569;
        }
        
        .edit-icon {
            position: absolute;
            bottom: 8px;
            right: 8px;
            background: #f59e0b;
            color: white;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            border: 3px solid white;
            font-size: 14px;
            transition: all 0.2s;
        }
        
        .edit-icon:hover {
            background: #d97706;
            transform: scale(1.05);
        }
        
        .profile-pic-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 0.5rem;
        }
        
        .dark-mode .profile-pic-title {
            color: #f1f5f9;
        }
        
        .profile-pic-subtitle {
            color: #64748b;
            margin-bottom: 1.5rem;
            font-size: 0.95rem;
        }
        
        .dark-mode .profile-pic-subtitle {
            color: #94a3b8;
        }
        
        .choose-photo-btn {
            background: #3b82f6;
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            font-size: 0.95rem;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .choose-photo-btn:hover {
            background: #2563eb;
            transform: translateY(-1px);
        }
        
        .stats-container {
            display: flex;
            justify-content: space-around;
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid #e2e8f0;
        }
        
        .dark-mode .stats-container {
            border-color: #475569;
        }
        
        .stat-item {
            text-align: center;
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: #3b82f6;
            display: block;
        }
        
        .stat-number.orange {
            color: #f59e0b;
        }
        
        .stat-label {
            color: #64748b;
            font-size: 0.9rem;
            font-weight: 500;
        }
        
        .dark-mode .stat-label {
            color: #94a3b8;
        }
        
        .icon-chooser {
            display: none;
            position: absolute;
            top: 100%;
            left: 50%;
            transform: translateX(-50%);
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 1rem;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
            z-index: 100;
            margin-top: 8px;
            min-width: 200px;
        }
        
        .icon-chooser::before {
            content: '';
            position: absolute;
            top: -6px;
            left: 50%;
            transform: translateX(-50%);
            width: 12px;
            height: 12px;
            background: white;
            border: 1px solid #e2e8f0;
            border-bottom: none;
            border-right: none;
            transform: translateX(-50%) rotate(45deg);
        }
        
        .dark-mode .icon-chooser {
            background: #1e293b;
            border-color: #334155;
        }
        
        .dark-mode .icon-chooser::before {
            background: #1e293b;
            border-color: #334155;
        }
        
        .icon-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 0.5rem;
        }
        
        .icon-choice {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            border: 2px solid transparent;
            cursor: pointer;
            transition: all 0.2s;
            object-fit: cover;
        }
        
        .icon-choice:hover {
            border-color: #3b82f6;
            transform: scale(1.05);
        }
        
        .section-header {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 1.5rem;
        }
        
        .section-icon {
            background: #3b82f6;
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
        }
        
        .security-icon {
            background: #ef4444 !important;
        }
        
        .preferences-icon {
            background: #10b981 !important;
        }
        
        .section-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #1e293b;
        }
        
        .dark-mode .section-title {
            color: #f1f5f9;
        }
        
        .section-subtitle {
            color: #64748b;
            font-size: 0.95rem;
            margin-left: 52px;
            margin-top: -0.5rem;
            margin-bottom: 1.5rem;
        }
        
        .dark-mode .section-subtitle {
            color: #94a3b8;
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
        }
        
        .form-label {
            font-weight: 500;
            color: #374151;
            margin-bottom: 0.5rem;
            font-size: 0.95rem;
        }
        
        .dark-mode .form-label {
            color: #94a3b8;
        }
        
        .form-input {
            padding: 0.75rem 1rem;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.2s;
            background: white;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        
        .dark-mode .form-input {
            background: #0f172a;
            border-color: #334155;
            color: #e2e8f0;
        }
        
        .dark-mode .form-input:focus {
            border-color: #3b82f6;
        }
        
        .password-input-container {
            position: relative;
            display: flex;
            align-items: center;
        }
        
        .password-input {
            padding-right: 3rem !important;
        }
        
        .password-toggle {
            position: absolute;
            right: 1rem;
            background: none;
            border: none;
            color: #9ca3af;
            cursor: pointer;
            font-size: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 24px;
            height: 24px;
            transition: color 0.2s;
        }
        
        .password-toggle:hover {
            color: #6b7280;
        }
        
        .dark-mode .password-toggle {
            color: #9ca3af;
        }
        
        .dark-mode .password-toggle:hover {
            color: #d1d5db;
        }
        
        .password-requirements {
            background: #fef2f2;
            border: 1px solid #fecaca;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }
        
        .requirements-header {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 600;
            color: #dc2626;
            margin-bottom: 0.5rem;
        }
        
        .password-requirements p {
            color: #dc2626;
            margin: 0;
            font-size: 0.9rem;
        }
        
        .dark-mode .password-requirements {
            background: #2d1b1b;
            border-color: #7f1d1d;
        }
        
        .dark-mode .requirements-header,
        .dark-mode .password-requirements p {
            color: #fca5a5;
        }
        
        .preference-item {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: 1px solid #e2e8f0;
            margin-bottom: 1.5rem;
            transition: all 0.3s ease;
        }
        
        .dark-mode .preference-item {
            background: #1e293b;
            border-color: #334155;
        }
        
        .preference-content h4 {
            font-size: 1.1rem;
            font-weight: 600;
            color: #1e293b;
            margin: 0 0 0.25rem 0;
        }
        
        .dark-mode .preference-content h4 {
            color: #f1f5f9;
        }
        
        .preference-desc {
            font-size: 0.9rem;
            color: #64748b;
            margin: 0;
        }
        
        .dark-mode .preference-desc {
            color: #94a3b8;
        }
        
        /* Toggle Switch */
        .switch {
            position: relative;
            display: inline-block;
            width: 50px;
            height: 25px;
        }
        
        .switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }
        
        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #cbd5e1;
            transition: .4s;
            border-radius: 25px;
        }
        
        .slider:before {
            position: absolute;
            content: "";
            height: 21px;
            width: 21px;
            left: 2px;
            bottom: 2px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }
        
        input:checked + .slider {
            background-color: #10b981;
        }
        
        input:checked + .slider:before {
            transform: translateX(25px);
        }
        
        .save-btn {
            background: #3b82f6;
            color: white;
            border: none;
            padding: 0.875rem 2rem;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            font-size: 1rem;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            margin-left: auto;
        }
        
        .save-btn:hover {
            background: #2563eb;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }
        
        .update-password-btn {
            background: #ef4444;
            color: white;
            border: none;
            padding: 0.875rem 2rem;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            font-size: 1rem;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .update-password-btn:hover {
            background: #dc2626;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
        }
        
        .update-password-btn:before {
            content: '\f023';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
        }
        
        .btn {
            background: #10b981;
            color: white;
            border: none;
            padding: 0.875rem 2rem;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            font-size: 1rem;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .btn:hover {
            background: #059669;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
        }
        
        .back-btn {
            background: #6b7280;
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            font-size: 0.95rem;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
        }
        
        .back-btn:hover {
            background: #4b5563;
            transform: translateY(-1px);
            color: white;
            text-decoration: none;
        }
        
        .message-label {
            margin-top: 1rem;
            padding: 0.75rem;
            border-radius: 8px;
            text-align: center;
            font-weight: 500;
        }
        
        .message-label.success {
            background: #ecfdf5;
            color: #065f46;
            border: 1px solid #a7f3d0;
        }
        
        .message-label.error {
            background: #fef2f2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }
        
        @media (max-width: 768px) {
            .profile-grid {
                grid-template-columns: 1fr;
                gap: 1.5rem;
            }
            
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .main-container {
                padding: 1rem;
            }
            
            .preference-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }
        }
    </style>
    <script>
        function togglePasswordVisibility(inputId, iconId) {
            var input = document.getElementById(inputId);
            var icon = document.getElementById(iconId);

            if (input.type === "password") {
                input.type = "text";
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash");
            } else {
                input.type = "password";
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye");
            }
        }

        function toggleIconChooser(event) {
            if (event) event.stopPropagation();
            var chooser = document.getElementById('iconChooser');
            chooser.style.display = (chooser.style.display === "block") ? "none" : "block";
        }

        document.addEventListener('DOMContentLoaded', function () {
            document.getElementById('iconChooser').addEventListener('click', function (event) {
                event.stopPropagation();
            });
            document.addEventListener("click", function () {
                document.getElementById('iconChooser').style.display = "none";
            });
        });

        function showMessage(text, isSuccess) {
            var messageLabel = document.getElementById('<%= lblMessage.ClientID %>');
            messageLabel.textContent = text;
            messageLabel.className = 'message-label ' + (isSuccess ? 'success' : 'error');
            messageLabel.style.display = 'block';
        }
    </script>
</head>
<body class="<%= (Session["DarkMode"] != null && (bool)Session["DarkMode"]) ? "dark-mode" : "" %>">
    <form id="form1" runat="server">
        <div class="main-container">
            <div class="header">
                <h1><i class="fas fa-user-circle"></i> My Profile</h1>
                <p>Manage your account settings and preferences</p>
            </div>
            
            <div class="profile-grid">
                <!-- Profile Picture Section -->
                <div class="profile-picture-section">
                    <div class="profile-pic-container">
                        <img id="userIcon" runat="server" class="profile-pic" alt="Profile Picture" />
                        <div class="edit-icon" onclick="toggleIconChooser(event)">
                            <i class="fas fa-pencil-alt"></i>
                        </div>
                        <div id="iconChooser" class="icon-chooser">
                            <div class="icon-grid">
                                <asp:Repeater ID="rptIcons" runat="server">
                                    <ItemTemplate>
                                        <asp:ImageButton runat="server" CssClass="icon-choice" 
                                            ImageUrl='<%# Eval("IconPath") %>' 
                                            CommandArgument='<%# Eval("IconPath") %>' 
                                            OnCommand="SelectIcon_Command" />
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </div>
                    
                    <h3 class="profile-pic-title">Profile Picture</h3>
                    <p class="profile-pic-subtitle">Upload your best professional photo</p>
                    
                    <button type="button" class="choose-photo-btn" onclick="toggleIconChooser(event)">
                        <i class="fas fa-camera"></i>
                        Choose Photo
                    </button>
                    
                    <div class="stats-container">
                        <div class="stat-item">
                            <span class="stat-number">12</span>
                            <span class="stat-label">Courses</span>
                        </div>
                        <div class="stat-item">
                            <span class="stat-number orange">8</span>
                            <span class="stat-label">Certificates</span>
                        </div>
                    </div>
                </div>
                
                <!-- Right Column Container -->
                <div class="right-column-container">
                    <!-- Personal Information Section -->
                    <div class="personal-info-section">
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-user"></i>
                            </div>
                            <h3 class="section-title">Personal Information</h3>
                        </div>
                        <p class="section-subtitle">Manage your basic profile details</p>
                        
                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label">First Name</label>
                                <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-input" placeholder="Enter your first name"></asp:TextBox>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">Last Name</label>
                                <asp:TextBox ID="txtLastName" runat="server" CssClass="form-input" placeholder="Enter your last name"></asp:TextBox>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">Username</label>
                                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-input" placeholder="Enter your username"></asp:TextBox>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">Email Address</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" placeholder="Enter your email address" TextMode="Email"></asp:TextBox>
                            </div>
                        </div>
                        
                        <div style="display: flex; justify-content: flex-end;">
                            <asp:Button ID="btnSaveChanges" runat="server" Text="Save Changes" CssClass="save-btn" OnClick="btnSaveChanges_Click" />
                        </div>
                        
                        <asp:Label ID="lblMessage" runat="server" CssClass="message-label" Visible="false"></asp:Label>
                    </div>
                    
                    <!-- Account Security Section -->
                    <div class="security-section">
                        <div class="section-header">
                            <div class="section-icon security-icon">
                                <i class="fas fa-shield-alt"></i>
                            </div>
                            <h3 class="section-title">Account Security</h3>
                        </div>
                        <p class="section-subtitle">Keep your account safe and secure</p>
                        
                        <div class="password-form">
                            <div class="form-group" style="margin-bottom: 1.5rem;">
                                <label class="form-label">Current Password</label>
                                <div class="password-input-container">
                                    <asp:TextBox ID="txtCurrentPassword" runat="server" TextMode="Password" CssClass="form-input password-input" placeholder="Enter your current password"></asp:TextBox>
                                    <button type="button" class="password-toggle" onclick="togglePasswordVisibility('<%= txtCurrentPassword.ClientID %>', 'eyeCurrentPw')">
                                        <i id="eyeCurrentPw" class="fas fa-eye"></i>
                                    </button>
                                </div>
                            </div>
                            
                            <div class="form-group" style="margin-bottom: 1.5rem;">
                                <label class="form-label">New Password</label>
                                <div class="password-input-container">
                                    <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" CssClass="form-input password-input" placeholder="Enter your new password"></asp:TextBox>
                                    <button type="button" class="password-toggle" onclick="togglePasswordVisibility('<%= txtNewPassword.ClientID %>', 'eyeNewPw')">
                                        <i id="eyeNewPw" class="fas fa-eye"></i>
                                    </button>
                                </div>
                            </div>
                            
                            <div class="form-group" style="margin-bottom: 1.5rem;">
                                <label class="form-label">Confirm New Password</label>
                                <div class="password-input-container">
                                    <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-input password-input" placeholder="Confirm your new password"></asp:TextBox>
                                    <button type="button" class="password-toggle" onclick="togglePasswordVisibility('<%= txtConfirmPassword.ClientID %>', 'eyeConfirmPw')">
                                        <i id="eyeConfirmPw" class="fas fa-eye"></i>
                                    </button>
                                </div>
                            </div>
                            
                            <div class="password-requirements">
                                <div class="requirements-header">
                                    <i class="fas fa-exclamation-triangle"></i>
                                    <span>Password Requirements</span>
                                </div>
                                <p>Password must be at least 8 characters long and include uppercase, lowercase, and numbers.</p>
                            </div>
                            
                            <div style="display: flex; justify-content: flex-end; margin-top: 1.5rem;">
                                <asp:Button ID="btnUpdatePassword" runat="server" Text="Update Password" CssClass="update-password-btn" OnClick="btnUpdatePassword_Click" />
                            </div>
                            
                            <asp:Label ID="lblPasswordMessage" runat="server" CssClass="message-label" Visible="false"></asp:Label>
                        </div>
                    </div>
                    
                    <!-- Preferences Section -->
                    <div class="preferences-section">
                        <div class="section-header">
                            <div class="section-icon preferences-icon">
                                <i class="fas fa-cog"></i>
                            </div>
                            <h3 class="section-title">Preferences</h3>
                        </div>
                        <p class="section-subtitle">Customize your learning experience</p>
                        
                        <div class="preference-item">
                            <div class="preference-content">
                                <h4>Theme</h4>
                                <p class="preference-desc">Switch between light and dark mode</p>
                            </div>
                            <label class="switch">
                                <asp:CheckBox ID="chkDarkMode" runat="server" />
                                <span class="slider round"></span>
                            </label>
                        </div>

                        <asp:Button ID="btnSaveMode" runat="server" Text="Save Preferences" CssClass="btn btn-primary" OnClick="btnSaveMode_Click" />
                    </div>
                </div>
            </div>
            
            <div style="text-align: center; margin-top: 2rem;">
                <asp:Button ID="btnBack" runat="server" Text="← Back to Dashboard" CssClass="back-btn" PostBackUrl="~/Student_Dashboard.aspx" />
            </div>
        </div>
    </form>
</body>
</html>