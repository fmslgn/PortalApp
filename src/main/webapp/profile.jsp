<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%-- SQL işlemleri için gerekli sınıflar --%>
<%@ page import="java.sql.*" %>

<%-- URL encode işlemi için gerekli sınıf --%>
<%@ page import="java.net.URLEncoder" %>

<%-- Veritabanı bağlantı sınıfı --%>
<%@ page import="util.DBConnection" %>

<%
    // Projenin kök yolunu alır
    String contextPath = request.getContextPath();

    // Session'dan kullanıcı bilgileri alınır
    Integer userId = (Integer) session.getAttribute("userId");
    String sessionFullname = (String) session.getAttribute("fullname");

    // Kullanıcı giriş yapmamışsa login sayfasına yönlendirilir
    if (userId == null) {
        response.sendRedirect(contextPath + "/login.jsp");
        return;
    }

    // URL parametreleri alınır
    String success = request.getParameter("success");
    String error = request.getParameter("error");

    // Veritabanından gelecek kullanıcı bilgileri için değişkenler
    String dbFullname = "";
    String dbEmail = "";
    String profileImage = null;
    String imageUrl = null;
    String errorMessage = null;

    try (Connection conn = DBConnection.getConnection()) {

        // Kullanıcının adı, e-postası ve profil resmi bilgisi alınır
        String sql = "SELECT fullname, email, profile_image FROM users WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    dbFullname = rs.getString("fullname");
                    dbEmail = rs.getString("email");
                    profileImage = rs.getString("profile_image");

                    // Profil resmi varsa tarayıcıda gösterilecek URL hazırlanır
                    if (profileImage != null && !profileImage.trim().isEmpty()) {
                        imageUrl = contextPath + "/profile-image?file=" + URLEncoder.encode(profileImage, "UTF-8");
                    }
                } else {
                    errorMessage = "Kullanıcı bilgileri alınamadı.";
                }
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
        errorMessage = "Profil bilgileri alınırken bir hata oluştu: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">

    <%-- Mobil uyumluluk ayarı --%>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Profilim | PortalApp</title>

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

        .btn-danger-clean {
            background: #fff5f5;
            color: var(--danger);
            border: 1px solid #fecaca;
        }

        .btn-danger-clean:hover {
            background: var(--danger);
            color: #fff;
            border-color: var(--danger);
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

        .profile-section {
            min-height: calc(100vh - 76px);
            display: flex;
            align-items: center;
            padding: 40px 0;
        }

        .profile-wrapper {
            max-width: 1100px;
            margin: 0 auto;
        }

        .profile-info {
            padding-right: 30px;
        }

        .profile-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 16px;
            border-radius: 999px;
            background: #eff6ff;
            color: var(--primary);
            font-size: 0.92rem;
            font-weight: 700;
            margin-bottom: 22px;
        }

        .profile-title {
            font-size: clamp(2rem, 4.5vw, 3.2rem);
            line-height: 1.08;
            font-weight: 800;
            letter-spacing: -0.05em;
            margin-bottom: 16px;
        }

        .profile-text {
            color: var(--muted);
            font-size: 1.05rem;
            line-height: 1.9;
            max-width: 560px;
            margin-bottom: 28px;
        }

        .feature-list {
            display: grid;
            gap: 14px;
            max-width: 520px;
        }

        .feature-item {
            background: rgba(255,255,255,0.78);
            border: 1px solid var(--line);
            border-radius: 18px;
            padding: 18px 20px;
            box-shadow: 0 10px 24px rgba(15, 23, 42, 0.04);
        }

        .feature-item strong {
            display: block;
            font-size: 1rem;
            margin-bottom: 6px;
        }

        .feature-item span {
            color: var(--muted);
            line-height: 1.7;
            font-size: 0.96rem;
        }

        .profile-card {
            background: var(--surface);
            border: 1px solid rgba(226, 232, 240, 0.9);
            border-radius: 28px;
            padding: 34px;
            box-shadow: var(--shadow);
        }

        .profile-card h2 {
            font-size: 1.9rem;
            font-weight: 800;
            letter-spacing: -0.03em;
            margin-bottom: 8px;
        }

        .profile-card p {
            color: var(--muted);
            margin-bottom: 18px;
        }

        .profile-image-box {
            width: 180px;
            height: 180px;
            border-radius: 24px;
            overflow: hidden;
            border: 1px solid var(--line);
            background: var(--soft);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
        }

        .profile-image-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .profile-placeholder {
            color: var(--muted);
            text-align: center;
            font-weight: 600;
            padding: 16px;
        }

        .form-label {
            font-weight: 600;
            color: #334155;
            margin-bottom: 8px;
        }

        .form-control {
            border-radius: 14px;
            padding: 14px 16px;
            border: 1px solid var(--line);
            box-shadow: none !important;
        }

        .form-control:focus {
            border-color: #93c5fd;
        }

        .alert {
            border-radius: 16px;
            padding: 14px 16px;
            margin-bottom: 18px;
        }

        .profile-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 16px;
        }

        .site-footer {
            padding: 22px 0 28px;
            text-align: center;
            color: var(--muted);
            font-size: 0.95rem;
        }

        @media (max-width: 991px) {
            .profile-section {
                padding: 28px 0 40px;
            }

            .profile-info {
                padding-right: 0;
                margin-bottom: 26px;
            }

            .profile-card {
                padding: 26px 20px;
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
                <li class="nav-item">
                    <a class="nav-link" href="<%= contextPath %>/article-form.jsp">İçerik Ekle</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= contextPath %>/profile.jsp">Profilim</a>
                </li>
                <li class="nav-item">
                    <a class="btn-main btn-outline-clean" href="<%= contextPath %>/logout">Çıkış Yap</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Profil sayfası ana bölümü -->
<section class="profile-section">
    <div class="container profile-wrapper">
        <div class="row align-items-center g-4">

            <!-- Sol taraf: bilgilendirme -->
            <div class="col-lg-6">
                <div class="profile-info">
                    <div class="profile-badge">PortalApp • profil yönetimi</div>

                    <h1 class="profile-title">Profil bilgilerini ve görselini yönet</h1>

                    <p class="profile-text">
                        Buradan kullanıcı bilgilerini görüntüleyebilir, profil resmini yükleyebilir
                        veya mevcut resmini silebilirsin.
                    </p>

                    <div class="feature-list">
                        <div class="feature-item">
                            <strong>Profil resmi yükleme</strong>
                            <span>Kendi hesabına özel profil fotoğrafı ekleyebilirsin.</span>
                        </div>

                        <div class="feature-item">
                            <strong>Güncel görünüm</strong>
                            <span>Yüklediğin görsel hesabına ait görünümü daha kişisel hale getirir.</span>
                        </div>

                        <div class="feature-item">
                            <strong>Silme desteği</strong>
                            <span>İstersen mevcut profil resmini tek tıkla kaldırabilirsin.</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sağ taraf: profil kartı -->
            <div class="col-lg-6">
                <div class="profile-card">
                    <h2>Profilim</h2>
                    <p>Hesap bilgilerin ve profil görselin burada yer alır.</p>

                    <% if (errorMessage != null) { %>
                        <div class="alert alert-danger">
                            <%= errorMessage %>
                        </div>
                    <% } %>

                    <% if ("uploaded".equals(success)) { %>
                        <div class="alert alert-success">
                            Profil resmi başarıyla yüklendi.
                        </div>
                    <% } %>

                    <% if ("deleted".equals(success)) { %>
                        <div class="alert alert-success">
                            Profil resmi başarıyla silindi.
                        </div>
                    <% } %>

                    <% if ("empty".equals(error)) { %>
                        <div class="alert alert-danger">
                            Lütfen bir dosya seç.
                        </div>
                    <% } %>

                    <% if ("type".equals(error)) { %>
                        <div class="alert alert-danger">
                            Sadece resim dosyaları yükleyebilirsin.
                        </div>
                    <% } %>

                    <% if ("system".equals(error)) { %>
                        <div class="alert alert-danger">
                            İşlem sırasında bir sistem hatası oluştu.
                        </div>
                    <% } %>

                    <% if ("noimage".equals(error)) { %>
                        <div class="alert alert-danger">
                            Silinecek bir profil resmi bulunamadı.
                        </div>
                    <% } %>

                    <!-- Profil resmi alanı -->
                    <div class="profile-image-box">
                        <% if (imageUrl != null) { %>
                            <img src="<%= imageUrl %>" alt="Profil Resmi">
                        <% } else { %>
                            <div class="profile-placeholder">
                                Profil resmi<br>yüklenmemiş
                            </div>
                        <% } %>
                    </div>

                    <!-- Kullanıcı bilgileri -->
                    <p><strong>Ad Soyad:</strong> <%= dbFullname %></p>
                    <p><strong>E-posta:</strong> <%= dbEmail %></p>

                    <!-- Profil resmi yükleme formu -->
                    <form action="<%= contextPath %>/upload-profile-image" method="post" enctype="multipart/form-data">
                        <div class="mb-3">
                            <label class="form-label">Yeni Profil Resmi</label>
                            <input type="file" name="profileImage" class="form-control" accept="image/*" required>
                        </div>

                        <div class="profile-actions">
                            <button type="submit" class="btn-main btn-primary-clean">Resim Yükle</button>
                        </div>
                    </form>

                    <!-- Profil resmi silme formu -->
                    <% if (imageUrl != null) { %>
                        <form action="<%= contextPath %>/delete-profile-image" method="post" class="mt-3">
                            <button type="submit" class="btn-main btn-danger-clean">Resmi Sil</button>
                        </form>
                    <% } %>

                </div>
            </div>

        </div>
    </div>
</section>

<!-- Alt bilgi -->
<footer class="site-footer">
    <div class="container">
        © 2026 PortalApp • Profil yönetimi
    </div>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>