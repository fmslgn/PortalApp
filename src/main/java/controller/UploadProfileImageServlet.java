package controller;

// Giriş-çıkış işlemleri için gerekli sınıflar
import java.io.IOException;
import java.io.InputStream;

// Dosya işlemleri için gerekli sınıflar
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

// Veritabanı işlemleri için gerekli sınıflar
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

// Benzersiz dosya adı üretmek için UUID kullanılır
import java.util.UUID;

// Servlet işlemleri için gerekli sınıflar
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

// Veritabanı bağlantı sınıfı
import util.DBConnection;

// Bu servlet profil resmi yükleme işlemini karşılar
@WebServlet("/upload-profile-image")

// Dosya yükleme desteği açılır
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB
    maxFileSize = 5 * 1024 * 1024,        // 5 MB
    maxRequestSize = 6 * 1024 * 1024      // 6 MB
)
public class UploadProfileImageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Profil resimlerinin kaydedileceği klasörü oluşturur ve döndürür
    private Path getUploadDirectory() throws IOException {
        Path uploadPath = Paths.get(System.getProperty("user.home"), "PortalAppUploads", "profiles");
        Files.createDirectories(uploadPath);
        return uploadPath;
    }

    // POST isteği ile gelen profil resmi yükleme işlemini yapar
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

        // Formdan gelen dosya alınır
        Part imagePart = request.getPart("profileImage");

        // Dosya seçilmemişse hata ile profile sayfasına dönülür
        if (imagePart == null || imagePart.getSize() == 0) {
            response.sendRedirect(request.getContextPath() + "/profile.jsp?error=empty");
            return;
        }

        // Yüklenen dosyanın içerik tipi alınır
        String contentType = imagePart.getContentType();

        // Sadece resim dosyalarına izin verilir
        if (contentType == null || !contentType.startsWith("image/")) {
            response.sendRedirect(request.getContextPath() + "/profile.jsp?error=type");
            return;
        }

        // Orijinal dosya adı alınır
        String originalFileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();

        // Dosya uzantısı çıkarılır
        String extension = "";
        int dotIndex = originalFileName.lastIndexOf(".");
        if (dotIndex != -1) {
            extension = originalFileName.substring(dotIndex).toLowerCase();
        }

        // Sadece belirli uzantılara izin verilir
        if (!(extension.equals(".jpg") || extension.equals(".jpeg") || extension.equals(".png")
                || extension.equals(".gif") || extension.equals(".webp"))) {
            response.sendRedirect(request.getContextPath() + "/profile.jsp?error=type");
            return;
        }

        // Yeni benzersiz dosya adı oluşturulur
        String newFileName = UUID.randomUUID().toString() + extension;

        // Dosyanın kaydedileceği tam yol hazırlanır
        Path uploadDir = getUploadDirectory();
        Path targetFile = uploadDir.resolve(newFileName);

        // Eski profil resmi adı burada tutulur
        String oldImage = null;

        try {
            // Yeni dosya fiziksel olarak kaydedilir
            try (InputStream inputStream = imagePart.getInputStream()) {
                Files.copy(inputStream, targetFile, StandardCopyOption.REPLACE_EXISTING);
            }

            // Veritabanı bağlantısı açılır
            try (Connection conn = DBConnection.getConnection()) {

                // Önce eski profil resmi adı alınır
                String selectSql = "SELECT profile_image FROM users WHERE id = ?";
                try (PreparedStatement selectPs = conn.prepareStatement(selectSql)) {
                    selectPs.setInt(1, userId);

                    try (ResultSet rs = selectPs.executeQuery()) {
                        if (rs.next()) {
                            oldImage = rs.getString("profile_image");
                        }
                    }
                }

                // Yeni profil resmi adı veritabanına kaydedilir
                String updateSql = "UPDATE users SET profile_image = ? WHERE id = ?";
                try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                    updatePs.setString(1, newFileName);
                    updatePs.setInt(2, userId);

                    int result = updatePs.executeUpdate();

                    // Güncelleme başarısızsa yeni yüklenen dosya silinir
                    if (result == 0) {
                        Files.deleteIfExists(targetFile);
                        response.sendRedirect(request.getContextPath() + "/profile.jsp?error=system");
                        return;
                    }

                    // Session içindeki profil resmi bilgisi de güncellenir
                    session.setAttribute("profileImage", newFileName);
                }
            }

            // Eski resim varsa ve yeni resimden farklıysa fiziksel olarak silinir
            if (oldImage != null && !oldImage.trim().isEmpty() && !oldImage.equals(newFileName)) {
                Path oldFile = uploadDir.resolve(oldImage);
                Files.deleteIfExists(oldFile);
            }

            // Başarılı işlem sonrası profile sayfasına dönülür
            response.sendRedirect(request.getContextPath() + "/profile.jsp?success=uploaded");

        } catch (Exception e) {
            // Hata olursa yeni dosya silinmeye çalışılır
            Files.deleteIfExists(targetFile);

            // Hata konsola yazdırılır
            e.printStackTrace();

            // Kullanıcı hata ile profile sayfasına döner
            response.sendRedirect(request.getContextPath() + "/profile.jsp?error=system");
        }
    }
}