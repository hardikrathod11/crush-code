package controller;

import model.User;
import dao.UserDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SignupServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        User user = new User(email, password, name);
        UserDAO userDao = new UserDAO();
        
        if (userDao.createUser(user)) {
            request.setAttribute("success", "Account created successfully. Please login.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Account creation failed. Email may already exist.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        }
    }
}