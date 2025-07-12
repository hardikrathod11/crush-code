<%
    model.User currentUser = (model.User) session.getAttribute("user");
    if (currentUser != null && currentUser.isAdmin()) {
        response.sendRedirect("admin-panel.jsp");
        return;
    }
%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Login</title>
</head>
<body>
    <h2>Admin Login</h2>
    <form action="admin-login-process.jsp" method="post">
        Email: <input type="text" name="email" required><br><br>
        Password: <input type="password" name="password" required><br><br>
        <input type="submit" value="Login">
    </form>
    <% if (request.getParameter("error") != null) { %>
        <p style="color:red;"><%= request.getParameter("error") %></p>
    <% } %>
</body>
</html>
