package model;

import java.sql.Timestamp;

public class Feedback {
    private int feedbackId;
    private int swapId;
    private int fromUserId;
    private int toUserId;
    private double rating;
    private String comment;
    private Timestamp createdAt;

    // Getters and Setters
    public int getFeedbackId() { return feedbackId; }
    public void setFeedbackId(int feedbackId) { this.feedbackId = feedbackId; }
    
    public int getSwapId() { return swapId; }
    public void setSwapId(int swapId) { this.swapId = swapId; }
    
    public int getFromUserId() { return fromUserId; }
    public void setFromUserId(int fromUserId) { this.fromUserId = fromUserId; }
    
    public int getToUserId() { return toUserId; }
    public void setToUserId(int toUserId) { this.toUserId = toUserId; }
    
    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }
    
    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}