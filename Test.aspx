<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Test.aspx.cs" Inherits="WAPPSS.Test" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
  <meta charset="UTF-8" />
  <title>Create/Edit Test - Scholapedia</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
  <link href="https://fonts.googleapis.com/css2?family=Indie+Flower&family=Roboto:wght@400;700&display=swap" rel="stylesheet" />
  <link href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" rel="stylesheet" />
  <style>
    body {
      font-family: 'Roboto', sans-serif;
      background: #f7f8fd;
      margin: 0;
      padding: 0;
      color: #23249c;
    }
    .test-container {
      max-width: 800px;
      margin: 40px auto 0 auto;
      background: #fff;
      border-radius: 18px;
      box-shadow: 0 8px 30px #3c40c11b;
      padding: 32px 38px 42px 38px;
      min-height: 84vh;
    }
    .test-header {
      font-family: 'Indie Flower', cursive;
      font-size: 2.1rem;
      color: #3c40c1;
      margin-bottom: 14px;
      text-align: center;
    }
    .test-form label {
      font-weight: bold;
      color: #23249c;
      margin-top: 16px;
      display: block;
    }
    .test-form input[type='text'],
    .test-form textarea,
    .test-form input[type='number'] {
      width: 100%;
      padding: 10px 13px;
      border: 1.4px solid #cfcfff;
      border-radius: 7px;
      font-size: 1.04rem;
      margin-bottom: 12px;
      margin-top: 5px;
      background: #f7f8ff;
      color: #23249c;
      transition: border 0.18s;
    }
    .test-form textarea { min-height: 70px; }
    .test-form input[type='number'] { max-width: 120px; }
    .q-section {
      margin-top: 32px;
    }
    .question-block {
      background: #f7faff;
      border: 1.2px solid #e5e7f7;
      border-radius: 10px;
      margin-bottom: 28px;
      padding: 24px 16px 16px 24px;
      position: relative;
      box-shadow: 0 2px 8px #3c40c11a;
      animation: fadeInUp 0.8s;
    }
    .question-block .remove-question-btn {
      position: absolute;
      top: 18px; right: 18px;
      background: none;
      border: none;
      color: #e74c3c;
      font-size: 19px;
      cursor: pointer;
      transition: color 0.2s;
    }
    .question-block .remove-question-btn:hover { color: #b10000; }
    .question-type-select {
      width: 150px;
      padding: 7px;
      border-radius: 6px;
      border: 1.3px solid #cfcfff;
      background: #f7f8ff;
      font-size: 1rem;
      color: #23249c;
    }
    .option-row {
      display: flex;
      align-items: center;
      gap: 12px;
      margin-bottom: 8px;
    }
    .option-row input[type='text'] {
      flex: 1;
      min-width: 0;
    }
    .option-row .mark-correct {
      cursor: pointer;
      font-size: 17px;
      color: #bbb;
      margin-left: 4px;
      transition: color 0.2s;
    }
    .option-row .mark-correct.selected { color: #1abf1a; }
    .option-row .remove-option-btn {
      color: #e74c3c;
      font-size: 18px;
      background: none;
      border: none;
      cursor: pointer;
      margin-left: 8px;
      transition: color 0.2s;
    }
    .option-row .remove-option-btn:hover { color: #b10000; }
    .add-option-btn {
      background: #3c40c1;
      color: #fff;
      border: none;
      border-radius: 7px;
      padding: 7px 18px;
      font-size: 0.97rem;
      font-weight: 700;
      margin-top: 7px;
      cursor: pointer;
      transition: background 0.12s;
      display: inline-block;
    }
    .add-option-btn:hover { background: #23249c; }

    /* BUTTON COLOR CHANGE: Both .add-question-btn and .submit-test-btn use the same color */
    .add-question-btn,
    .submit-test-btn {
      background: #59bbff; /* Light blue */
      color: #fff;
      border: none;
      border-radius: 9px;
      padding: 14px 44px;
      font-size: 1.07rem;
      font-weight: 700;
      margin: 38px 0 0 0;
      cursor: pointer;
      box-shadow: 0 2px 8px #3c40c11a;
      transition: background 0.15s;
      display:block;
      margin-left:auto;
      margin-right:auto;
    }
    .add-question-btn:hover,
    .submit-test-btn:hover { background: #3c40c1; }

    /* .submit-test-btn margin adjustment */
    .submit-test-btn { margin-top: 36px; }

    @keyframes fadeInUp {
      from { opacity: 0; transform: translateY(30px);}
      to { opacity: 1; transform: translateY(0);}
    }
    .success-message {
      background: #e9ffe9;
      color: #14a314;
      border: 1px solid #b1e7b1;
      border-radius: 8px;
      margin: 18px 0;
      padding: 13px;
      text-align: center;
      font-weight: 600;
      font-size: 1.04rem;
      animation: fadeInUp 0.6s;
    }
    /* DARK MODE STYLES */
    body.dark-mode {
      background: #181a22;
      color: #e5e7eb;
    }
    .dark-mode .test-container {
      background: #23263a;
      box-shadow: 0 8px 30px #0e101a70;
    }
    .dark-mode .test-header {
      color: #59bbff;
    }
    .dark-mode .test-form label {
      color: #97b4d9;
    }
    .dark-mode .test-form input[type='text'],
    .dark-mode .test-form textarea,
    .dark-mode .test-form input[type='number'] {
      background: #23263a;
      color: #e5e7eb;
      border: 1.4px solid #44486a;
    }
    .dark-mode .question-block {
      background: #1f2338;
      border: 1.2px solid #44486a;
      box-shadow: 0 2px 8px #23263a60;
    }
    .dark-mode .question-type-select {
      background: #23263a;
      color: #e5e7eb;
      border: 1.3px solid #44486a;
    }
    .dark-mode .option-row input[type='text'] {
      background: #23263a;
      color: #e5e7eb;
      border: 1.2px solid #44486a;
    }
    .dark-mode .add-option-btn {
      background: #59bbff;
      color: #23263a;
    }
    .dark-mode .add-option-btn:hover {
      background: #3c40c1;
      color: #fff;
    }
    /* BUTTON COLOR CHANGE: Both .add-question-btn and .submit-test-btn use the same light blue in dark mode */
    .dark-mode .add-question-btn,
    .dark-mode .submit-test-btn {
      background: #59bbff;
      color: #23263a;
    }
    .dark-mode .add-question-btn:hover,
    .dark-mode .submit-test-btn:hover {
      background: #0288d1;
      color: #fff;
    }
    .dark-mode .success-message {
      background: #1a4021;
      color: #13ff60;
      border-color: #39e58a;
    }
  </style>
</head>
<body id="bodyTag" runat="server">
  <form id="form1" runat="server">
    <div class="test-container">
<asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="success-message">
  <div style="font-size:1.6rem; color:#13b113; margin-bottom:10px;">
    <i class="fa fa-check-circle" style="font-size:2.2rem;"></i>
  </div>
  <div style="font-size:1.22rem; font-weight:700; color:#23249c;">Test Successfully Saved!</div>
  <div style="margin-top:16px;">
    <a href="course_detail.aspx?course=<%= Server.UrlEncode(Request.QueryString["course"] ?? (Session["SelectedCourse"] as string) ?? "") %>" 
       style="background:linear-gradient(90deg,#3c40c1 60%,#6658ea 100%);color:#fff;padding:10px 38px;border-radius:7px;font-weight:700;text-decoration:none;box-shadow:0 2px 8px #3c40c11a;transition:background 0.15s;">
      <i class="fa fa-arrow-left"></i> Return to Course
    </a>
  </div>
</asp:Panel>
      <asp:Panel ID="pnlTestForm" runat="server" CssClass="test-form">
          <div class="test-header">Create New Test</div>
      <label for="txtTestTitle">Test Title</label>
      <asp:TextBox ID="txtTestTitle" runat="server" MaxLength="200" required="required" />
      <label for="txtTestInstructions">Test Instructions</label>
      <asp:TextBox ID="txtTestInstructions" runat="server" TextMode="MultiLine" MaxLength="1000" />
      <label for="txtTestTime">Time (minutes)</label>
      <asp:TextBox ID="txtTestTime" runat="server" TextMode="Number" required="required" />
      <div class="q-section" id="questions-section"></div>
      <button type="button" class="add-question-btn" id="add-question-btn"><i class="fa fa-plus"></i> Add Question</button>
      <asp:Button ID="btnSaveTest" runat="server" Text="Save Test" CssClass="submit-test-btn" OnClick="btnSaveTest_Click" />
    </asp:Panel>
    <asp:HiddenField ID="hfQuestionsJSON" runat="server" />
  </div>
</form>
<script>
    // Dynamic Question UI
    let questions = [];
    function renderQuestions() {
        let html = '';
        questions.forEach((q, i) => {
            html += `
      <div class="question-block" data-index="${i}">
        <button type="button" class="remove-question-btn" title="Remove Question"><i class="fa fa-trash"></i></button>
        <label>Question ${i + 1}</label>
        <input type="text" class="q-text" value="${q.text.replace(/"/g, '&quot;')}" placeholder="Enter question..." maxlength="1000" required/>
        <div style="margin-top:8px;">
          <select class="question-type-select">
            <option value="radio" ${q.type === 'radio' ? 'selected' : ''}>Multiple Choice (Single Correct)</option>
            <option value="checkbox" ${q.type === 'checkbox' ? 'selected' : ''}>Multiple Choice (Multiple Correct)</option>
          </select>
        </div>
        <div class="options-section" style="${q.type === 'radio' || q.type === 'checkbox' ? '' : 'display:none;'};margin-top:14px;">
          ${(q.options || []).map((opt, j) => `
            <div class="option-row" data-oid="${j}">
              <input type="text" class="option-text" value="${opt.text.replace(/"/g, '&quot;')}" placeholder="Option..." maxlength="500" required/>
              <span class="mark-correct${opt.correct ? ' selected' : ''}" title="Mark as correct"><i class="fa fa-check-circle"></i></span>
              <button type="button" class="remove-option-btn" title="Remove Option"><i class="fa fa-times"></i></button>
            </div>
          `).join('')}
          <button type="button" class="add-option-btn"><i class="fa fa-plus"></i> Add Option</button>
        </div>
      </div>
      `;
        });
        document.getElementById('questions-section').innerHTML = html;
    }
    // Add Question
    document.getElementById('add-question-btn').onclick = function () {
        questions.push({ text: '', type: 'radio', options: [{ text: '', correct: true }, { text: '', correct: false }] });
        renderQuestions();
    };
    // Delegate events
    document.getElementById('questions-section').addEventListener('click', function (e) {
        let qDiv = e.target.closest('.question-block');
        if (!qDiv) return;
        let idx = +qDiv.dataset.index;
        // Remove Question
        if (e.target.closest('.remove-question-btn')) {
            questions.splice(idx, 1); renderQuestions(); return;
        }
        // Add Option
        if (e.target.classList.contains('add-option-btn')) {
            if (!questions[idx].options) questions[idx].options = [];
            questions[idx].options.push({ text: '', correct: false });
            renderQuestions(); return;
        }
        // Remove Option
        if (e.target.classList.contains('remove-option-btn')) {
            let oid = +e.target.closest('.option-row').dataset.oid;
            questions[idx].options.splice(oid, 1); renderQuestions(); return;
        }
        // Mark Correct
        if (e.target.closest('.mark-correct')) {
            let oid = +e.target.closest('.option-row').dataset.oid;
            if (questions[idx].type === 'radio') {
                questions[idx].options.forEach((o, j) => o.correct = (j === oid));
            } else {
                questions[idx].options[oid].correct = !questions[idx].options[oid].correct;
            }
            renderQuestions(); return;
        }
    });
    // Change Question text/type/options
    document.getElementById('questions-section').addEventListener('input', function (e) {
        let qDiv = e.target.closest('.question-block');
        if (!qDiv) return;
        let idx = +qDiv.dataset.index;
        // Question Text
        if (e.target.classList.contains('q-text')) {
            questions[idx].text = e.target.value;
        }
        // Option Text
        if (e.target.classList.contains('option-text')) {
            let oid = +e.target.closest('.option-row').dataset.oid;
            questions[idx].options[oid].text = e.target.value;
        }
    });
    document.getElementById('questions-section').addEventListener('change', function (e) {
        let qDiv = e.target.closest('.question-block');
        if (!qDiv) return;
        let idx = +qDiv.dataset.index;
        // Change Type
        if (e.target.classList.contains('question-type-select')) {
            let val = e.target.value;
            questions[idx].type = val;
            if (val === 'radio' || val === 'checkbox') {
                if (!questions[idx].options) questions[idx].options = [{ text: '', correct: false }, { text: '', correct: false }];
            } else {
                questions[idx].options = undefined;
            }
            renderQuestions();
        }
    });
    // Before submit, store questions as JSON
    document.getElementById('<%= btnSaveTest.ClientID %>').onclick = function () {
        document.getElementById('<%= hfQuestionsJSON.ClientID %>').value = JSON.stringify(questions);
  };
</script>
<script>
    // Set JSON before form submit
    document.getElementById('form1').onsubmit = function () {
        document.getElementById('<%= hfQuestionsJSON.ClientID %>').value = JSON.stringify(questions);
        return true;
    };
    // Show popup if instructed (set by server)
    if (window.showTestSavedPopup) {
        setTimeout(function () {
            alert('Test successfully saved!');
        }, 400);
    }
</script>
</body>
</html>