<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TestPreview.aspx.cs" Inherits="WAPPSS.TestPreview" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
  <meta charset="UTF-8" />
  <title>Test Preview - Scholapedia</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
  <link href="https://fonts.googleapis.com/css2?family=Indie+Flower&family=Roboto:wght@400;700&display=swap" rel="stylesheet" />
  <link href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" rel="stylesheet" />
  <style>
    body { font-family: 'Roboto', sans-serif; background:#f7f8fd; color:#23249c; }
    .preview-container {
      max-width: 800px;
      margin: 38px auto 0 auto;
      background: #fff;
      border-radius: 18px;
      box-shadow: 0 8px 30px #3c40c11b;
      padding: 32px 38px 52px 38px;
      min-height: 84vh;
    }
    .preview-header {
      font-family: 'Indie Flower', cursive;
      font-size: 2.1rem;
      color: #3c40c1;
      margin-bottom: 14px;
      text-align: center;
    }
    .test-instructions { text-align:center; font-size:1.09rem; margin-bottom:22px; color:#444;}
    .progress-bar-outer {
      background: #e4e8ff;
      border-radius: 9px;
      height: 22px;
      width: 100%;
      margin-bottom: 22px;
      box-shadow: 0 2px 8px #3c40c120;
      position: relative;
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
      min-width: 34px;
      white-space:nowrap;
    }
    .timer-countdown {
      font-size: 1.1rem;
      font-weight: 600;
      color: #b00606;
      text-align: right;
      margin-bottom: 9px;
      letter-spacing:1.2px;
    }
    .preview-question {
      margin-bottom: 34px;
      background: #f7faff;
      border-radius: 10px;
      box-shadow: 0 2px 8px #3c40c11a;
      padding: 22px;
      position: relative;
    }
    .preview-question .q-title { font-weight:700; font-size:1.13rem; margin-bottom:9px; }
    .preview-question label { font-weight: 600;}
    .preview-question input[type='text'],
    .preview-question textarea {
      width: 100%; font-size: 1.04rem; border-radius: 7px; border: 1.3px solid #cfcfff; background: #f7f8ff; color: #23249c; margin-bottom: 9px;
      padding: 9px 11px;
    }
    .preview-question textarea { min-height: 50px;}
    .preview-question .option-row {margin-bottom: 8px;}
    .preview-question .option-row label {margin-left:7px; font-weight:400;}
    .preview-submit-btn {
      background: #59bbff;
      color: #fff;
      border: none;
      border-radius: 9px;
      padding: 14px 44px;
      font-size: 1.09rem;
      font-weight: 700;
      margin: 30px auto 0 auto;
      cursor: pointer;
      box-shadow: 0 2px 8px #3c40c11a;
      transition: background 0.13s;
      display:block;
    }
    .preview-submit-btn:hover { background: #3c40c1; }
    .result-panel { background: #eefdde; border: 1.3px solid #c3e6b1; color:#0d810d; border-radius: 10px; margin: 24px 0; padding: 18px; text-align: center; font-size:1.1rem; font-weight:600; }
    .back-to-test-btn { background: #3c40c1; color: #fff; border:none; border-radius: 7px; padding: 11px 36px; font-size:1.03rem; font-weight:600; margin-top:18px; cursor:pointer; }
    .back-to-test-btn:hover { background: #23249c; }

    /* DARK MODE STYLES */
    body.dark-mode { background: #181a22; color: #e5e7eb;}
    .dark-mode .preview-container {
      background: #23263a;
      box-shadow: 0 8px 30px #0e101a70;
    }
    .dark-mode .preview-header {
      color: #59bbff;
    }
    .dark-mode .test-instructions {
      color: #b8c8e1;
    }
    .dark-mode .progress-bar-outer {
      background: #323651;
      box-shadow: 0 2px 8px #181a2260;
    }
    .dark-mode .progress-bar-inner {
      background: linear-gradient(90deg, #59bbff 60%, #3c40c1 100%);
      color: #23263a;
    }
    .dark-mode .timer-countdown {
      color: #ff7c7c;
    }
    .dark-mode .preview-question {
      background: #1f2338;
      box-shadow: 0 2px 8px #23263a60;
    }
    .dark-mode .preview-question .q-title,
    .dark-mode .preview-question label {
      color: #b8c8e1;
    }
    .dark-mode .preview-question input[type='text'],
    .dark-mode .preview-question textarea {
      background: #23263a;
      color: #e5e7eb;
      border: 1.3px solid #44486a;
    }
    .dark-mode .preview-submit-btn {
      background: #59bbff;
      color: #23263a;
    }
    .dark-mode .preview-submit-btn:hover {
      background: #0288d1;
      color: #fff;
    }
    .dark-mode .result-panel {
      background: #263d21;
      color: #13ff60;
      border-color: #39e58a;
    }
    .dark-mode .back-to-test-btn {
      background: #59bbff;
      color: #23263a;
    }
    .dark-mode .back-to-test-btn:hover {
      background: #0288d1;
      color: #fff;
    }
  </style>
</head>
<body id="bodyTag" runat="server">
  <form id="form1" runat="server">
    <div class="preview-container">
      <div class="preview-header" id="testTitle" runat="server"></div>
      <div class="test-instructions" id="testInstructions" runat="server"></div>
      <div class="timer-countdown" id="timerDiv"></div>
      <div class="progress-bar-outer">
        <div class="progress-bar-inner" id="progressBar" style="width:0%">0%</div>
      </div>
      <asp:Panel ID="PreviewPanel" runat="server"></asp:Panel>
      <div id="resultPanel" class="result-panel" style="display:none;"></div>
      <button type="button" id="submitBtn" class="preview-submit-btn">Submit Test</button>
     <a href='course_detail.aspx?course=<%= Server.UrlEncode(CourseName ?? "") %>' 
   style="background:linear-gradient(90deg,#3c40c1 60%,#6658ea 100%);color:#fff;padding:10px 38px;border-radius:7px;font-weight:700;text-decoration:none;box-shadow:0 2px 8px #3c40c11a;transition:background 0.15s;display:none;" 
   class="back-to-test-btn" id="backToTestBtn">
  <i class="fa fa-arrow-left"></i> Return to Course
</a>
    </div>
    <asp:HiddenField ID="hfQuestionsJSON" runat="server" />
    <asp:HiddenField ID="hfCorrectAnswers" runat="server" />
    <asp:HiddenField ID="hfTestTime" runat="server" />
  </form>
  <script>
      // Timer logic
      let timeLeft = parseInt(document.getElementById('<%= hfTestTime.ClientID %>').value || "0") * 60;
    let timerDiv = document.getElementById('timerDiv');
    let interval = null;
    function formatTime(sec) {
      let m = Math.floor(sec/60), s = sec%60;
      return m+':'+(s<10?'0':'')+s;
    }
    function updateTimer() {
      timerDiv.innerText = 'Time left: ' + formatTime(timeLeft);
      if (timeLeft <= 0) {
        timerDiv.innerText = 'Time is up!';
        clearInterval(interval);
        submitTest(true);
      }
      timeLeft--;
    }
    if (timeLeft > 0) {
      updateTimer();
      interval = setInterval(updateTimer, 1000);
    }
    // Progress Bar
    function updateProgress() {
      let total = document.querySelectorAll('.preview-question').length;
      let answered = 0;
      document.querySelectorAll('.preview-question').forEach(function(q){
        let type = q.dataset.type;
        if (type==='radio' || type==='checkbox') {
          let inputs = q.querySelectorAll('input[type="'+type+'"]');
          for (let inp of inputs) if (inp.checked) { answered++; break; }
        } else {
          let inp = q.querySelector('input[type="text"],textarea');
          if (inp && inp.value.trim().length>0) answered++;
        }
      });
      let perc = total ? Math.round(100*answered/total) : 0;
      document.getElementById('progressBar').style.width = perc+'%';
      document.getElementById('progressBar').innerText = perc+'%';
    }
    document.addEventListener('input', updateProgress);
    // Submit logic
    document.getElementById('submitBtn').onclick = function(){ submitTest(false); };
    function submitTest(timeup) {
      clearInterval(interval);
      let questions = JSON.parse(document.getElementById('<%= hfQuestionsJSON.ClientID %>').value||"[]");
      let correctAnswers = JSON.parse(document.getElementById('<%= hfCorrectAnswers.ClientID %>').value || "[]");
          let score = 0, total = 0;
          let html = "";
          document.querySelectorAll('.preview-question').forEach(function (qDiv, i) {
              let type = qDiv.dataset.type;
              if (type === 'radio' || type === 'checkbox') {
                  total++;
                  let correct = correctAnswers[i] || [];
                  let selected = [];
                  qDiv.querySelectorAll('input[type="' + type + '"]').forEach((inp, j) => {
                      if (inp.checked) selected.push(j);
                  });
                  let isCorrect = (selected.length === correct.length) && selected.every(x => correct.includes(x));
                  if (isCorrect) score++;
                  html += `<div>Q${i + 1}: <b style="color:${isCorrect ? '#13b113' : '#d80000'}">${isCorrect ? 'Correct!' : 'Incorrect'}</b></div>`;
              } else {
                  let ans = qDiv.querySelector('input,textarea').value;
                  html += `<div>Q${i + 1}: <b>Your Answer:</b> ${ans ? ans : '(No answer)'}</div>`;
              }
          });
          let res = `<div style="font-size:1.23rem;margin-bottom:12px;">Test Finished!</div>`;
          if (total > 0) res += `<div style="font-size:1.08rem;margin-bottom:10px;">Score: <b>${score}/${total}</b></div>`;
          res += html;
          document.getElementById('resultPanel').innerHTML = res;
          document.getElementById('resultPanel').style.display = '';
          document.getElementById('submitBtn').style.display = 'none';
          document.getElementById('backToTestBtn').style.display = '';
      }
  </script>
</body>
</html>