<%@page import="dao.UserDAO"%>
<%@page import="model.Skill"%>
<%@page import="model.User"%>
<%@page import="dao.UserSkillsDAO"%>
<%@page import="dao.SkillDAO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Skill Swap - Send Request</title>
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

.nav-user-profile {
    display: flex;
    align-items: center;
    margin-right: 1rem;
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

/* Main Request Container */
.request-container {
    max-width: 800px;
    margin: 2rem auto;
    padding: 2rem;
    background-color: var(--pure-white);
    border-radius: 8px;
    box-shadow: 0 2px 15px rgba(0, 0, 0, 0.05);
}

.request-header {
    display: flex;
    align-items: center;
    margin-bottom: 2rem;
    padding-bottom: 2rem;
    border-bottom: 1px solid var(--light-gray);
}

.receiver-profile {
    display: flex;
    align-items: center;
}

.receiver-profile-img {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    object-fit: cover;
    border: 3px solid var(--primary-blue);
    margin-right: 1.5rem;
    box-shadow: 0 2px 10px rgba(52, 152, 219, 0.2);
}

.receiver-profile h2 {
    margin: 0;
    color: var(--dark-gray);
}

.request-container h1 {
    color: var(--dark-gray);
    margin-bottom: 2rem;
    text-align: center;
}

/* Form Styles */
form {
    display: flex;
    flex-direction: column;
    gap: 1.5rem;
}

.form-group {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
}

.form-group label {
    font-weight: 500;
    color: var(--dark-gray);
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.form-group label i {
    color: var(--primary-blue);
}

select, textarea {
    padding: 0.8rem 1rem;
    border: 1px solid var(--light-gray);
    border-radius: 6px;
    font-size: 1rem;
    background-color: var(--pure-white);
    transition: all 0.3s ease;
}

select:focus, textarea:focus {
    outline: none;
    border-color: var(--primary-blue);
    box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2);
}

textarea {
    min-height: 120px;
    resize: vertical;
}

/* Form Actions */
.form-actions {
    display: flex;
    justify-content: center;
    gap: 1rem;
    margin-top: 2rem;
}

.submit-btn, .cancel-btn {
    padding: 0.8rem 1.5rem;
    border: none;
    border-radius: 6px;
    font-size: 1rem;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.submit-btn {
    background-color: var(--primary-blue);
    color: var(--pure-white);
    box-shadow: 0 2px 5px rgba(52, 152, 219, 0.3);
}

.submit-btn:hover {
    background-color: var(--dark-blue);
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(52, 152, 219, 0.3);
}

.cancel-btn {
    background-color: var(--light-gray);
    color: var(--dark-gray);
}

.cancel-btn:hover {
    background-color: #d0d0d0;
}

/* Error Message */
.error-message {
    padding: 1rem;
    background-color: rgba(231, 76, 60, 0.1);
    color: var(--error-red);
    border-radius: 6px;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    margin: 2rem 0;
}

.error-message i {
    font-size: 1.2rem;
}

/* Responsive Design */
@media (max-width: 768px) {
    .request-container {
        padding: 1.5rem;
        margin: 1.5rem;
    }
    
    .receiver-profile {
        flex-direction: column;
        text-align: center;
    }
    
    .receiver-profile-img {
        margin-right: 0;
        margin-bottom: 1rem;
    }
    
    .form-actions {
        flex-direction: column;
    }
    
    nav ul {
        flex-direction: column;
        align-items: flex-end;
    }
    
    nav ul li {
        margin: 0.5rem 0;
    }
}

/* Focus states for accessibility */
button:focus, a:focus, select:focus, textarea:focus {
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
            <% User currentUser = (User)session.getAttribute("user"); %>
<!--            <div class="nav-user-profile">
                <% if (currentUser != null) { %>
                <img src="DisplayImageServlet?userId=<%= currentUser.getUserId() %>" alt="Profile" class="nav-profile-img">
                <% } %>
            </div>-->
            <ul>
                <li><a href="home.jsp"><i class="fas fa-home"></i> Home</a></li>
                <li><a href="profile.jsp"><i class="fas fa-user"></i> Profile</a></li>
                <li><a href="requests.jsp"><i class="fas fa-exchange-alt"></i> Requests</a></li>
                <li><a href="LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </nav>
    </header>
    
    <div class="request-container">
        <%
            int receiverId = Integer.parseInt(request.getParameter("userId"));
            UserDAO userDao = new UserDAO();
            User receiver = userDao.getUserById(receiverId);
            
            if (receiver != null) {
        %>
        <div class="request-header">
            <div class="receiver-profile">
                <img src="DisplayImageServlet?userId=<%= receiver.getUserId() %>" alt="Profile" class="receiver-profile-img">
                <h2><%= receiver.getName() %></h2>
            </div>
        </div>
        
        <h1>Send Swap Request</h1>
        <form action="SendRequestServlet" method="post">
            <input type="hidden" name="receiver-id" value="<%= receiver.getUserId() %>">
            
            <div class="form-group">
                <label for="offered-skill"><i class="fas fa-hand-holding-heart"></i> Choose one of your offered skills:</label>
                <select id="offered-skill" name="offered-skill" required>
                    <option value="">Select a skill you offer</option>
                    <%
                        UserSkillsDAO userSkillsDao = new UserSkillsDAO();
                        SkillDAO skillDao = new SkillDAO();
                        List<Integer> offeredSkills = userSkillsDao.getOfferedSkillsForUser(currentUser.getUserId());
                        
                        for (Integer skillId : offeredSkills) {
                            Skill skill = skillDao.getSkillById(skillId);
                    %>
                    <option value="<%= skill.getSkillId() %>"><%= skill.getSkillName() %></option>
                    <%
                        }
                    %>
                </select>
            </div>
            
            <div class="form-group">
                <label for="wanted-skill"><i class="fas fa-search"></i> Choose one of their wanted skills:</label>
                <select id="wanted-skill" name="wanted-skill" required>
                    <option value="">Select a skill they want</option>
                    <%
                        List<Integer> wantedSkills = userSkillsDao.getWantedSkillsForUser(receiver.getUserId());
                        
                        for (Integer skillId : wantedSkills) {
                            Skill skill = skillDao.getSkillById(skillId);
                    %>
                    <option value="<%= skill.getSkillId() %>"><%= skill.getSkillName() %></option>
                    <%
                        }
                    %>
                </select>
            </div>
            
            <div class="form-group">
                <label for="message"><i class="fas fa-comment"></i> Message (optional):</label>
                <textarea id="message" name="message" rows="4" placeholder="Add a personal message to <%= receiver.getName() %>..."></textarea>
            </div>
            
            <div class="form-actions">
                <button type="submit" class="submit-btn"><i class="fas fa-paper-plane"></i> Send Request</button>
                <button type="button" class="cancel-btn" onclick="window.history.back()"><i class="fas fa-times"></i> Cancel</button>
            </div>
        </form>
        <%
            } else {
        %>
        <div class="error-message">
            <i class="fas fa-exclamation-circle"></i> User not found.
        </div>
        <%
            }
        %>
    </div>
</body>
</html>