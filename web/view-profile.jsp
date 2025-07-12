<%@page import="model.User"%>
<%@page import="model.Skill"%>
<%@page import="dao.UserDAO"%>
<%@page import="dao.UserSkillsDAO"%>
<%@page import="dao.SkillDAO"%>
<%@page import="dao.FeedbackDAO"%>
<%@page import="dao.SwapRequestDAO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User currentUser = (User)session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    int viewedUserId = Integer.parseInt(request.getParameter("userId"));
    UserDAO userDao = new UserDAO();
    UserSkillsDAO userSkillsDao = new UserSkillsDAO();
    SkillDAO skillDao = new SkillDAO();
    FeedbackDAO feedbackDao = new FeedbackDAO();
    SwapRequestDAO swapRequestDao = new SwapRequestDAO();
    
    User viewedUser = userDao.getUserById(viewedUserId);
    List<Integer> offeredSkillIds = userSkillsDao.getOfferedSkillsForUser(viewedUserId);
    List<Integer> wantedSkillIds = userSkillsDao.getWantedSkillsForUser(viewedUserId);
    double avgRating = feedbackDao.getAverageRating(viewedUserId);
    
    // Check if request already exists
    boolean requestExists = swapRequestDao.checkRequestExists(currentUser.getUserId(), viewedUserId);
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title><%= viewedUser.getName() %>'s Profile | Skill Swap</title>
    <style>
        <%@include file="css/styles.css"%>
        :root {
    /* Blue Color Palette */
    --primary-blue: #3498db;
    --dark-blue: #2980b9;
    --light-blue: #e6f2ff;
    --pale-blue: #f5f9fd;
    
    /* White/Gray Palette */
    --pure-white: #ffffff;
    --off-white: #f9f9f9;
    --light-gray: #e0e0e0;
    --medium-gray: #b0b0b0;
    --dark-gray: #333333;
    
    /* Accent Colors */
    --success-green: #2ecc71;
    --error-red: #e74c3c;
    --warning-yellow: #f39c12;
}

body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: var(--off-white);
    color: var(--dark-gray);
    line-height: 1.6;
    margin: 0;
    padding: 0;
}

