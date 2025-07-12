package controller;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import java.io.OutputStream;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class DisplayImageServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String userIdParam = request.getParameter("userId");
        if (userIdParam == null || userIdParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User ID is required");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdParam);
            UserDAO userDao = new UserDAO();
            User user = userDao.getUserById(userId);
            
            if (user == null || user.getProfilePhoto() == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User or profile photo not found");
                return;
            }
            
            byte[] imageData = user.getProfilePhoto();
            
            response.setContentType("image/jpeg");
            response.setContentLength(imageData.length);
            
            try (OutputStream out = response.getOutputStream()) {
                out.write(imageData);
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID format");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving image");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}