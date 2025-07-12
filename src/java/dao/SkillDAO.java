package dao;

import model.Skill;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SkillDAO {
    // Get all approved skills
    public List<Skill> getAllApprovedSkills() {
        List<Skill> skills = new ArrayList<>();
        String sql = "SELECT * FROM skills WHERE is_approved = TRUE";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Skill skill = new Skill();
                skill.setSkillId(rs.getInt("skill_id"));
                skill.setSkillName(rs.getString("skill_name"));
                skill.setDescription(rs.getString("description"));
                skills.add(skill);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return skills;
    }
    
    // Get skill by ID
    public Skill getSkillById(int skillId) {
        String sql = "SELECT * FROM skills WHERE skill_id = ?";
        Skill skill = null;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, skillId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                skill = new Skill();
                skill.setSkillId(rs.getInt("skill_id"));
                skill.setSkillName(rs.getString("skill_name"));
                skill.setDescription(rs.getString("description"));
                skill.setApproved(rs.getBoolean("is_approved"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return skill;
    }
    
    // Add a new skill
    public boolean addSkill(Skill skill) {
        String sql = "INSERT INTO skills (skill_name, description) VALUES (?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, skill.getSkillName());
            stmt.setString(2, skill.getDescription());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get skills by name (search)
    public List<Skill> searchSkillsByName(String searchTerm) {
        List<Skill> skills = new ArrayList<>();
        String sql = "SELECT * FROM skills WHERE skill_name LIKE ? AND is_approved = TRUE";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, "%" + searchTerm + "%");
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Skill skill = new Skill();
                skill.setSkillId(rs.getInt("skill_id"));
                skill.setSkillName(rs.getString("skill_name"));
                skill.setDescription(rs.getString("description"));
                skills.add(skill);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return skills;
    }
}