<%@page import="model.User"%>
<%@page import="model.Skill"%>
<%@page import="java.util.List"%>
<%@page import="dao.UserDAO"%>
<%@page import="dao.FeedbackDAO"%>
<%@page import="dao.SwapRequestDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User currentUser = (User)session.getAttribute("user");
    int currentPage = request.getParameter("page") != null 
            ? Integer.parseInt(request.getParameter("page")) : 1;
    int recordsPerPage = 3;
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Skill Swap - Home</title>
    <style>
        <%@include file="css/styles.css"%>
        
        /* Modern Color Scheme */
        :root {
            --primary-color: #4361ee;
            --secondary-color: #3f37c9;
            --accent-color: #4895ef;
            --light-color: #f8f9fa;
            --dark-color: #212529;
            --success-color: #4cc9f0;
            --warning-color: #f72585;
            --card-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f7fb;
            color: var(--dark-color);
            line-height: 1.6;
        }
        
        /* Modern Header/Navigation */
        header {
            background-color: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
            padding: 0 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 70px;
            position: sticky;
            top: 0;
            z-index: 100;
            border-bottom: 2px solid var(--primary-color); /* Added border color */
        }
        
        .logo {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
            display: flex;
            align-items: center;
        }
        
        .logo i {
            margin-right: 10px;
            color: var(--accent-color);
        }
        
        nav {
            display: flex;
            align-items: center;
            height: 100%;
        }
        
        .nav-container {
            display: flex;
            height: 100%;
            align-items: center;
        }
        
        .nav-menu {
            display: flex;
            list-style: none;
            margin: 0;
            padding: 0;
            height: 100%;
        }
        
        .nav-menu li {
            display: flex;
            align-items: center;
            height: 100%;
            position: relative;
        }
        
        .nav-menu li a {
            text-decoration: none;
            color: var(--dark-color);
            font-weight: 500;
            display: flex;
            align-items: center;
            padding: 0 15px;
            height: 100%;
            transition: var(--transition);
        }
        
        .nav-menu li a:hover {
            color: var(--primary-color);
            background-color: rgba(67, 97, 238, 0.05);
        }
        
        .nav-menu li a i {
            margin-right: 8px;
            font-size: 1.1rem;
        }
        
        .user-profile {
            display: flex;
            align-items: center;
            margin-left: 30px;
            cursor: pointer;
            position: relative;
        }
        
        .profile-img {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid var(--light-color);
            box-shadow: var(--card-shadow);
            transition: var(--transition);
        }
        
        .profile-img:hover {
            transform: scale(1.05);
            border-color: var(--accent-color);
        }
        
        /* Search and Filter Section */
        .search-section {
            background-color: white;
            padding: 25px 5%;
            margin-bottom: 30px;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.05);
        }
        
        .search-container {
            display: flex;
            max-width: 1200px;
            margin: 0 auto;
            gap: 20px;
        }
        
        .search-box {
            flex: 1;
            position: relative;
        }
        
        .search-box input {
            width: 100%;
            /*padding: 12px 20px;*/
            padding-left: 0px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            font-size: 0.95rem;
            transition: var(--transition);
            background-color: #f8f9fa;
        }
        
        .search-box input:focus {
            outline: none;
            border-color: var(--accent-color);
            box-shadow: 0 0 0 3px rgba(72, 149, 239, 0.2);
            background-color: white;
        }
        
        .search-box i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }
        
        .filter-box {
            width: 250px;
        }
        
        .filter-box select {
            width: 100%;
            padding: 12px 20px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            font-size: 0.95rem;
            background-color: #f8f9fa;
            cursor: pointer;
            transition: var(--transition);
        }
        
        .filter-box select:focus {
            outline: none;
            border-color: var(--accent-color);
            box-shadow: 0 0 0 3px rgba(72, 149, 239, 0.2);
            background-color: white;
        }
        
        /* User Profiles Section */
        .main-content {
            padding: 0 5%;
            max-width: 1400px;
            margin: 0 auto;
        }
        
        .section-title {
            font-size: 1.5rem;
            color: var(--dark-color);
            margin-bottom: 20px;
            font-weight: 600;
            display: flex;
            align-items: center;
        }
        
        .section-title i {
            margin-right: 10px;
            color: var(--accent-color);
        }
        
        .profiles-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        
         .profile-card {
            background-color: white;
            border-radius: 10px;
            box-shadow: var(--card-shadow);
            overflow: hidden;
            transition: var(--transition);
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 20px;
        }
        
        .profile-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }
        
        .profile-avatar-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-bottom: 15px;
            width: 100%;
        }
        
        .profile-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid white;
            box-shadow: var(--card-shadow);
            margin-bottom: 10px;
        }
        
        .profile-info {
            text-align: center;
            width: 100%;
        }
        
        .profile-info h3 {
            margin: 0 0 5px 0;
            color: var(--dark-color);
            font-weight: 600;
            font-size: 1.2rem;
        }
        
        .rating {
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
            color: var(--dark-color);
            margin-bottom: 15px;
        }
        
        .rating i {
            color: #ffc107;
            margin-right: 5px;
        }
        
        .profile-details {
            width: 100%;
            padding: 0;
        }
        
        .skills-section {
            margin-bottom: 15px;
        }
        
        .skills-title {
            font-size: 0.9rem;
            text-transform: uppercase;
            color: #6c757d;
            margin-bottom: 10px;
            font-weight: 600;
            letter-spacing: 0.5px;
            display: flex;
            align-items: center;
        }
        
        .skills-title i {
            margin-right: 8px;
            color: var(--accent-color);
        }
        
        .skills-list {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            justify-content: center;
        }
        
        .skill-tag {
            background-color: #e9ecef;
            color: var(--dark-color);
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
        }
        
        .skill-tag.offered {
            background-color: #d1e7dd;
            color: #0f5132;
        }
        
        .skill-tag.wanted {
            background-color: #fff3cd;
            color: #664d03;
        }
        
        .profile-actions {
            display: flex;
            justify-content: center;
            margin-top: 20px;
            width: 100%;
        }
        
        .action-btn {
            padding: 8px 16px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 0.85rem;
            font-weight: 500;
            transition: var(--transition);
            display: flex;
            align-items: center;
        }
        
        .request-btn {
            background-color: var(--primary-color);
            color: white;
            border: 1px solid var(--primary-color);
        }
        
        .request-btn:hover {
            background-color: var(--secondary-color);
        }
        
        .request-sent {
            background-color: #198754;
            color: white;
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 500;
            display: flex;
            align-items: center;
        }
        
        .request-sent i {
            margin-right: 5px;
        }
        
        /* Pagination */
        .pagination {
            display: flex;
            justify-content: center;
            padding: 30px 0;
        }
        
        .pagination a {
            color: var(--dark-color);
            padding: 8px 16px;
            text-decoration: none;
            border: 1px solid #dee2e6;
            margin: 0 4px;
            border-radius: 6px;
            transition: var(--transition);
            font-weight: 500;
        }
        
        .pagination a.active {
            background-color: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
        }
        
        .pagination a:hover:not(.active) {
            background-color: #f8f9fa;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .search-container {
                flex-direction: column;
            }
            
            .filter-box {
                width: 100%;
            }
            
            .profiles-grid {
                grid-template-columns: 1fr;
            }
            
            .nav-menu {
                display: none;
            }
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <header>
        <div class="logo">
            <i class="fas fa-exchange-alt"></i>
            SkillSwap
        </div>
        
        <div class="nav-container">
            <ul class="nav-menu">
                <li><a href="home.jsp"><i class="fas fa-home"></i> Home</a></li>
                <li><a href="profile.jsp"><i class="fas fa-user"></i> Profile</a></li>
                <li><a href="requests.jsp"><i class="fas fa-handshake"></i> Requests</a></li>
                   <li><a href="LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                <% if (currentUser != null && currentUser.isAdmin()) { %>
                    <li><a href="admin-dashboard.jsp"><i class="fas fa-cog"></i> Admin</a></li>
                <% } %>
            </ul>
            
            <div class="user-profile">
                <% if (currentUser != null) { %>
                    <img src="DisplayImageServlet?userId=<%= currentUser.getUserId() %>" alt="Profile" class="profile-img"
                         onerror="this.onerror=null; this.src='https://ui-avatars.com/api/?name=<%= currentUser.getName() != null ? currentUser.getName().replace(" ", "+") : "User" %>&size=128&background=4361ee&color=fff'">
                <% } else { %>
                    <a href="login.jsp" class="action-btn request-btn">
                        <i class="fas fa-sign-in-alt"></i> Login
                    </a>
                <% } %>
            </div>
        </div>
    </header>
    
    <div class="search-section">
        <div class="search-container">
            <div class="search-box">
                <!--<i class="fas fa-search"></i>-->
                <input type="text" placeholder="Search for skills or users...">
            </div>
            <div class="filter-box">
                <select>
                    <option value="">Filter by Skill</option>
                    <option value="design">Design</option>
                    <option value="development">Development</option>
                    <option value="language">Language</option>
                    <option value="business">Business</option>
                </select>
            </div>
        </div>
    </div>
    
    <div class="main-content">
        
       <div class="main-content">
        <h2 class="section-title">
            <i class="fas fa-users"></i>
            Available Skill Partners
        </h2>
              
        <div class="profiles-grid">
            <%
                UserDAO userDao = new UserDAO();
                FeedbackDAO feedbackDao = new FeedbackDAO();
                SwapRequestDAO swapRequestDao = new SwapRequestDAO();
                
                List<User> allUsers = userDao.getAllPublicUsers();
                
                // Calculate pagination
                int start = (currentPage - 1) * recordsPerPage;
                int end = Math.min(start + recordsPerPage, allUsers.size());
                int totalPages = (int) Math.ceil(allUsers.size() * 1.0 / recordsPerPage);
                
                for (int i = start; i < end; i++) {
                    User user = allUsers.get(i);
                    if (currentUser != null && user.getUserId() == currentUser.getUserId()) {
                        continue;
                    }
                    
                    double avgRating = feedbackDao.getAverageRating(user.getUserId());
                    
                    // Get offered and wanted skills for this user
                    List<String> offeredSkills = userDao.getOfferedSkillNames(user.getUserId());
                    List<String> wantedSkills = userDao.getWantedSkillNames(user.getUserId());
            %>
            <div class="profile-card">
                <div class="profile-avatar-container">
                    <img src="DisplayImageServlet?userId=<%= user.getUserId() %>" alt="<%= user.getName() %>" class="profile-avatar"
                         onerror="this.onerror=null; this.src='https://ui-avatars.com/api/?name=<%= user.getName() != null ? user.getName().replace(" ", "+") : "User" %>&size=128&background=4361ee&color=fff'">
                    <div class="profile-info">
                        <h3><%= user.getName() %></h3>
                        <div class="rating">
                            <i class="fas fa-star"></i>
                            <%= String.format("%.1f", avgRating) %>/5.0
                        </div>
                    </div>
                </div>
                
                <div class="profile-details">
                    <div class="skills-section">
                        <div class="skills-title">
                            <i class="fas fa-hand-holding-heart"></i>
                            Skills Offered
                        </div>
                        <div class="skills-list">
                            <% for (String skill : offeredSkills) { %>
                                <span class="skill-tag offered"><%= skill %></span>
                            <% } %>
                            <% if (offeredSkills.isEmpty()) { %>
                                <span class="skill-tag">No skills offered</span>
                            <% } %>
                        </div>
                    </div>
                    
                    <div class="skills-section">
                        <div class="skills-title">
                            <i class="fas fa-search"></i>
                            Skills Wanted
                        </div>
                        <div class="skills-list">
                            <% for (String skill : wantedSkills) { %>
                                <span class="skill-tag wanted"><%= skill %></span>
                            <% } %>
                            <% if (wantedSkills.isEmpty()) { %>
                                <span class="skill-tag">No skills wanted</span>
                            <% } %>
                        </div>
                    </div>
                    
                    <div class="profile-actions">
                        <% if (currentUser != null) { 
                            boolean requestExists = swapRequestDao.checkRequestExists(currentUser.getUserId(), user.getUserId());
                        %>
                            <% if (!requestExists) { %>
                                <a href="view-profile.jsp?userId=<%= user.getUserId() %>" class="action-btn request-btn">
                                    <i class="fas fa-handshake"></i> Connect
                                </a>
                            <% } else { %>
                                <span class="request-sent">
                                    <i class="fas fa-check"></i> Request Sent
                                </span>
                            <% } %>
                        <% } else { %>
                            <a href="login.jsp" class="action-btn request-btn">
                                <i class="fas fa-sign-in-alt"></i> Login to Connect
                            </a>
                        <% } %>
                    </div>
                </div>
            </div>
            <%
                }
            %>
        </div>
        
        
        <div class="pagination">
            <% if (currentPage > 1) { %>
                <a href="home.jsp?page=<%= currentPage - 1 %>"><i class="fas fa-chevron-left"></i></a>
            <% } %>
            
            <% for (int i = 1; i <= totalPages; i++) { %>
                <a href="home.jsp?page=<%= i %>" class="<%= i == currentPage ? "active" : "" %>"><%= i %></a>
            <% } %>
            
            <% if (currentPage < totalPages) { %>
                <a href="home.jsp?page=<%= currentPage + 1 %>"><i class="fas fa-chevron-right"></i></a>
            <% } %>
        </div>
    </div>
</body>
</html>