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

// Veritabanı bağlantısı
import util.DBConnection;

// Bu servlet /add-article adresinden gelen istekleri karşılar
@WebServlet("/add-article")
public class AddArticleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Makale ekleme formundan gelen POST isteğini işler
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Türkçe karakter desteği
        request.setCharacterEncoding("UTF-8");

        // Var olan session alınır, yoksa yeni oluşturulmaz
        HttpSession session = request.getSession(false);

        // Kullanıcı giriş yapmamışsa login sayfasına yönlendirilir
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Session içinden kullanıcı id bilgisi alınır
        int userId = (int) session.getAttribute("userId");

        // Formdan gelen makale başlığı alınır
        String title = request.getParameter("title");

        // Formdan gelen makale içeriği alınır
        String content = request.getParameter("content");

        // Başlık veya içerik boşsa tekrar form sayfasına dönülür
        if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/article-form.jsp?error=true");
            return;
        }

        // Yeni makaleyi veritabanına ekleme sorgusu
        String sql = "INSERT INTO articles (user_id, title, content) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // SQL içindeki ? yerlerine değerler yazılır
            ps.setInt(1, userId);
            ps.setString(2, title.trim());
            ps.setString(3, content.trim());

            // Ekleme işlemi yapılır
            int result = ps.executeUpdate();

            // Başarılıysa makale listesine gider
            if (result > 0) {
                response.sendRedirect(request.getContextPath() + "/articles.jsp");
            } else {
                // Başarısızsa tekrar forma döner
                response.sendRedirect(request.getContextPath() + "/article-form.jsp?error=true");
            }

        } catch (Exception e) {
            // Hata konsola yazılır
            e.printStackTrace();

            // Kullanıcı tekrar form ekranına yönlendirilir
            response.sendRedirect(request.getContextPath() + "/article-form.jsp?error=true");
        }
    }
}