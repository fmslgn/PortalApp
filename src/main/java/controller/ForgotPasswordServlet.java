package controller;

// IOException sınıfı, giriş/çıkış işlemlerinde hata oluşursa kullanılır
import java.io.IOException;

// Veritabanı işlemleri için gerekli sınıflar
import java.sql.Connection;
import java.sql.PreparedStatement;

// Servlet işlemleri için gerekli sınıflar
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// Veritabanı bağlantı sınıfı
import util.DBConnection;

// Bu servlet /forgot-password adresine gelen istekleri karşılar
@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Formdan gelen POST isteğini yakalar
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Türkçe karakter desteği için karakter seti ayarlanır
        request.setCharacterEncoding("UTF-8");

        // Formdan gelen e-posta bilgisi alınır
        String email = request.getParameter("email");

        // Formdan gelen yeni şifre bilgisi alınır
        String newPassword = request.getParameter("newPassword");

        // Veritabanı bağlantısı ve sorgu nesneleri try-with-resources ile açılır
        // Böylece iş bitince otomatik kapanırlar
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "UPDATE users SET password = ? WHERE email = ?")) {

            // SQL sorgusundaki ilk ? yerine yeni şifre atanır
            ps.setString(1, newPassword);

            // SQL sorgusundaki ikinci ? yerine e-posta atanır
            ps.setString(2, email);

            // Güncelleme sorgusu çalıştırılır
            int result = ps.executeUpdate();

            // Eğer en az 1 kayıt güncellendiyse işlem başarılıdır
            if (result > 0) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?reset=success");
            } else {
                // E-posta bulunamadıysa tekrar forgot-password sayfasına yönlendir
                response.sendRedirect(request.getContextPath() + "/forgot-password.jsp?error=notfound");
            }

        } catch (Exception e) {
            // Hata oluşursa konsola yazdırılır
            e.printStackTrace();

            // Kullanıcı hata sayfasına değil, tekrar aynı forma yönlendirilir
            response.sendRedirect(request.getContextPath() + "/forgot-password.jsp?error=system");
        }
    }
}