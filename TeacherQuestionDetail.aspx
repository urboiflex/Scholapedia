<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TeacherQuestionDetail.aspx.cs" Inherits="WAPPSS.TeacherQuestionDetail" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Question Details</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <link id="darkModeCss" runat="server" rel="stylesheet" href="" />
    <style>
    body {
        font-family: 'Segoe UI', sans-serif;
        background: #f0f4f8;
        margin: 0;
        padding: 20px;
        color: #1f2937;
    }

    .container {
        max-width: 900px;
        margin: auto;
        background: #ffffff;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
    }

    .question {
        border-bottom: 2px solid #e5e7eb;
        padding-bottom: 25px;
        margin-bottom: 25px;
    }

    .question-title {
        font-size: 28px;
        font-weight: 600;
        color: #1d4ed8;
        margin-bottom: 10px;
    }

    .question-meta {
        color: #6b7280;
        font-size: 14px;
        margin-bottom: 15px;
    }

    .question-content {
        font-size: 16px;
        line-height: 1.7;
    }

    .replies {
        margin-top: 40px;
    }

    .replies h3 {
        font-size: 20px;
        margin-bottom: 15px;
        color: #1e3a8a;
    }

    .reply {
        padding: 20px;
        border: 1px solid #dbeafe;
        margin-bottom: 20px;
        border-radius: 10px;
        background-color: #f9fbfe;
        position: relative;
    }

    .reply.best {
        border-left: 6px solid #2563eb;
        background-color: #eff6ff;
    }

    .reply-meta {
        color: #6b7280;
        font-size: 13px;
        margin-bottom: 12px;
    }

    .reply-actions {
        margin-top: 15px;
    }

    .btn-like,
    .btn-edit,
    .btn-delete,
    .btn-best {
        display: inline-block;
        background: none;
        border: none;
        color: #2563eb;
        cursor: pointer;
        font-size: 14px;
        margin-right: 10px;
        text-decoration: underline;
    }

    .btn-like.liked {
        color: #1e40af;
        font-weight: bold;
    }

    .btn-best {
        background-color: #1d4ed8;
        color: white;
        padding: 6px 12px;
        border-radius: 5px;
        text-decoration: none;
        border: none;
    }

    .btn-best:hover {
        background-color: #1e3a8a;
    }

    .btn-submit {
        background-color: #2563eb;
        color: white;
        padding: 8px 16px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-weight: 500;
        transition: background 0.3s ease;
    }

    .btn-submit:hover {
        background-color: #1d4ed8;
    }

    .reply-form {
        margin-top: 40px;
        background-color: #f1f5f9;
        padding: 20px;
        border-radius: 10px;
    }

    .form-group textarea,
    .form-control {
        width: 100%;
        padding: 12px;
        font-size: 15px;
        border-radius: 6px;
        border: 1px solid #cbd5e1;
        background-color: #ffffff;
        margin-bottom: 15px;
    }

    .best-tag {
        background: #1d4ed8;
        color: white;
        padding: 3px 8px;
        font-size: 12px;
        border-radius: 4px;
        margin-left: 10px;
        font-weight: 500;
        position: absolute;
        top: 10px;
        right: 10px;
    }

    .btn-delete, .btn-edit {
        color: #64748b;
    }

    .btn-delete:hover, .btn-edit:hover {
        color: #1e40af;
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
    }

    .btn-back:hover {
        background-color: #4b5563;
    }

    /* Dark mode styles */
    .dark-mode {
        background: #1a1a1a !important;
        color: #e0e0e0;
    }

    .dark-mode .container {
        background: #2a2a2a !important;
        color: #e0e0e0;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
    }

    .dark-mode .question {
        border-bottom-color: #404040;
    }

    .dark-mode .question-title {
        color: #64b5f6;
    }

    .dark-mode .question-meta {
        color: #b0b0b0;
    }

    .dark-mode .replies h3 {
        color: #64b5f6;
    }

    .dark-mode .reply {
        background-color: #3a3a3a !important;
        border-color: #555;
    }

    .dark-mode .reply.best {
        border-left: 6px solid #64b5f6;
        background-color: #2a3f5f !important;
    }

    .dark-mode .reply-meta {
        color: #b0b0b0;
    }

    .dark-mode .btn-like,
    .dark-mode .btn-edit,
    .dark-mode .btn-delete {
        color: #64b5f6;
    }

    .dark-mode .btn-best {
        background-color: #64b5f6;
    }

    .dark-mode .btn-best:hover {
        background-color: #5a9fd8;
    }

    .dark-mode .btn-submit {
        background-color: #64b5f6;
    }

    .dark-mode .btn-submit:hover {
        background-color: #5a9fd8;
    }

    .dark-mode .reply-form {
        background-color: #333333 !important;
    }

    .dark-mode .form-control {
        background-color: #3a3a3a !important;
        border-color: #555;
        color: #e0e0e0;
    }

    .dark-mode .form-control:focus {
        border-color: #64b5f6;
    }

    .dark-mode .best-tag {
        background: #64b5f6;
    }

    .dark-mode .btn-delete:hover,
    .dark-mode .btn-edit:hover {
        color: #5a9fd8;
    }
    </style>
