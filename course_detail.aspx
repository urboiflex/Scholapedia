<%@ Page Language="C#" AutoEventWireup="true" MaintainScrollPositionOnPostBack="true" CodeBehind="course_detail.aspx.cs" Inherits="WAPPSS.course_detail" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
  <meta charset="UTF-8" />
  <title>Course Detail - Scholapedia</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
  <link href="https://fonts.googleapis.com/css2?family=Indie+Flower&family=Roboto:wght@400;700&display=swap" rel="stylesheet" />
  <link href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" rel="stylesheet" />
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <style>
    body {
      font-family: 'Roboto', sans-serif;
      background: #fefefb;
      color: #333;
      margin: 0; padding: 0;
    }
    body.dark-mode {
      background-color: #181d23 !important;
      color: #f5f5fa !important;
    }
    .container {
      max-width: 1140px;
      margin: 24px auto 0 auto;
      padding: 32px 40px 40px 40px;
      background: #fff;
      border-radius: 20px;
      box-shadow: 0 10px 38px rgba(0,0,0,0.08);
      border: 1px solid #ececec;
      position: relative;
      min-height: 80vh;
    }
    body.dark-mode .container {
      background: #23272f;
      border: 1px solid #23272f;
      box-shadow: 0 10px 38px rgba(0,0,0,0.24);
    }
    .breadcrumb {
      max-width: 1140px;
      margin: 12px auto 0 auto;
      font-size: 14px;
      color: #888;
      padding: 0 20px;
    }
    body.dark-mode .breadcrumb {
      color: #b6bdd8;
    }
    .breadcrumb a { color: #3c40c1; text-decoration: none; }
    body.dark-mode .breadcrumb a { color: #7ea7ff; }

    .course-main-layout {
      display: flex;
      flex-direction: row;
      gap: 36px;
      align-items: flex-start;
      margin-bottom: 36px;
      flex-wrap: wrap;
    }
    .course-left { flex: 1 1 340px; min-width: 320px; max-width: 470px; }
    .course-title {
      font-family: 'Indie Flower', cursive;
      font-size: 2.45rem;
      color: #3c40c1;
      margin-bottom: 8px;
      margin-top: 0;
      text-align: left;
      letter-spacing: 1.2px;
    }
    body.dark-mode .course-title { color: #8bb5ff; }
    .course-img {
      display: block;
      margin: 0 0 24px 0;
      max-width: 100%;
      border-radius: 15px;
      box-shadow: 0 8px 32px rgba(60,64,193,0.09);
      border: 1.5px solid #e8eaff;
      background: #23272f;
    }
    body.dark-mode .course-img {
      border: 1.5px solid #23249c;
      background: #191f24;
      box-shadow: 0 8px 32px rgba(60, 64, 193, 0.17);
    }
    .course-description {
      font-size: 1.08rem;
      line-height: 1.6;
      color: #444;
      padding-left: 18px;
      border-left: 4px solid #3c40c1;
      margin-bottom: 10px;
    }
    body.dark-mode .course-description {
      color: #c7d2e5;
      border-left: 4px solid #7ea7ff;
      background: #23272f;
    }
    .course-features {
      flex: 1 1 295px;
      max-width: 375px;
      background: linear-gradient(100deg, #f3f6ff 70%, #f9f9ff 100%);
      border-radius: 18px;
      box-shadow: 0 4px 24px rgba(60,64,193,0.07);
      border: 1.5px solid #ececff;
      padding: 30px 32px 26px 32px;
      margin-top: 10px;
      margin-left: auto;
      margin-right: 0;
    }
    body.dark-mode .course-features {
      background: linear-gradient(100deg, #23272f 70%, #262b36 100%);
      border: 1.5px solid #23249c;
      box-shadow: 0 4px 24px #12151e77;
    }
    .course-features h3 {
      font-size: 1.31rem;
      text-align: center;
      color: #3c40c1;
      margin-bottom: 16px;
      letter-spacing: 0.8px;
    }
    body.dark-mode .course-features h3 { color: #8bb5ff; }
    .feature {
      display: flex;
      align-items: center;
      margin-bottom: 16px;
      font-size: 16px;
      gap: 12px;
      background: #f8faff;
      padding: 10px 13px 10px 10px;
      border-radius: 8px;
      box-shadow: 0 2px 8px #3c40c11a;
    }
    body.dark-mode .feature {
      background: #23272f;
      box-shadow: 0 2px 8px #23249c20;
    }
    .feature:last-child { margin-bottom: 0; }
    .feature i { font-size: 20px; color: #3c40c1; min-width: 24px; margin-right: 6px; }
    body.dark-mode .feature i { color: #8bb5ff; }
    .feature span.label { font-weight: 700; color: #23249c; min-width: 90px; }
    body.dark-mode .feature span.label { color: #8bb5ff; }
    .feature span.value { font-weight: 500; }
    body.dark-mode .feature span.value { color: #f5f6fa; }
    .feature .star { color: #FFD700; font-size:18px; }
    .feature .delete-resource { margin-left:12px; color:#e74c3c; cursor:pointer; font-size:19px;}
    .feature .delete-resource:hover { color:#b10000; }

    .calendar-container {
      width: 100%;
      max-width: 800px;
      margin: 38px auto 0 auto;
      padding: 26px 32px;
      background: #fff url('Images/notebook-paper.jpg') repeat-y center;
      background-size: contain;
      border: 1px solid #ccc;
      border-radius: 15px;
    }
    body.dark-mode .calendar-container {
      background: #23272f;
      border: 1px solid #23249c;
      color: #e5eaff;
    }
    .calendar-add-row input[type='date'],
    .calendar-add-row input[type='time'] {
      padding:7px 13px; border-radius:6px; border:1.2px solid #cfcfff; font-size:1rem;
      background:#fff; color:#333; font-family:'Roboto',sans-serif;
    }
    body.dark-mode .calendar-add-row input[type='date'],
    body.dark-mode .calendar-add-row input[type='time'] {
      background: #23272f;
      color: #e5eaff;
      border: 1.2px solid #23249c;
    }
    .calendar-add-row button, .add-class-btn {
      padding: 9px 25px;
      border: none;
      border-radius: 7px;
      background:linear-gradient(90deg,#3c40c1 60%,#6658ea 100%);
      color: #fff;
      font-weight: 700;
      font-size: 1rem;
      box-shadow: 0 2px 8px #3c40c11a;
      cursor: pointer;
      transition: background 0.12s;
      margin-left: 10px;
    }
    .calendar-add-row button:hover, .add-class-btn:hover { background: #23249c; }
    .calendar-table {
      margin: 0 auto 18px auto;
      border-collapse: separate;
      border-spacing: 8px 5px;
      font-size: 16px;
      width: 95%;
    }
    .calendar-table th,
    .calendar-table td {
      text-align: center;
      padding: 7px 0;
      border-radius: 7px;
    }
    .calendar-table th {
      background: #f7faff;
      color: #3c40c1;
      font-size: 1.12rem;
    }
    body.dark-mode .calendar-table th {
      background: #23249c;
      color: #fff;
    }
    .calendar-table td.scheduled {
      background: #3c40c1;
      color: #fff;
      font-weight: 700;
    }
    body.dark-mode .calendar-table td.scheduled {
      background: #23249c;
      color: #fff;
    }

    .resources-box {
      background-color: white;
      padding: 25px;
      border-radius: 12px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
      margin-top: 18px;
    }
    body.dark-mode .resources-box {
      background: #23272f;
      color: #e5eaff;
      box-shadow: 0 2px 8px #23249c20;
    }
    .add-resource-btn {
      background: linear-gradient(90deg, #3c40c1 60%, #6658ea 100%);
      color: #fff;
      border: none;
      border-radius: 50%;
      width: 38px;
      height: 38px;
      font-size: 1.35rem;
      font-weight: 900;
      line-height: 38px;
      text-align: center;
      box-shadow:0 2px 8px #3c40c11a;
      margin-left: 12px;
      vertical-align: middle;
      transition: background 0.12s;
      cursor: pointer;
    }
    .add-resource-btn:hover { background: #23249c; }
    .resource-item .delete-resource {
      color: #e74c3c;
      margin-left: 15px;
      font-size: 18px;
      cursor: pointer;
      transition: color 0.13s;
    }
    .resource-item .delete-resource:hover { color: #b10000; }

    /* Video & Reading resources dark mode */
    body.dark-mode .resource-item.video {
      background-color: #20263b !important;
      border-left: 4px solid #7ea7ff !important;
    }
    body.dark-mode .resource-item.reading {
      background-color: #1c2530 !important;
      border-left: 4px solid #8bb5ff !important;
    }
    body.dark-mode .resource-item .fa-video,
    body.dark-mode .resource-item .fa-file-alt {
      color: #8bb5ff !important;
    }
    body.dark-mode .resource-item a {
      color: #8bb5ff !important;
    }

    @media (max-width: 970px) {
      .course-main-layout { flex-direction: column; }
      .course-features {
        max-width: 100%; margin: 20px 0 0 0;
      }
    }
    @media (max-width: 600px) {
      .container { padding: 13px 3vw; }
      .breadcrumb { padding: 0 5vw; }
      .resources-box { padding: 10px 2vw; }
      .calendar-container { padding: 9px 3vw;}
    }
    /* style for manage students section*/
    .progress-bar-outer {
      background: #e4e8ff;
      border-radius: 9px;
      height: 22px;
      box-shadow: 0 2px 8px #3c40c120;
      position: relative;
      width: 100%;
    }
    body.dark-mode .progress-bar-outer {
      background: #23249c;
    }
    .progress-bar-inner {
      background: linear-gradient(90deg, #3c40c1 60%, #6658ea 100%);
      border-radius: 9px;
      height: 22px;
      color: #fff;
      font-weight: 700;
      font-size: 14px;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: width 0.5s;
      box-shadow: 0 2px 8px #3c40c11a;
      min-width: 34px;
      white-space:nowrap;
    }
    #autocomplete-container div:hover {
        background: #f2f2ff;
        color: #3c40c1;
    }
    body.dark-mode #autocomplete-container div:hover {
        background: #23249c;
        color: #fff;
    }
    #autocomplete-container div.autocomplete-item:hover {
        background: #f2f2ff;
        color: #3c40c1;
    }
    body.dark-mode #autocomplete-container div.autocomplete-item:hover {
        background: #23249c;
        color: #fff;
    }
    /* Flashcard Flip Animation */
    .flashcard-showcase {
      display: flex;
      gap: 18px;
      flex-wrap: wrap;
      margin-top: 18px;
    }
    .course-flashcard {
      width: 190px;
      height: 125px;
      perspective: 800px;
      margin-bottom: 10px;
    }
    .card-inner {
      position: relative;
      width: 100%;
      height: 100%;
      transition: transform 0.7s cubic-bezier(.4,2,.6,1);
      transform-style: preserve-3d;
      cursor: pointer;
    }
    .card-inner.flipped {
      transform: rotateY(180deg);
    }
    .card-front, .card-back {
      position: absolute;
      width: 100%;
      height: 100%;
      border-radius: 9px;
      backface-visibility: hidden;
      background: linear-gradient(100deg, #f3f6ff 70%, #f9f9ff 100%);
      box-shadow: 0 6px 18px #3c40c11c;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.07rem;
      font-weight: 600;
      color: #3c40c1;
      padding: 13px 10px;
      text-align:center;
      user-select: none;
    }
    .card-back {
      background: linear-gradient(100deg,#6658ea 70%,#b8baff 100%);
      color: #fff;
      transform: rotateY(180deg);
    }
    body.dark-mode .card-front, body.dark-mode .card-back {
      background: linear-gradient(100deg, #262b36 70%, #23272f 100%);
      color: #8bb5ff;
      box-shadow: 0 6px 18px #23249c1a;
    }
    body.dark-mode .card-back {
      background: linear-gradient(100deg, #23249c 70%, #23272f 100%);
      color: #fff;
    }
    .card-hint {
      font-size: 0.85rem;
      color: #888;
      font-style: italic;
      margin-top: 7px;
      text-align: center;
    }
    body.dark-mode .card-hint { color: #a1b6ce; }
  </style>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
    <body<%= (ViewState["IsDarkMode"] != null && (bool)ViewState["IsDarkMode"]) ? " class='dark-mode'" : "" %>>
 <form id="form1" runat="server">
    <div class="headerSection"></div>
    <div class="breadcrumb">
  <a href="course.aspx">Home</a> &raquo; <span>Course Detail</span>
</div>
    <div class="container animate__animated animate__fadeInUp">
      <div class="course-main-layout">
        <div class="course-left">
          <h1 class="course-title" id="courseName" runat="server"></h1>
          <asp:Image ID="courseImage" runat="server" CssClass="course-img" />
          <p class="course-description" id="courseDescription" runat="server"></p>
        </div>
        <div class="course-features animate__animated animate__fadeInRight">
          <h3>Course Features</h3>
          <div class="feature"><i class="fa fa-cubes"></i> <span class="label">Mode:</span> <span class="value" id="courseMode" runat="server"></span></div>
          <div class="feature"><i class="fa fa-user"></i> <span class="label">Instructor:</span> <span class="value" id="instructor" runat="server"></span></div>
          <div class="feature"><i class="fa fa-star star"></i> <span class="label">Rating:</span> <span class="value" id="rating" runat="server"></span></div>
          <asp:Panel ID="lecturesDiv" runat="server" Visible="true">
            <div class="feature"><i class="fa fa-video"></i> <span class="label">Lectures:</span> <a href="https://teams.microsoft.com" target="_blank" style="color: #3c40c1; text-decoration: underline;">Join Meeting</a></div>
          </asp:Panel>
          <div class="feature"><i class="fa fa-clock"></i> <span class="label">Duration:</span> <span class="value" id="courseDuration" runat="server"></span></div>
          <div class="feature"><i class="fa fa-signal"></i> <span class="label">Skill Level:</span> <span class="value" id="courseSkill" runat="server"></span></div>
          <div class="feature"><i class="fa fa-language"></i> <span class="label">Language:</span> <span class="value" id="courseLanguage" runat="server"></span></div>
          <div class="feature"><i class="fa fa-calendar-alt"></i> <span class="label">Published:</span> <span class="value" id="publishedDate" runat="server"></span></div>
        </div>
      </div>
      <asp:Panel ID="calendarPanel" runat="server" Visible="false" CssClass="calendar-container animate__animated animate__fadeIn">
        <h2 style="color: #3c40c1;">Class Schedule</h2>
        <div class="calendar-add-row">
          <asp:TextBox ID="txtClassDate" runat="server" TextMode="Date" style="min-width:145px;"/>
          <asp:TextBox ID="txtClassTime" runat="server" TextMode="Time" style="min-width:120px;"/>
          <asp:Button ID="btnAddClass" runat="server" Text="Add Class" CssClass="add-class-btn" OnClick="btnAddClass_Click" />
        </div>
        <asp:Literal ID="calendarLiteral" runat="server" />
      </asp:Panel>
<!-- Resources Section -->
      <div class="resources-box animate__animated animate__fadeInUp">
        <h2 class="resource-title" style="color: #3c40c1; width: 100%;">Resources</h2>
        <div style="margin-bottom: 18px;">
          <asp:FileUpload ID="resourceUpload" runat="server" />
          <asp:Button ID="btnAddResource" runat="server" Text="+" CssClass="add-resource-btn" OnClick="btnAddResource_Click" />
        </div>
        <div style="margin-top: 20px;">
          <h4 class="resource-subtitle" style="color: #2d2f91; font-weight: 600;">Video Lectures (MP4)</h4>
          <asp:Repeater ID="VideoRepeater" runat="server" OnItemCommand="ResourceRepeater_ItemCommand">
            <ItemTemplate>
              <div class="resource-item video" style="margin: 10px 0; padding: 10px; background-color: #f0f2fa; border-left: 4px solid #3c40c1; border-radius: 8px;">
                <i class="fa fa-video" style="color: #3c40c1;"></i>
                <a href='<%# Eval("FilePath") %>' target="_blank" style="margin-left: 10px; color: #3c40c1; text-decoration: none; font-weight: 500;"><%# Eval("FileName") %></a>
                <asp:LinkButton runat="server" CssClass="delete-resource" CommandName="DeleteResource" CommandArgument='<%# Eval("FilePath") %>' ToolTip="Delete"><i class="fa fa-trash"></i></asp:LinkButton>
              </div>
            </ItemTemplate>
          </asp:Repeater>
        </div>
        <div style="margin-top: 30px;">
          <h4 class="resource-subtitle" style="color: #2a7fbf; font-weight: 600;">Reading Materials (PDF/DOC)</h4>
          <asp:Repeater ID="ReadingRepeater" runat="server" OnItemCommand="ResourceRepeater_ItemCommand">
            <ItemTemplate>
              <div class="resource-item reading" style="margin: 10px 0; padding: 10px; background-color: #f7f9fc; border-left: 4px solid #2a7fbf; border-radius: 8px;">
                <i class="fa fa-file-alt" style="color: #2a7fbf;"></i>
                <a href='<%# Eval("FilePath") %>' target="_blank" style="margin-left: 10px; color: #2a7fbf; text-decoration: none; font-weight: 500;"><%# Eval("FileName") %></a>
                <asp:LinkButton runat="server" CssClass="delete-resource" CommandName="DeleteResource" CommandArgument='<%# Eval("FilePath") %>' ToolTip="Delete"><i class="fa fa-trash"></i></asp:LinkButton>
              </div>
            </ItemTemplate>
          </asp:Repeater>
        </div>
        <div style="margin-top: 30px;">
          <h4 class="resource-subtitle" style="color: #d24726; font-weight: 600;">
            PowerPoint Slides (PPT)
            <i class="fa fa-file-powerpoint" style="color: #d24726; margin-left:7px;"></i>
          </h4>
          <asp:Repeater ID="PptRepeater" runat="server" OnItemCommand="ResourceRepeater_ItemCommand">
            <ItemTemplate>
              <div class="resource-item ppt" style="margin: 10px 0; padding: 10px; background-color: #fff5ed; border-left: 4px solid #d24726; border-radius: 8px;">
                <i class="fa fa-file-powerpoint" style="color: #d24726;"></i>
                <a href='<%# Eval("FilePath") %>' target="_blank" style="margin-left: 10px; color: #d24726; text-decoration: none; font-weight: 500;"><%# Eval("FileName") %></a>
                <asp:LinkButton runat="server" CssClass="delete-resource" CommandName="DeleteResource" CommandArgument='<%# Eval("FilePath") %>' ToolTip="Delete"><i class="fa fa-trash"></i></asp:LinkButton>
              </div>
            </ItemTemplate>
          </asp:Repeater>
        </div>
      </div>

<!-- Manage Students Section - UPDATED -->
<div class="resources-box animate__animated animate__fadeInUp" style="margin-top:30px;">
  <h2 style="color: #3c40c1;">Manage Students</h2>
  <asp:Panel ID="ManageStudentsPanel" runat="server">
    <div style="margin-bottom: 18px; position:relative;">
      <asp:TextBox ID="txtStudentSearch" runat="server" 
                   placeholder="Search by name or username (e.g., 'John', 'john doe', or 'johndoe123')..." 
                   CssClass="form-control" 
                   style="width: 420px; display:inline-block; padding: 8px 12px; font-size: 14px;" 
                   AutoComplete="off" />
      <div id="autocomplete-container" 
           style="position:absolute; z-index:20; background:white; border:1px solid #d2d2d2; width:420px; max-height:220px; overflow-y:auto; display:none; border-radius:6px; box-shadow: 0 2px 9px #3c40c11a;"></div>
      <asp:Button ID="btnSearchStudent" runat="server" Text="Search" CssClass="add-class-btn" OnClick="btnSearchStudent_Click" />
    </div>
    
    <!-- Search Instructions -->
    <div style="margin-bottom: 15px; font-size: 13px; color: #666; font-style: italic;">
      💡 You can search by: first name, last name, username, or "first last" combination. Search is case-insensitive.
    </div>
    
    <asp:Repeater ID="SearchResultsRepeater" runat="server" OnItemCommand="SearchResultsRepeater_ItemCommand">
      <ItemTemplate>
        <div style="margin-bottom:12px; display:flex; align-items:center; background: #f8faff; padding: 10px; border-radius: 8px; border-left: 3px solid #3c40c1;">
          <span style="font-weight:600; color:#23249c; margin-right:18px; flex: 1;">
            <%# Eval("FullName") %>
          </span>
          <asp:Button runat="server" CommandName="AddStudent" CommandArgument='<%# Eval("UserID") %>' Text="+ Add to Course" CssClass="add-class-btn" style="font-size: 13px; padding: 6px 12px;" />
        </div>
      </ItemTemplate>
    </asp:Repeater>
    
    <hr style="margin:18px 0;">
    <h4 style="color:#2d2f91; font-weight:600;">Students in Course</h4>
    <asp:Repeater ID="CourseStudentsRepeater" runat="server" OnItemCommand="CourseStudentsRepeater_ItemCommand">
      <ItemTemplate>
        <div style="margin-bottom:18px; display:flex; align-items:center;">
          <span style="font-weight:600; color:#23249c; min-width:200px;">
            <%# Eval("FullName") %>
          </span>
          <div class="progress-bar-outer" style="flex:1; max-width:240px; margin:0 20px;">
            <div class="progress-bar-inner" style='width:<%# Eval("Progress") %>%; background: linear-gradient(90deg, #3c40c1 60%, #6658ea 100%); color:#fff; border-radius: 9px; height:22px; display:flex; align-items:center; justify-content:center; font-weight:700; font-size:14px; box-shadow:0 2px 8px #3c40c11a; transition:width 0.5s;'>
              <%# Eval("Progress") %>%
            </div>
          </div>
          <asp:LinkButton runat="server" CommandName="RemoveStudent" CommandArgument='<%# Eval("CourseStudentID") %>' ToolTip="Remove Student" CssClass="remove-student-btn" style="color:#e74c3c; font-size:22px; margin-left:5px;">
            <i class="fa fa-trash"></i>
          </asp:LinkButton>
        </div>
      </ItemTemplate>
    </asp:Repeater>
  </asp:Panel>
</div>

<!-- Course Flash Cards Section -->
<div class="resources-box animate__animated animate__fadeInUp" style="margin-top:30px;">
  <div style="display: flex; align-items: center; justify-content: space-between;">
    <h2 style="color: #3c40c1; margin-bottom:0;">Course Flash Cards</h2>
    <a href='flashcard.aspx?course=<%= Server.UrlEncode(Request.QueryString["course"] ?? (Session["SelectedCourse"] as string) ?? "") %>' 
       style="background: linear-gradient(90deg, #3c40c1 60%, #6658ea 100%); color: #fff; border: none; border-radius: 50%; width: 38px; height: 38px; font-size: 1.35rem; font-weight: 900; line-height: 38px; text-align: center; display: inline-block; margin-left: 15px; box-shadow: 0 2px 8px #3c40c11a; vertical-align: middle; text-decoration:none;" 
       title="Add Flash Cards">
      <i class="fa fa-plus"></i>
    </a>
  </div>
  <div style="margin-top:25px;">
    <asp:Repeater ID="FlashcardDeckRepeater" runat="server" OnItemDataBound="FlashcardDeckRepeater_ItemDataBound">
<ItemTemplate>
  <div class="deck-card" style="margin-bottom: 28px; background-color: #f4f7ff; border-radius: 10px; padding: 22px 20px 18px 20px; box-shadow: 0 2px 8px #f4f7ff;">
    <div class="deck-header" style="display: flex; align-items: center; margin-bottom: 8px;">
      <div class="deck-icon" style="width:36px; height:36px; background:#3c40c1; border-radius:8px; display:flex; align-items:center; justify-content:center; color:white; margin-right:12px;">
        <i class="fa fa-clone"></i>
      </div>
      <div class="deck-title" style="font-size:1.13rem; font-weight:600; color:#23249c;">
        <%# Eval("DeckTitle") %>
        <a href='flashcard.aspx?course=<%# Server.UrlEncode(Request.QueryString["course"] ?? (Session["SelectedCourse"] as string) ?? "") %>&deck=<%# Eval("DeckID") %>' 
   title="Edit Deck" class="edit-deck-link" style="margin-left:10px; color:#3c40c1; font-size:17px; vertical-align:middle;">
  <i class="fa fa-pencil-alt"></i>
</a>
      </div>
    </div>
    <div class="deck-info" style="color:#444; font-size:0.98rem; margin-bottom:8px;"><%# Eval("DeckDescription") %></div>
    <asp:PlaceHolder ID="phFlashcards" runat="server"></asp:PlaceHolder>
  </div>
</ItemTemplate>
        <FooterTemplate>
        <asp:Literal ID="litNoDecks" runat="server" />
      </FooterTemplate>
    </asp:Repeater>
  </div>
</div>

<!-- Course Test Section -->
<div class="resources-box animate__animated animate__fadeInUp" style="margin-top:30px;">
  <div style="display: flex; align-items: center; justify-content: space-between;">
    <h2 style="color: #3c40c1; margin-bottom:0;">Course Test</h2>
<a href='Test.aspx?course=<%= Server.UrlEncode(Request.QueryString["course"] ?? (Session["SelectedCourse"] as string) ?? "") %>' 
   style="background: linear-gradient(90deg, #3c40c1 60%, #6658ea 100%); color: #fff; border: none; border-radius: 7px; padding: 10px 26px; font-size: 1.05rem; font-weight: bold; box-shadow: 0 2px 8px #3c40c11a; text-decoration:none; margin-left: 15px; transition:background 0.15s; display:inline-block;" 
   id="addTestBtn">
  <i class="fa fa-plus"></i> Add Test
</a>
  </div>
  <div style="margin-top:30px;" id="test-list-section">
    <asp:Repeater ID="TestRepeater" runat="server" OnItemCommand="TestRepeater_ItemCommand">
      <ItemTemplate>
        <div class="test-item" style="display:flex;align-items:center;justify-content:space-between; background:#eef1ff; margin-bottom:16px; padding:18px 22px; border-radius:10px; box-shadow:0 2px 8px #3c40c11a;">
          <div style="font-size:1.14rem; font-weight:700; color:#3c40c1;">
            <i class="fa fa-clipboard-list" style="margin-right:10px"></i>
            <%# Eval("TestTitle") %>
            <span style="font-weight:400;font-size:0.98rem;color:#8b8bce;margin-left:12px;"><%# Eval("TestTime") %> min</span>
            <!-- EDIT BUTTON: Pencil icon beside the test title -->
            <a href='TestEdit.aspx?id=<%# Eval("TestID") %>' title='Edit Test' class='edit-test-link' style='margin-left:14px;color:#3c40c1;font-size:17px;vertical-align:middle;'>
              <i class='fa fa-pencil-alt'></i>
            </a>
          </div>
          <div style="display:flex;align-items:center;gap:16px;">
            <asp:LinkButton runat="server" CommandName="PreviewTest" CommandArgument='<%# Eval("TestID") %>' ToolTip="Preview" style="color:#23249c;font-size:20px; background:#e6eaff; border-radius:7px; padding:7px 17px; font-weight:bold; margin-right:6px; box-shadow:0 1px 4px #3c40c120;transition:background 0.15s;"><i class="fa fa-eye"></i> Preview</asp:LinkButton>
            <asp:LinkButton runat="server" CssClass="delete-test-btn" CommandName="DeleteTest" CommandArgument='<%# Eval("TestID") %>' ToolTip="Delete" style="color:#e74c3c;font-size:22px; background:#fdeeee; border-radius:7px; padding:7px 13px; font-weight:700;"><i class="fa fa-trash"></i></asp:LinkButton>
          </div>
        </div>
      </ItemTemplate>
      <FooterTemplate>
        <asp:Literal ID="litNoTests" runat="server" />
      </FooterTemplate>
    </asp:Repeater>
  </div>
</div>

    </div>
  </form>
  
  <script>
      // Optionally, confirm delete with JS
      $(document).on('click', '.delete-resource', function (e) {
          if (!confirm('Are you sure you want to delete this resource?')) {
              e.preventDefault();
          }
      });

      // File type validation for upload
      $(document).ready(function () {
          $('#<%= btnAddResource.ClientID %>').click(function (e) {
            var fileInput = $('#<%= resourceUpload.ClientID %>')[0];
            if (fileInput && fileInput.files.length > 0) {
                var fileName = fileInput.files[0].name.toLowerCase();
                var allowed = /\.(mp4|pdf|doc|docx|ppt|pptx)$/i;
                var forbidden = /\.(png|jpg|jpeg)$/i;
                if (forbidden.test(fileName)) {
                    alert("Only PDF, Word, PowerPoint, and Video files are allowed. Image files (.png, .jpg) cannot be uploaded.");
                    e.preventDefault();
                    return false;
                }
                if (!allowed.test(fileName)) {
                    alert("Only PDF, Word, PowerPoint, and Video files are allowed.");
                    e.preventDefault();
                    return false;
                }
            }
        });
    });
  </script>

  <!-- UPDATED Student Search JavaScript -->
  <script>
    var btnSearchStudentId = '<%= btnSearchStudent.ClientID %>';
    $(document).ready(function () {
        var acTimeout = null;
        var $input = $('#<%=txtStudentSearch.ClientID%>');
        var $acContainer = $('#autocomplete-container');

        $input.on('input', function () {
            clearTimeout(acTimeout);
            var val = $(this).val().trim();
            if (val.length < 2) { // Require at least 2 characters
                $acContainer.hide().empty();
                return;
            }
            acTimeout = setTimeout(function () {
                $.ajax({
                    url: 'course_detail.aspx/GetStudentSuggestions',
                    method: 'POST',
                    contentType: 'application/json; charset=utf-8',
                    data: JSON.stringify({ prefix: val }),
                    dataType: 'json',
                    cache: false,
                    success: function (resp) {
                        var results = resp.d;
                        $acContainer.empty();
                        if (results && results.length > 0) {
                            results.forEach(function (s) {
                                var $item = $('<div/>')
                                    .addClass('autocomplete-item')
                                    .css({
                                        padding: '10px 15px',
                                        cursor: 'pointer',
                                        fontSize: '14px',
                                        borderBottom: '1px solid #f0f0f0'
                                    })
                                    .html('<strong>' + s.FullName + '</strong>')
                                    .attr('data-id', s.UserID)
                                    .on('mousedown', function (e) {
                                        e.preventDefault();
                                        // Extract just the name part (without username in parentheses)
                                        var nameOnly = s.FullName.split(' (')[0];
                                        $input.val(nameOnly);
                                        $acContainer.hide().empty();
                                        // Trigger the server search
                                        setTimeout(function () {
                                            $('#<%=btnSearchStudent.ClientID%>').click();
                                        }, 50);
                                    });
                                $acContainer.append($item);
                            });
                            $acContainer.show();
                        } else {
                            var $noResults = $('<div/>')
                                .css({
                                    padding: '10px 15px',
                                    fontSize: '14px',
                                    color: '#888',
                                    fontStyle: 'italic'
                                })
                                .text('No students found matching "' + val + '"');
                            $acContainer.append($noResults);
                            $acContainer.show();
                        }
                    },
                    error: function (xhr, status, error) {
                        console.log('Autocomplete error:', error);
                        $acContainer.hide();
                    }
                });
            }, 300); // Increased delay to reduce server calls
        });

        // Hide autocomplete when clicking outside
        $(document).on('mousedown', function (e) {
            if (!$(e.target).closest('#autocomplete-container, #<%=txtStudentSearch.ClientID%>').length) {
                $acContainer.hide();
            }
        });

        // Handle Enter key to trigger search
        $input.on('keypress', function (e) {
            if (e.which === 13) { // Enter key
                $acContainer.hide();
                $('#<%=btnSearchStudent.ClientID%>').click();
                return false;
            }
        });

        // Confirm delete for students
        $(document).on('click', '.remove-student-btn', function (e) {
            var ok = confirm('Are you sure you want to remove this student from this course?');
            if (!ok) e.preventDefault();
        });

        // Clear search results when input is cleared
        $input.on('blur', function () {
            setTimeout(function () {
                $acContainer.hide();
            }, 200);
        });
    });
</script>

    <!--flash card flip-->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            document.querySelectorAll('.course-flashcard .card-inner').forEach(function (card) {
                card.onclick = function () {
                    card.classList.toggle('flipped');
                }
            });
        });
</script>

<script>
    // Optionally, confirm delete with JS
    $(document).on('click', '.delete-resource', function (e) {
        if (!confirm('Are you sure you want to delete this resource?')) {
            e.preventDefault();
        }
    });

    // Confirm delete for tests
    $(document).on('click', '.delete-test-btn', function (e) {
        var ok = confirm('Are you sure you want to delete this test?');
        if (!ok) e.preventDefault();
    });
</script>
    <!--Course test section -->
</body>
</html>