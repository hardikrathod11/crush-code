<%@page import="model.Skill"%>
<%@page import="model.SwapRequest"%>
<%@page import="model.User"%>
<%@page import="dao.SwapRequestDAO"%>
<%@page import="dao.UserDAO"%>
<%@page import="dao.SkillDAO"%>
<%@page import="java.util.List"%>
<%@page import="dao.RequestMessageDAO"%>
<%@page import="model.RequestMessage"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Check if user is logged in
    User currentUser = (User)session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    try {
        SwapRequestDAO swapRequestDao = new SwapRequestDAO();
        UserDAO userDao = new UserDAO();
        SkillDAO skillDao = new SkillDAO();
        RequestMessageDAO messageDao = new RequestMessageDAO();
        
        // Check if we're viewing messages for a specific request
        String viewMessages = request.getParameter("viewMessages");
        SwapRequest activeRequest = null;
        User otherUser = null;
        List<RequestMessage> messages = null;
        
        if (viewMessages != null && !viewMessages.isEmpty()) {
            int requestId = Integer.parseInt(viewMessages);
            activeRequest = swapRequestDao.getSwapRequestById(requestId);
            
            if (activeRequest != null) {
                if (activeRequest.getRequesterId() == currentUser.getUserId()) {
                    otherUser = userDao.getUserById(activeRequest.getReceiverId());
                } else {
                    otherUser = userDao.getUserById(activeRequest.getRequesterId());
                }
                
                messages = messageDao.getMessagesForRequest(requestId);
            }
        }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Skill Swap - Requests</title>
    <style>
        <%@include file="css/styles.css"%>
        
     :root {
    --primary-blue: #3498db;
    --dark-blue: #2980b9;
    --light-blue: #e6f2ff;
    --white: #ffffff;
    --light-gray: #f5f7fa;
    --medium-gray: #e0e0e0;
    --dark-gray: #333333;
    --success-green: #27ae60;
    --error-red: #e74c3c;
}

body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: var(--light-gray);
    color: var(--dark-gray);
    line-height: 1.6;
    margin: 0;
    padding: 0;
}