</head>
<body class='<%= (Session["DarkMode"] != null && (bool)Session["DarkMode"]) ? "dark-mode" : "" %>'>
    <form id="form1" runat="server">
        <div class="container">
            <!-- Question Section -->
            <div class="question">
                <h1 class="question-title"><asp:Label ID="lblTitle" runat="server" /></h1>
                <div class="question-meta">
                    Posted by <asp:Label ID="lblAuthor" runat="server" /> on 
                    <asp:Label ID="lblDate" runat="server" /> | 
                    Subject: <asp:Label ID="lblSubject" runat="server" />
                </div>
                <div class="question-content">
                    <asp:Label ID="lblContent" runat="server" />
                </div>

                <asp:LinkButton ID="btnDeleteQuestion" runat="server" Text="Delete Question" 
                    OnClick="btnDeleteQuestion_Click" Visible="false" CssClass="btn-delete" />

                <asp:LinkButton ID="btnEditQuestion" runat="server" Text="Edit Question" 
                    CssClass="btn-edit" OnClick="btnEditQuestion_Click" Visible="false" />

                <div style="margin-top: 20px;">
                    <asp:Button ID="btnBack" runat="server" Text="← Back to Forum" 
                        CssClass="btn-back" OnClick="btnBack_Click" />
                </div>

                <asp:Panel ID="pnlEditQuestion" runat="server" Visible="false">
                    <asp:TextBox ID="txtEditTitle" runat="server" CssClass="form-control" />
                    <asp:TextBox ID="txtEditContent" runat="server" TextMode="MultiLine" CssClass="form-control" />
                    <asp:Button ID="btnSaveQuestion" runat="server" Text="Save" OnClick="btnSaveQuestion_Click" CssClass="btn-submit" />
                </asp:Panel>
            </div>

            <!-- Replies Section -->
            <div class="replies">
                <h3>Replies (<asp:Label ID="lblReplyCount" runat="server" Text="0" />)</h3>
                <asp:Repeater ID="rptReplies" runat="server" OnItemDataBound="rptReplies_ItemDataBound">
                    <ItemTemplate>
                        <div class='reply <%# Eval("IsBest").ToString() == "True" ? "best" : "" %>'>
                            <%# Eval("IsBest").ToString() == "True" ? "<span class='best-tag'>Best Answer</span>" : "" %>
                            <div class="reply-meta">
                                Posted by <%# Eval("Username") %> (<%# Eval("UserType") %>) on <%# Eval("CreatedAt", "{0:MMM dd, yyyy}") %> |
                                Likes: <%# Eval("Likes") %>
                            </div>

                            <asp:Literal ID="LiteralReplyText" runat="server" Text='<%# Eval("ReplyText") %>' />

                            <div class="reply-actions">
                                <asp:LinkButton ID="btnLike" runat="server" CssClass='btn-like <%# Eval("IsBest").ToString() == "True" ? "liked" : "" %>' 
                                    CommandArgument='<%# Eval("ReplyID") %>' OnClick="btnLike_Click">
                                    <i class='fas fa-thumbs-up'></i> <%# Eval("IsBest").ToString() == "True" ? "Marked as Best" : "Like" %>
                                </asp:LinkButton>

                                <asp:LinkButton ID="btnEdit" runat="server" CssClass="btn-edit" Text="Edit" OnClick="btnEdit_Click" Visible="false" />
                                <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn-delete"
                                    Text="Delete" CommandArgument='<%# Eval("ReplyID") %>' OnClick="btnDelete_Click" Visible="false" />

                                <asp:LinkButton ID="btnMarkBest" runat="server" CssClass="btn-best" 
                                    CommandArgument='<%# Eval("ReplyID") %>' OnClick="btnMarkBest_Click" Text="Mark as Best" Visible="false" />

                                <asp:Panel ID="pnlEditReply" runat="server" Visible="false">
                                    <asp:TextBox ID="txtEditReply" runat="server" TextMode="MultiLine" CssClass="form-control" />
                                    <asp:HiddenField ID="hfReplyID" runat="server" Value='<%# Eval("ReplyID") %>' />
                                    <asp:LinkButton ID="btnSaveReply" runat="server" Text="Save" CssClass="btn-submit" OnClick="btnSaveReply_Click" />
                                </asp:Panel>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <asp:Label ID="lblNoReplies" runat="server" Text="No replies yet. Be the first to answer!" Visible="false" />
            </div>

            <!-- Reply Form (only visible if user is logged in) -->
            <asp:Panel ID="pnlReplyForm" runat="server" CssClass="reply-form" Visible="false">
                <h4>Post Your Reply</h4>
                <div class="form-group">
                    <asp:TextBox ID="txtReply" runat="server" TextMode="MultiLine" placeholder="Write your reply here..."></asp:TextBox>
                </div>
                <asp:Button ID="btnSubmitReply" runat="server" Text="Submit Reply" CssClass="btn-submit" OnClick="btnSubmitReply_Click" />
            </asp:Panel>
        </div>
    </form>
</body>
</html>