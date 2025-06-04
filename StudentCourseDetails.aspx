<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StudentCourseDetails.aspx.cs" Inherits="WAPPSS.StudentCourseDetails" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <title>Course Detail - Scholapedia</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
  <link href="https://fonts.googleapis.com/css2?family=Indie+Flower&family=Roboto:wght@400;700&display=swap" rel="stylesheet" />
  <link href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" rel="stylesheet" />
        <link id="darkModeCss" rel="stylesheet" runat="server" />
    <style>
 body {
   font-family: 'Roboto', sans-serif;
   background: #fefefb;
   color: #333;
   margin: 0; padding: 0;
 }
 body.dark-mode {
   background-color: #121212;
   color: #fff;
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
 .breadcrumb {
   max-width: 1140px;
   margin: 12px auto 0 auto;
   font-size: 14px;
   color: #888;
   padding: 0 20px;
 }
 .breadcrumb a { color: #3c40c1; text-decoration: none; }

 /* Main grid layout */
 .course-main-layout {
   display: flex;
   flex-direction: row;
   gap: 36px;
   align-items: flex-start;
   margin-bottom: 36px;
   flex-wrap: wrap;
 }
 .course-left {
   flex: 1 1 340px;
   min-width: 320px;
   max-width: 470px;
 }
 .course-title {

   font-size: 2.45rem;
   color: #3c40c1;
   margin-bottom: 8px;
   margin-top: 0;
   text-align: left;
   letter-spacing: 1.2px;
 }
 .course-img {
   display: block;
   margin: 0 0 24px 0;
   max-width: 100%;
   border-radius: 15px;
   box-shadow: 0 8px 32px rgba(60,64,193,0.09);
   border: 1.5px solid #e8eaff;
 }
 .course-description {
   font-size: 1.08rem;
   line-height: 1.6;
   color: #444;
   padding-left: 18px;
   border-left: 4px solid #3c40c1;
   margin-bottom: 10px;
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
 .course-features h3 {
   font-size: 1.31rem;
   text-align: center;
   color: #3c40c1;
   margin-bottom: 16px;
   letter-spacing: 0.8px;
 }
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
 .feature:last-child { margin-bottom: 0; }
 .feature i {
   font-size: 20px;
   color: #3c40c1;
   min-width: 24px;
   margin-right: 6px;
 }
/* Flashcard Section Layout */
.flashcard-section {
  margin-top: 40px;
  padding: 20px;
  background: #f9f9ff;
  border-radius: 12px;

font-size: 2.1rem;
color: #3c40c1;
}

.deck {
  margin-bottom: 40px;

font-size: 2.1rem;
color: #3c40c1;
}

/* Flashcard Grid */
/* Section spacing */
.flashcard-section {
  padding: 20px;
}

/* Deck header icon */
.deck-icon {
  font-size: 1.8rem;
  color: #3c40c1;
  margin-bottom: 12px;
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
  text-align: center;
  user-select: none;
}
.card-back {
  background: linear-gradient(100deg, #6658ea 70%, #b8baff 100%);
  color: #fff;
  transform: rotateY(180deg);
}
.card-hint {
  font-size: 0.85rem;
  color: #888;
  font-style: italic;
  margin-top: 7px;
  text-align: center;
}

.progress-container {
    margin: 20px 0;
    text-align: center;
}

.progress-bar-outer {
    width: 100%;
    height: 30px;
    background-color: #eee;
    border-radius: 20px;
    overflow: hidden;
    box-shadow: 0 2px 6px rgba(0,0,0,0.2);
}

.progress-bar-inner {
    height: 100%;
    background: linear-gradient(90deg, #00c6ff, #0072ff);
    width: 0%;
    text-align: center;
    line-height: 30px;
    color: white;
    font-weight: bold;
    transition: width 0.5s ease-in-out;
    border-radius: 20px 0 0 20px;
}

.progress-text {
    margin-top: 5px;
    font-size: 18px;
    color: #333;
    font-weight: bold;
}

.test-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    background: #eef1ff;
    margin-bottom: 16px;
    padding: 18px 22px;
    border-radius: 10px;
    box-shadow: 0 2px 8px #3c40c11a;
  }

  .test-title {
    font-size: 1.14rem;
    font-weight: 700;
    color: #3c40c1;
  }

  .test-title i {
    margin-right: 10px;
  }

  .test-duration {
    font-weight: 400;
    font-size: 0.98rem;
    color: #8b8bce;
    margin-left: 12px;
  }

  .btn-take-test {
    background: linear-gradient(90deg, #3c40c1 60%, #6658ea 100%);
    color: #fff;
    border: none;
    border-radius: 7px;
    padding: 10px 26px;
    font-size: 1.05rem;
    font-weight: bold;
    box-shadow: 0 2px 8px #3c40c11a;
    text-decoration: none;
    transition: background 0.15s;
  }

  .btn-take-test:hover {
    background: linear-gradient(90deg, #2e2fa1 60%, #5145c2 100%);
  }
  .feature {
    font-size: 18px;
    color: #444;
  }
  .stars .star {
    color: #ccc; /* grey empty star */
    margin-right: 2px;
  }
  .stars .star.filled {
    color: #ffd700; /* gold filled star */
  }
  .test-item {
    padding: 10px;
    margin-bottom: 10px;
    border: 1px solid #ccc;
}
.test-item.completed {
    background-color: #e0ffe0;
}
.save-score-btn {
    margin-top: 10px;
    padding: 8px 16px;
    background-color: #3c40c1;
    color: #fff;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}
.save-score-btn:hover {
    background-color: #2a2f9d;
}


    </style>


</head>
<body class='<%= (Session["DarkMode"] != null && (bool)Session["DarkMode"]) ? "dark-mode" : "" %>'>
<form id="form1" runat="server" class="course-main-layout">

<div class="container animate__animated animate__fadeInUp">
    <button type="button" onclick="window.location.href='CourseDashboard.aspx'">Back</button>

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
      <div class="feature">
  <span class="label">Rating:</span>
  <span class="stars">
    <i class="fa fa-star star filled"></i>
    <i class="fa fa-star star filled"></i>
    <i class="fa fa-star star filled"></i>
    <i class="fa fa-star star filled"></i>
    <i class="fa fa-star star"></i>
  </span>
</div>
      <asp:Panel ID="lecturesDiv" runat="server" Visible="true">
        <div class="feature"><i class="fa fa-video"></i> <span class="label">Lectures:</span> <a href="https://teams.microsoft.com" target="_blank" style="color: #3c40c1; text-decoration: underline;">Join Meeting</a></div>
      </asp:Panel>
      <div class="feature"><i class="fa fa-clock"></i> <span class="label">Duration:</span> <span class="value" id="courseDuration" runat="server"></span></div>
      <div class="feature"><i class="fa fa-signal"></i> <span class="label">Skill Level:</span> <span class="value" id="courseSkill" runat="server"></span></div>
      <div class="feature"><i class="fa fa-language"></i> <span class="label">Language:</span> <span class="value" id="courseLanguage" runat="server"></span></div>
      <div class="feature"><i class="fa fa-calendar-alt"></i> <span class="label">Published:</span> <span class="value" id="publishedDate" runat="server"></span></div>
    </div>
      
      <div id="progressBarWrapper">
    <asp:Label ID="lblProgress" runat="server" />
    <div style="width:100%; background:#e0eaff; border-radius:10px;">
        <div id="progressBar" runat="server" style="height:20px; background:blue; width:0%; border-radius:10px;"></div>
    </div>

<!-- FLASHCARD SECTION -->
<div class="flashcard-section">
    <asp:CheckBox ID="chkFlashcard" runat="server" AutoPostBack="true" OnCheckedChanged="chkFlashcard_CheckedChanged" />
        <!-- Progress Bar -->

    <div class="section-header">
        <h2>Course Flashcards</h2>
        <!-- Flashcard Checkbox -->


        
    </div>

    <asp:Repeater ID="rptDecks" runat="server" OnItemCommand="rptDecks_ItemCommand">
        
        <ItemTemplate>
            <div class="deck">
                <h3><%# Eval("DeckTitle") %></h3>

                <!-- Icon below header -->
                <div class="deck-icon">
                    <i class="fas fa-lightbulb"></i>
                </div>

                <p><%# Eval("DeckDescription") %></p>

                <div class="flashcard-showcase">
                    <asp:Repeater ID="rptFlashcards" runat="server" DataSource='<%# Eval("Flashcards") %>'>
    <ItemTemplate>
        <div class="course-flashcard">

            <div class="card-inner">
                <div class="card-front">
                    <%# Eval("FrontText") %>
                </div>
                <div class="card-back">
                    <%# Eval("BackText") %>
                </div>
            </div>
        </div>
    </ItemTemplate>
</asp:Repeater>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>

    <div class="resource-section">
        <div class="section-header">
            <h2>Resources</h2>

        </div>
        <h3 class="subheading">Reading Materials (PDF/DOC)</h3>

        <!-- Example of checkbox added before the resource file link -->
        <asp:CheckBox ID="chkResource" runat="server" AutoPostBack="true" OnCheckedChanged="chkResource_CheckedChanged" />
        <asp:Literal ID="litResourceFile" runat="server"></asp:Literal>
    </div>
</div>


<!-- Course Test Section -->
<div class="resources-box animate__animated animate__fadeInUp" style="margin-top:30px;">
  <div style="display: flex; align-items: center; justify-content: space-between;">
    <h2 style="color: #3c40c1; margin-bottom:0;">Course Test</h2>
    <!-- Course Test Checkbox -->
    <asp:CheckBox ID="chkTest" runat="server" AutoPostBack="true" OnCheckedChanged="chkTest_CheckedChanged" />
  </div>

  <div style="margin-top:30px;" id="test-list-section">
    <asp:Repeater ID="TestRepeater" runat="server" OnItemCommand="TestRepeater_ItemCommand">
      <ItemTemplate>
        <div class="test-item" style="display:flex;align-items:center;justify-content:space-between; background:#eef1ff; margin-bottom:16px; padding:18px 22px; border-radius:10px; box-shadow:0 2px 8px #3c40c11a;">
          <div style="font-size:1.14rem; font-weight:700; color:#3c40c1;">
            <i class="fa fa-clipboard-list" style="margin-right:10px"></i>
            <%# Eval("TestTitle") %>
            <span style="font-weight:400;font-size:0.98rem;color:#8b8bce;margin-left:12px;"><%# Eval("TestTime") %> min</span>
          </div>
          <div style="display:flex;align-items:center;gap:16px;">
            <asp:LinkButton 
                ID="lnkTakeTest" 
                runat="server" 
                CommandName="TakeTest" 
                CommandArgument='<%# Eval("TestID") %>' 
                ToolTip="Take The Test"
                CssClass="take-test-btn"
                Enabled='<%# Eval("Score") == null %>'
                style='<%# Eval("Score") != null ? "background:#ccc; color:#666; cursor:not-allowed;" : "background:linear-gradient(90deg, #3c40c1 60%, #6658ea 100%); color:#fff; padding:10px 26px; border-radius:7px; font-weight:bold; text-decoration:none; transition:background 0.15s;" %>'
                >
              <i class="fa fa-play"></i> Take The Test
            </asp:LinkButton>
            <%-- Show Score if available --%>
           <span style="font-weight:600; color:#4a4a4a;">
  <%# Eval("Score") != null ? "Completed: " + Eval("Score") + " / " + Eval("TotalQuestions") : "" %>
</span>

          </div>
        </div>
      </ItemTemplate>
    </asp:Repeater>

    <asp:Literal ID="litNoTests" runat="server" />
  </div>
</div>



<script>
    function triggerPostback() {
        __doPostBack('UpdateProgress', '');
    }
</script>




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
    function updateProgressBar(progress) {
        const bar = document.getElementById("progressBar");
        const text = document.getElementById("progressText");
        let maxProgress = 100;

        let displayProgress = Math.min(progress, maxProgress);
        bar.style.width = displayProgress + "%";
        text.innerText = displayProgress + "%";

        if (displayProgress >= 100) {
            bar.style.background = "linear-gradient(90deg, #00ff99, #00cc66)";
            text.innerText = "Completed!";
        }
    }
</script>


</form>


</body>
</html>
