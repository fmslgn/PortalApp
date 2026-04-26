<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%-- SQL işlemleri için gerekli sınıflar --%>
<%@ page import="java.sql.*" %>

<%-- Veritabanı bağlantı sınıfı --%>
<%@ page import="util.DBConnection" %>

<%
    // Projenin kök yolunu alır
    String contextPath = request.getContextPath();

    // Oturumdan giriş yapan kullanıcı bilgileri alınır
    Integer userId = (Integer) session.getAttribute("userId");
    String fullname = (String) session.getAttribute("fullname");

    // Kullanıcının giriş yapıp yapmadığı kontrol edilir
    boolean isLoggedIn = (userId != null);

    // Session içinden profil resmi dosya adı alınır
    String profileImage = (String) session.getAttribute("profileImage");

    // Profil resmi varsa navbar için URL hazırlanır
    String profileImageUrl = null;
    if (profileImage != null && !profileImage.trim().isEmpty()) {
        profileImageUrl = contextPath + "/profile-image?file=" + java.net.URLEncoder.encode(profileImage, "UTF-8");
    }

    // Profil resmi yoksa kullanılacak baş harf hazırlanır
    String profileInitial = "P";
    if (fullname != null && !fullname.trim().isEmpty()) {
        profileInitial = fullname.substring(0, 1).toUpperCase();
    }

    // URL üzerinden gelen makale id bilgisi alınır
    String idStr = request.getParameter("id");

    // Makale bilgilerini tutacak değişkenler
    String articleTitle = "";
    String articleContent = "";
    String articleAuthor = "";
    int viewCount = 0;
    int ownerId = 0;

    // Makale bulundu mu kontrolü
    boolean articleFound = false;

    // Hata mesajı için değişken
    String errorMessage = null;

    // Eğer id parametresi boşsa hata mesajı hazırlanır
    if (idStr == null || idStr.trim().isEmpty()) {
        errorMessage = "Geçersiz makale seçimi.";
    } else {
        try {
            // String olarak gelen id değeri sayıya çevrilir
            int articleId = Integer.parseInt(idStr);

            // Veritabanı bağlantısı açılır
            try (Connection conn = DBConnection.getConnection()) {

                // Önce makalenin okunma sayısı 1 artırılır
                String updateSql = "UPDATE articles SET view_count = view_count + 1 WHERE id = ?";

                try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                    updatePs.setInt(1, articleId);
                    updatePs.executeUpdate();
                }

                // Daha sonra makalenin güncel bilgileri çekilir
                String selectSql = "SELECT articles.id, articles.title, articles.content, articles.view_count, " +
                                   "articles.user_id, users.fullname " +
                                   "FROM articles " +
                                   "INNER JOIN users ON articles.user_id = users.id " +
                                   "WHERE articles.id = ?";

                try (PreparedStatement ps = conn.prepareStatement(selectSql)) {
                    ps.setInt(1, articleId);

                    try (ResultSet rs = ps.executeQuery()) {
                        // Makale bulunduysa bilgiler değişkenlere aktarılır
                        if (rs.next()) {
                            articleFound = true;
                            articleTitle = rs.getString("title");
                            articleContent = rs.getString("content");
                            articleAuthor = rs.getString("fullname");
                            viewCount = rs.getInt("view_count");
                            ownerId = rs.getInt("user_id");
                        } else {
                            errorMessage = "Makale bulunamadı.";
                        }
                    }
                }
            }

        } catch (NumberFormatException e) {
            // id sayıya çevrilemezse hata mesajı hazırlanır
            errorMessage = "Makale kimliği geçersiz.";
        } catch (Exception e) {
            // Sistem hatası oluşursa mesaj hazırlanır
            errorMessage = "Makale bilgileri alınırken bir hata oluştu: " + e.getMessage();
        }
    }

    // Giriş yapan kullanıcı makalenin sahibi mi kontrol edilir
    boolean isOwner = (articleFound && userId != null && userId == ownerId);
