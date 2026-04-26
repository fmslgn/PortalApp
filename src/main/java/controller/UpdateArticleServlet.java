package controller;

// Giriş-çıkış işlemleri için IOException
import java.io.IOException;

// Veritabanı işlemleri için gerekli sınıflar
import java.sql.Connection;
import java.sql.PreparedStatement;

// Servlet yapısı için gerekli sınıflar
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Veritabanı bağlantı sınıfı
import util.DBConnection;

// Bu servlet /update-article adresinden gelen istekleri karşılar
@WebServlet("/update-article")
public class UpdateArticleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Güncelleme formundan gelen POST isteğini işler
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Türkçe karakter desteği
        request.setCharacterEncoding("UTF-8");

        // Var olan session alınır
        HttpSession session = request.getSession(false);

        // Kullanıcı giriş yapmamışsa login sayfasına yönlendirilir
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Giriş yapan kullanıcının id bilgisi alınır
        int userId = (int) session.getAttribute("userId");

        // Formdan gelen makale id bilgisi alınır
        String idStr = request.getParameter("id");

        // Yeni başlık bilgisi alınır
        String title = request.getParameter("title");

        // Yeni içerik bilgisi alınır
        String content = request.getParameter("content");

        // Zorunlu alanlardan biri boşsa liste sayfasına döner
        if (idStr == null || idStr.trim().isEmpty()
                || title == null || title.trim().isEmpty()
                || content == null || content.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/articles.jsp");
            return;
        }

        try {
            // String id değeri int'e çevrilir
            int articleId = Integer.parseInt(idStr);

            // Sadece makale sahibi kendi makalesini güncelleyebilir
            String sql = "UPDATE articles SET title = ?, content = ? WHERE id = ? AND user_id = ?";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                // SQL içindeki ? yerlerine değerler yazılır
                ps.setString(1, title.trim());
                ps.setString(2, content.trim());
                ps.setInt(3, articleId);
                ps.setInt(4, userId);

                // Güncelleme işlemi yapılır
                ps.executeUpdate();
            }

            // Güncelleme sonrası detay sayfasına gider
            response.sendRedirect(request.getContextPath() + "/article-detail.jsp?id=" + articleId);

        } catch (Exception e) {
            // Hata konsola yazılır
            e.printStackTrace();

            // Hata durumunda liste sayfasına dönülür
            response.sendRedirect(request.getContextPath() + "/articles.jsp");
        }
    }
}