<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%-- SQL işlemleri için gerekli sınıflar --%>
<%@ page import="java.sql.*" %>

<%-- Veritabanı bağlantı sınıfı --%>
<%@ page import="util.DBConnection" %>

<%
    // Projenin kök yolunu alır
    String contextPath = request.getContextPath();

    // Session içinden kullanıcı bilgileri alınır
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
%>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">

    <%-- Mobil uyumluluk ayarı --%>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Makaleler | PortalApp</title>

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

        /* Tüm elemanlarda kutu modeli düzenlenir */
        * {
            box-sizing: border-box;
        }

        /* Sayfanın genel görünümü */
        body {
            margin: 0;
            font-family: "Inter", "Segoe UI", Arial, sans-serif;
            color: var(--text);
            background: radial-gradient(circle at top left, #e8f0ff 0%, #f8fbff 35%, #f8fafc 100%);
        }

        /* Link alt çizgileri kaldırılır */
        a {
            text-decoration: none;
        }

        /* --------------------------------------------------
           Navbar alanı
        -------------------------------------------------- */
        .site-navbar {
            position: sticky;
            top: 0;
            z-index: 1050;
            background: rgba(255,255,255,0.92);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(226, 232, 240, 0.85);
        }

        /* Logo yazısı */
        .navbar-brand {
            font-size: 1.45rem;
            font-weight: 800;
            color: var(--text) !important;
            letter-spacing: -0.03em;
        }

        /* Menü linkleri */
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

        /* --------------------------------------------------
           Ortak buton yapısı
        -------------------------------------------------- */
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

        /* --------------------------------------------------
           Sayfa üst başlık alanı
        -------------------------------------------------- */
        .page-header {
            padding: 48px 0 20px;
        }

        .header-card {
            background: var(--surface);
            border: 1px solid rgba(226, 232, 240, 0.9);
            border-radius: 28px;
            padding: 32px;
            box-shadow: var(--shadow);
        }

        .page-badge {
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

        .page-title {
            font-size: clamp(2rem, 4.5vw, 3rem);
            line-height: 1.08;
            font-weight: 800;
            letter-spacing: -0.05em;
            margin-bottom: 14px;
        }

        .page-text {
            color: var(--muted);
            font-size: 1.04rem;
            line-height: 1.9;
            margin-bottom: 22px;
            max-width: 760px;
        }

        .header-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
        }

        /* --------------------------------------------------
           Makale listesi alanı
        -------------------------------------------------- */
        .articles-section {
            padding: 18px 0 60px;
        }

        .articles-grid {
            display: grid;
            gap: 22px;
        }

        /* Tek bir makale kartı */
        .article-card {
            background: rgba(255,255,255,0.95);
            border: 1px solid var(--line);
            border-radius: 22px;
            padding: 26px;
            box-shadow: 0 12px 26px rgba(15, 23, 42, 0.05);
            transition: 0.2s ease;
        }

        .article-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 18px 34px rgba(15, 23, 42, 0.08);
        }

        /* Kart üst meta bilgileri */
        .article-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 14px;
        }

        .meta-badge {
            display: inline-flex;
            align-items: center;
            padding: 7px 12px;
            border-radius: 999px;
            background: var(--soft);
            color: #475569;
            font-size: 0.86rem;
            font-weight: 600;
        }

        /* Makale başlığı */
        .article-title {
            font-size: 1.4rem;
            font-weight: 800;
            letter-spacing: -0.02em;
            margin-bottom: 12px;
        }

        /* Makale kısa içeriği */
        .article-text {
            color: var(--muted);
            line-height: 1.85;
            margin-bottom: 18px;
        }

        /* İşlem butonları */
        .article-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        /* Boş durum kutusu */
        .empty-state {
            background: rgba(255,255,255,0.92);
            border: 1px solid var(--line);
            border-radius: 22px;
            padding: 34px;
            text-align: center;
            color: var(--muted);
            box-shadow: 0 12px 26px rgba(15, 23, 42, 0.05);
        }

        /* Alt bilgi */
        .site-footer {
            padding: 22px 0 28px;
            text-align: center;
            color: var(--muted);
            font-size: 0.95rem;
        }

        /* Tablet ve küçük ekranlar */
        @media (max-width: 991px) {
            .header-card {
                padding: 24px 20px;
            }

            .article-card {
                padding: 22px 18px;
            }
        }
    </style>
</head>
<body>

<!-- Üst menü -->
<nav class="navbar navbar-expand-lg site-navbar">
    <div class="container">

        <!-- Logo / ana sayfa bağlantısı -->
        <a class="navbar-brand" href="<%= contextPath %>/index.jsp">PortalApp</a>

        <!-- Mobil menü butonu -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Menü bağlantıları -->
        <div class="collapse navbar-collapse" id="mainNav">
            <ul class="navbar-nav ms-auto align-items-lg-center gap-lg-2">

                <!-- Ana sayfa -->
                <li class="nav-item">
                    <a class="nav-link" href="<%= contextPath %>/index.jsp">Ana Sayfa</a>
                </li>

                <!-- Makaleler -->
                <li class="nav-item">
                    <a class="nav-link" href="<%= contextPath %>/articles.jsp">Makaleler</a>
                </li>

                <%-- Kullanıcı giriş yaptıysa gösterilecek menü --%>
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

                    <%-- Kullanıcı giriş yapmadıysa gösterilecek menü --%>
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

