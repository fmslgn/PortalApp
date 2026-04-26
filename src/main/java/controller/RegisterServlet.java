package controller;

// Giriş-çıkış işlemleri için gerekli sınıf
import java.io.IOException;

// Veritabanı işlemleri için gerekli sınıflar
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

// Servlet yapısı için gerekli sınıflar
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// Veritabanı bağlantı sınıfı
import util.DBConnection;

// Bu servlet /register adresinden gelen istekleri karşılar
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Kayıt formundan gelen POST isteğini işler
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Türkçe karakter desteği sağlanır
        request.setCharacterEncoding("UTF-8");

        // Formdan gelen veriler alınır
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Alanlardan biri boşsa kayıt sayfasına hata ile geri yönlendirilir
        if (fullname == null || fullname.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=true");
            return;
        }

        // Aynı e-posta daha önce kullanılmış mı kontrol eden sorgu
        String checkSql = "SELECT id FROM users WHERE email = ?";

        // Yeni kullanıcı ekleme sorgusu
        String insertSql = "INSERT INTO users (fullname, email, password) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection()) {

            // Önce e-posta daha önce kayıtlı mı kontrol edilir
            try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                checkPs.setString(1, email.trim());

                try (ResultSet rs = checkPs.executeQuery()) {
                    // Eğer aynı e-posta varsa tekrar kayıt sayfasına gönderilir
                    if (rs.next()) {
                        response.sendRedirect(request.getContextPath() + "/register.jsp?error=true");
                        return;
                    }
                }
            }

            // Kullanıcı veritabanına eklenir
            try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                insertPs.setString(1, fullname.trim());
                insertPs.setString(2, email.trim());
                insertPs.setString(3, password);

                int result = insertPs.executeUpdate();

                // Kayıt başarılıysa login sayfasına gönderilir
                if (result > 0) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp?registered=true");
                } else {
                    // Başarısızsa tekrar kayıt sayfasına yönlendirilir
                    response.sendRedirect(request.getContextPath() + "/register.jsp?error=true");
                }
            }

        } catch (Exception e) {
            // Hata oluşursa konsola yazdırılır
            e.printStackTrace();

            // Hata durumunda kullanıcı tekrar kayıt sayfasına döner
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=true");
        }
    }
} 	