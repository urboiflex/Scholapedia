<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="register.aspx.cs" Inherits="WAPPSS.register" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Register - Create Your Account</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="register.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="register-container">
            <div class="register-image">
                <img id="registerImage" src="images/registration.jpg" alt="Welcome" />
            </div>

            <div class="register-form">
                <!-- Step 1: Basic Information -->
                <div id="step1" class="step-content">
                    <div class="logo-header">
                        <a href="landingPage.aspx" class="logo-link">
                            <img src="Images/scholapedia.png" alt="Scholapedia" class="logo-img" />
                        </a>
                    </div>
                    
                    <div class="form-header">
                        <h1>Registration</h1>
                        <p>Join our community today</p>
                    </div>

                    <div class="step-indicator">
                        <div class="step active">1</div>
                        <div class="step">2</div>
                    </div>

                    <div class="input-group">
                        <label for="txtFirstName">First Name *</label>
                        <asp:TextBox ID="txtFirstName" runat="server" placeholder="Enter your first name" />
                    </div>

                    <div class="input-group">
                        <label for="txtLastName">Last Name</label>
                        <asp:TextBox ID="txtLastName" runat="server" placeholder="Enter your last name (optional)" />
                    </div>

                    <div class="input-group">
                        <label for="txtUsername">Username *</label>
                        <asp:TextBox ID="txtUsername" runat="server" placeholder="Choose a unique username" />
                    </div>

                    <div class="input-group">
                        <label for="txtEmail">Email Address *</label>
                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="Enter your email address" />
                    </div>

                    <div class="input-group">
                        <label for="txtPassword">Password *</label>
                        <div class="password-container">
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" 
                                placeholder="Create a strong password" onkeyup="checkPasswordStrength(this.value)" />
                            <span class="password-toggle" onclick="togglePassword('txtPassword', this)" title="Show password">🙈</span>
                        </div>
                        <div class="strength-indicator" id="passwordStrength" style="display: none;">
                            <div class="strength-bar"></div>
                            <div class="strength-bar"></div>
                            <div class="strength-bar"></div>
                            <div class="strength-bar"></div>
                        </div>
                        <small style="color: #666; margin-top: 5px; display: block;">
                            Password should be at least 8 characters with letters and numbers
                        </small>
                    </div>

                    <div class="input-group">
                        <label for="txtConfirmPassword">Confirm Password *</label>
                        <div class="password-container">
                            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" 
                                placeholder="Confirm your password" onkeyup="checkPasswordMatch()" />
                            <span class="password-toggle" onclick="togglePassword('txtConfirmPassword', this)" title="Show password">🙈</span>
                        </div>
                        <small id="passwordMatch" style="margin-top: 5px; display: block;"></small>
                    </div>

                    <div class="checkbox-group">
                        <asp:CheckBox ID="chkTerms" runat="server" />
                        <label for="chkTerms">
                            I agree to the <a href="#" target="_blank">Terms of Service</a> and 
                            <a href="#" target="_blank">Privacy Policy</a>
                        </label>
                    </div>

                    <asp:Button ID="btnNext" runat="server" Text="Continue" 
                        CssClass="btn" OnClientClick="return validateStep1();" />

                    <div class="login-link">
                        Already have an account? <a href="login.aspx">Sign in here</a>
                    </div>
                </div>

                <!-- Step 2: Category Selection -->
                <div id="step2" class="step-content" style="display:none;">
                    <div class="logo-header">
                        <a href="landingPage.aspx" class="logo-link">
                            <img src="Images/scholapedia.png" alt="Scholapedia" class="logo-img" />
                        </a>
                    </div>
                    
                    <div class="form-header">
                        <h1>Almost Done!</h1>
                        <p>Choose your role to personalize your experience</p>
                    </div>

                    <div class="step-indicator">
                        <div class="step completed">✓</div>
                        <div class="step active">2</div>
                    </div>

                    <div class="input-group">
                        <label style="margin-bottom: 15px;">Select Your Role *</label>
                        
                        <div class="category-option" onclick="selectCategory('Teacher', this)">
                            <div class="category-icon" style="background: #e3f2fd;">👨‍🏫</div>
                            <div class="category-info">
                                <h3>Teacher</h3>
                                <p>Create courses, manage students, and share knowledge</p>
                            </div>
                        </div>

                        <div class="category-option" onclick="selectCategory('Student', this)">
                            <div class="category-icon" style="background: #f3e5f5;">🎓</div>
                            <div class="category-info">
                                <h3>Student</h3>
                                <p>Enroll in courses, learn new skills, and track progress</p>
                            </div>
                        </div>

                        <asp:HiddenField ID="hdnCategory" runat="server" />
                    </div>

                    <asp:Button ID="btnRegister" runat="server" Text="Create My Account" 
                        CssClass="btn" OnClick="btnRegister_Click" OnClientClick="return validateStep2();" />
                    
                    <button type="button" class="btn btn-secondary" onclick="goBackToStep1()">
                        ←  Back
                    </button>
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

            function checkPasswordStrength(password) {
                const indicator = document.getElementById('passwordStrength');
                const bars = indicator.querySelectorAll('.strength-bar');

                if (password.length === 0) {
                    indicator.style.display = 'none';
                    return;
                }

                indicator.style.display = 'flex';

                let strength = 0;
                if (password.length >= 8) strength++;
                if (/[a-z]/.test(password)) strength++;
                if (/[A-Z]/.test(password)) strength++;
                if (/[0-9]/.test(password)) strength++;

                bars.forEach((bar, index) => {
                    bar.className = 'strength-bar';
                    if (index < strength) {
                        if (strength <= 2) bar.classList.add('weak');
                        else if (strength === 3) bar.classList.add('medium');
                        else bar.classList.add('strong');
                    }
                });
            }

            function checkPasswordMatch() {
                const password = document.getElementById('txtPassword').value;
                const confirmPassword = document.getElementById('txtConfirmPassword').value;
                const matchIndicator = document.getElementById('passwordMatch');

                if (confirmPassword.length === 0) {
                    matchIndicator.textContent = '';
                    return;
                }

                if (password === confirmPassword) {
                    matchIndicator.textContent = '✓ Passwords match';
                    matchIndicator.style.color = '#4caf50';
                } else {
                    matchIndicator.textContent = '✗ Passwords do not match';
                    matchIndicator.style.color = '#f44336';
                }
            }

            function validateStep1() {
                const firstName = document.getElementById('txtFirstName').value.trim();
                const username = document.getElementById('txtUsername').value.trim();
                const email = document.getElementById('txtEmail').value.trim();
                const password = document.getElementById('txtPassword').value;
                const confirmPassword = document.getElementById('txtConfirmPassword').value;
                const termsChecked = document.getElementById('chkTerms').checked;

                if (!firstName) {
                    alert('Please enter your first name.');
                    return false;
                }

                if (!username) {
                    alert('Please choose a username.');
                    return false;
                }

                if (!email || !isValidEmail(email)) {
                    alert('Please enter a valid email address.');
                    return false;
                }

                if (!password || password.length < 8) {
                    alert('Password must be at least 8 characters long.');
                    return false;
                }

                if (password !== confirmPassword) {
                    alert('Passwords do not match.');
                    return false;
                }

                if (!termsChecked) {
                    alert('Please agree to the terms and conditions.');
                    return false;
                }

                showStep2();
                return false;
            }

            function isValidEmail(email) {
                return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
            }

            function showStep2() {
                document.getElementById('step1').style.display = 'none';
                document.getElementById('step2').style.display = 'block';
                document.getElementById('registerImage').src = 'images/registration2.jpg';
            }

            function goBackToStep1() {
                document.getElementById('step2').style.display = 'none';
                document.getElementById('step1').style.display = 'block';
                document.getElementById('registerImage').src = 'images/registration.jpg';
            }

            function selectCategory(category, element) {
                // Remove selection from all options
                document.querySelectorAll('.category-option').forEach(opt => {
                    opt.classList.remove('selected');
                });

                // Add selection to clicked option
                element.classList.add('selected');
                document.getElementById('hdnCategory').value = category;
            }

            function validateStep2() {
                const category = document.getElementById('hdnCategory').value;
                if (!category) {
                    alert('Please select your role.');
                    return false;
                }
                return true;
            }
        </script>
    </form>
</body>
</html>