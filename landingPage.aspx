<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="landingPage.aspx.cs" Inherits="WAPPSS.landingPage" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Scholapedia - Home</title>
    <!-- Google Fonts - Nunito -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700&display=swap" rel="stylesheet">
    <!-- Geist Font for Chat Widget -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/geist-font/1.0.0/fonts/geist-sans/style.min.css">
    <!-- CSS Files -->
    <link rel="stylesheet" href="css/search.css">
    <link rel="stylesheet" href="css/main.css">
    <link rel="stylesheet" href="css/header.css">
    <link rel="stylesheet" href="css/footer.css">
    <link rel="stylesheet" href="css/icon.css">
    <link rel="stylesheet" href="css/partnership.css">
    <link rel="stylesheet" href="css/testimonials.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Chat Widget Styles -->
    <style>
        /* Chat Widget Styling */
        #chat-widget-container {
            position: fixed;
            bottom: 20px;
            right: 20px;
            width: 350px;
            height: 500px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            display: none;
            flex-direction: column;
            z-index: 1000;
            overflow: hidden;
            font-family: 'Geist Sans', -apple-system, BlinkMacSystemFont, system-ui, sans-serif;
        }
        #chat-widget-header {
            background: #854fff;
            color: white;
            padding: 20px;
            font-weight: bold;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 18px;
        }
        #chat-widget-header button {
            background: none;
            border: none;
            color: white;
            font-size: 16px;
            cursor: pointer;
            padding: 0;
            margin: 0;
        }
        #chat-widget-body {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
        }
        #chat-widget-body p {
            margin-bottom: 15px;
            padding: 12px;
            border-radius: 8px;
            font-size: 14px;
            word-wrap: break-word;
        }
        #chat-widget-footer {
            padding: 12px;
            border-top: 1px solid #ddd;
            display: flex;
            gap: 10px;
        }
        #chat-widget-input {
            flex: 1;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 8px;
            outline: none;
            font-family: inherit;
        }
        #chat-widget-send {
            background: #854fff;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 8px;
            cursor: pointer;
            font-family: inherit;
        }
        #chat-widget-send:hover {
            background: #6b3fd4;
        }
        #chat-widget-button {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: #854fff;
            color: white;
            border: none;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            cursor: pointer;
            font-size: 20px;
            z-index: 1001;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
            transition: all 0.3s ease;
        }
        #chat-widget-button:hover {
            background: #6b3fd4;
            transform: scale(1.05);
        }
        
        @media (max-width: 768px) {
            #chat-widget-container {
                width: 90%;
                height: 70%;
                bottom: 10px;
                right: 5%;
                left: 5%;
            }
            #chat-widget-button {
                bottom: 15px;
                right: 15px;
            }
        }
    </style>
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function () {
            // Load header component
            $(".headerSection").load("guest/header.aspx .header", function () {
                // After header is loaded, add scroll event listener
                $(window).on('scroll', function () {
                    if ($(window).scrollTop() > 50) {
                        $('.header').addClass('header-scrolled');
                    } else {
                        $('.header').removeClass('header-scrolled');
                    }
                });
            });

            // Load main content component
            $(".mainContentSection").load("guest/main.aspx .main-content");

            // Load partnership component
            $(".partnershipSection").load("guest/partnership.aspx .container");

            // Load testimonials component
            $(".testimonialsSection").load("guest/testimonials.aspx .testimonials-container");

            // Load footer component
            $(".footerSection").load("guest/footer.aspx .footer");

            // Initialize chat widget after page loads
            initializeChatWidget();
        });

        function initializeChatWidget() {
            // Chat Widget Configuration
            window.ChatWidgetConfig = {
                webhook: {
                    url: 'https://sayaca3709.app.n8n.cloud/webhook/a889d2ae-2159-402f-b326-5f61e90f602e/chat',
                    route: 'general'
                },
                style: {
                    primaryColor: '#854fff',
                    secondaryColor: '#6b3fd4',
                    position: 'right',
                    backgroundColor: '#ffffff',
                    fontColor: '#333333'
                }
            };

            // Function to generate or retrieve a unique chat ID
            function getChatId() {
                let chatId = sessionStorage.getItem("chatId");
                if (!chatId) {
                    chatId = "chat_" + Math.random().toString(36).substr(2, 9);
                    sessionStorage.setItem("chatId", chatId);
                }
                return chatId;
            }

            // Show chat widget and hide bubble
            $("#chat-widget-button").on("click", function () {
                $("#chat-widget-container").show().css('display', 'flex');
                $("#chat-widget-button").hide();
            });

            // Close chat widget and show bubble
            window.closeChatWidget = function () {
                $("#chat-widget-container").hide();
                $("#chat-widget-button").show().css('display', 'flex');
            }

            // Send message function
            function sendMessage() {
                let message = $("#chat-widget-input").val().trim();
                if (message === "") return;

                let chatBody = $("#chat-widget-body");
                let newMessage = $("<p></p>")
                    .text(message)
                    .css({
                        color: "#333",
                        background: "#f1f1f1"
                    });
                chatBody.append(newMessage);

                let chatId = getChatId();

                // Show typing indicator
                let typingIndicator = $("<p></p>")
                    .html("AI is typing...")
                    .css({
                        color: "#666",
                        background: "#f9f9f9",
                        fontStyle: "italic"
                    });
                chatBody.append(typingIndicator);
                chatBody.scrollTop(chatBody[0].scrollHeight);

                $.ajax({
                    url: window.ChatWidgetConfig.webhook.url,
                    method: "POST",
                    contentType: "application/json",
                    data: JSON.stringify({
                        chatId: chatId,
                        message: message,
                        route: window.ChatWidgetConfig.webhook.route
                    }),
                    success: function (data) {
                        typingIndicator.remove();
                        let botMessage = $("<p></p>")
                            .html(data.output || "Sorry, I couldn't understand that.")
                            .css({
                                color: "#fff",
                                background: "#854fff",
                                marginTop: "10px"
                            });
                        chatBody.append(botMessage);
                        chatBody.scrollTop(chatBody[0].scrollHeight);
                    },
                    error: function (error) {
                        typingIndicator.remove();
                        let errorMessage = $("<p></p>")
                            .text("Sorry, there was an error. Please try again.")
                            .css({
                                color: "#fff",
                                background: "#ff4444",
                                marginTop: "10px"
                            });
                        chatBody.append(errorMessage);
                        chatBody.scrollTop(chatBody[0].scrollHeight);
                        console.error("Error:", error);
                    }
                });

                $("#chat-widget-input").val("");
            }

            // Send message on button click
            $("#chat-widget-send").on("click", sendMessage);

            // Send message on Enter key press
            $("#chat-widget-input").on("keypress", function (e) {
                if (e.which === 13) { // Enter key
                    sendMessage();
                }
            });
        }
    </script>
</head>
<body>
    <!-- Header Section -->
    <div class="headerSection"></div>

    <!-- Main Content Section -->
    <div class="mainContentSection"></div>
    
    <!-- Partnership Section -->
    <div class="partnershipSection"></div>
    
    <!-- Testimonials Section -->
    <div class="testimonialsSection"></div>

    <!-- Footer Section -->
    <div class="footerSection"></div>

    <!-- Chat Widget Button -->
    <button id="chat-widget-button">💬</button>

    <!-- Chat Widget -->
    <div id="chat-widget-container">
        <div id="chat-widget-header">
            <span>Ask Scholapedia AI</span>
            <button onclick="closeChatWidget()">✖</button>
        </div>
        <div id="chat-widget-body">
            <p style="margin-bottom: 20px; color: #333; background: #f1f1f1;"><strong>Hi 👋 Welcome to Scholapedia! How can I help you today?</strong></p>
        </div>
        <div id="chat-widget-footer">
            <input type="text" id="chat-widget-input" placeholder="Ask me anything about Scholapedia...">
            <button id="chat-widget-send">Send</button>
        </div>
    </div>
</body>
</html>