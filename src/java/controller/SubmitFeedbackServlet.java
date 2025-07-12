package controller;

import model.Feedback;
import dao.FeedbackDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;

public class SubmitFeedbackServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        int requestId = Integer.parseInt(request.getParameter("request-id"));
        int toUserId = Integer.parseInt(request.getParameter("to-user-id"));
        double rating = Double.parseDouble(request.getParameter("rating"));
        String comment = request.getParameter("comment");
        
        Feedback feedback = new Feedback();
        feedback.setSwapId(requestId);
        feedback.setFromUserId(user.getUserId());
        feedback.setToUserId(toUserId);
        feedback.setRating(rating);
        feedback.setComment(comment);
        
        FeedbackDAO feedbackDao = new FeedbackDAO();
        if (feedbackDao.addFeedback(feedback)) {
            response.sendRedirect("requests.jsp");
        } else {
            request.setAttribute("error", "Failed to submit feedback");
            request.getRequestDispatcher("feedback.jsp?requestId=" + requestId).forward(request, response);
        }
    }
}