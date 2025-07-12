package model;

import java.sql.Timestamp;

public class SwapRequest {
    private int requestId;
    private int requesterId;
    private int receiverId;
    private int offeredSkillId;
    private int wantedSkillId;
    private String message;
    private String status;
    private Timestamp createdAt;
    
    // Getters and Setters
    public int getRequestId() { return requestId; }
    public void setRequestId(int requestId) { this.requestId = requestId; }
    
    public int getRequesterId() { return requesterId; }
    public void setRequesterId(int requesterId) { this.requesterId = requesterId; }
    
    public int getReceiverId() { return receiverId; }
    public void setReceiverId(int receiverId) { this.receiverId = receiverId; }
    
    public int getOfferedSkillId() { return offeredSkillId; }
    public void setOfferedSkillId(int offeredSkillId) { this.offeredSkillId = offeredSkillId; }
    
    public int getWantedSkillId() { return wantedSkillId; }
    public void setWantedSkillId(int wantedSkillId) { this.wantedSkillId = wantedSkillId; }
    
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}