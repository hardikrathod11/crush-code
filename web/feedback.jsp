<%@page import="model.SwapRequest"%>
<%@page import="model.User"%>
<%@page import="dao.SwapRequestDAO"%>
<%@page import="dao.UserDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Skill Swap - Give Feedback</title>
    <style>
        <%@include file="css/styles.css"%>
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
    
    <div class="feedback-container">
        <h1>Give Feedback</h1>
        <%
            int requestId = Integer.parseInt(request.getParameter("requestId"));
            SwapRequestDAO swapRequestDao = new SwapRequestDAO();
            UserDAO userDao = new UserDAO();
            
            SwapRequest requestObj = swapRequestDao.getRequestById(requestId);
            User otherUser = null;
            
            if (requestObj != null) {
                User currentUser = (User)session.getAttribute("user");
                if (currentUser.getUserId() == requestObj.getRequesterId()) {
                    otherUser = userDao.getUserById(requestObj.getReceiverId());
                } else {
                    otherUser = userDao.getUserById(requestObj.getRequesterId());
                }
        %>
        <form action="SubmitFeedbackServlet" method="post">
            <input type="hidden" name="request-id" value="<%= requestObj.getRequestId() %>">
            <input type="hidden" name="to-user-id" value="<%= otherUser.getUserId() %>">
            
            <div class="form-group">
                <label>You are giving feedback to: <%= otherUser.getName() %></label>
            </div>
            
            <div class="form-group">
                <label for="rating">Rating (1-5):</label>
                <select id="rating" name="rating" required>
                    <option value="">Select a rating</option>
                    <option value="1">1 - Poor</option>
                    <option value="2">2 - Fair</option>
                    <option value="3">3 - Good</option>
                    <option value="4">4 - Very Good</option>
                    <option value="5">5 - Excellent</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="comment">Comment (optional):</label>
                <textarea id="comment" name="comment" rows="4"></textarea>
            </div>
            
            <div class="form-actions">
                <button type="submit">Submit Feedback</button>
                <button type="button" onclick="window.location.href='requests.jsp'">Cancel</button>
            </div>
        </form>
        <%
            } else {
        %>
        <div class="error-message">Request not found.</div>
        <%
            }
        %>
    </div>
</body>
</html>