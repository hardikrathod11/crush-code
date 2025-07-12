package dao;

import model.User;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import static util.DBConnection.getConnection;

public class UserDAO {
    
   public boolean createUser(User user) {
        String sql = "INSERT INTO users (email, password, name, location, profile_photo, availability, is_public, is_admin) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getName());
            stmt.setString(4, user.getLocation());
            stmt.setBytes(5, user.getProfilePhoto());
            stmt.setString(6, user.getAvailability());
            stmt.setBoolean(7, user.isPublic());
            stmt.setBoolean(8, user.isAdmin());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating user failed, no rows affected.");
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    user.setUserId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Creating user failed, no ID obtained.");
                }
            }
            
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        User user = null;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                user = extractUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return user;
    }
    
    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setName(rs.getString("name"));
        user.setLocation(rs.getString("location"));
        user.setProfilePhoto(rs.getBytes("profile_photo"));
        user.setAvailability(rs.getString("availability"));
        user.setPublic(rs.getBoolean("is_public"));
        user.setAdmin(rs.getBoolean("is_admin"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }  
    public List<String> getOfferedSkillNames(int userId) {
    List<String> skills = new ArrayList<>();
    String sql = "SELECT s.skill_name FROM skills s JOIN user_skills_offered u ON s.skill_id = u.skill_id WHERE u.user_id = ?";
    
    try (Connection conn = getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, userId);
        ResultSet rs = stmt.executeQuery();
        
        while (rs.next()) {
            skills.add(rs.getString("skill_name"));
        }
    } catch (SQLException e) {
    }
    return skills;
}

public List<String> getWantedSkillNames(int userId) {
    List<String> skills = new ArrayList<>();
    String sql = "SELECT s.skill_name FROM skills s JOIN user_skills_wanted u ON s.skill_id = u.skill_id WHERE u.user_id = ?";
    
    try (Connection conn = getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, userId);
        ResultSet rs = stmt.executeQuery();
        
        while (rs.next()) {
            skills.add(rs.getString("skill_name"));
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return skills;
}
    public List<User> getAllPublicUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT user_id, email, name, location, profile_photo, availability FROM users WHERE is_public = TRUE";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setEmail(rs.getString("email"));
                user.setName(rs.getString("name"));
                user.setLocation(rs.getString("location"));
                user.setProfilePhoto(rs.getBytes("profile_photo"));
                user.setAvailability(rs.getString("availability"));
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return users;
    }
    
    public User getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        User user = null;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                user = extractUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return user;
    }

    public boolean updateUser(User user) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
  
}