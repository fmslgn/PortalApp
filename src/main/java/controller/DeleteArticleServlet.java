package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import util.DBConnection;

@WebServlet("/delete-article")
public class DeleteArticleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String idStr = request.getParameter("id");

        if (idStr == null) {
            response.getWriter().println("Geçersiz makale id.");
            return;
        }

        try {
            int articleId = Integer.parseInt(idStr);

            Connection conn = DBConnection.getConnection();

            String sql = "DELETE FROM articles WHERE id = ? AND user_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, articleId);
            ps.setInt(2, userId);

            int result = ps.executeUpdate();

            if (result > 0) {
                response.getWriter().println("Makale başarıyla silindi.");
            } else {
                response.getWriter().println("Makale silinemedi veya bu makale size ait değil.");
            }

            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Hata: " + e.getMessage());
        }
    }
}