header {
    background-color: var(--white);
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    padding: 1rem 5%;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.logo {
    font-size: 1.5rem;
    font-weight: 700;
    color: var(--primary-blue);
}

nav ul {
    display: flex;
    list-style: none;
    margin: 0;
    padding: 0;
}

nav ul li {
    margin-left: 1.5rem;
}

nav ul li a {
    text-decoration: none;
    color: var(--dark-gray);
    font-weight: 500;
    padding: 0.5rem 1rem;
    border-radius: 4px;
    transition: all 0.3s ease;
}

nav ul li a:hover {
    color: var(--primary-blue);
    background-color: var(--light-blue);
}

.requests-container {
    max-width: 1000px;
    margin: 2rem auto;
    padding: 2rem;
    background-color: var(--white);
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

h1, h2 {
    color: var(--primary-blue);
    margin-top: 0;
}

.tabs {
    display: flex;
    border-bottom: 1px solid var(--medium-gray);
    margin-bottom: 1.5rem;
}

.tab-button {
    padding: 0.75rem 1.5rem;
    background: none;
    border: none;
    border-bottom: 3px solid transparent;
    font-size: 1rem;
    color: var(--dark-gray);
    cursor: pointer;
    transition: all 0.3s ease;
}

.tab-button.active {
    color: var(--primary-blue);
    border-bottom-color: var(--primary-blue);
    font-weight: 600;
}

.tab-button:hover:not(.active) {
    color: var(--primary-blue);
    background-color: var(--light-blue);
}

.tab-content {
    display: none;
    padding: 1rem 0;
}

.request-card {
    background-color: var(--white);
    border: 1px solid var(--medium-gray);
    border-radius: 8px;
    padding: 1.5rem;
    margin-bottom: 1.5rem;
    transition: all 0.3s ease;
}

.request-card:hover {
    border-color: var(--primary-blue);
    box-shadow: 0 2px 10px rgba(52, 152, 219, 0.1);
}

.request-header {
    display: flex;
    align-items: center;
    margin-bottom: 1rem;
}

.request-photo {
    width: 60px;
    height: 60px;
    border-radius: 50%;
    object-fit: cover;
    margin-right: 1rem;
    border: 2px solid var(--light-blue);
}

.request-info h3 {
    margin: 0 0 0.5rem 0;
    color: var(--primary-blue);
}

.request-actions {
    display: flex;
    gap: 1rem;
    margin-top: 1rem;
}

button, .message-btn {
    padding: 0.5rem 1rem;
    border: none;
    border-radius: 4px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s ease;
}

.accept-btn {
    background-color: var(--success-green);
    color: white;
}

.accept-btn:hover {
    background-color: #219653;
}

.reject-btn, .cancel-btn {
    background-color: var(--error-red);
    color: white;
}

.reject-btn:hover, .cancel-btn:hover {
    background-color: #c0392b;
}

.message-btn {
    background-color: var(--primary-blue);
    color: white;
    text-decoration: none;
    display: inline-block;
}

.message-btn:hover {
    background-color: var(--dark-blue);
}

.status-pending {
    color: #f39c12;
    font-weight: 500;
}

.status-accepted {
    color: var(--success-green);
    font-weight: 500;
}

.status-rejected, .status-cancelled {
    color: var(--error-red);
    font-weight: 500;
}

/* Messaging Styles */
.messaging-container {
    display: flex;
    flex-direction: column;
    height: 60vh;
    border: 1px solid var(--medium-gray);
    border-radius: 8px;
    overflow: hidden;
    margin-top: 1.5rem;
}

.message-header {
    padding: 1rem;
    background-color: var(--light-blue);
    border-bottom: 1px solid var(--medium-gray);
    display: flex;
    align-items: center;
}

.message-header img {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    margin-right: 1rem;
    border: 2px solid var(--white);
}

.messages-area {
    flex: 1;
    padding: 1rem;
    overflow-y: auto;
    background-color: var(--white);
    display: flex;
    flex-direction: column;
}

.message {
    margin-bottom: 1rem;
    max-width: 70%;
    padding: 0.75rem 1rem;
    border-radius: 18px;
    position: relative;
}

.received-message {
    background-color: var(--white);
    border: 1px solid var(--medium-gray);
    align-self: flex-start;
    margin-right: auto;
}

.sent-message {
    background-color: var(--light-blue);
    align-self: flex-end;
    margin-left: auto;
}

.message-time {
    font-size: 0.75rem;
    color: #7f8c8d;
    margin-top: 0.25rem;
    text-align: right;
}

.message-input-area {
    padding: 1rem;
    background-color: var(--light-blue);
    border-top: 1px solid var(--medium-gray);
    display: flex;
}

.message-input {
    flex: 1;
    padding: 0.75rem 1rem;
    border: 1px solid var(--medium-gray);
    border-radius: 20px;
    outline: none;
    font-size: 1rem;
}

.send-button {
    margin-left: 1rem;
    padding: 0.75rem 1.5rem;
    background-color: var(--primary-blue);
    color: white;
    border: none;
    border-radius: 20px;
    cursor: pointer;
    transition: background-color 0.3s ease;
}

.send-button:hover {
    background-color: var(--dark-blue);
}

.back-button {
    margin-bottom: 1rem;
    padding: 0.5rem 1rem;
    background-color: var(--light-blue);
    color: var(--primary-blue);
    border: 1px solid var(--primary-blue);
    border-radius: 4px;
    cursor: pointer;
    transition: all 0.3s ease;
}

.back-button:hover {
    background-color: var(--primary-blue);
    color: white;
}

/* Responsive Design */
@media (max-width: 768px) {
    .requests-container {
        padding: 1rem;
    }
    
    .request-header {
        flex-direction: column;
        align-items: flex-start;
    }
    
    .request-photo {
        margin-bottom: 1rem;
    }
    
    .message {
        max-width: 85%;
    }
}
    </style>
</head>
<body>
    <header>
        <div class="logo">Skill Swap</div>
        <nav>
            <ul>
                <li><a href="home.jsp">Home</a></li>
                <li><a href="profile.jsp">Profile</a></li>
                <li><a href="requests.jsp">Requests</a></li>
                <li><a href="LogoutServlet">Logout</a></li>
            </ul>
            
        </nav>
    </header>
    
    <% if (activeRequest == null) { %>
    <div class="requests-container">
        <h1>My Requests</h1>
        
        <div class="tabs">
            <button class="tab-button active" onclick="openTab(event, 'received')">Received</button>
            <button class="tab-button" onclick="openTab(event, 'sent')">Sent</button>
        </div>
        
        <div id="received" class="tab-content" style="display: block;">
            <h2>Received Requests</h2>
            <%
                List<SwapRequest> receivedRequests = swapRequestDao.getReceivedRequests(currentUser.getUserId());
                
                if (receivedRequests != null && !receivedRequests.isEmpty()) {
                    for (SwapRequest receivedRequest : receivedRequests) {
                        if (receivedRequest != null) {
                            User requester = userDao.getUserById(receivedRequest.getRequesterId());
                            Skill offeredSkill = receivedRequest.getOfferedSkillId() > 0 ? skillDao.getSkillById(receivedRequest.getOfferedSkillId()) : null;
                            Skill wantedSkill = receivedRequest.getWantedSkillId() > 0 ? skillDao.getSkillById(receivedRequest.getWantedSkillId()) : null;
                            
                            if (requester != null && offeredSkill != null && wantedSkill != null) {
            %>
            <div class="request-card">
                <div class="request-header">
                    <img src="DisplayImageServlet?userId=<%= requester.getUserId() %>" alt="Profile Photo" class="request-photo">
                    <div class="request-info">
                        <h3><%= requester.getName() %></h3>
                        <p>Wants to swap: <strong><%= offeredSkill.getSkillName() %></strong> for <strong><%= wantedSkill.getSkillName() %></strong></p>
                        <p><%= receivedRequest.getMessage() != null ? receivedRequest.getMessage() : "" %></p>
                        <p>Status: <span class="status-<%= receivedRequest.getStatus().toLowerCase() %>"><%= receivedRequest.getStatus() %></span></p>
                    </div>
                </div>
                <div class="request-actions">
                    <% if ("pending".equalsIgnoreCase(receivedRequest.getStatus())) { %>
                    <form action="HandleRequestServlet" method="post" style="display: inline;">
                        <input type="hidden" name="request-id" value="<%= receivedRequest.getRequestId() %>">
                        <input type="hidden" name="action" value="accept">
                        <button type="submit" class="accept-btn">Accept</button>
                    </form>
                    <form action="HandleRequestServlet" method="post" style="display: inline;">
                        <input type="hidden" name="request-id" value="<%= receivedRequest.getRequestId() %>">
                        <input type="hidden" name="action" value="reject">
                        <button type="submit" class="reject-btn">Reject</button>
                    </form>
                    <% } else if ("accepted".equalsIgnoreCase(receivedRequest.getStatus())) { %>
                    <a href="requests.jsp?viewMessages=<%= receivedRequest.getRequestId() %>" class="message-btn">Message</a>
                    <% } %>
                </div>
            </div>
            <%
                            }
                        }
                    }
                } else {
            %>
            <p>No received requests.</p>
            <%
                }
            %>
        </div>
        
        <div id="sent" class="tab-content" style="display: none;">
            <h2>Sent Requests</h2>
            <%
                List<SwapRequest> sentRequests = swapRequestDao.getSentRequests(currentUser.getUserId());
                
                if (sentRequests != null && !sentRequests.isEmpty()) {
                    for (SwapRequest sentRequest : sentRequests) {
                        if (sentRequest != null) {
                            User receiver = userDao.getUserById(sentRequest.getReceiverId());
                            Skill offeredSkill = sentRequest.getOfferedSkillId() > 0 ? skillDao.getSkillById(sentRequest.getOfferedSkillId()) : null;
                            Skill wantedSkill = sentRequest.getWantedSkillId() > 0 ? skillDao.getSkillById(sentRequest.getWantedSkillId()) : null;
                            
                            if (receiver != null && offeredSkill != null && wantedSkill != null) {
            %>
            <div class="request-card">
                <div class="request-header">
                    <img src="DisplayImageServlet?userId=<%= receiver.getUserId() %>" alt="Profile Photo" class="request-photo">
                    <div class="request-info">
                        <h3><%= receiver.getName() %></h3>
                        <p>You offered: <strong><%= offeredSkill.getSkillName() %></strong> for <strong><%= wantedSkill.getSkillName() %></strong></p>
                        <p>Status: <span class="status-<%= sentRequest.getStatus().toLowerCase() %>"><%= sentRequest.getStatus() %></span></p>
                        <p><%= sentRequest.getMessage() != null ? sentRequest.getMessage() : "" %></p>
                    </div>
                </div>
                <%
                    if ("pending".equalsIgnoreCase(sentRequest.getStatus())) {
                %>
                <div class="request-actions">
                    <form action="CancelRequestServlet" method="post" style="display: inline;">
                        <input type="hidden" name="request-id" value="<%= sentRequest.getRequestId() %>">
                        <button type="submit" class="cancel-btn">Cancel</button>
                    </form>
                </div>
                <%
                    } else if ("accepted".equalsIgnoreCase(sentRequest.getStatus())) {
                %>
                <div class="request-actions">
                    <a href="requests.jsp?viewMessages=<%= sentRequest.getRequestId() %>" class="message-btn">Message</a>
                </div>
                <%
                    }
                %>
            </div>
            <%
                            }
                        }
                    }
                } else {
            %>
            <p>No sent requests.</p>
            <%
                }
            %>
        </div>
    </div>
    <% } else { %>
    <div class="requests-container">
        <button class="back-button" onclick="window.location.href='requests.jsp'">← Back to Requests</button>
        <h1>Messages with <%= otherUser.getName() %></h1>
        
        <div class="messaging-container">
            <div class="message-header">
                <img src="DisplayImageServlet?userId=<%= otherUser.getUserId() %>" alt="Profile Photo">
                <div>
                    <h3><%= otherUser.getName() %></h3>
                    <p>Swap: 
                        <strong><%= skillDao.getSkillById(activeRequest.getOfferedSkillId()).getSkillName() %></strong> 
                        for 
                        <strong><%= skillDao.getSkillById(activeRequest.getWantedSkillId()).getSkillName() %></strong>
                    </p>
                </div>
            </div>
            
            <div class="messages-area" id="messagesArea">
                <% if (messages != null && !messages.isEmpty()) { 
                    for (RequestMessage message : messages) { 
                        boolean isCurrentUser = message.getSenderId() == currentUser.getUserId();
                        User sender = userDao.getUserById(message.getSenderId());
                %>
                <div class="message <%= isCurrentUser ? "sent-message" : "received-message" %>">
                    <% if (!isCurrentUser) { %>
                    <div class="sender-name"><%= sender.getName() %></div>
                    <% } %>
                    <div class="message-text"><%= message.getMessage() %></div>
                    <div class="message-time">
                        <%= message.getCreatedAt().toString() %>
                        <% if (isCurrentUser) { %>
                        <span>✓✓</span>
                        <% } %>
                    </div>
                </div>
                <% } %>
                <% } else { %>
                <p>No messages yet. Start the conversation!</p>
                <% } %>
            </div>
           <!-- In the message form section, make sure the hidden input is properly closed -->
<form id="messageForm" class="message-input-area" onsubmit="sendMessage(event)">
    <input type="hidden" name="requestId" id="requestId" value="<%= activeRequest.getRequestId() %>">
    <input type="hidden" name="userId" id="userId" value="<%= currentUser.getUserId() %>">
    <input type="text" name="message" id="messageInput" class="message-input" placeholder="Type your message here..." required>
    <button type="submit" class="send-button">Send</button>
</form>

<script>
    // Scroll to bottom of messages
    window.onload = function() {
        var messagesArea = document.getElementById('messagesArea');
        messagesArea.scrollTop = messagesArea.scrollHeight;
    };
    
    // Auto-refresh messages every 3 seconds (changed from 5 for better responsiveness)
    setInterval(function() {
        if (window.location.href.includes("viewMessages")) {
            fetch(window.location.href)
                .then(response => response.text())
                .then(data => {
                    const parser = new DOMParser();
                    const doc = parser.parseFromString(data, 'text/html');
                    const newMessages = doc.getElementById('messagesArea').innerHTML;
                    document.getElementById('messagesArea').innerHTML = newMessages;
                    document.getElementById('messagesArea').scrollTop = document.getElementById('messagesArea').scrollHeight;
                })
                .catch(error => console.error('Error refreshing messages:', error));
        }
    }, 3000);
    
  // Handle form submission with AJAX - improved version
// Handle form submission with AJAX - improved version
document.getElementById('messageForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const requestId = document.getElementById('requestId').value;
    const message = document.getElementById('messageInput').value;
    
    // Create form data manually
    const formData = new URLSearchParams();
    formData.append('requestId', requestId);
    formData.append('message', message);
    
    fetch('SendMessageServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: formData
    })
    .then(response => {
        if (!response.ok) {
            return response.text().then(text => { throw new Error(text) });
        }
        return response.text();
    })
    .then(data => {
        document.getElementById('messageInput').value = '';
        // Manually trigger a refresh after sending
        return fetch(window.location.href);
    })
    .then(response => response.text())
    .then(data => {
        const parser = new DOMParser();
        const doc = parser.parseFromString(data, 'text/html');
        const newMessages = doc.getElementById('messagesArea').innerHTML;
        document.getElementById('messagesArea').innerHTML = newMessages;
        document.getElementById('messagesArea').scrollTop = document.getElementById('messagesArea').scrollHeight;
    })
    .catch(error => {
        console.error('Error sending message:', error);
        alert('Error: ' + error.message);
    });
});
</script>
    <% } %>
    
    <script>
        function openTab(evt, tabName) {
            // Hide all tab content
            const tabContents = document.getElementsByClassName("tab-content");
            for (let i = 0; i < tabContents.length; i++) {
                tabContents[i].style.display = "none";
            }
            
            // Remove active class from all tab buttons
            const tabButtons = document.getElementsByClassName("tab-button");
            for (let i = 0; i < tabButtons.length; i++) {
                tabButtons[i].classList.remove("active");
            }
            
            // Show the current tab and add active class to the button
            document.getElementById(tabName).style.display = "block";
            evt.currentTarget.classList.add("active");
        }
    </script>
</body>
</html>
<%
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("error.jsp");
    }
%>