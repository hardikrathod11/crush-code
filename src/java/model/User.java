package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class User implements Serializable {
    private int userId;
    private String email;
    private String password;
    private String name;
    private String location;
    private byte[] profilePhoto;
    private String availability;
    private boolean isPublic;
    private boolean isAdmin;
    private Timestamp createdAt;

    // Constructors
    public User() {}

    public User(String email, String password, String name) {
        this.email = email;
        this.password = password;
        this.name = name;
    }

    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    
    public byte[] getProfilePhoto() { return profilePhoto; }
    public void setProfilePhoto(byte[] profilePhoto) { this.profilePhoto = profilePhoto; }
    
    public String getAvailability() { return availability; }
    public void setAvailability(String availability) { this.availability = availability; }
    
    public boolean isPublic() { return isPublic; }
    public void setPublic(boolean isPublic) { this.isPublic = isPublic; }
    
    public boolean isAdmin() { return isAdmin; }
    public void setAdmin(boolean isAdmin) { this.isAdmin = isAdmin; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}