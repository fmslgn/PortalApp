package util;

// Veritabanı bağlantısı için gerekli sınıflar
import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    // Veritabanı bağlantı adresi
    // localhost:3306 -> MySQL sunucusu ve portu
    // portalapp_db -> kullanılacak veritabanı adı
    // useSSL=false -> SSL kapalı
    // allowPublicKeyRetrieval=true -> bazı MySQL bağlantı hatalarını önlemek için eklenir
    // serverTimezone=UTC -> zaman dilimi ayarı
    private static final String URL = "jdbc:mysql://localhost:3306/portalapp_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

    // Veritabanı kullanıcı adı
    private static final String USER = "root";

    // Veritabanı şifresi
    private static final String PASSWORD = "SIFRENIZ!";

    // Veritabanına bağlantı kurup Connection nesnesi döndüren metot
    public static Connection getConnection() {

        // Başlangıçta bağlantı nesnesi boş olarak tanımlanır
        Connection conn = null;

        try {
            // MySQL JDBC sürücüsünü belleğe yükler
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Belirtilen URL, kullanıcı adı ve şifre ile veritabanı bağlantısı kurar
            conn = DriverManager.getConnection(URL, USER, PASSWORD);

            // Bağlantı başarılıysa konsola mesaj yazar
            System.out.println("Veritabanı bağlantısı başarılı.");
        } catch (Exception e) {
            // Hata oluşursa hata detaylarını konsola yazdırır
            e.printStackTrace();
        }

        // Oluşturulan bağlantıyı geri döndürür
        return conn;
    }
}