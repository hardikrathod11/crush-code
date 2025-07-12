package model;

import java.sql.Timestamp;

public class RequestMessage {
    private int messageId;
    private int requestId;
    private int senderId;
    private String message;
    private Timestamp createdAt;
    
    // Constructors, getters and setters
    public RequestMessage() {}
    
    public RequestMessage(int messageId, int requestId, int senderId, String message, Timestamp createdAt) {
        this.messageId = messageId;
        this.requestId = requestId;
        this.senderId = senderId;
        this.message = message;
        this.createdAt = createdAt;
    }
    
    // Getters and setters
    public int getMessageId() { return messageId; }
    public void setMessageId(int messageId) { this.messageId = messageId; }
    
    public int getRequestId() { return requestId; }
    public void setRequestId(int requestId) { this.requestId = requestId; }
    
    public int getSenderId() { return senderId; }
    public void setSenderId(int senderId) { this.senderId = senderId; }
    
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}