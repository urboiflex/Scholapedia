<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Event.aspx.cs" Inherits="WAPPSS.Event" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link id="darkModeCss" rel="stylesheet" runat="server" />
<style>
    * {
        box-sizing: border-box;
    }

    body {
        font-family: 'Segoe UI', sans-serif;
        background-color: #f0f8ff;
        padding: 30px;
        margin: 0;
    }

    form {
        background-color: #ffffff;
        max-width: 500px;
        margin: auto;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 8px 20px rgba(0, 123, 255, 0.2);
    }

    .form-control {
        display: block;
        width: 100%;
        padding: 12px 15px;
        margin-bottom: 20px;
        border: 1px solid #b0d4ff;
        border-radius: 8px;
        font-size: 15px;
        transition: border-color 0.3s ease;
    }

    .form-control:focus {
        border-color: #007bff;
        outline: none;
        box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
    }

    .btn-submit {
        background-color: #007bff;
        color: #fff;
        padding: 12px 25px;
        font-size: 16px;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        transition: background-color 0.3s ease;
        width: 100%;
    }

    .btn-submit:hover {
        background-color: #0056b3;
    }
    .btn-cancel {
    background-color: #dc3545; /* Bootstrap red */
    color: #fff;
    padding: 12px 25px;
    font-size: 16px;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    transition: background-color 0.3s ease;
    width: 100%;
    margin-top: 10px; /* optional spacing */
}

.btn-cancel:hover {
    background-color: #c82333;
}


    .calendar-day {
        margin-top: 30px;
        font-size: 18px;
        background-color: #e6f2ff;
        color: #007bff;
        padding: 12px;
        border-radius: 10px;
        text-align: center;
        width: 100px;
        margin-left: auto;
        margin-right: auto;
        box-shadow: 0 4px 10px rgba(0, 123, 255, 0.15);
    }
</style>

</head>
<body class='<%= (Session["DarkMode"] != null && (bool)Session["DarkMode"]) ? "dark-theme" : "" %>'>
<div class="event-container">
    <form id="form1" runat="server">
        <asp:TextBox ID="txtEventName" runat="server" placeholder="Event Name" CssClass="form-control" />
        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" placeholder="Description" CssClass="form-control" />
        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control">
            <asp:ListItem Text="Meeting" Value="Meeting" />
            <asp:ListItem Text="Assessment" Value="Assessment" />
            <asp:ListItem Text="Deadline" Value="Deadline" />
        </asp:DropDownList>
        <asp:TextBox ID="txtDate" runat="server" TextMode="Date" CssClass="form-control" />
        
        <asp:Button ID="btnSave" runat="server" Text="Save Event" OnClick="btnSave_Click" CssClass="btn-submit" />
        <asp:Button ID="btnCancel" runat="server" Text="Cancel" PostBackUrl="~/Student_Dashboard.aspx" CssClass="btn-cancel" />
    </form>
</div>





    </form>
</body>
</html>
