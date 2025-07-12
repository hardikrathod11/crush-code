package controller;

import dao.SwapRequestDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class HandleRequestServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int requestId = Integer.parseInt(request.getParameter("request-id"));
        String action = request.getParameter("action");
        
        SwapRequestDAO swapRequestDao = new SwapRequestDAO();
        boolean success = false;
        
        if ("accept".equals(action)) {
            success = swapRequestDao.updateRequestStatus(requestId, "accepted");
        } else if ("reject".equals(action)) {
            success = swapRequestDao.updateRequestStatus(requestId, "rejected");
        }
        
        if (success) {
            response.sendRedirect("requests.jsp");
        } else {
            request.setAttribute("error", "Failed to process request");
            request.getRequestDispatcher("requests.jsp").forward(request, response);
        }
    }
}