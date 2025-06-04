<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="WAPPSS.login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login - Student & Teacher Portal</title>
    <link href="login.css" rel="stylesheet" />
    <style>
        body {
            background: linear-gradient(135deg, #e0e7ef 0%, #9fb0e6 50%, #f5f5f5 100%);
            margin: 0;
            min-height: 100vh;
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .disabled-field {
            background-color: #e0e0e0 !important;
            color: #666 !important;
        }
        
        .login-wrapper {
            display: flex;
            align-items: stretch;
            justify-content: center;
            box-shadow: 0 4px 24px rgba(0,0,0,0.09);
            background: #fff;
            border-radius: 14px;
            max-width: 900px;
            width: 100%;
            overflow: hidden;
            min-height: 700px;
        }
        
        .login-image {
            flex: 1;
            max-width: 50%;
        }
        
        .login-image img {
            border-radius: 14px 0 0 14px;
            display: block;
            width: 100%;
            height: 100%;
            object-fit: cover;
            min-height: 700px;
        }
        
        .login-form-container {
            padding: 40px 50px 50px 50px;
            flex: 1;
            min-height: 700px;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
        }
        
        .login-form {
            width: 100%;
        }
        
        .back-link-top {
            margin-bottom: 30px;
            text-align: center;
        }
        
        .logo-link {
            display: inline-block;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        
        .logo-link:hover {
            transform: translateY(-2px);
            filter: brightness(1.1);
        }
        
        .logo-img {
            height: 60px;
            width: auto;
            max-width: 300px;
            transition: all 0.3s ease;
        }
        
        .logo-img:hover {
            transform: scale(1.05);
        }
        
        .login-form h1 {
            font-size: 2.5rem;
            margin-bottom: 10px;
            color: #3651aa;
            font-weight: 700;
            text-align: center;
        }
        
        .login-subtitle {
            text-align: center;
            color: #666;
            font-size: 16px;
            margin-bottom: 35px;
            font-weight: 500;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-group label {
            display: block;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            font-size: 16px;
        }
        
        .form-input {
            width: 100%;
            padding: 16px 20px;
            border: 2px solid #d0d1e6;
            border-radius: 10px;
            font-size: 16px;
            background: #f8f9fa;
            transition: all 0.3s ease;
            box-sizing: border-box;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #3651aa;
            background: white;
            box-shadow: 0 0 0 3px rgba(54, 81, 170, 0.1);
        }
        
        .password-container {
            position: relative;
        }
        
        .password-container .form-input {
            padding-right: 55px;
        }
        
        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #666;
            font-size: 20px;
            user-select: none;
            padding: 8px;
            border-radius: 4px;
            transition: all 0.2s ease;
            background: rgba(255, 255, 255, 0.8);
            border: 1px solid #d0d1e6;
        }
        
        .password-toggle:hover {
            color: #333;
            background: rgba(255, 255, 255, 1);
            border-color: #3651aa;
        }
        
        .remember-me {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            gap: 10px;
        }
        
        .remember-me input[type="checkbox"] {
            transform: scale(1.2);
        }
        
        .remember-me label {
            font-size: 16px;
            cursor: pointer;
            color: #333;
            margin-bottom: 0;
        }
        
        .login-btn {
            margin-top: 20px;
            width: 100%;
            background: linear-gradient(135deg, #3651aa 0%, #223378 100%);
            color: #fff;
            font-size: 18px;
            border: none;
            padding: 16px 0;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(54, 81, 170, 0.3);
        }
        
        .login-btn:active {
            transform: translateY(0);
        }
        
        .register-link {
            margin-top: 30px;
            margin-bottom: 30px;
            text-align: center;
            font-size: 16px;
            color: #666;
        }
        
        .register-link a {
            color: #3651aa;
            text-decoration: none;
            font-weight: 600;
        }
        
        .register-link a:hover {
            text-decoration: underline;
        }
        
        /* Mobile responsiveness */
        @media (max-width: 768px) {
            .login-wrapper {
                flex-direction: column;
                max-width: 500px;
                margin: 20px;
                min-height: auto;
            }
            
            .login-image {
                width: 100%;
                max-width: 100%;
            }
            
            .login-image img {
                border-radius: 14px 14px 0 0;
                width: 100%;
                height: 250px;
                object-fit: cover;
                min-height: 250px;
            }
            
            .login-form-container {
                padding: 40px 30px 40px 30px;
                min-height: auto;
            }
            
            .login-form h1 {
                font-size: 2rem;
            }
            
            .logo-img {
                height: 35px;
            }
            
            .register-link {
                margin-bottom: 25px;
            }
        }
        
        @media (max-width: 480px) {
            .login-form-container {
                padding: 30px 20px 30px 20px;
            }
            
            .login-form h1 {
                font-size: 1.8rem;
            }
            
            .form-input {
                padding: 14px 16px;
            }
            
            .login-btn {
                padding: 14px 0;
                font-size: 16px;
            }
            
            .logo-img {
                height: 32px;
            }
            
            .register-link {
                margin-bottom: 20px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-wrapper">
            <div class="login-image">
                <img src="images/login2.jpg" alt="Login Image" />
            </div>
            <div class="login-form-container">
                <div class="login-form">
                    <div class="back-link-top">
                        <a href="landingPage.aspx" class="logo-link">
                            <img src="Images/scholapedia.png" alt="Scholapedia" class="logo-img" />
                        </a>
                    </div>
                    <h1>Portal Login</h1>
                    <div class="login-subtitle">Users Welcome</div>
                    <div class="form-group">
                        <label for="<%=txtUsername.ClientID%>">Username/Email</label>
                        <asp:TextBox ID="txtUsername" runat="server" placeholder="Enter username or email" CssClass="form-input" EnableViewState="true"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="<%=txtPassword.ClientID%>">Password</label>
                        <div class="password-container">
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Enter password" CssClass="form-input" EnableViewState="true"></asp:TextBox>
                            <span class="password-toggle" onclick="togglePassword('<%=txtPassword.ClientID%>', this)" title="Show password">🙈</span>
                        </div>
                    </div>
                    <div class="remember-me">
                        <asp:CheckBox ID="chkRemember" runat="server" EnableViewState="true" />
                        <label for="<%=chkRemember.ClientID%>">Remember me</label>
                    </div>
                    <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="login-btn" OnClick="btnLogin_Click" UseSubmitBehavior="true" />
                    <div class="register-link">
                        Don't have an account? <a href="register.aspx">Register here</a>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function togglePassword(inputId, icon) {
                const input = document.getElementById(inputId);
                if (input.type === "password") {
                    input.type = "text";
                    icon.innerHTML = "👁️";
                    icon.title = "Hide password";
                } else {
                    input.type = "password";
                    icon.innerHTML = "🙈";
                    icon.title = "Show password";
                }
            }

            // Debug function to check form values before submission
            function checkFormValues() {
                const username = document.getElementById('<%=txtUsername.ClientID%>').value;
                const password = document.getElementById('<%=txtPassword.ClientID%>').value;
                alert('Debug: Username = "' + username + '", Password = "' + password + '"');
            }

            // Add form validation before submit
            function validateForm() {
                const username = document.getElementById('<%=txtUsername.ClientID%>').value.trim();
                const password = document.getElementById('<%=txtPassword.ClientID%>').value.trim();
                
                if (username === '') {
                    alert('⚠️ Please enter your username or email.');
                    return false;
                }
                if (password === '') {
                    alert('⚠️ Please enter your password.');
                    return false;
                }
                return true;
            }

            // Override form submission to add validation
            document.addEventListener('DOMContentLoaded', function() {
                const form = document.getElementById('form1');
                const loginButton = document.getElementById('<%=btnLogin.ClientID%>');

                if (loginButton) {
                    loginButton.addEventListener('click', function (e) {
                        if (!validateForm()) {
                            e.preventDefault();
                            return false;
                        }
                    });
                }
            });
        </script>
    </form>
</body>
</html>