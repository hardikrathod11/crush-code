package dao;

import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserSkillsDAO {
    // Add offered skill to user
    public boolean addOfferedSkill(int userId, int skillId) {
        String sql = "INSERT INTO user_skills_offered (user_id, skill_id) VALUES (?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, skillId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Add wanted skill to user
    public boolean addWantedSkill(int userId, int skillId) {
        String sql = "INSERT INTO user_skills_wanted (user_id, skill_id) VALUES (?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, skillId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get all offered skills for a user
    public List<Integer> getOfferedSkillsForUser(int userId) {
        List<Integer> skillIds = new ArrayList<>();
        String sql = "SELECT skill_id FROM user_skills_offered WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                skillIds.add(rs.getInt("skill_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return skillIds;
    }
    
    // Get all wanted skills for a user
    public List<Integer> getWantedSkillsForUser(int userId) {
        List<Integer> skillIds = new ArrayList<>();
        String sql = "SELECT skill_id FROM user_skills_wanted WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                skillIds.add(rs.getInt("skill_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return skillIds;
    }
    
    // Remove offered skill from user
    public boolean removeOfferedSkill(int userId, int skillId) {
        String sql = "DELETE FROM user_skills_offered WHERE user_id = ? AND skill_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, skillId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Remove wanted skill from user
    public boolean removeWantedSkill(int userId, int skillId) {
        String sql = "DELETE FROM user_skills_wanted WHERE user_id = ? AND skill_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, skillId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}