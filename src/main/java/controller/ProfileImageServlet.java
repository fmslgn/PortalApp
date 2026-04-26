package controller;

// Giriş-çıkış işlemleri için gerekli sınıflar
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

// Dosya işlemleri için gerekli sınıflar
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

// Servlet işlemleri için gerekli sınıflar
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// Bu servlet profil resmini tarayıcıya gösterir
@WebServlet("/profile-image")
public class ProfileImageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Profil resimlerinin tutulduğu klasörü döndürür
    private Path getUploadDirectory() throws IOException {
        Path uploadPath = Paths.get(System.getProperty("user.home"), "PortalAppUploads", "profiles");
        Files.createDirectories(uploadPath);
        return uploadPath;
    }

    // GET isteği ile dosya tarayıcıya gönderilir
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // URL'den dosya adı alınır
        String fileName = request.getParameter("file");

        // Dosya adı boşsa 404 döndürülür
        if (fileName == null || fileName.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Güvenlik için sadece dosya adı alınır
        String safeFileName = Paths.get(fileName).getFileName().toString();

        // Dosyanın tam yolu oluşturulur
        Path imagePath = getUploadDirectory().resolve(safeFileName);

        // Dosya yoksa 404 döndürülür
        if (!Files.exists(imagePath)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Dosyanın MIME tipi belirlenir
        String mimeType = Files.probeContentType(imagePath);
        if (mimeType == null) {
            mimeType = "application/octet-stream";
        }

        // Response bilgileri ayarlanır
        response.setContentType(mimeType);
        response.setContentLengthLong(Files.size(imagePath));

        // Dosya tarayıcıya gönderilir
        try (InputStream inputStream = Files.newInputStream(imagePath);
             OutputStream outputStream = response.getOutputStream()) {

            inputStream.transferTo(outputStream);
        }
    }
}