%>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">

    <%-- Mobil uyumluluk ayarı --%>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Makale Detayı | PortalApp</title>

    <%-- Bootstrap CSS bağlantısı --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        /* --------------------------------------------------
           Genel renk ve tasarım değişkenleri
        -------------------------------------------------- */
        :root {
            --primary: #2563eb;
            --primary-dark: #1d4ed8;
            --success: #10b981;
            --success-dark: #059669;
            --danger: #dc2626;
            --danger-dark: #b91c1c;
            --text: #0f172a;
            --muted: #64748b;
            --line: #e2e8f0;
            --surface: rgba(255,255,255,0.92);
            --soft: #f8fafc;
            --shadow: 0 20px 50px rgba(15, 23, 42, 0.08);
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: "Inter", "Segoe UI", Arial, sans-serif;
            color: var(--text);
            background: radial-gradient(circle at top left, #e8f0ff 0%, #f8fbff 35%, #f8fafc 100%);
        }

        a {
            text-decoration: none;
        }

        .site-navbar {
            position: sticky;
            top: 0;
            z-index: 1050;
            background: rgba(255,255,255,0.92);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(226, 232, 240, 0.85);
        }

        .navbar-brand {
            font-size: 1.45rem;
            font-weight: 800;
            color: var(--text) !important;
            letter-spacing: -0.03em;
        }

        .nav-link {
            color: #334155 !important;
            font-weight: 600;
        }

        .nav-link:hover {
            color: var(--primary) !important;
        }

        /* Navbar içindeki küçük profil avatarı */
        .nav-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            object-fit: cover;
            border: 1px solid #e2e8f0;
            flex: 0 0 32px;
        }

        /* Profil resmi yoksa gösterilecek harf avatarı */
        .nav-avatar-fallback {
            width: 32px;
            height: 32px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            background: #eff6ff;
            color: #2563eb;
            font-size: 0.85rem;
            font-weight: 700;
            border: 1px solid #dbeafe;
            flex: 0 0 32px;
        }

        .btn-main {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 12px 20px;
            border-radius: 14px;
            font-weight: 700;
            transition: 0.2s ease;
            border: 1px solid transparent;
            text-decoration: none;
        }

        .btn-main:hover {
            transform: translateY(-1px);
        }

        .btn-primary-clean {
            background: var(--primary);
            color: #fff;
            box-shadow: 0 12px 24px rgba(37, 99, 235, 0.16);
        }

        .btn-primary-clean:hover {
            background: var(--primary-dark);
            color: #fff;
        }

        .btn-success-clean {
            background: var(--success);
            color: #fff;
            box-shadow: 0 12px 24px rgba(16, 185, 129, 0.16);
        }

        .btn-success-clean:hover {
            background: var(--success-dark);
            color: #fff;
        }

        .btn-outline-clean {
            background: #fff;
            color: var(--text);
            border-color: var(--line);
        }

        .btn-outline-clean:hover {
            background: #f8fafc;
            color: var(--text);
        }

        .btn-danger-clean {
            background: #fff5f5;
            color: var(--danger);
            border-color: #fecaca;
        }

        .btn-danger-clean:hover {
            background: var(--danger);
            color: #fff;
            border-color: var(--danger);
        }

        .detail-header {
            padding: 48px 0 18px;
        }

        .header-card {
            background: var(--surface);
            border: 1px solid rgba(226, 232, 240, 0.9);
            border-radius: 28px;
            padding: 30px;
            box-shadow: var(--shadow);
        }

        .header-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 16px;
            border-radius: 999px;
            background: #eff6ff;
            color: var(--primary);
            font-size: 0.92rem;
            font-weight: 700;
            margin-bottom: 18px;
        }

        .detail-title {
            font-size: clamp(2rem, 4.5vw, 3rem);
            line-height: 1.08;
            font-weight: 800;
            letter-spacing: -0.05em;
            margin-bottom: 16px;
        }

        .meta-list {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 16px;
        }

        .meta-badge {
            display: inline-flex;
            align-items: center;
            padding: 8px 12px;
            border-radius: 999px;
            background: var(--soft);
            color: #475569;
            font-size: 0.88rem;
            font-weight: 600;
        }

        .header-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 14px;
        }

        .detail-section {
            padding: 18px 0 60px;
        }

        .content-card {
            background: rgba(255,255,255,0.95);
            border: 1px solid var(--line);
            border-radius: 24px;
            padding: 30px;
            box-shadow: 0 14px 28px rgba(15, 23, 42, 0.05);
        }

        .content-card h3 {
            font-size: 1.2rem;
            font-weight: 700;
            margin-bottom: 16px;
        }

        .article-content {
            color: #334155;
            line-height: 1.95;
            white-space: pre-line;
            font-size: 1.02rem;
        }

        .empty-state {
            background: rgba(255,255,255,0.92);
            border: 1px solid var(--line);
            border-radius: 22px;
            padding: 34px;
            text-align: center;
            color: var(--muted);
            box-shadow: 0 12px 26px rgba(15, 23, 42, 0.05);
        }

        .site-footer {
            padding: 22px 0 28px;
            text-align: center;
            color: var(--muted);
            font-size: 0.95rem;
        }

        @media (max-width: 991px) {
            .header-card,
            .content-card {
                padding: 22px 18px;
            }
        }
    </style>
