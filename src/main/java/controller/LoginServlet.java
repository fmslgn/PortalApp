package controller;

// Giriş-çıkış işlemlerinde kullanılacak IOException sınıfı
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
import jakarta.servlet.http.HttpSession;

// Veritabanı bağlantı sınıfı
import util.DBConnection;

// Bu servlet /login adresinden gelen istekleri karşılar
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Login formundan gelen POST isteğini işler
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Türkçe karakter desteği sağlanır
        request.setCharacterEncoding("UTF-8");

        // Formdan gelen e-posta bilgisi alınır
        String email = request.getParameter("email");

        // Formdan gelen şifre bilgisi alınır
        String password = request.getParameter("password");

        // Alanlar boşsa tekrar giriş sayfasına yönlendirilir
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=true");
            return;
        }

        // Kullanıcı bilgileri veritabanından çekilir
        // profile_image alanı da session için alınır
        String sql = "SELECT id, fullname, email, profile_image FROM users WHERE email = ? AND password = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // SQL içindeki ? alanlarına formdan gelen veriler yazılır
            ps.setString(1, email.trim());
            ps.setString(2, password);

            // Sorgu çalıştırılır
            try (ResultSet rs = ps.executeQuery()) {

                // Kullanıcı bulunduysa session bilgileri oluşturulur
                if (rs.next()) {
                    HttpSession session = request.getSession();

                    // Kullanıcının temel bilgileri session içine alınır
                    session.setAttribute("userId", rs.getInt("id"));
                    session.setAttribute("fullname", rs.getString("fullname"));
                    session.setAttribute("email", rs.getString("email"));

                    // Profil resmi bilgisi de session içine alınır
                    session.setAttribute("profileImage", rs.getString("profile_image"));

                    // Başarılı giriş sonrası ana sayfaya yönlendirilir
                    response.sendRedirect(request.getContextPath() + "/index.jsp");
                } else {
                    // Kullanıcı bulunamazsa hata ile giriş sayfasına dönülür
                    response.sendRedirect(request.getContextPath() + "/login.jsp?error=true");
                }
            }

        } catch (Exception e) {
            // Hata oluşursa konsola yazdırılır
            e.printStackTrace();

            // Hata durumunda tekrar giriş sayfasına dönülür
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=true");
        }
    }
}