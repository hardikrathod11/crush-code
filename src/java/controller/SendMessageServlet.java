package controller;

import dao.RequestMessageDAO;
import dao.SwapRequestDAO;
import model.RequestMessage;
import model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/SendMessageServlet")
public class SendMessageServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            int requestId = Integer.parseInt(request.getParameter("requestId"));
            String messageText = request.getParameter("message");
            
            RequestMessageDAO messageDao = new RequestMessageDAO();
            SwapRequestDAO swapRequestDao = new SwapRequestDAO();
            
            // Check if user is allowed to send messages for this request
            if (!messageDao.canMessage(requestId, user.getUserId())) {
                response.sendRedirect("error.jsp?message=Unauthorized message attempt");
                return;
            }
            
            RequestMessage message = new RequestMessage();
            message.setRequestId(requestId);
            message.setSenderId(user.getUserId());
            message.setMessage(messageText);
            
            boolean success = messageDao.addMessage(message);
            
            if (success) {
                response.sendRedirect("requests.jsp?viewMessages=" + requestId);
            } else {
                response.sendRedirect("error.jsp?message=Failed to send message");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}