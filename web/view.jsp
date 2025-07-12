<%@page import="model.User"%>
<%@page import="dao.UserDAO"%>
<%@page import="dao.UserSkillsDAO"%>
<%@page import="dao.SkillDAO"%>
<%@page import="dao.FeedbackDAO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Skill Swap - User Profile</title>
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
    
    <div class="profile-container">
        <%
            int userId = Integer.parseInt(request.getParameter("userId"));
            UserDAO userDao = new UserDAO();
            User user = userDao.getUserById(userId);
            
            if (user != null) {
        %>
        <div class="profile-header">
            <div class="profile-photo-container">
                <img src="DisplayImageServlet?userId=<%= user.getUserId() %>" alt="Profile Photo">
            </div>
            <div class="profile-info">
                <h1><%= user.getName() %></h1>
                <p><%= user.getLocation() != null ? user.getLocation() : "" %></p>
                <p>Availability: <%= user.getAvailability() != null ? user.getAvailability() : "Not specified" %></p>
                <%
                    FeedbackDAO feedbackDao = new FeedbackDAO();
                    double avgRating = feedbackDao.getAverageRating(user.getUserId());
                %>
                <div class="rating">Rating: <%= String.format("%.1f", avgRating) %>/5</div>
                <a href="send-request.jsp?userId=<%= user.getUserId() %>" class="request-btn">Send Swap Request</a>
            </div>
        </div>
        
        <div class="profile-details">
            <div class="skills-section">
                <h2>Skills Offered</h2>
                <div class="skills-container">
                    <%
                        UserSkillsDAO userSkillsDao = new UserSkillsDAO();
                        SkillDAO skillDao = new SkillDAO();
                        List<Integer> offeredSkills = userSkillsDao.getOfferedSkillsForUser(user.getUserId());
                        
                        for (Integer skillId : offeredSkills) {
                            Skill skill = skillDao.getSkillById(skillId);
                    %>
                    <div class="skill-tag"><%= skill.getSkillName() %></div>
                    <%
                        }
                    %>
                </div>
            </div>
            
            <div class="skills-section">
                <h2>Skills Wanted</h2>
                <div class="skills-container">
                    <%
                        List<Integer> wantedSkills = userSkillsDao.getWantedSkillsForUser(user.getUserId());
                        
                        for (Integer skillId : wantedSkills) {
                            Skill skill = skillDao.getSkillById(skillId);
                    %>
                    <div class="skill-tag"><%= skill.getSkillName() %></div>
                    <%
                        }
                    %>
                </div>
            </div>
            
            <div class="feedback-section">
                <h2>Feedback</h2>
                <%
                    List<Feedback> feedbacks = feedbackDao.getFeedbackForUser(user.getUserId());
                    
                    if (feedbacks.isEmpty()) {
                %>
                <p>No feedback yet.</p>
                <%
                    } else {
                        for (Feedback feedback : feedbacks) {
                            User feedbackUser = userDao.getUserById(feedback.getFromUserId());
                %>
                <div class="feedback-item">
                    <div class="feedback-header">
                        <span class="feedback-user"><%= feedbackUser.getName() %></span>
                        <span class="feedback-rating">Rating: <%= feedback.getRating() %>/5</span>
                    </div>
                    <div class="feedback-comment"><%= feedback.getComment() %></div>
                </div>
                <%
                        }
                    }
                %>
            </div>
        </div>
        <%
            } else {
        %>
        <div class="error-message">User not found.</div>
        <%
            }
        %>
    </div>
</body>
</html>