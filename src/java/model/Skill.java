package model;

public class Skill {
    private int skillId;
    private String skillName;
    private String description;
    private boolean isApproved;

    // Constructors
    public Skill() {}

    public Skill(String skillName) {
        this.skillName = skillName;
    }

    // Getters and Setters
    public int getSkillId() { return skillId; }
    public void setSkillId(int skillId) { this.skillId = skillId; }
    
    public String getSkillName() { return skillName; }
    public void setSkillName(String skillName) { this.skillName = skillName; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public boolean isApproved() { return isApproved; }
    public void setApproved(boolean isApproved) { this.isApproved = isApproved; }
}