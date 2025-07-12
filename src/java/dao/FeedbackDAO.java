package dao;

import model.Feedback;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {
    // Add feedback
    public boolean addFeedback(Feedback feedback) {
        String sql = "INSERT INTO feedbacks (swap_id, from_user_id, to_user_id, rating, comment) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, feedback.getSwapId());
            stmt.setInt(2, feedback.getFromUserId());
            stmt.setInt(3, feedback.getToUserId());
            stmt.setDouble(4, feedback.getRating());
            stmt.setString(5, feedback.getComment());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get feedback for a user
    public List<Feedback> getFeedbackForUser(int userId) {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT * FROM feedbacks WHERE to_user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Feedback feedback = new Feedback();
                feedback.setFeedbackId(rs.getInt("feedback_id"));
                feedback.setSwapId(rs.getInt("swap_id"));
                feedback.setFromUserId(rs.getInt("from_user_id"));
                feedback.setToUserId(rs.getInt("to_user_id"));
                feedback.setRating(rs.getDouble("rating"));
                feedback.setComment(rs.getString("comment"));
                feedback.setCreatedAt(rs.getTimestamp("created_at"));
                feedbacks.add(feedback);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return feedbacks;
    }
    
    // Calculate average rating for a user
    public double getAverageRating(int userId) {
        String sql = "SELECT AVG(rating) as avg_rating FROM feedbacks WHERE to_user_id = ?";
        double avgRating = 0.0;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                avgRating = rs.getDouble("avg_rating");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return avgRating;
    }
}