<%@page import="model.Skill"%>
<%@page import="dao.SkillDAO"%>
<%@page import="dao.UserSkillsDAO"%>
<%@page import="model.User"%>
<%@page import="java.util.List"%>
<%@page import="dao.UserDAO"%>
<%@page import="dao.FeedbackDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Check for success/error messages
    String success = request.getParameter("success");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Skill Swap - My Profile</title>
    <style>
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
            --border-black: #000000;
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

        nav {
            display: flex;
            align-items: center;
            padding: 0.5rem;
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
            transition: color 0.3s ease;
            padding: 0.5rem 0;
        }

        nav ul li a:hover {
            color: var(--primary-blue);
        }

        nav ul li a i {
            margin-right: 0.5rem;
            font-size: 1.1rem;
        }

        .profile-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 2.5rem;
            background-color: var(--white);
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            border: 1px solid var(--border-black);
        }

        .profile-container h1 {
            color: var(--dark-gray);
            margin-bottom: 1.5rem;
            font-weight: 600;
            border-bottom: 2px solid var(--primary-blue);
            padding-bottom: 0.5rem;
            display: inline-block;
        }

        .profile-photo-container {
            text-align: center;
            margin-bottom: 2rem;
        }

        #profile-preview {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid var(--primary-blue);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .form-group {
            margin-bottom: 1.8rem;
            border: 1px solid var(--border-black);
            padding: 1rem;
            border-radius: 4px;
        }

        label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: var(--dark-gray);
        }

        input[type="text"],
        input[type="email"],
        input[type="password"],
        select {
            width: 100%;
            padding: 0.8rem;
            border: 1px solid var(--medium-gray);
            border-radius: 4px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
            border: 1px solid var(--border-black);
        }

        input[type="text"]:focus,
        input[type="email"]:focus,
        input[type="password"]:focus,
        select:focus {
            outline: none;
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2);
        }

        input[type="file"] {
            width: 100%;
            padding: 0.5rem;
            border: 1px dashed var(--medium-gray);
            border-radius: 4px;
            background-color: var(--light-gray);
            border: 1px solid var(--border-black);
        }

        input[type="checkbox"] {
            margin-right: 0.5rem;
        }

        .skills-container {
            display: flex;
            flex-wrap: wrap;
            gap: 0.8rem;
            margin-bottom: 1rem;
            padding: 1rem;
            background-color: var(--light-gray);
            border-radius: 4px;
            border: 1px solid var(--border-black);
        }

        .skill-tag {
            background-color: var(--primary-blue);
            color: var(--white);
            padding: 0.5rem 1rem;
            border-radius: 20px;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.9rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .remove-skill {
            color: var(--white);
            text-decoration: none;
            font-weight: bold;
            opacity: 0.8;
            transition: opacity 0.3s ease;
        }

        .remove-skill:hover {
            opacity: 1;
        }

        .add-skill {
            display: flex;
            gap: 0.8rem;
            margin-top: 0.5rem;
        }

        .add-skill select {
            flex-grow: 1;
        }

        .add-skill button {
            padding: 0 1.5rem;
            background-color: var(--primary-blue);
            color: var(--white);
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
            transition: background-color 0.3s ease;
            border: 1px solid var(--border-black);
        }

        .add-skill button:hover {
            background-color: var(--dark-blue);
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 1rem;
            margin-top: 2rem;
        }

        .form-actions button {
            padding: 0.8rem 1.8rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 500;
            transition: all 0.3s ease;
            border: 1px solid var(--border-black);
        }

        .form-actions button[type="submit"] {
            background-color: var(--primary-blue);
            color: var(--white);
        }

        .form-actions button[type="submit"]:hover {
            background-color: var(--dark-blue);
            transform: translateY(-2px);
        }

        .form-actions button[type="button"] {
            background-color: var(--medium-gray);
            color: var(--dark-gray);
        }

        .form-actions button[type="button"]:hover {
            background-color: #d0d0d0;
        }

        .message {
            padding: 1rem;
            margin-bottom: 1.5rem;
            border-radius: 4px;
            display: flex;
            align-items: center;
            font-weight: 500;
            border: 1px solid var(--border-black);
        }

        .success {
            background-color: rgba(39, 174, 96, 0.1);
            color: var(--success-green);
            border-left: 4px solid var(--success-green);
        }

        .error {
            background-color: rgba(231, 76, 60, 0.1);
            color: var(--error-red);
            border-left: 4px solid var(--error-red);
        }

        .message i {
            margin-right: 0.5rem;
            font-size: 1.2rem;
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
    </header>
    
    <div class="profile-container">
        <h1>My Profile</h1>
        
        <% if (success != null) { %>
            <div class="message success">
                <i class="fas fa-check-circle"></i> Profile updated successfully!
            </div>
        <% } %>
        
        <% if (error != null) { %>
            <div class="message error">
                <i class="fas fa-exclamation-circle"></i> <%= error %>
            </div>
        <% } %>
        
        <form action="UpdateProfileServlet" method="post" enctype="multipart/form-data">
            <div class="profile-photo-container">
                <img id="profile-preview" src="DisplayImageServlet?userId=<%= user.getUserId() %>" 
                     onerror="this.onerror=null; this.src='https://ui-avatars.com/api/?name=<%= user.getName() != null ? user.getName().replace(" ", "+") : "User" %>&size=150&background=3498db&color=fff'" 
                     alt="Profile Photo">
                <div style="margin-top: 1rem;">
                    <input type="file" id="profile-photo" name="profile-photo" accept="image/*" onchange="previewImage(this)">
                </div>
            </div>
            
            <div class="form-group">
                <label for="name">Name:</label>
                <input type="text" id="name" name="name" value="<%= user.getName() %>" required>
            </div>
            
            <div class="form-group">
                <label for="location">Location:</label>
                <input type="text" id="location" name="location" value="<%= user.getLocation() != null ? user.getLocation() : "" %>">
            </div>
            
            <div class="form-group">
                <label for="availability">Availability:</label>
                <select id="availability" name="availability">
                    <option value="">Select Availability</option>
                    <option value="weekends" <%= "weekends".equals(user.getAvailability()) ? "selected" : "" %>>Weekends</option>
                    <option value="evenings" <%= "evenings".equals(user.getAvailability()) ? "selected" : "" %>>Evenings</option>
                    <option value="weekdays" <%= "weekdays".equals(user.getAvailability()) ? "selected" : "" %>>Weekdays</option>
                    <option value="flexible" <%= "flexible".equals(user.getAvailability()) ? "selected" : "" %>>Flexible</option>
                </select>
            </div>
            
            <div class="form-group">
                <label>
                    <input type="checkbox" name="is-public" <%= user.isPublic() ? "checked" : "" %>> Make my profile public
                </label>
            </div>
            
            <div class="form-group">
                <label>Skills Offered:</label>
                <div class="skills-container" id="offered-skills-container">
                    <%
                        UserSkillsDAO userSkillsDao = new UserSkillsDAO();
                        SkillDAO skillDao = new SkillDAO();
                        List<Integer> offeredSkills = userSkillsDao.getOfferedSkillsForUser(user.getUserId());
                        
                        for (Integer skillId : offeredSkills) {
                            Skill skill = skillDao.getSkillById(skillId);
                            if (skill != null) {
                    %>
                    <div class="skill-tag">
                        <%= skill.getSkillName() %>
                        <a href="RemoveSkillServlet?type=offered&skillId=<%= skill.getSkillId() %>" class="remove-skill">×</a>
                    </div>
                    <%
                            }
                        }
                    %>
                </div>
                <div class="add-skill">
                    <select id="offered-skill" name="offered-skill">
                        <option value="">Add a skill you offer</option>
                        <%
                            List<Skill> allSkills = skillDao.getAllApprovedSkills();
                            for (Skill skill : allSkills) {
                                if (!offeredSkills.contains(skill.getSkillId())) {
                        %>
                        <option value="<%= skill.getSkillId() %>"><%= skill.getSkillName() %></option>
                        <%
                                }
                            }
                        %>
                    </select>
                    <button type="button" onclick="addSkill('offered')">Add</button>
                </div>
            </div>
            
            <div class="form-group">
                <label>Skills Wanted:</label>
                <div class="skills-container" id="wanted-skills-container">
                    <%
                        List<Integer> wantedSkills = userSkillsDao.getWantedSkillsForUser(user.getUserId());
                        
                        for (Integer skillId : wantedSkills) {
                            Skill skill = skillDao.getSkillById(skillId);
                            if (skill != null) {
                    %>
                    <div class="skill-tag">
                        <%= skill.getSkillName() %>
                        <a href="RemoveSkillServlet?type=wanted&skillId=<%= skill.getSkillId() %>" class="remove-skill">×</a>
                    </div>
                    <%
                            }
                        }
                    %>
                </div>
                <div class="add-skill">
                    <select id="wanted-skill" name="wanted-skill">
                        <option value="">Add a skill you want</option>
                        <%
                            for (Skill skill : allSkills) {
                                if (!wantedSkills.contains(skill.getSkillId())) {
                        %>
                        <option value="<%= skill.getSkillId() %>"><%= skill.getSkillName() %></option>
                        <%
                                }
                            }
                        %>
                    </select>
                    <button type="button" onclick="addSkill('wanted')">Add</button>
                </div>
            </div>
            
            <div class="form-actions">
                <button type="button" class="btn-cancel" onclick="window.location.href='home.jsp'">Cancel</button>
                <button type="submit" class="btn-save">Save Changes</button>
            </div>
        </form>
    </div>
    
    <script>
        function previewImage(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('profile-preview').src = e.target.result;
                }
                reader.readAsDataURL(input.files[0]);
            }
        }
        
        function addSkill(type) {
            const select = document.getElementById(type + '-skill');
            const skillId = select.value;
            
            if (skillId) {
                window.location.href = 'AddSkillServlet?type=' + type + '&skillId=' + skillId;
            } else {
                alert('Please select a skill first');
            }
        }
    </script>
</body>
</html>