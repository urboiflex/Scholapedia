<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditProfile.aspx.cs" Inherits="WAPPSS.EditProfile" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<title>Edit Profile</title>
        <link id="darkModeCss" runat="server" rel="stylesheet" href="" />
    <style>
body {
    margin: 0;
    font-family: 'Segoe UI', sans-serif;
    background: linear-gradient(-45deg, #74ebd5, #ACB6E5, #74ebd5, #ACB6E5);
    background-size: 400% 400%;
    animation: gradientBG 15s ease infinite;
    min-height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
}

@keyframes gradientBG {
    0% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
    100% { background-position: 0% 50%; }
}

.edit-profile-container {
    background: #e0e0e0;
    padding: 40px;
    border-radius: 12px;
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
    width: 100%;
    max-width: 600px;
    border: 3px solid #007BFF; /* blue border */
    animation: fadeIn 0.8s ease;
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(-20px); }
    to { opacity: 1; transform: translateY(0); }
}

.profile-header h2 {
    margin: 0 0 20px;
    color: #007BFF;
    text-align: center;
    font-size: 24px;
}

.form-group {
    margin-bottom: 20px;
}

.input-icon {
    display: flex;
    align-items: center;
    background: #f1f3f5;
    padding: 10px 14px;
    border-radius: 8px;
    box-shadow: inset 0 0 4px rgba(0, 0, 0, 0.1);
}

.input-icon i {
    margin-right: 10px;
    color: #007BFF;
}

.form-input {
    border: none;
    background: transparent;
    outline: none;
    width: 100%;
    font-size: 16px;
    color: #333;
}

.form-input::placeholder {
    color: #888;
}

.password-hint {
    font-size: 12px;
    color: #666;
    margin-top: 4px;
    padding-left: 4px;
}

.form-actions {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 30px;
}

.btn-save, .btn-cancel {
    padding: 10px 20px;
    border-radius: 6px;
    font-weight: bold;
    border: none;
    cursor: pointer;
    font-size: 15px;
    transition: 0.3s;
}

.btn-save {
    background-color: #007BFF;
    color: white;
}

.btn-save:hover {
    background-color: #0056b3;
}

.btn-cancel {
    background-color: #e0e0e0;
    color: #333;
    text-decoration: none;
    padding: 10px 20px;
}

.btn-cancel:hover {
    background-color: #d6d6d6;
}

.message-label {
    display: block;
    text-align: center;
    margin-top: 20px;
    color: #007BFF;
    font-weight: bold;
}

.icon-selection {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 20px;
}

.current-icon {
    width: 60px;
    height: 60px;
    border-radius: 50%;
    border: 2px solid #007BFF;
    object-fit: cover;
}

.icon-choice {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    margin: 5px;
    border: 2px solid transparent;
    transition: 0.2s;
}

.icon-choice:hover {
    border-color: #007BFF;
    transform: scale(1.1);
}

.back-button {
    color: #007BFF;
    font-weight: bold;
    text-decoration: none;
    transition: color 0.3s;
}

.back-button:hover {
    color: #0056b3;
}


    </style>
<script>
    function toggleIconChooser() {
        console.log("toggleIconChooser called");
        var chooser = document.getElementById('iconChooser');
        chooser.style.display = chooser.style.display === 'none' ? 'block' : 'none';
    }
</script>




</head>
<body class='<%= (Session["DarkMode"] != null && (bool)Session["DarkMode"]) ? "dark-theme" : "" %>'>
<form id="form1" runat="server" enctype="multipart/form-data">
    <div class="edit-profile-container">
        <div class="profile-header">
            <h2><i class="fas fa-user-edit"></i> Edit Profile</h2>
        </div>

<div class="icon-selection">
    <asp:Image ID="imgCurrentIcon" runat="server" CssClass="current-icon" />
<button type="button" id="btnEditIcon" onclick="toggleIconChooser(); return false;">✏️</button>

    
    <div id="iconChooser" style="display: none;">
        <asp:Repeater ID="rptIcons" runat="server">
            <ItemTemplate>
                <asp:ImageButton runat="server" ImageUrl='<%# Eval("IconPath") %>' 
                    CssClass="icon-choice" CommandArgument='<%# Eval("IconPath") %>'
                    OnCommand="SelectIcon_Command" />
            </ItemTemplate>
        </asp:Repeater>
    </div>
</div>
<asp:Button ID="btnUpdateIcon" runat="server" Text="Update Icon" OnClick="btnUpdateIcon_Click" />


        <div class="form-group">
            <div class="input-icon">
                <i class="fas fa-user"></i>
                <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-input" 
                    Placeholder="Enter your first name"></asp:TextBox>
            </div>
        </div>

        <div class="form-group">
            <div class="input-icon">
                <i class="fas fa-user"></i>
                <asp:TextBox ID="txtLastName" runat="server" CssClass="form-input" 
                    Placeholder="Enter your last name"></asp:TextBox>
            </div>
        </div>

        <div class="form-group">
            <div class="input-icon">
                <i class="fas fa-at"></i>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-input" 
                    Placeholder="Choose a username"></asp:TextBox>
            </div>
        </div>

        <div class="form-group">
            <div class="input-icon">
                <i class="fas fa-envelope"></i>
                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-input" 
                    Placeholder="Enter your email address" OnTextChanged="txtEmail_TextChanged"></asp:TextBox>
            </div>
        </div>

        <div class="form-group">
            <div class="input-icon">
                <i class="fas fa-lock"></i>
                <asp:TextBox ID="txtCurrentPassword" runat="server" TextMode="Password" CssClass="form-input" 
                    Placeholder="Enter current password"></asp:TextBox>
            </div>
        </div>

        <div class="form-group">
            <div class="input-icon">
                <i class="fas fa-key"></i>
                <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" CssClass="form-input" 
                    Placeholder="New password (leave blank to keep current)"></asp:TextBox>
            </div>
            <div class="password-hint">Minimum 8 characters with numbers and symbols</div>
        </div>

        <div class="form-actions">
            <asp:Button ID="btnUpdate" runat="server" Text="Save Changes" CssClass="btn-save" OnClick="btnUpdate_Click" />
            <asp:HyperLink ID="btnCancel" runat="server" NavigateUrl="Student_Dashboard.aspx" CssClass="btn-cancel">
                Cancel
            </asp:HyperLink>
        </div>

        <asp:Label ID="lblMessage" runat="server" CssClass="message-label"></asp:Label>
    </div>
    <div style="text-align: right; margin: 20px;">
    <a href="Student_Dashboard.aspx" class="back-button">
        <i class="fas fa-arrow-left"></i> Back to Dashboard
    </a>
</div>

</form>


</body>
</html>
