<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TeacherDiscussionForum.aspx.cs" Inherits="WAPPSS.TeacherDiscussionForum" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link id="darkModeCss" runat="server" rel="stylesheet" href="" />
 <style>
    body {
        font-family: 'Segoe UI', Arial, sans-serif;
        margin: 0;
        padding: 0;
        background: linear-gradient(135deg, #e3f2fd, #ffffff);
    }

    .forum-container {
        width: 90%;
        max-width: 1000px;
        margin: 40px auto;
        background: rgba(255, 255, 255, 0.95);
        border-radius: 16px;
        box-shadow: 0 12px 30px rgba(0, 0, 0, 0.1);
        padding: 30px;
        backdrop-filter: blur(4px);
    }

    .header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 2px solid #e0e0e0;
        padding-bottom: 20px;
    }

    .header h1 {
        font-size: 26px;
        color: #1565c0;
        margin: 0;
    }

    .subject-dropdown {
        padding: 10px 14px;
        border-radius: 8px;
        border: 1px solid #90caf9;
        background-color: #e3f2fd;
        color: #1565c0;
        font-size: 15px;
        margin-right: 12px;
        transition: border 0.3s;
    }

    .subject-dropdown:focus {
        outline: none;
        border-color: #42a5f5;
    }

    .add-question-btn {
        background: linear-gradient(to right, #2196f3, #1e88e5);
        color: white;
        border: none;
        border-radius: 50%;
        width: 42px;
        height: 42px;
        font-size: 24px;
        cursor: pointer;
        box-shadow: 0 4px 10px rgba(33, 150, 243, 0.3);
        transition: background 0.3s;
    }

    .add-question-btn:hover {
        background: linear-gradient(to right, #1e88e5, #1565c0);
    }

    .questions-list {
        margin-top: 30px;
    }

    /* Default student styling (blue) */
    .question-item {
        background: #f1f8ff;
        border-left: 4px solid #2196f3;
        padding: 18px 20px;
        border-radius: 8px;
        margin-bottom: 15px;
        transition: background 0.2s;
    }

    .question-item:hover {
        background-color: #e3f2fd;
    }

    /* Teacher styling (red) */
    .question-item.teacher {
        background: #fff1f1;
        border-left: 4px solid #f44336;
    }

    .question-item.teacher:hover {
        background-color: #ffebee;
    }

    .question-title {
        font-weight: bold;
        color: #0d47a1;
        font-size: 18px;
        margin-bottom: 8px;
    }

    .question-item.teacher .question-title {
        color: #c62828;
    }

    .question-meta {
        font-size: 13px;
        color: #607d8b;
        display: flex;
        flex-wrap: wrap;
        gap: 16px;
        align-items: center;
    }

    .user-type-badge {
        padding: 2px 8px;
        border-radius: 12px;
        font-size: 11px;
        font-weight: 600;
        text-transform: uppercase;
    }

    .user-type-badge.student {
        background-color: #e3f2fd;
        color: #1565c0;
    }

    .user-type-badge.teacher {
        background-color: #ffebee;
        color: #c62828;
    }

    .no-questions {
        text-align: center;
        padding: 40px;
        color: #78909c;
        font-style: italic;
    }

    .reply-count {
        display: flex;
        align-items: center;
        gap: 5px;
    }

    .reply-count i {
        color: #2196f3;
    }

    .question-item.teacher .reply-count i {
        color: #f44336;
    }

    .best-answer-tag {
        background-color: #2196f3;
        color: white;
        padding: 2px 6px;
        border-radius: 3px;
        font-size: 12px;
        margin-left: 8px;
    }

    a {
        text-decoration: none;
        color: #0d47a1;
    }

    a:hover {
        text-decoration: underline;
    }

    .question-item.teacher a {
        color: #c62828;
    }

    .back-button {
        background-color: #6b7280;
        color: white;
        padding: 8px 16px;
        border-radius: 6px;
        text-decoration: none;
        font-size: 14px;
        transition: background-color 0.3s;
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }

    .back-button:hover {
        background-color: #4b5563;
        color: white;
        text-decoration: none;
    }

    /* Dark mode styles */
    .dark-mode {
        background: linear-gradient(135deg, #1a1a1a, #2d2d2d) !important;
        color: #e0e0e0;
    }

    .dark-mode .forum-container {
        background: rgba(42, 42, 42, 0.95) !important;
        color: #e0e0e0;
        box-shadow: 0 12px 30px rgba(0, 0, 0, 0.3);
    }

    .dark-mode .header {
        border-bottom-color: #404040;
    }

    .dark-mode .header h1 {
        color: #64b5f6;
    }

    .dark-mode .subject-dropdown {
        background-color: #3a3a3a;
        border-color: #555;
        color: #e0e0e0;
    }

    .dark-mode .subject-dropdown:focus {
        border-color: #64b5f6;
    }

    .dark-mode .question-item {
        background: #3a3a3a !important;
        border-left: 4px solid #64b5f6;
    }

    .dark-mode .question-item:hover {
        background-color: #404040 !important;
    }

    .dark-mode .question-item.teacher {
        background: #442c2c !important;
        border-left: 4px solid #f44336;
    }

    .dark-mode .question-item.teacher:hover {
        background-color: #4a3333 !important;
    }

    .dark-mode .question-title {
        color: #64b5f6;
    }

    .dark-mode .question-item.teacher .question-title {
        color: #ff6b6b;
    }

    .dark-mode .question-meta {
        color: #b0b0b0;
    }

    .dark-mode .user-type-badge.student {
        background-color: #2a3f5f;
        color: #64b5f6;
    }

    .dark-mode .user-type-badge.teacher {
        background-color: #5f2a2a;
        color: #ff6b6b;
    }

    .dark-mode .no-questions {
        color: #888;
    }

    .dark-mode .reply-count i {
        color: #64b5f6;
    }

    .dark-mode .question-item.teacher .reply-count i {
        color: #ff6b6b;
    }

    .dark-mode a {
        color: #64b5f6;
    }

    .dark-mode .question-item.teacher a {
        color: #ff6b6b;
    }

</style>

</head>
<body class='<%= (Session["DarkMode"] != null && (bool)Session["DarkMode"]) ? "dark-mode" : "" %>'>
   <form id="form1" runat="server">

        <div class="forum-container">
            <div class="header">
                <h1>Discussion Forum</h1>
                <div>
                    <asp:DropDownList ID="ddlSubjects" runat="server" CssClass="subject-dropdown" AutoPostBack="true" 
                        OnSelectedIndexChanged="ddlSubjects_SelectedIndexChanged" AppendDataBoundItems="true">
                        <asp:ListItem Value="0">-- Select Subject --</asp:ListItem>
                    </asp:DropDownList>
                    <asp:Button ID="btnAddQuestion" runat="server" Text="+" CssClass="add-question-btn" OnClick="btnAddQuestion_Click" />
                    <div style="margin-top: 20px;">
                        <a href="course.aspx" class="back-button">
                            <i class="fas fa-arrow-left"></i> Back to Courses
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="questions-list">
                <asp:Repeater ID="rptQuestions" runat="server" OnItemCommand="rptQuestions_ItemCommand1">
                    <ItemTemplate>
                        <div class='question-item <%# Eval("UserType").ToString().ToLower() == "teacher" ? "teacher" : "student" %>'>
                            <div class="question-title">
                                <asp:HyperLink ID="lnkQuestion" runat="server" 
                                    NavigateUrl='<%# "TeacherQuestionDetail.aspx?ID=" + Eval("QuestionID") %>'
                                    Text='<%# Eval("Title") %>'></asp:HyperLink>
                            </div>
                            <div class="question-meta">
                                <span>Posted by <%# Eval("Username") %> 
                                    <span class='user-type-badge <%# Eval("UserType").ToString().ToLower() %>'>
                                        <%# Eval("UserType") %>
                                    </span>
                                    on <%# Eval("PostDate", "{0:MMM dd, yyyy}") %>
                                </span>
                                <span class="reply-count">
                                    <i class="fas fa-comment"></i> <%# Eval("ReplyCount") %> replies
                                </span>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                
                <asp:Label ID="lblNoQuestions" runat="server" Text="No questions found for this subject." 
                    CssClass="no-questions" Visible="false"></asp:Label>
            </div>
        </div>
    </form>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
</body>
</html>