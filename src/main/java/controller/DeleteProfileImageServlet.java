package controller;

// Giriş-çıkış işlemleri için gerekli sınıflar
import java.io.IOException;

// Dosya işlemleri için gerekli sınıflar
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

// Veritabanı işlemleri için gerekli sınıflar
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

// Servlet işlemleri için gerekli sınıflar
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Veritabanı bağlantı sınıfı
import util.DBConnection;

// Bu servlet profil resmini silme işlemini yapar
@WebServlet("/delete-profile-image")
public class DeleteProfileImageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Profil resimlerinin tutulduğu klasörü döndürür
    private Path getUploadDirectory() throws IOException {
        Path uploadPath = Paths.get(System.getProperty("user.home"), "PortalAppUploads", "profiles");
        Files.createDirectories(uploadPath);
        return uploadPath;
    }

    // POST isteği ile profil resmi silinir
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        // Silinecek eski resim adı burada tutulur
        String oldImage = null;

        try (Connection conn = DBConnection.getConnection()) {

            // Önce veritabanından mevcut profil resmi adı alınır
            String selectSql = "SELECT profile_image FROM users WHERE id = ?";
            try (PreparedStatement selectPs = conn.prepareStatement(selectSql)) {
                selectPs.setInt(1, userId);

                try (ResultSet rs = selectPs.executeQuery()) {
                    if (rs.next()) {
                        oldImage = rs.getString("profile_image");
                    }
                }
            }

            // Kullanıcının profil resmi yoksa hata ile profile sayfasına döner
            if (oldImage == null || oldImage.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/profile.jsp?error=noimage");
                return;
            }

            // Veritabanındaki profil resmi alanı boşaltılır
            String updateSql = "UPDATE users SET profile_image = NULL WHERE id = ?";
            try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                updatePs.setInt(1, userId);
                updatePs.executeUpdate();

                // Session içindeki profil resmi bilgisi de temizlenir
                session.removeAttribute("profileImage");
            }

            // Fiziksel dosya sisteminden eski resim silinir
            Path imagePath = getUploadDirectory().resolve(oldImage);
            Files.deleteIfExists(imagePath);

            // Başarılı işlem sonrası profile sayfasına dönülür
            response.sendRedirect(request.getContextPath() + "/profile.jsp?success=deleted");

        } catch (Exception e) {
            // Hata konsola yazdırılır
            e.printStackTrace();

            // Hata olursa kullanıcı profile sayfasına hata ile döner
            response.sendRedirect(request.getContextPath() + "/profile.jsp?error=system");
        }
    }
}