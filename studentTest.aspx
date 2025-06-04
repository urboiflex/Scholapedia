<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="studentTest.aspx.cs" Inherits="WAPPSS.studentTest" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>User Registration</title>
    <style>
        body {
            background-color: #f5f5fa;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
        }
        
        .container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            padding: 30px;
            max-width: 700px;
            margin: 0 auto;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .logo {
            background-color: #4caf50;
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0 auto 20px;
        }
        
        h1 {
            color: #4caf50;
            margin-bottom: 10px;
        }
        
        .subtitle {
            color: #9e9e9e;
            margin-bottom: 30px;
        }
        
        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .form-group {
            flex: 1;
            text-align: left;
        }
        
        .form-group.full-width {
            flex: 100%;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #616161;
            font-weight: bold;
        }
        
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #e0e0e0;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 14px;
        }
        
        .form-control:focus {
            border-color: #4caf50;
            outline: none;
            box-shadow: 0 0 5px rgba(76, 175, 80, 0.3);
        }
        
        .file-upload {
            border: 2px dashed #e0e0e0;
            border-radius: 5px;
            padding: 20px;
            text-align: center;
            background-color: #fafafa;
            transition: all 0.3s ease;
        }
        
        .file-upload:hover {
            border-color: #4caf50;
            background-color: #f1f8e9;
        }
        
        .btn-primary {
            background-color: #4caf50;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 12px 30px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 20px;
            width: 200px;
        }
        
        .btn-primary:hover {
            background-color: #45a049;
        }
        
        .btn-secondary {
            background-color: #9e9e9e;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 12px 30px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 20px;
            margin-left: 10px;
            width: 200px;
        }
        
        .btn-secondary:hover {
            background-color: #757575;
        }
        
        .error-message {
            color: red;
            margin-top: 5px;
            font-size: 12px;
        }
        
        .success-message {
            color: green;
            margin-top: 5px;
            font-size: 14px;
        }
        
        .button-group {
            text-align: center;
            margin-top: 30px;
        }
        
        .info-text {
            font-size: 12px;
            color: #9e9e9e;
            margin-top: 5px;
        }
        
        .password-strength {
            font-size: 12px;
            margin-top: 5px;
        }
        
        .weak { color: #f44336; }
        .medium { color: #ff9800; }
        .strong { color: #4caf50; }
    </style>
</head>
<body>
    <form id="form1" runat="server" enctype="multipart/form-data">
        <div class="container">
            <div class="header">
                <div class="logo">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="40" height="40" fill="white">
                        <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                    </svg>
                </div>
                <h1>User Registration</h1>
                <p class="subtitle">Create your account for the E-learning platform</p>
            </div>
            
            <!-- Name Fields -->
            <div class="form-row">
                <div class="form-group">
                    <asp:Label ID="lblFirstName" runat="server" Text="First Name *" AssociatedControlID="txtFirstName"></asp:Label>
                    <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" placeholder="Enter your first name" MaxLength="50"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" 
                        ControlToValidate="txtFirstName" 
                        ErrorMessage="First name is required." 
                        Display="Dynamic" 
                        CssClass="error-message">
                    </asp:RequiredFieldValidator>
                </div>
                <div class="form-group">
                    <asp:Label ID="lblLastName" runat="server" Text="Last Name" AssociatedControlID="txtLastName"></asp:Label>
                    <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" placeholder="Enter your last name" MaxLength="50"></asp:TextBox>
                </div>
            </div>
            
            <!-- Username -->
            <div class="form-row">
                <div class="form-group full-width">
                    <asp:Label ID="lblUsername" runat="server" Text="Username (Optional)" AssociatedControlID="txtUsername"></asp:Label>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Choose a unique username (optional)" MaxLength="50"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="revUsername" runat="server"
                        ControlToValidate="txtUsername"
                        ValidationExpression="^[a-zA-Z0-9_]{3,50}$"
                        ErrorMessage="Username must be 3-50 characters and contain only letters, numbers, and underscores."
                        Display="Dynamic"
                        CssClass="error-message">
                    </asp:RegularExpressionValidator>
                    <p class="info-text">Username is optional. If provided, must be 3-50 characters (letters, numbers, underscores only)</p>
                </div>
            </div>
            
            <!-- Email -->
            <div class="form-row">
                <div class="form-group full-width">
                    <asp:Label ID="lblEmail" runat="server" Text="Email Address (Optional)" AssociatedControlID="txtEmail"></asp:Label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="Enter your email address (optional)" MaxLength="100"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="revEmail" runat="server"
                        ControlToValidate="txtEmail"
                        ValidationExpression="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
                        ErrorMessage="Please enter a valid email address."
                        Display="Dynamic"
                        CssClass="error-message">
                    </asp:RegularExpressionValidator>
                </div>
            </div>
            
            <!-- Password Fields -->
            <div class="form-row">
                <div class="form-group">
                    <asp:Label ID="lblPassword" runat="server" Text="Password *" AssociatedControlID="txtPassword"></asp:Label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Create a strong password" MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" 
                        ControlToValidate="txtPassword" 
                        ErrorMessage="Password is required." 
                        Display="Dynamic" 
                        CssClass="error-message">
                    </asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revPassword" runat="server"
                        ControlToValidate="txtPassword"
                        ValidationExpression="^.{6,}$"
                        ErrorMessage="Password must be at least 6 characters long."
                        Display="Dynamic"
                        CssClass="error-message">
                    </asp:RegularExpressionValidator>
                    <p class="info-text">Minimum 6 characters required</p>
                </div>
                <div class="form-group">
                    <asp:Label ID="lblConfirmPassword" runat="server" Text="Confirm Password *" AssociatedControlID="txtConfirmPassword"></asp:Label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Re-enter your password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" 
                        ControlToValidate="txtConfirmPassword" 
                        ErrorMessage="Please confirm your password." 
                        Display="Dynamic" 
                        CssClass="error-message">
                    </asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="cvPassword" runat="server"
                        ControlToValidate="txtConfirmPassword"
                        ControlToCompare="txtPassword"
                        ErrorMessage="Passwords do not match."
                        Display="Dynamic"
                        CssClass="error-message">
                    </asp:CompareValidator>
                </div>
            </div>
            
            <!-- Category (User Type) -->
            <div class="form-row">
                <div class="form-group full-width">
                    <asp:Label ID="lblCategory" runat="server" Text="Register As *" AssociatedControlID="ddlCategory"></asp:Label>
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Select Registration Type" Value="" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="Student" Value="student"></asp:ListItem>
                        <asp:ListItem Text="Teacher" Value="teacher"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvCategory" runat="server" 
                        ControlToValidate="ddlCategory" 
                        InitialValue=""
                        ErrorMessage="Please select whether you're registering as a student or teacher." 
                        Display="Dynamic" 
                        CssClass="error-message">
                    </asp:RequiredFieldValidator>
                    <p class="info-text">Choose whether you want to register as a student or teacher</p>
                </div>
            </div>
            
            <!-- Message Label -->
            <div class="form-row">
                <div class="form-group full-width">
                    <asp:Label ID="lblMessage" runat="server" CssClass="success-message"></asp:Label>
                </div>
            </div>
            
            <!-- Buttons -->
            <div class="button-group">
                <asp:Button ID="btnRegister" runat="server" Text="Create Account" CssClass="btn-primary" OnClick="btnRegister_Click" />
                <asp:Button ID="btnClear" runat="server" Text="Clear Form" CssClass="btn-secondary" OnClick="btnClear_Click" CausesValidation="false" />
            </div>
            
            <!-- Footer -->
            <div class="form-row" style="margin-top: 30px; text-align: center;">
                <div class="form-group full-width">
                    <p style="color: #9e9e9e; font-size: 12px;">
                        © 2025 E-Learning Platform. All rights reserved.<br/>
                        Already have an account? <a href="userLogin.aspx" style="color: #4caf50;">Sign in here</a>
                    </p>
                </div>
            </div>
        </div>
    </form>
</body>
</html>