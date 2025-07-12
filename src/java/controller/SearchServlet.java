package controller;

import dao.SkillDAO;
import dao.UserDAO;
import dao.UserSkillsDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Skill;

public class SearchServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchTerm = request.getParameter("search");
        
        SkillDAO skillDao = new SkillDAO();
        List<Skill> skills = skillDao.searchSkillsByName(searchTerm);
        
        request.setAttribute("skills", skills);
        request.setAttribute("searchTerm", searchTerm);
        request.getRequestDispatcher("search-results.jsp").forward(request, response);
    }
}