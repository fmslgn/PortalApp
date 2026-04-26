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

// Bu servlet /delete-article adresinden gelen istekleri karşılar
@WebServlet("/delete-article")
public class DeleteArticleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Silme işlemi GET isteği ile yapılır
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Var olan session alınır
        HttpSession session = request.getSession(false);

        // Kullanıcı giriş yapmamışsa login sayfasına yönlendirilir
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Giriş yapan kullanıcının id bilgisi alınır
        int userId = (int) session.getAttribute("userId");

        // URL üzerinden gelen makale id bilgisi alınır
        String idStr = request.getParameter("id");

        // id boşsa makale listesine geri dönülür
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/articles.jsp");
            return;
        }

        try {
            // String id değeri int'e çevrilir
            int articleId = Integer.parseInt(idStr);

            // Sadece makalenin sahibi kendi makalesini silebilir
            String sql = "DELETE FROM articles WHERE id = ? AND user_id = ?";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                // SQL içindeki ? yerlerine değerler yazılır
                ps.setInt(1, articleId);
                ps.setInt(2, userId);

                // Silme işlemi gerçekleştirilir
                ps.executeUpdate();
            }

            // İşlem sonrası makale listesine dönülür
            response.sendRedirect(request.getContextPath() + "/articles.jsp");

        } catch (Exception e) {
            // Hata varsa konsola yazdırılır
            e.printStackTrace();

            // Hata durumunda yine liste sayfasına yönlendirilir
            response.sendRedirect(request.getContextPath() + "/articles.jsp");
        }
    }
}