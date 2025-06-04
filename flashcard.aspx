<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="flashcard.aspx.cs" Inherits="WAPPSS.flashcard" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <title>Course Flash Cards</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <style>
        body {
            font-family:'Roboto',sans-serif;
            background:#f7faff;
            color:#222;
            margin:0;
            transition: background 0.4s, color 0.4s;
        }
        .container {
            max-width:700px;
            margin:40px auto 0 auto;
            background:#fff;
            border-radius:16px;
            box-shadow:0 6px 24px #3c40c113;
            padding:36px 34px;
            transition: background 0.4s, color 0.4s, box-shadow 0.4s;
        }
        h2 { color:#3c40c1; margin-bottom:24px; transition: color 0.4s; }
        .deck-form, .card-form { display:flex; gap:15px; margin-bottom:35px; }
        .deck-form input, .card-form input, .card-form textarea {
            padding:7px 12px;
            border-radius:7px;
            border:1.1px solid #c3cfff;
            font-size:1.02rem;
            background:#fff;
            color:#222;
            transition: background 0.4s, color 0.4s, border-color 0.4s;
        }
        .deck-form button, .card-form button {
            background:linear-gradient(90deg,#3c40c1 60%,#6658ea 100%);
            color:#fff;
            border:none;
            border-radius:7px;
            padding:9px 23px;
            font-weight:700;
            font-size:1rem;
            cursor:pointer;
            transition: background 0.3s, color 0.3s;
        }
        .deck-list { margin-bottom:35px; }
        .deck-card {
            background:#f4f7ff;
            border-radius:10px;
            padding:19px 17px 12px 17px;
            box-shadow:0 2px 8px #3c40c120;
            margin-bottom:16px;
            transition: background 0.4s, color 0.4s, box-shadow 0.4s;
        }
        .deck-title { font-size:1.07rem; font-weight:600; color:#23249c; transition: color 0.4s; }
        .deck-desc { color:#4d4d7a; margin-bottom:7px; transition: color 0.4s; }
        .card-table { width:100%; border-collapse:collapse; margin-top:20px;}
        .card-table th, .card-table td { border-bottom:1px solid #e3e3f7; padding:8px 7px; transition: border-color 0.4s, color 0.4s, background 0.4s;}
        .card-table th { color:#3c40c1; font-weight:700; background: #f7faff; }
        .card-table td { color:#222; background: #fff; }
        .delete-btn { color:#e74c3c; cursor:pointer; font-size:17px; background:none; border:none; }
        .delete-btn:hover { color:#b10000;}
        .back-link { color:#3c40c1; text-decoration:none; font-weight:700; margin-bottom:22px; display:inline-block;}
        .back-link:hover { text-decoration:underline;}

        /* --- DARK MODE --- */
        body.dark-mode {
            background: #181b22 !important;
            color: #c2d1fa !important;
        }
        body.dark-mode .container {
            background: #232b3e !important;
            color: #c2d1fa !important;
            box-shadow: 0 8px 30px #11131b70;
        }
        body.dark-mode h2 {
            color: #89a8fa !important;
        }
        body.dark-mode .deck-form input,
        body.dark-mode .card-form input,
        body.dark-mode .card-form textarea {
            background: #20263a !important;
            color: #c2d1fa !important;
            border-color: #3949ab !important;
        }
        body.dark-mode .deck-form input::placeholder,
        body.dark-mode .card-form input::placeholder,
        body.dark-mode .card-form textarea::placeholder {
            color: #7fa3e5 !important;
            opacity: 1;
        }
        body.dark-mode .deck-form button,
        body.dark-mode .card-form button {
            background: linear-gradient(90deg,#5ea4f3 60%,#8faaff 100%) !important;
            color: #222 !important;
        }
        body.dark-mode .deck-list select,
        body.dark-mode .deck-list input {
            background: #20263a !important;
            color: #c2d1fa !important;
            border-color: #3949ab !important;
        }
        body.dark-mode .deck-card {
            background: #20263a !important;
            color: #c2d1fa !important;
            box-shadow: 0 2px 12px #131b3c30;
        }
        body.dark-mode .deck-title { color: #8faaff !important; }
        body.dark-mode .deck-desc { color: #b5c9ef !important; }
        body.dark-mode .card-table th {
            color: #5ea4f3 !important;
            background: #232b3e !important;
            border-color: #395488 !important;
        }
        body.dark-mode .card-table td {
            color: #e3eafe !important;
            background: #181b22 !important;
            border-color: #2a364f !important;
        }
        body.dark-mode .delete-btn {
            color: #ff7676 !important;
        }
        body.dark-mode .delete-btn:hover {
            color: #ff2d2d !important;
        }
        body.dark-mode .back-link {
            color: #5ea4f3 !important;
        }
        body.dark-mode .back-link:hover {
            color: #fff !important;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <a class="back-link" href="course_detail.aspx?course=<%= Server.UrlEncode(Request.QueryString["course"]??"") %>"><i class="fa fa-arrow-left"></i> Back to Course</a>
            <h2>Course Flash Cards</h2>
            <!-- Deck creation -->
            <div style="margin-bottom:20px;">
                <asp:Panel ID="pnlCreateDeck" runat="server">
                    <div class="deck-form">
                        <asp:TextBox ID="txtDeckTitle" runat="server" placeholder="Deck Title" MaxLength="100" />
                        <asp:TextBox ID="txtDeckDescription" runat="server" placeholder="Deck Description" MaxLength="255" />
                        <asp:Button ID="btnCreateDeck" runat="server" Text="Create Deck" OnClick="btnCreateDeck_Click" />
                    </div>
                </asp:Panel>
            </div>
            <!-- Decks List -->
            <div class="deck-list">
                <asp:DropDownList ID="ddlDecks" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlDecks_SelectedIndexChanged" style="margin-bottom:18px; min-width:200px;" />
            </div>
            <!-- Deck edit panel -->
            <asp:Panel ID="pnlEditDeck" runat="server" Visible="false">
                <div class="deck-form">
                    <asp:TextBox ID="txtEditDeckTitle" runat="server" placeholder="Edit Deck Title" MaxLength="100" />
                    <asp:TextBox ID="txtEditDeckDescription" runat="server" placeholder="Edit Deck Description" MaxLength="255" />
                    <asp:Button ID="btnSaveDeck" runat="server" Text="Save Deck" OnClick="btnSaveDeck_Click" />
                </div>
            </asp:Panel>
            <!-- Card Creation -->
            <asp:Panel ID="pnlCreateCard" runat="server" Visible="false">
                <div class="card-form">
                    <asp:TextBox ID="txtFront" runat="server" placeholder="Front (Question/Term)" MaxLength="255" />
                    <asp:TextBox ID="txtBack" runat="server" placeholder="Back (Answer/Definition)" MaxLength="255" />
                    <asp:Button ID="btnAddCard" runat="server" Text="Add Card" OnClick="btnAddCard_Click" />
                </div>
            </asp:Panel>
            <!-- Cards Table -->
            <asp:Panel ID="pnlCards" runat="server" Visible="false">
                <table class="card-table">
                    <thead>
                        <tr>
                            <th>Front</th>
                            <th>Back</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptCards" runat="server" OnItemCommand="rptCards_ItemCommand">
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("FrontText") %></td>
                                    <td><%# Eval("BackText") %></td>
                                    <td>
                                        <asp:Button runat="server" CommandName="DeleteCard" CommandArgument='<%# Eval("FlashcardID") %>' Text="Delete" CssClass="delete-btn" />
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </asp:Panel>
        </div>
    </form>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script>
        $(document).ready(function () {
            var modeType = '<%= ModeTypeFromDB %>';
            if (modeType === "dark") {
                $('body').addClass('dark-mode');
            } else {
                $('body').removeClass('dark-mode');
            }
        });
    </script>
</body>
</html>