<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="coursesTest.aspx.cs" Inherits="WAPPSS.coursesTest" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add New Course</title>
    <style>
        body {
            background-color: #f5f5fa;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
        }
        
        .container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            padding: 30px;
            max-width: 800px;
            margin: 0 auto;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .logo {
            background-color: #7c4dff;
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0 auto 20px;
        }
        
        h1 {
            color: #7c4dff;
            margin-bottom: 10px;
        }
        
        .subtitle {
            color: #9e9e9e;
            margin-bottom: 30px;
        }
        
        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .form-group {
            flex: 1;
            text-align: left;
        }
        
        .form-group.full-width {
            flex: 100%;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #616161;
            font-weight: bold;
        }
        
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #e0e0e0;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 14px;
        }
        
        .form-control:focus {
            border-color: #7c4dff;
            outline: none;
            box-shadow: 0 0 5px rgba(124, 77, 255, 0.3);
        }
        
        .file-upload {
            border: 2px dashed #e0e0e0;
            border-radius: 5px;
            padding: 20px;
            text-align: center;
            background-color: #fafafa;
            transition: all 0.3s ease;
        }
        
        .file-upload:hover {
            border-color: #7c4dff;
            background-color: #f3f0ff;
        }
        
        .btn-primary {
            background-color: #7c4dff;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 12px 30px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 20px;
            width: 200px;
        }
        
        .btn-primary:hover {
            background-color: #6a3de8;
        }
        
        .btn-secondary {
            background-color: #9e9e9e;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 12px 30px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 20px;
            margin-left: 10px;
            width: 200px;
        }
        
        .btn-secondary:hover {
            background-color: #757575;
        }
        
        .error-message {
            color: red;
            margin-top: 5px;
            font-size: 12px;
        }
        
        .success-message {
            color: green;
            margin-top: 5px;
            font-size: 14px;
        }
        
        .button-group {
            text-align: center;
            margin-top: 30px;
        }
        
        .info-text {
            font-size: 12px;
            color: #9e9e9e;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" enctype="multipart/form-data">
        <div class="container">
            <div class="header">
                <div class="logo">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="40" height="40" fill="white">
                        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>
                    </svg>
                </div>
                <h1>Add New Course</h1>
                <p class="subtitle">Fill in the course details below</p>
            </div>
            
            <!-- Course Name -->
            <div class="form-row">
                <div class="form-group full-width">
                    <asp:Label ID="lblCourseName" runat="server" Text="Course Name *" AssociatedControlID="txtCourseName"></asp:Label>
                    <asp:TextBox ID="txtCourseName" runat="server" CssClass="form-control" placeholder="Enter course name" MaxLength="150"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvCourseName" runat="server" 
                        ControlToValidate="txtCourseName" 
                        ErrorMessage="Course name is required." 
                        Display="Dynamic" 
                        CssClass="error-message">
                    </asp:RequiredFieldValidator>
                </div>
            </div>
            
            <!-- Cover Image Upload -->
            <div class="form-row">
                <div class="form-group full-width">
                    <asp:Label ID="lblCoverImage" runat="server" Text="Course Cover Image" AssociatedControlID="fuCoverImage"></asp:Label>
                    <div class="file-upload">
                        <asp:FileUpload ID="fuCoverImage" runat="server" CssClass="form-control" accept="image/*" />
                        <p class="info-text">Supported formats: JPG, PNG, GIF (Max size: 5MB)</p>
                    </div>
                </div>
            </div>
            
            <!-- Resource File Upload -->
            <div class="form-row">
                <div class="form-group full-width">
                    <asp:Label ID="lblResourceFile" runat="server" Text="Course Resource File" AssociatedControlID="fuResourceFile"></asp:Label>
                    <div class="file-upload">
                        <asp:FileUpload ID="fuResourceFile" runat="server" CssClass="form-control" />
                        <p class="info-text">Supported formats: PDF, DOC, DOCX, PPT, PPTX, ZIP (Max size: 50MB)</p>
                    </div>
                </div>
            </div>
            
            <!-- Publish Date and Time -->
            <div class="form-row">
                <div class="form-group">
                    <asp:Label ID="lblPublishDate" runat="server" Text="Publish Date *" AssociatedControlID="txtPublishDate"></asp:Label>
                    <asp:TextBox ID="txtPublishDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvPublishDate" runat="server" 
                        ControlToValidate="txtPublishDate" 
                        ErrorMessage="Publish date is required." 
                        Display="Dynamic" 
                        CssClass="error-message">
                    </asp:RequiredFieldValidator>
                </div>
                <div class="form-group">
                    <asp:Label ID="lblPublishTime" runat="server" Text="Publish Time *" AssociatedControlID="txtPublishTime"></asp:Label>
                    <asp:TextBox ID="txtPublishTime" runat="server" CssClass="form-control" TextMode="Time"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvPublishTime" runat="server" 
                        ControlToValidate="txtPublishTime" 
                        ErrorMessage="Publish time is required." 
                        Display="Dynamic" 
                        CssClass="error-message">
                    </asp:RequiredFieldValidator>
                </div>
            </div>
            
            <!-- Module Type and Duration -->
            <div class="form-row">
                <div class="form-group">
                    <asp:Label ID="lblModuleType" runat="server" Text="Module Type *" AssociatedControlID="ddlModuleType"></asp:Label>
                    <asp:DropDownList ID="ddlModuleType" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Select Module Type" Value="" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="Video Lecture" Value="Video Lecture"></asp:ListItem>
                        <asp:ListItem Text="Interactive Content" Value="Interactive Content"></asp:ListItem>
                        <asp:ListItem Text="Quiz" Value="Quiz"></asp:ListItem>
                        <asp:ListItem Text="Assignment" Value="Assignment"></asp:ListItem>
                        <asp:ListItem Text="Reading Material" Value="Reading Material"></asp:ListItem>
                        <asp:ListItem Text="Practical Exercise" Value="Practical Exercise"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvModuleType" runat="server" 
                        ControlToValidate="ddlModuleType" 
                        InitialValue=""
                        ErrorMessage="Please select a module type." 
                        Display="Dynamic" 
                        CssClass="error-message">
                    </asp:RequiredFieldValidator>
                </div>
                <div class="form-group">
                    <asp:Label ID="lblDuration" runat="server" Text="Duration *" AssociatedControlID="txtDuration"></asp:Label>
                    <asp:TextBox ID="txtDuration" runat="server" CssClass="form-control" placeholder="e.g., 2h 30m" MaxLength="10"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvDuration" runat="server" 
                        ControlToValidate="txtDuration" 
                        ErrorMessage="Duration is required." 
                        Display="Dynamic" 
                        CssClass="error-message">
                    </asp:RequiredFieldValidator>
                </div>
            </div>
            
            <!-- Skill Level and Language -->
            <div class="form-row">
                <div class="form-group">
                    <asp:Label ID="lblSkillLevel" runat="server" Text="Skill Level *" AssociatedControlID="ddlSkillLevel"></asp:Label>
                    <asp:DropDownList ID="ddlSkillLevel" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Select Skill Level" Value="" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="Beginner" Value="Beginner"></asp:ListItem>
                        <asp:ListItem Text="Intermediate" Value="Intermediate"></asp:ListItem>
                        <asp:ListItem Text="Advanced" Value="Advanced"></asp:ListItem>
                        <asp:ListItem Text="Expert" Value="Expert"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvSkillLevel" runat="server" 
                        ControlToValidate="ddlSkillLevel" 
                        InitialValue=""
                        ErrorMessage="Please select a skill level." 
                        Display="Dynamic" 
                        CssClass="error-message">
                    </asp:RequiredFieldValidator>
                </div>
                <div class="form-group">
                    <asp:Label ID="lblLanguage" runat="server" Text="Language *" AssociatedControlID="ddlLanguage"></asp:Label>
                    <asp:DropDownList ID="ddlLanguage" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Select Language" Value="" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="English" Value="English"></asp:ListItem>
                        <asp:ListItem Text="Spanish" Value="Spanish"></asp:ListItem>
                        <asp:ListItem Text="French" Value="French"></asp:ListItem>
                        <asp:ListItem Text="German" Value="German"></asp:ListItem>
                        <asp:ListItem Text="Chinese" Value="Chinese"></asp:ListItem>
                        <asp:ListItem Text="Japanese" Value="Japanese"></asp:ListItem>
                        <asp:ListItem Text="Other" Value="Other"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvLanguage" runat="server" 
                        ControlToValidate="ddlLanguage" 
                        InitialValue=""
                        ErrorMessage="Please select a language." 
                        Display="Dynamic" 
                        CssClass="error-message">
                    </asp:RequiredFieldValidator>
                </div>
            </div>
            
            <!-- Message Label -->
            <div class="form-row">
                <div class="form-group full-width">
                    <asp:Label ID="lblMessage" runat="server" CssClass="success-message"></asp:Label>
                </div>
            </div>
            
            <!-- Buttons -->
            <div class="button-group">
                <asp:Button ID="btnSaveCourse" runat="server" Text="Save Course" CssClass="btn-primary" OnClick="btnSaveCourse_Click" />
                <asp:Button ID="btnClear" runat="server" Text="Clear Form" CssClass="btn-secondary" OnClick="btnClear_Click" CausesValidation="false" />
            </div>
        </div>
    </form>
</body>
</html>