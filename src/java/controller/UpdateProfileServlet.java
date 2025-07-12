package controller;

import model.User;
import dao.UserDAO;
import java.io.IOException;
import java.io.InputStream;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,     // 1MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class UpdateProfileServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            // Get form parameters
            String name = request.getParameter("name");
            String location = request.getParameter("location");
            String availability = request.getParameter("availability");
            boolean isPublic = request.getParameter("is-public") != null;

            // Update user object
            user.setName(name);
            user.setLocation(location);
            user.setAvailability(availability);
            user.setPublic(isPublic);
            
            // Process profile photo upload if exists
            Part filePart = request.getPart("profile-photo");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = filePart.getSubmittedFileName();
                String fileType = filePart.getContentType();
                
                // Validate image file type
                if (fileType.startsWith("image/")) {
                    try (InputStream fileContent = filePart.getInputStream()) {
                        byte[] photoBytes = fileContent.readAllBytes();
                        user.setProfilePhoto(photoBytes);
                    }
                } else {
                    request.setAttribute("error", "Only image files are allowed");
                    request.getRequestDispatcher("profile.jsp").forward(request, response);
                    return;
                }
            }
            
            // Update user in database
            UserDAO userDao = new UserDAO();
            boolean success = userDao.updateUser(user);
            
            if (success) {
                // Update session and redirect with success
                session.setAttribute("user", user);
                response.sendRedirect("profile.jsp?success=true");
            } else {
                request.setAttribute("error", "Failed to update profile. Please try again.");
                request.getRequestDispatcher("profile.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        }
    }
}