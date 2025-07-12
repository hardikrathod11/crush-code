// dao/AdminSwapDAO.java
package dao;

import java.sql.*;
import java.util.*;
import model.SwapRequest;
import util.DBConnection;

public class AdminSwapDAO {
    public List<SwapRequest> getSwapsByStatus(String status) {
        List<SwapRequest> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM swap_requests WHERE status = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SwapRequest sr = new SwapRequest();
                sr.setRequestId(rs.getInt("request_id"));
                sr.setRequesterId(rs.getInt("requester_id"));
                sr.setReceiverId(rs.getInt("receiver_id"));
                sr.setOfferedSkillId(rs.getInt("offered_skill_id"));
                sr.setWantedSkillId(rs.getInt("wanted_skill_id"));
                sr.setMessage(rs.getString("message"));
                sr.setStatus(rs.getString("status"));
                sr.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(sr);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
