<%@ page import="java.sql.*, model.User" %>
<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/skill_swap", "root", ""); // Update DB credentials

        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, email);
        stmt.setString(2, password);
        rs = stmt.executeQuery();

        if (rs.next()) {
            boolean isAdmin = rs.getBoolean("is_admin");

            if (isAdmin) {
                // Save to session
                model.User admin = new model.User();
                admin.setUserId(rs.getInt("user_id"));
                admin.setEmail(rs.getString("email"));
                admin.setName(rs.getString("name"));
                admin.setAdmin(true);
                session.setAttribute("user", admin);
                
                response.sendRedirect("admin-panel.jsp");
            } else {
                response.sendRedirect("admin-login.jsp?error=Access denied. Not an admin.");
            }
        } else {
            response.sendRedirect("admin-login.jsp?error=Invalid credentials");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("admin-login.jsp?error=Error occurred");
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception ignored) {}
        try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
        try { if (conn != null) conn.close(); } catch (Exception ignored) {}
    }
%>
