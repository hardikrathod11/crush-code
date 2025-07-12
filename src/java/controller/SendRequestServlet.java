package controller;

import model.SwapRequest;
import dao.SwapRequestDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;

public class SendRequestServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        int receiverId = Integer.parseInt(request.getParameter("receiver-id"));
        int offeredSkillId = Integer.parseInt(request.getParameter("offered-skill"));
        int wantedSkillId = Integer.parseInt(request.getParameter("wanted-skill"));
        String message = request.getParameter("message");
        
        SwapRequest swapRequest = new SwapRequest();
        swapRequest.setRequesterId(user.getUserId());
        swapRequest.setReceiverId(receiverId);
        swapRequest.setOfferedSkillId(offeredSkillId);
        swapRequest.setWantedSkillId(wantedSkillId);
        swapRequest.setMessage(message);
        
        SwapRequestDAO swapRequestDao = new SwapRequestDAO();
        if (swapRequestDao.createSwapRequest(swapRequest)) {
            response.sendRedirect("requests.jsp");
        } else {
            request.setAttribute("error", "Failed to send request");
            request.getRequestDispatcher("send-request.jsp?userId=" + receiverId).forward(request, response);
        }
    }
}