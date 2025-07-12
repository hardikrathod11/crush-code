<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.skillswap.model.*, com.skillswap.dao.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Swaps</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <jsp:include page="admin_header.jsp" />

    <div class="container">
        <h2>Swap Requests</h2>
        
        <div class="filter-options">
            <form action="AdminServlet" method="get">
                <input type="hidden" name="action" value="filterSwaps">
                <select name="status">
                    <option value="all">All Statuses</option>
                    <option value="pending">Pending</option>
                    <option value="accepted">Accepted</option>
                    <option value="rejected">Rejected</option>
                    <option value="cancelled">Cancelled</option>
                </select>
                <button type="submit">Filter</button>
            </form>
        </div>
        
        <table>
            <tr>
                <th>ID</th>
                <th>Requester</th>
                <th>Receiver</th>
                <th>Offered Skill</th>
                <th>Wanted Skill</th>
                <th>Status</th>
                <th>Date</th>
                <th>Actions</th>
            </tr>
            <% List<SwapRequest> swaps = (List<SwapRequest>) request.getAttribute("swaps");
               for(SwapRequest swap : swaps) { %>
            <tr>
                <td><%= swap.getRequestId() %></td>
                <td><%= swap.getRequester().getName() %></td>
                <td><%= swap.getReceiver().getName() %></td>
                <td><%= swap.getOfferedSkill().getSkillName() %></td>
                <td><%= swap.getWantedSkill().getSkillName() %></td>
                <td><%= swap.getStatus() %></td>
                <td><%= swap.getCreatedAt() %></td>
                <td>
                    <a href="AdminServlet?action=viewSwapDetails&id=<%= swap.getRequestId() %>" class="btn-view">View</a>
                </td>
            </tr>
            <% } %>
        </table>
    </div>
</body>
</html>