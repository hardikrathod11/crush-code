<%@ page import="java.util.*, dao.AdminSwapDAO, dao.UserDAO, dao.SkillDAO, model.SwapRequest, model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
   
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !currentUser.isAdmin()) {
        response.sendRedirect("admin-login.jsp");
        return;
    }

    String statusFilter = request.getParameter("status");
    if (statusFilter == null) {
        statusFilter = "pending";
    }

    AdminSwapDAO swapDao = new AdminSwapDAO();
    UserDAO userDao = new UserDAO();
    SkillDAO skillDao = new SkillDAO();
    List<SwapRequest> swaps = swapDao.getSwapsByStatus(statusFilter);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Panel - Swap Monitoring</title>
    <style>
        body { font-family: Arial; margin: 20px; background: #f8f9fa; }
        h1 { color: #333; }
        .tabs { margin-bottom: 20px; }
        .tabs a {
            padding: 10px 15px;
            background-color: #eee;
            margin-right: 5px;
            text-decoration: none;
            border-radius: 5px;
            color: #333;
        }
        .tabs a.active { background-color: #007bff; color: white; }
        table { width: 100%; border-collapse: collapse; background: white; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        th, td { padding: 12px; border: 1px solid #ccc; text-align: left; }
        th { background-color: #f1f1f1; }
    </style>
</head>
<body>
    <h1>Welcome Admin: <%= currentUser.getName() %></h1>

    <div class="tabs">
        <a href="admin-panel.jsp?status=pending" class="<%= statusFilter.equals("pending") ? "active" : "" %>">Pending</a>
        <a href="admin-panel.jsp?status=accepted" class="<%= statusFilter.equals("accepted") ? "active" : "" %>">Accepted</a>
        <a href="admin-panel.jsp?status=rejected" class="<%= statusFilter.equals("rejected") ? "active" : "" %>">Rejected</a>
        <a href="admin-panel.jsp?status=cancelled" class="<%= statusFilter.equals("cancelled") ? "active" : "" %>">Cancelled</a>
    </div>

    <h2>Showing <%= statusFilter.toUpperCase() %> Swaps</h2>
    <table>
        <tr>
            <th>#</th>
            <th>Requester</th>
            <th>Receiver</th>
            <th>Offered Skill</th>
            <th>Wanted Skill</th>
            <th>Message</th>
            <th>Date</th>
        </tr>
        <%
            int i = 1;
            for (SwapRequest s : swaps) {
                User requester = userDao.getUserById(s.getRequesterId());
                User receiver = userDao.getUserById(s.getReceiverId());
                String offeredSkill = skillDao.getSkillById(s.getOfferedSkillId()).getSkillName();
                String wantedSkill = skillDao.getSkillById(s.getWantedSkillId()).getSkillName();
        %>
        <tr>
            <td><%= i++ %></td>
            <td><%= requester.getName() %></td>
            <td><%= receiver.getName() %></td>
            <td><%= offeredSkill %></td>
            <td><%= wantedSkill %></td>
            <td><%= s.getMessage() != null ? s.getMessage() : "" %></td>
            <td><%= s.getCreatedAt() %></td>
        </tr>
        <% } %>
        <% if (swaps.size() == 0) { %>
        <tr><td colspan="7">No records found for <%= statusFilter %>.</td></tr>
        <% } %>
    </table>
</body>
</html>
