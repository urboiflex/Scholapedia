<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="header.aspx.cs" Inherits="WAPPSS.header" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Scholapedia Header</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/header.css">
    <link rel="stylesheet" href="css/icon.css">
    <link rel="stylesheet" href="css/search.css">
</head>
<body>
    <header class="header">
        <div class="logo">
            <a href="landingPage.aspx">
                <div class="ghost-container">
                    <div id="ghost">
                        <div id="blue">
                            <div id="pupil"></div>
                            <div id="pupil1"></div>
                            <div id="eye"></div>
                            <div id="eye1"></div>
                            <div id="top0"></div>
                            <div id="top1"></div>
                            <div id="top2"></div>
                            <div id="top3"></div>
                            <div id="top4"></div>
                            <div id="st0"></div>
                            <div id="st1"></div>
                            <div id="st2"></div>
                            <div id="st3"></div>
                            <div id="st4"></div>
                            <div id="st5"></div>
                            <div id="an1"></div>
                            <div id="an2"></div>
                            <div id="an3"></div>
                            <div id="an4"></div>
                            <div id="an5"></div>
                            <div id="an6"></div>
                            <div id="an7"></div>
                            <div id="an8"></div>
                            <div id="an9"></div>
                            <div id="an10"></div>
                            <div id="an11"></div>
                            <div id="an12"></div>
                            <div id="an13"></div>
                            <div id="an14"></div>
                            <div id="an15"></div>
                            <div id="an16"></div>
                            <div id="an17"></div>
                            <div id="an18"></div>
                        </div>
                        <div id="shadow"></div>
                    </div>
                </div>
                <img src="images/scholapedia.png" alt="Scholapedia Logo">
            </a>
        </div>
        <div class="search-container">
            <form class="form">
                <button>
                    <svg width="17" height="16" fill="none" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="search">
                        <path d="M7.667 12.667A5.333 5.333 0 107.667 2a5.333 5.333 0 000 10.667zM14.334 14l-2.9-2.9" stroke="currentColor" stroke-width="1.333" stroke-linecap="round" stroke-linejoin="round"></path>
                    </svg>
                </button>
                <input class="input" placeholder="Search courses..." required="" type="text">
                <button class="reset" type="reset">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                </button>
            </form>
        </div>
        <div class="auth-buttons">
            <a href="login.aspx"><button class="login-btn">LOGIN</button></a>
            <a href="register.aspx"><button class="signup-btn">SIGN UP</button></a>
        </div>
    </header>
</body>
</html>