</head>
<body>

<!-- Üst menü -->
<nav class="navbar navbar-expand-lg site-navbar">
    <div class="container">

        <!-- Logo -->
        <a class="navbar-brand" href="<%= contextPath %>/index.jsp">PortalApp</a>

        <!-- Mobil menü butonu -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Menü bağlantıları -->
        <div class="collapse navbar-collapse" id="mainNav">
            <ul class="navbar-nav ms-auto align-items-lg-center gap-lg-2">

                <li class="nav-item">
                    <a class="nav-link" href="<%= contextPath %>/index.jsp">Ana Sayfa</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="<%= contextPath %>/articles.jsp">Makaleler</a>
                </li>

                <%-- Kullanıcı giriş yaptıysa farklı menü gösterilir --%>
                <% if (isLoggedIn) { %>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= contextPath %>/article-form.jsp">İçerik Ekle</a>
                    </li>

                    <!-- Profilim linki avatar ile birlikte gösterilir -->
                    <li class="nav-item">
                        <a class="nav-link d-flex align-items-center gap-2" href="<%= contextPath %>/profile.jsp">
                            <% if (profileImageUrl != null) { %>
                                <img src="<%= profileImageUrl %>" alt="Profil" class="nav-avatar">
                            <% } else { %>
                                <span class="nav-avatar-fallback"><%= profileInitial %></span>
                            <% } %>
                            <span>Profilim</span>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a class="btn-main btn-outline-clean" href="<%= contextPath %>/logout">Çıkış Yap</a>
                    </li>
                <% } else { %>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= contextPath %>/login.jsp">Giriş Yap</a>
                    </li>
                    <li class="nav-item">
                        <a class="btn-main btn-primary-clean" href="<%= contextPath %>/register.jsp">Kayıt Ol</a>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>

<!-- Üst bilgi alanı -->
<section class="detail-header">
    <div class="container">

        <%-- Eğer hata varsa hata kutusu gösterilir --%>
        <% if (errorMessage != null) { %>
            <div class="empty-state">
                <h4>İşlem tamamlanamadı</h4>
                <p><%= errorMessage %></p>
                <a href="<%= contextPath %>/articles.jsp" class="btn-main btn-primary-clean">Makale Listesine Dön</a>
            </div>
        <% } %>

        <%-- Makale bulunduysa üst bilgi alanı gösterilir --%>
        <% if (articleFound) { %>
            <div class="header-card">
                <div class="header-badge">PortalApp • makale detayı</div>

                <h1 class="detail-title"><%= articleTitle %></h1>

                <div class="meta-list">
                    <span class="meta-badge">Yazar: <%= articleAuthor %></span>
                    <span class="meta-badge">Okunma: <%= viewCount %></span>

                    <% if (isOwner) { %>
                        <span class="meta-badge">Sana ait içerik</span>
                    <% } %>
                </div>

                <div class="header-actions">
                    <a href="<%= contextPath %>/articles.jsp" class="btn-main btn-outline-clean">Listeye Dön</a>

                    <%-- Sadece makale sahibi düzenleme ve silme işlemini görür --%>
                    <% if (isOwner) { %>
                        <a href="<%= contextPath %>/edit-article.jsp?id=<%= idStr %>" class="btn-main btn-success-clean">
                            Güncelle
                        </a>

                        <a href="<%= contextPath %>/delete-article?id=<%= idStr %>"
                           class="btn-main btn-danger-clean"
                           onclick="return confirm('Bu makaleyi silmek istediğinize emin misiniz?');">
                            Sil
                        </a>
                    <% } %>
                </div>
            </div>
        <% } %>

    </div>
</section>

<!-- İçerik alanı -->
<% if (articleFound) { %>
<section class="detail-section">
    <div class="container">
        <div class="content-card">
            <h3>Makale İçeriği</h3>

            <%-- İçerik metni gösterilir --%>
            <div class="article-content">
                <%= articleContent %>
            </div>
        </div>
    </div>
</section>
<% } %>

<!-- Alt bilgi -->
<footer class="site-footer">
    <div class="container">
        © 2026 PortalApp • Makale detay sayfası
    </div>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>