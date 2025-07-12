package dao;

import model.SwapRequest;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SwapRequestDAO {
    // Create a new swap request
    public boolean createSwapRequest(SwapRequest request) {
        String sql = "INSERT INTO swap_requests (requester_id, receiver_id, offered_skill_id, wanted_skill_id, message) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, request.getRequesterId());
            stmt.setInt(2, request.getReceiverId());
            stmt.setInt(3, request.getOfferedSkillId());
            stmt.setInt(4, request.getWantedSkillId());
            stmt.setString(5, request.getMessage());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Check if request already exists
    public boolean checkRequestExists(int requesterId, int receiverId) {
        String sql = "SELECT COUNT(*) FROM swap_requests WHERE requester_id = ? AND receiver_id = ? AND status = 'pending'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, requesterId);
            stmt.setInt(2, receiverId);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get all swap requests for a user (received)
    public List<SwapRequest> getReceivedRequests(int userId) {
        List<SwapRequest> requests = new ArrayList<>();
        String sql = "SELECT * FROM swap_requests WHERE receiver_id = ? AND status = 'pending'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                SwapRequest request = new SwapRequest();
                request.setRequestId(rs.getInt("request_id"));
                request.setRequesterId(rs.getInt("requester_id"));
                request.setReceiverId(rs.getInt("receiver_id"));
                request.setOfferedSkillId(rs.getInt("offered_skill_id"));
                request.setWantedSkillId(rs.getInt("wanted_skill_id"));
                request.setMessage(rs.getString("message"));
                request.setStatus(rs.getString("status"));
                request.setCreatedAt(rs.getTimestamp("created_at"));
                requests.add(request);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return requests;
    }
    
    // Get all swap requests sent by a user
    public List<SwapRequest> getSentRequests(int userId) {
        List<SwapRequest> requests = new ArrayList<>();
        String sql = "SELECT * FROM swap_requests WHERE requester_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                SwapRequest request = new SwapRequest();
                request.setRequestId(rs.getInt("request_id"));
                request.setRequesterId(rs.getInt("requester_id"));
                request.setReceiverId(rs.getInt("receiver_id"));
                request.setOfferedSkillId(rs.getInt("offered_skill_id"));
                request.setWantedSkillId(rs.getInt("wanted_skill_id"));
                request.setMessage(rs.getString("message"));
                request.setStatus(rs.getString("status"));
                request.setCreatedAt(rs.getTimestamp("created_at"));
                requests.add(request);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return requests;
    }
    
    // Update swap request status
    public boolean updateRequestStatus(int requestId, String status) {
        String sql = "UPDATE swap_requests SET status = ? WHERE request_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, requestId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete swap request
    public boolean deleteRequest(int requestId) {
        String sql = "DELETE FROM swap_requests WHERE request_id = ? AND status = 'pending'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, requestId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get swap request by ID (correct implementation)
    public SwapRequest getSwapRequestById(int requestId) {
        SwapRequest request = null;
        String sql = "SELECT * FROM swap_requests WHERE request_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, requestId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                request = new SwapRequest();
                request.setRequestId(rs.getInt("request_id"));
                request.setRequesterId(rs.getInt("requester_id"));
                request.setReceiverId(rs.getInt("receiver_id"));
                request.setOfferedSkillId(rs.getInt("offered_skill_id"));
                request.setWantedSkillId(rs.getInt("wanted_skill_id"));
                request.setMessage(rs.getString("message"));
                request.setStatus(rs.getString("status"));
                request.setCreatedAt(rs.getTimestamp("created_at"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return request;
    }
}