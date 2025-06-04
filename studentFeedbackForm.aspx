<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="studentFeedbackForm.aspx.cs" Inherits="WAPPSS.studentFeedbackForm" UnobtrusiveValidationMode="None" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Feedback Form</title>
    <link id="darkModeCss" runat="server" rel="stylesheet" href="" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #e3f2fd, #ffffff);
            min-height: 100vh;
        }

        .feedback-container {
            width: 90%;
            max-width: 800px;
            margin: 40px auto;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 16px;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.1);
            padding: 40px;
            backdrop-filter: blur(4px);
        }

        .header {
            text-align: center;
            border-bottom: 2px solid #e0e0e0;
            padding-bottom: 25px;
            margin-bottom: 30px;
        }

        .header h1 {
            font-size: 32px;
            color: #1565c0;
            margin: 0 0 10px 0;
            font-weight: 600;
        }

        .header p {
            color: #607d8b;
            font-size: 16px;
            margin: 0;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-label {
            display: block;
            font-weight: 600;
            color: #1565c0;
            margin-bottom: 8px;
            font-size: 16px;
        }

        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e3f2fd;
            border-radius: 8px;
            font-size: 15px;
            background-color: #fafafa;
            transition: all 0.3s ease;
            box-sizing: border-box;
        }

        .form-control:focus {
            outline: none;
            border-color: #2196f3;
            background-color: #ffffff;
            box-shadow: 0 0 0 3px rgba(33, 150, 243, 0.1);
        }

        .form-control.textarea {
            min-height: 120px;
            resize: vertical;
            font-family: 'Segoe UI', Arial, sans-serif;
        }

        .category-dropdown {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23666' d='M6 8L2 4h8z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 12px center;
            padding-right: 40px;
        }

        .btn-submit {
            background: linear-gradient(to right, #2196f3, #1e88e5);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 14px 30px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(33, 150, 243, 0.3);
        }

        .btn-submit:hover {
            background: linear-gradient(to right, #1e88e5, #1565c0);
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(33, 150, 243, 0.4);
        }

        .btn-submit:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .btn-back {
            background-color: #6b7280;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            font-size: 14px;
            transition: background 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 20px;
        }

        .btn-back:hover {
            background-color: #4b5563;
            color: white;
            text-decoration: none;
        }

        .success-message {
            background-color: #e8f5e8;
            border: 1px solid #4caf50;
            color: #2e7d32;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .error-message {
            background-color: #ffebee;
            border: 1px solid #f44336;
            color: #c62828;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .required {
            color: #f44336;
        }

        .form-actions {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
        }

        .char-counter {
            text-align: right;
            font-size: 12px;
            color: #607d8b;
            margin-top: 5px;
        }

        /* Dark mode styles */
        .dark-mode {
            background: linear-gradient(135deg, #1a1a1a, #2d2d2d);
        }

        .dark-mode .feedback-container {
            background: rgba(42, 42, 42, 0.95);
            color: #e0e0e0;
        }

        .dark-mode .header {
            border-bottom-color: #404040;
        }

        .dark-mode .header h1 {
            color: #64b5f6;
        }

        .dark-mode .header p {
            color: #b0b0b0;
        }

        .dark-mode .form-label {
            color: #64b5f6;
        }

        .dark-mode .form-control {
            background-color: #3a3a3a;
            border-color: #555;
            color: #e0e0e0;
        }

        .dark-mode .form-control:focus {
            border-color: #64b5f6;
            background-color: #404040;
        }

        .dark-mode .form-actions {
            border-top-color: #404040;
        }

        @media (max-width: 768px) {
            .feedback-container {
                width: 95%;
                padding: 25px;
                margin: 20px auto;
            }

            .header h1 {
                font-size: 24px;
            }

            .form-control {
                padding: 10px 12px;
            }
        }
    </style>
</head>
<body class='<%= (Session["DarkMode"] != null && (bool)Session["DarkMode"]) ? "dark-mode" : "" %>'>
    <form id="form1" runat="server">
        <div class="feedback-container">
            <div style="margin-bottom: 20px;">
                <a href="Student_Dashboard.aspx" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </div>

            <div class="header">
                <h1><i class="fas fa-comment-dots"></i> Feedback Form</h1>
                <p>We value your feedback! Help us improve our platform by sharing your thoughts.</p>
            </div>

            <asp:Panel ID="pnlSuccessMessage" runat="server" CssClass="success-message" Visible="false">
                <i class="fas fa-check-circle"></i>
                <asp:Label ID="lblSuccessMessage" runat="server" Text="Thank you for your feedback! We appreciate your input."></asp:Label>
            </asp:Panel>

            <asp:Panel ID="pnlErrorMessage" runat="server" CssClass="error-message" Visible="false">
                <i class="fas fa-exclamation-triangle"></i>
                <asp:Label ID="lblErrorMessage" runat="server"></asp:Label>
            </asp:Panel>

            <div class="form-group">
                <asp:Label ID="lblCategory" runat="server" CssClass="form-label" AssociatedControlID="ddlCategory">
                    Feedback Category <span class="required">*</span>
                </asp:Label>
                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control category-dropdown">
                    <asp:ListItem Value="">-- Select Category --</asp:ListItem>
                    <asp:ListItem Value="Bug Report">Bug Report</asp:ListItem>
                    <asp:ListItem Value="Feature Request">Feature Request</asp:ListItem>
                    <asp:ListItem Value="User Experience">User Experience</asp:ListItem>
                    <asp:ListItem Value="Performance">Performance</asp:ListItem>
                    <asp:ListItem Value="Content Quality">Content Quality</asp:ListItem>
                    <asp:ListItem Value="General Feedback">General Feedback</asp:ListItem>
                    <asp:ListItem Value="Other">Other</asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvCategory" runat="server" 
                    ControlToValidate="ddlCategory" 
                    ErrorMessage="Please select a feedback category."
                    CssClass="error-message" 
                    Display="Dynamic">
                </asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <asp:Label ID="lblContent" runat="server" CssClass="form-label" AssociatedControlID="txtContent">
                    Your Feedback <span class="required">*</span>
                </asp:Label>
                <asp:TextBox ID="txtContent" runat="server" 
                    TextMode="MultiLine" 
                    CssClass="form-control textarea" 
                    placeholder="Please provide detailed feedback. Be specific about what you liked, what needs improvement, or any issues you encountered..."
                    MaxLength="2000"
                    onkeyup="updateCharCounter()">
                </asp:TextBox>
                <div class="char-counter">
                    <span id="charCount">0</span>/2000 characters
                </div>
                <asp:RequiredFieldValidator ID="rfvContent" runat="server" 
                    ControlToValidate="txtContent" 
                    ErrorMessage="Please enter your feedback."
                    CssClass="error-message" 
                    Display="Dynamic">
                </asp:RequiredFieldValidator>
            </div>

            <div class="form-actions">
                <asp:Button ID="btnSubmit" runat="server" 
                    Text="Submit Feedback" 
                    CssClass="btn-submit" 
                    OnClick="btnSubmit_Click" />
            </div>
        </div>
    </form>

    <script type="text/javascript">
        function updateCharCounter() {
            var textArea = document.getElementById('<%= txtContent.ClientID %>');
            var charCount = document.getElementById('charCount');
            var currentLength = textArea.value.length;
            charCount.textContent = currentLength;

            // Change color when approaching limit
            if (currentLength > 1800) {
                charCount.style.color = '#f44336';
            } else if (currentLength > 1500) {
                charCount.style.color = '#ff9800';
            } else {
                charCount.style.color = '#607d8b';
            }
        }

        // Initialize character counter on page load
        window.onload = function () {
            updateCharCounter();
        };
    </script>
</body>
</html>