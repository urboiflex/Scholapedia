<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreateQuestion.aspx.cs" Inherits="WAPPSS.CreateQuestion" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
     <title>Ask a Question</title>
        <link id="darkModeCss" runat="server" rel="stylesheet" href="" />

<style>
    body {
        font-family: 'Segoe UI', sans-serif;
        background: #e3f2fd;
        margin: 0;
        padding: 20px;
    }

    .container {
        max-width: 800px;
        margin: 0 auto;
        background: #ffffff;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
    }

    h1 {
        margin-top: 0;
        color: #0d47a1;
        font-size: 28px;
        border-bottom: 2px solid #bbdefb;
        padding-bottom: 10px;
    }

    .form-group {
        margin-bottom: 20px;
    }

    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: 600;
        color: #1e88e5;
    }

    .form-group input[type="text"],
    .form-group textarea {
        width: 100%;
        padding: 12px;
        border: 1px solid #90caf9;
        border-radius: 6px;
        font-size: 14px;
        transition: border-color 0.3s, box-shadow 0.3s;
        box-sizing: border-box;
    }

    .form-group input[type="text"]:focus,
    .form-group textarea:focus {
        border-color: #42a5f5;
        box-shadow: 0 0 0 3px rgba(66, 165, 245, 0.2);
        outline: none;
    }

    .form-group textarea {
        min-height: 180px;
        resize: vertical;
        font-family: 'Segoe UI', sans-serif;
    }

    .subject-info {
        background: #e3f2fd;
        padding: 12px 15px;
        border-radius: 6px;
        border-left: 5px solid #2196f3;
        margin-bottom: 25px;
        font-size: 15px;
        color: #0d47a1;
    }

    .action-buttons {
        display: flex;
        justify-content: flex-end;
        gap: 12px;
        margin-top: 30px;
    }

    .btn {
        padding: 10px 20px;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-weight: 600;
        font-size: 14px;
        transition: background-color 0.3s, box-shadow 0.3s;
    }

    .btn-primary {
        background: #1e88e5;
        color: #fff;
        box-shadow: 0 4px 10px rgba(30, 136, 229, 0.3);
    }

    .btn-primary:hover {
        background: #1565c0;
        box-shadow: 0 6px 14px rgba(21, 101, 192, 0.4);
    }

    .btn-secondary {
        background: #e3f2fd;
        color: #1e88e5;
        border: 1px solid #90caf9;
    }

    .btn-secondary:hover {
        background: #bbdefb;
        color: #0d47a1;
    }
</style>

</head>
<body class='<%= (Session["DarkMode"] != null && (bool)Session["DarkMode"]) ? "dark-mode" : "" %>'>
     <form id="form1" runat="server">
        <div class="container">
            <h1>Ask a Question</h1>
            
            <div class="subject-info">
                Subject: <strong><asp:Label ID="lblSubject" runat="server" /></strong>
            </div>
            
            <div class="form-group">
                <label for="<%= txtTitle.ClientID %>">Title</label>
                <asp:TextBox ID="txtTitle" runat="server" placeholder="Enter your question title" />
            </div>
            
            <div class="form-group">
                <label for="<%= txtContent.ClientID %>">Details</label>
                <asp:TextBox ID="txtContent" runat="server" TextMode="MultiLine" Rows="8"
                    placeholder="Provide details about your question" />
            </div>
            
            <div class="action-buttons">
                <asp:Button ID="btnBack" runat="server" Text="Back" CssClass="btn btn-secondary" 
                    OnClick="btnBack_Click" />
                <asp:Button ID="btnSubmit" runat="server" Text="Post Question" CssClass="btn btn-primary" 
                    OnClick="btnSubmit_Click" />
            </div>
        </div>
    </form>
</body>
</html>