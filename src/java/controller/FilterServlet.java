package controller;

import dao.UserDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.User;

public class FilterServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String availability = request.getParameter("availability");
        
        UserDAO userDao = new UserDAO();
        List<User> users = userDao.getAllPublicUsers();
        
        if (!availability.isEmpty()) {
            users.removeIf(user -> !availability.equals(user.getAvailability()));
        }
        
        request.setAttribute("filteredUsers", users);
        request.setAttribute("selectedAvailability", availability);
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
}