<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="adminLogin.aspx.cs" Inherits="WAPPSS.adminLogin" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Login</title>
    <style>
        body {
            background-color: #f5f5fa;
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }
        
        .container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            padding: 30px;
            width: 400px;
            text-align: center;
        }
        
        .logo {
            background-color: #7c4dff;
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0 auto 30px;
        }
        
        .logo img {
            width: 40px;
            height: 40px;
        }
        
        h1 {
            color: #7c4dff;
            margin-bottom: 10px;
        }
        
        .subtitle {
            color: #9e9e9e;
            margin-bottom: 30px;
        }
        
        .form-group {
            text-align: left;
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #616161;
        }
        
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #e0e0e0;
            border-radius: 5px;
            box-sizing: border-box;
        }
        
        .btn-primary {
            background-color: #7c4dff;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 12px;
            width: 100%;
            cursor: pointer;
            font-size: 16px;
            margin-top: 20px;
        }
        
        .btn-primary:hover {
            background-color: #6a3de8;
        }
        
        .error-message {
            color: red;
            margin-top: 5px;
            font-size: 14px;
        }
        
        .footer {
            margin-top: 30px;
            color: #9e9e9e;
        }
        
        .form-check {
            display: flex;
            align-items: center;
            margin-top: 15px;
            text-align: left;
        }
        
        .form-check-input {
            margin-right: 8px;
        }
        
        .form-check-label {
            color: #616161;
            font-size: 14px;
        }
        
        .password-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 5px;
        }
        
        .forgot-password a {
            color: #7c4dff;
            text-decoration: none;
            font-size: 14px;
        }
        
        .forgot-password a:hover {
            text-decoration: underline;
        }
        
        .register-link {
            margin-top: 15px;
            font-size: 14px;
            color: #616161;
        }
        
        .register-link a {
            color: #7c4dff;
            text-decoration: none;
            font-weight: 500;
        }
        
        .register-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="logo">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="40" height="40" fill="white">
                    <path d="M6 2h12a2 2 0 0 1 2 2v16a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2zm0 2v16h12V4H6zm2 2h8v2H8V6zm0 4h8v2H8v-2zm0 4h8v2H8v-2z"/>
                </svg>
            </div>
            
            <h1>Admin Login</h1>
            <p class="subtitle">Sign in to access the E-learning admin dashboard</p>
            
            <div class="form-group">
                <asp:Label ID="lblUsername" runat="server" Text="Username" AssociatedControlID="txtUsername"></asp:Label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Enter your username"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvUsername" runat="server" 
                    ControlToValidate="txtUsername" 
                    ErrorMessage="Username is required." 
                    Display="Dynamic" 
                    CssClass="error-message">
                </asp:RequiredFieldValidator>
            </div>
            
            <div class="form-group">
                <div class="password-header">
                    <asp:Label ID="lblPassword" runat="server" Text="Password" AssociatedControlID="txtPassword"></asp:Label>
                    <div class="forgot-password">
                        <a href="#" onclick="alert('Contact administrator for password reset.'); return false;">Forgot password?</a>
                    </div>
                </div>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter your password"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" 
                    ControlToValidate="txtPassword" 
                    ErrorMessage="Password is required." 
                    Display="Dynamic" 
                    CssClass="error-message">
                </asp:RequiredFieldValidator>
            </div>
            
            <div class="form-check">
                <asp:CheckBox ID="chkRememberMe" runat="server" CssClass="form-check-input" />
                <asp:Label ID="lblRememberMe" runat="server" Text="Remember me for 30 days" CssClass="form-check-label" AssociatedControlID="chkRememberMe"></asp:Label>
            </div>
            
            <asp:Button ID="btnLogin" runat="server" Text="Sign In" CssClass="btn-primary" OnClick="btnLogin_Click" />
            
            
            
            <div class="footer">
                <asp:Label ID="lblMessage" runat="server" ForeColor="Green"></asp:Label>
                <p>© 2025 E-Learning Admin Portal. All rights reserved.</p>
            </div>
        </div>
    </form>
</body>
</html>