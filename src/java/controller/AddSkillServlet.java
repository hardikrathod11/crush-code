package controller;

import dao.UserSkillsDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;

public class AddSkillServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String type = request.getParameter("type");
        String skillIdParam = request.getParameter("skillId");
        
        if (type == null || skillIdParam == null) {
            response.sendRedirect("profile.jsp?error=Invalid parameters");
            return;
        }
        
        try {
            int skillId = Integer.parseInt(skillIdParam);
            UserSkillsDAO userSkillsDao = new UserSkillsDAO();
            boolean success = false;
            
            if ("offered".equals(type)) {
                success = userSkillsDao.addOfferedSkill(user.getUserId(), skillId);
            } else if ("wanted".equals(type)) {
                success = userSkillsDao.addWantedSkill(user.getUserId(), skillId);
            }
            
            if (success) {
                response.sendRedirect("profile.jsp");
            } else {
                response.sendRedirect("profile.jsp?error=Failed to add skill");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("profile.jsp?error=Invalid skill ID");
        } catch (Exception e) {
            response.sendRedirect("profile.jsp?error=" + e.getMessage());
        }
    }
}