/* Header Styles */
header {
    background-color: var(--pure-white);
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
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

nav {
    display: flex;
    align-items: center;
}

.user-nav-info {
    display: flex;
    align-items: center;
    margin-right: 2rem;
}

.nav-profile-img {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    object-fit: cover;
    border: 2px solid var(--primary-blue);
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
    display: flex;
    align-items: center;
    transition: all 0.3s ease;
    padding: 0.5rem 1rem;
    border-radius: 4px;
}

nav ul li a:hover {
    color: var(--primary-blue);
    background-color: var(--light-blue);
}

nav ul li a i {
    margin-right: 0.5rem;
    font-size: 1.1rem;
}

/* Main Profile Container */
.profile-view-container {
    max-width: 900px;
    margin: 2rem auto;
    padding: 2rem;
    background-color: var(--pure-white);
    border-radius: 8px;
    box-shadow: 0 2px 15px rgba(0, 0, 0, 0.05);
}

/* Profile Header Section */
.profile-header {
    display: flex;
    align-items: center;
    margin-bottom: 2rem;
    padding-bottom: 2rem;
    border-bottom: 1px solid var(--light-gray);
}

.profile-photo-large img {
    width: 150px;
    height: 150px;
    border-radius: 50%;
    object-fit: cover;
    border: 4px solid var(--primary-blue);
    margin-right: 2rem;
    box-shadow: 0 4px 10px rgba(52, 152, 219, 0.2);
}

.profile-info-large h1 {
    margin: 0 0 0.5rem 0;
    color: var(--dark-gray);
    font-size: 2rem;
}

.profile-info-large p {
    margin: 0.5rem 0;
    color: var(--medium-gray);
    font-size: 1.1rem;
    display: flex;
    align-items: center;
}

.profile-info-large p i {
    margin-right: 0.5rem;
    color: var(--primary-blue);
}

.rating-large {
    font-size: 1.2rem;
    color: var(--warning-yellow);
    margin-top: 1rem;
    display: flex;
    align-items: center;
}

.rating-large i {
    margin-right: 0.5rem;
}

/* Skills Section */
.skills-section {
    display: flex;
    gap: 2rem;
    margin-bottom: 2rem;
}

.skills-column {
    flex: 1;
    padding: 1.5rem;
    background-color: var(--pale-blue);
    border-radius: 8px;
    border: 1px solid var(--light-gray);
}

.skills-column h2 {
    color: var(--dark-gray);
    margin-top: 0;
    border-bottom: 1px solid var(--light-gray);
    padding-bottom: 0.5rem;
    display: flex;
    align-items: center;
}

.skills-column h2 i {
    margin-right: 0.5rem;
    color: var(--primary-blue);
}

.skills-list {
    list-style: none;
    padding: 0;
    margin: 1rem 0 0 0;
}

.skills-list li {
    padding: 0.75rem 0;
    border-bottom: 1px solid var(--light-gray);
    display: flex;
    justify-content: space-between;
    align-items: center;
    transition: background-color 0.3s ease;
}

.skills-list li:hover {
    background-color: var(--light-blue);
}

.skill-name {
    flex-grow: 1;
    color: var(--dark-gray);
}

.no-skills {
    color: var(--medium-gray);
    font-style: italic;
    padding: 1rem 0;
}

/* Request Buttons */
.request-section {
    text-align: center;
    margin-top: 2rem;
}

.request-btn-large {
    display: inline-block;
    padding: 1rem 2rem;
    background-color: var(--primary-blue);
    color: var(--pure-white);
    border-radius: 8px;
    text-decoration: none;
    font-size: 1.1rem;
    transition: all 0.3s ease;
    border: none;
    cursor: pointer;
    box-shadow: 0 2px 5px rgba(52, 152, 219, 0.3);
}

.request-btn-large:hover {
    background-color: var(--dark-blue);
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(52, 152, 219, 0.3);
}

.request-btn-large.disabled {
    background-color: var(--medium-gray);
    cursor: not-allowed;
    transform: none;
    box-shadow: none;
}

.request-btn-large i {
    margin-right: 0.5rem;
}

.skill-request-btn {
    background-color: var(--success-green);
    color: var(--pure-white);
    border: none;
    border-radius: 4px;
    padding: 0.5rem 1rem;
    cursor: pointer;
    font-size: 0.9rem;
    transition: all 0.3s ease;
    box-shadow: 0 1px 3px rgba(46, 204, 113, 0.3);
}

.skill-request-btn:hover {
    background-color: #27ae60;
    transform: translateY(-1px);
    box-shadow: 0 2px 5px rgba(46, 204, 113, 0.3);
}

/* Responsive Design */
@media (max-width: 768px) {
    .profile-header {
        flex-direction: column;
        text-align: center;
    }
    
    .profile-photo-large img {
        margin-right: 0;
        margin-bottom: 1.5rem;
    }
    
    .skills-section {
        flex-direction: column;
    }
    
    .profile-info-large {
        text-align: center;
    }
    
    .profile-info-large p {
        justify-content: center;
    }
    
    .rating-large {
        justify-content: center;
    }
    
    nav ul {
        flex-direction: column;
        align-items: flex-end;
    }
    
    nav ul li {
        margin: 0.5rem 0;
    }
}

/* Animation for interactive elements */
button, a {
    transition: all 0.3s ease;
}

/* Focus states for accessibility */
button:focus, a:focus, input:focus, select:focus {
    outline: 2px solid var(--primary-blue);
    outline-offset: 2px;
}
        
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <header>
        <div class="logo">Skill Swap</div>
        <nav>
         
            <ul>
                <li><a href="home.jsp"><i class="fas fa-home"></i> Home</a></li>
                <li><a href="profile.jsp"><i class="fas fa-user"></i> Profile</a></li>
                <li><a href="requests.jsp"><i class="fas fa-exchange-alt"></i> Requests</a></li>
                <li><a href="LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </nav>
           <div class="user-nav-info">
                <img src="DisplayImageServlet?userId=<%= currentUser.getUserId() %>" alt="Profile" class="nav-profile-img">
            </div>
    </header>
    
    <div class="profile-view-container">
        <div class="profile-header">
            <div class="profile-photo-large">
                <img src="DisplayImageServlet?userId=<%= viewedUser.getUserId() %>" alt="Profile Photo">
            </div>
            <div class="profile-info-large">
                <h1><%= viewedUser.getName() %></h1>
                <p><i class="fas fa-map-marker-alt"></i> <%= viewedUser.getLocation() != null ? viewedUser.getLocation() : "Location not specified" %></p>
                <p><i class="far fa-clock"></i> <%= viewedUser.getAvailability() != null ? viewedUser.getAvailability() : "Availability not specified" %></p>
                <div class="rating-large">
                    <i class="fas fa-star"></i> <%= String.format("%.1f", avgRating) %>/5
                </div>
            </div>
        </div>
        
        <div class="skills-section">
            <div class="skills-column">
                <h2><i class="fas fa-hand-holding-heart"></i> Skills Offered</h2>
                <% if (offeredSkillIds != null && !offeredSkillIds.isEmpty()) { %>
                    <ul class="skills-list">
                        <% for (Integer skillId : offeredSkillIds) { 
                            Skill skill = skillDao.getSkillById(skillId);
                        %>
                            <li>
                                <span class="skill-name"><%= skill.getSkillName() %></span>
                                <% if (!requestExists) { %>
                                    <button class="skill-request-btn" 
                                            onclick="prepareRequest(<%= skillId %>, 'offered')">
                                        Request This
                                    </button>
                                <% } %>
                            </li>
                        <% } %>
                    </ul>
                <% } else { %>
                    <p class="no-skills">No skills offered yet.</p>
                <% } %>
            </div>
            
            <div class="skills-column">
                <h2><i class="fas fa-search"></i> Skills Wanted</h2>
                <% if (wantedSkillIds != null && !wantedSkillIds.isEmpty()) { %>
                    <ul class="skills-list">
                        <% for (Integer skillId : wantedSkillIds) { 
                            Skill skill = skillDao.getSkillById(skillId);
                        %>
                            <li>
                                <span class="skill-name"><%= skill.getSkillName() %></span>
                                <% if (!requestExists) { %>
                                    <button class="skill-request-btn" 
                                            onclick="prepareRequest(<%= skillId %>, 'wanted')">
                                        Offer This
                                    </button>
                                <% } %>
                            </li>
                        <% } %>
                    </ul>
                <% } else { %>
                    <p class="no-skills">No skills wanted yet.</p>
                <% } %>
            </div>
        </div>
        
        <div class="request-section">
            <% if (requestExists) { %>
                <button class="request-btn-large disabled">
                    <i class="fas fa-check"></i> Request Already Sent
                </button>
            <% } else { %>
                <a href="send-request.jsp?userId=<%= viewedUser.getUserId() %>" class="request-btn-large" id="mainRequestBtn">
                    <i class="fas fa-exchange-alt"></i> Send Swap Request
                </a>
            <% } %>
        </div>
    </div>

    <script>
        // Store skills for use in request preparation
        const offeredSkills = [<%= offeredSkillIds != null ? String.join(",", offeredSkillIds.stream().map(String::valueOf).toArray(String[]::new)) : "" %>];
        const wantedSkills = [<%= wantedSkillIds != null ? String.join(",", wantedSkillIds.stream().map(String::valueOf).toArray(String[]::new)) : "" %>];
        
        let selectedOfferedSkill = null;
        let selectedWantedSkill = null;
        
        function prepareRequest(skillId, type) {
            if (type === 'offered') {
                selectedOfferedSkill = skillId;
                alert("You've selected to request: " + document.querySelector(`[onclick="prepareRequest(${skillId}, 'offered')"]`).parentElement.querySelector('.skill-name').textContent);
            } else {
                selectedWantedSkill = skillId;
                alert("You've selected to offer: " + document.querySelector(`[onclick="prepareRequest(${skillId}, 'wanted')"]`).parentElement.querySelector('.skill-name').textContent);
            }
            
            // Update the main request button if both skills are selected
            updateRequestButton();
        }
        
        function updateRequestButton() {
            const mainBtn = document.getElementById('mainRequestBtn');
            if (selectedOfferedSkill && selectedWantedSkill) {
                mainBtn.href = `send-request.jsp?userId=<%= viewedUser.getUserId() %>&offeredSkill=${selectedOfferedSkill}&wantedSkill=${selectedWantedSkill}`;
                mainBtn.innerHTML = `<i class="fas fa-exchange-alt"></i> Request Swap (Ready)`;
                mainBtn.style.backgroundColor = '#27ae60';
            } else {
                mainBtn.href = `send-request.jsp?userId=<%= viewedUser.getUserId() %>`;
                mainBtn.innerHTML = `<i class="fas fa-exchange-alt"></i> Send Swap Request`;
                mainBtn.style.backgroundColor = '#3498db';
            }
        }
    </script>
</body>
</html>