<!-- Sayfa üst başlığı -->
<section class="page-header">
    <div class="container">
        <div class="header-card">
            <div class="page-badge">PortalApp • makale listesi</div>

            <h1 class="page-title">Yayınlanan içerikleri keşfet</h1>

            <p class="page-text">
                Bu alanda sistemde bulunan tüm makaleleri görüntüleyebilir, detay sayfasına geçebilir ve
                giriş yaptıysan kendi içeriklerin üzerinde işlem yapabilirsin.
            </p>

            <div class="header-actions">
                <a href="<%= contextPath %>/index.jsp" class="btn-main btn-outline-clean">Ana Sayfaya Dön</a>

                <%-- Sadece giriş yapan kullanıcı makale ekleme butonunu görür --%>
                <% if (isLoggedIn) { %>
                    <a href="<%= contextPath %>/article-form.jsp" class="btn-main btn-success-clean">Yeni Makale Ekle</a>
                <% } else { %>
                    <a href="<%= contextPath %>/login.jsp" class="btn-main btn-primary-clean">Giriş Yap</a>
                <% } %>
            </div>
        </div>
    </div>
</section>

<!-- Makale listesi -->
<section class="articles-section">
    <div class="container">
        <div class="articles-grid">

            <%
                // Makale var mı kontrol etmek için sayaç değişkeni
                boolean hasArticle = false;

                try {
                    // Veritabanı bağlantısı alınır
                    Connection conn = DBConnection.getConnection();

                    // Makale bilgileri ve yazar adı çekilir
                    String sql = "SELECT articles.id, articles.title, articles.content, articles.view_count, " +
                                 "articles.user_id, users.fullname " +
                                 "FROM articles INNER JOIN users ON articles.user_id = users.id " +
                                 "ORDER BY articles.id DESC";

                    // SQL sorgusu hazırlanır
                    PreparedStatement ps = conn.prepareStatement(sql);

                    // Sorgu çalıştırılır
                    ResultSet rs = ps.executeQuery();

                    // Sonuçlar satır satır dolaşılır
                    while (rs.next()) {
                        hasArticle = true;

                        // Veriler değişkenlere alınır
                        int articleId = rs.getInt("id");
                        int ownerId = rs.getInt("user_id");
                        String title = rs.getString("title");
                        String content = rs.getString("content");
                        String author = rs.getString("fullname");
                        int viewCount = rs.getInt("view_count");

                        // İçeriğin kısa önizlemesi hazırlanır
                        String preview = content;
                        if (preview != null && preview.length() > 180) {
                            preview = preview.substring(0, 180) + "...";
                        }

                        // Bu makale giriş yapan kullanıcıya mı ait kontrol edilir
                        boolean isOwner = (userId != null && userId == ownerId);
            %>

                        <!-- Tek makale kartı -->
                        <div class="article-card">

                            <!-- Kart üst meta bilgileri -->
                            <div class="article-meta">
                                <span class="meta-badge">Yazar: <%= author %></span>
                                <span class="meta-badge">Okunma: <%= viewCount %></span>

                                <% if (isOwner) { %>
                                    <span class="meta-badge">Sana ait içerik</span>
                                <% } %>
                            </div>

                            <!-- Makale başlığı -->
                            <h2 class="article-title"><%= title %></h2>

                            <!-- Makale kısa içeriği -->
                            <p class="article-text"><%= preview %></p>

                            <!-- İşlem butonları -->
                            <div class="article-actions">
                                <a href="<%= contextPath %>/article-detail.jsp?id=<%= articleId %>" class="btn-main btn-primary-clean">
                                    Detay Gör
                                </a>

                                <% if (isOwner) { %>
                                    <a href="<%= contextPath %>/edit-article.jsp?id=<%= articleId %>" class="btn-main btn-outline-clean">
                                        Güncelle
                                    </a>

                                    <a href="<%= contextPath %>/delete-article?id=<%= articleId %>"
                                       class="btn-main btn-danger-clean"
                                       onclick="return confirm('Bu makaleyi silmek istediğinize emin misiniz?');">
                                        Sil
                                    </a>
                                <% } %>
                            </div>
                        </div>

            <%
                    }

                    // Nesneler kapatılır
                    rs.close();
                    ps.close();
                    conn.close();

                } catch (Exception e) {
            %>
                    <div class="empty-state">
                        <strong>Hata oluştu:</strong> <%= e.getMessage() %>
                    </div>
            <%
                }

                // Hiç makale yoksa boş durum gösterilir
                if (!hasArticle) {
            %>
                <div class="empty-state">
                    <h4>Henüz makale eklenmemiş</h4>
                    <p>Sistemde görüntülenecek bir içerik bulunmuyor.</p>
                </div>
            <%
                }
            %>

        </div>
    </div>
</section>

<!-- Alt bilgi -->
<footer class="site-footer">
    <div class="container">
        © 2026 PortalApp • Makale içerik listesi
    </div>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>