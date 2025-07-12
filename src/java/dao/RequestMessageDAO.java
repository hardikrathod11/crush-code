package dao;

import model.RequestMessage;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.DBConnection;

public class RequestMessageDAO {
    
    public List<RequestMessage> getMessagesForRequest(int requestId) {
        List<RequestMessage> messages = new ArrayList<>();
        String sql = "SELECT * FROM request_messages WHERE request_id = ? ORDER BY created_at ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, requestId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                RequestMessage message = new RequestMessage(
                    rs.getInt("message_id"),
                    rs.getInt("request_id"),
                    rs.getInt("sender_id"),
                    rs.getString("message"),
                    rs.getTimestamp("created_at")
                );
                messages.add(message);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return messages;
    }
    
    public boolean addMessage(RequestMessage message) {
        String sql = "INSERT INTO request_messages (request_id, sender_id, message) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, message.getRequestId());
            stmt.setInt(2, message.getSenderId());
            stmt.setString(3, message.getMessage());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    message.setMessageId(rs.getInt(1));
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Add this method to check if users can message for this request
    public boolean canMessage(int requestId, int userId) {
        String sql = "SELECT * FROM swap_requests WHERE request_id = ? AND " +
                     "((requester_id = ? OR receiver_id = ?) AND status = 'accepted')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, requestId);
            stmt.setInt(2, userId);
            stmt.setInt(3, userId);
            
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}