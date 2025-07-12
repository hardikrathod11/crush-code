package controller;

import dao.SwapRequestDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CancelRequestServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int requestId = Integer.parseInt(request.getParameter("request-id"));
        
        SwapRequestDAO swapRequestDao = new SwapRequestDAO();
        if (swapRequestDao.deleteRequest(requestId)) {
            response.sendRedirect("requests.jsp");
        } else {
            request.setAttribute("error", "Failed to cancel request");
            request.getRequestDispatcher("requests.jsp").forward(request, response);
        }
    }
}