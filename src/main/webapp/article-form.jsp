<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // Projenin kök yolunu alır
    String contextPath = request.getContextPath();

    // Oturumdan kullanıcı bilgileri alınır
    Integer userId = (Integer) session.getAttribute("userId");
    String fullname = (String) session.getAttribute("fullname");

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

    // URL üzerinden gelen hata parametresi alınır
    String error = request.getParameter("error");

    // Kullanıcı giriş yapmamışsa login sayfasına yönlendirilir
    if (userId == null) {
        response.sendRedirect(contextPath + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">

    <!-- Mobil uyumluluk ayarı -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Makale Ekle | PortalApp</title>

    <!-- Bootstrap CSS bağlantısı -->
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

        /* Linklerin alt çizgisini kaldırır */
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

        /* Menü bağlantıları */
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
           Buton yapısı
        -------------------------------------------------- */
        .btn-main {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 12px 22px;
            border-radius: 14px;
            font-weight: 700;
            transition: 0.2s ease;
            border: 1px solid transparent;
            text-decoration: none;
        }

        .btn-main:hover {
            transform: translateY(-1px);
        }

        /* Mavi ana buton */
        .btn-primary-clean {
            background: var(--primary);
            color: #fff;
            box-shadow: 0 12px 24px rgba(37, 99, 235, 0.16);
        }

        .btn-primary-clean:hover {
            background: var(--primary-dark);
            color: #fff;
        }

        /* Beyaz kenarlıklı buton */
        .btn-outline-clean {
            background: #fff;
            color: var(--text);
            border-color: var(--line);
        }

        .btn-outline-clean:hover {
            background: #f8fafc;
            color: var(--text);
        }

        /* --------------------------------------------------
           Ana form bölümü
        -------------------------------------------------- */
        .form-section {
            min-height: calc(100vh - 76px);
            display: flex;
            align-items: center;
            padding: 40px 0;
        }

        /* İçeriği ortalar */
        .form-wrapper {
            max-width: 1100px;
            margin: 0 auto;
        }

        /* Sol bilgi alanı */
        .form-info {
            padding-right: 30px;
        }

        /* Küçük üst etiket */
        .form-badge {
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

        /* Ana başlık */
        .form-title {
            font-size: clamp(2rem, 4.5vw, 3.2rem);
            line-height: 1.08;
            font-weight: 800;
            letter-spacing: -0.05em;
            margin-bottom: 18px;
        }

        /* Açıklama metni */
        .form-text {
            color: var(--muted);
            font-size: 1.05rem;
            line-height: 1.9;
            max-width: 540px;
            margin-bottom: 28px;
        }

        /* Bilgi kutuları listesi */
        .feature-list {
            display: grid;
            gap: 14px;
            max-width: 520px;
        }

        /* Tek bilgi kartı */
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

        /* Sağ taraftaki form kartı */
        .form-card {
            background: var(--surface);
            border: 1px solid rgba(226, 232, 240, 0.9);
            border-radius: 28px;
            padding: 34px;
            box-shadow: var(--shadow);
        }

        .form-card h2 {
            font-size: 1.9rem;
            font-weight: 800;
            letter-spacing: -0.03em;
            margin-bottom: 8px;
        }

        .form-card p {
            color: var(--muted);
            margin-bottom: 24px;
        }

        /* Form etiketleri */
        .form-label {
            font-weight: 600;
            color: #334155;
            margin-bottom: 8px;
        }

        /* Input ve textarea alanları */
        .form-control {
            border-radius: 14px;
            padding: 14px 16px;
            border: 1px solid var(--line);
            box-shadow: none !important;
        }

        .form-control:focus {
            border-color: #93c5fd;
        }

        /* Uyarı kutusu */
        .alert {
            border-radius: 16px;
            padding: 14px 16px;
            margin-bottom: 18px;
        }

        /* Alt bağlantılar */
        .helper-links {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 18px;
        }

        .helper-links a {
            color: var(--primary);
            font-weight: 600;
            font-size: 0.95rem;
        }

        .helper-links a:hover {
            color: var(--primary-dark);
        }

        /* Alt bilgi */
        .site-footer {
            padding: 22px 0 28px;
            text-align: center;
            color: var(--muted);
            font-size: 0.95rem;
        }

        /* Tablet ve küçük ekran ayarları */
        @media (max-width: 991px) {
            .form-section {
                padding: 28px 0 40px;
            }

            .form-info {
                padding-right: 0;
                margin-bottom: 26px;
            }

            .form-card {
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
            </ul>
        </div>
    </div>
</nav>

<!-- Ana form bölümü -->
<section class="form-section">
    <div class="container form-wrapper">
        <div class="row align-items-center g-4">

            <!-- Sol taraf: bilgilendirme -->
            <div class="col-lg-6">
                <div class="form-info">
                    <div class="form-badge">PortalApp • içerik ekleme</div>

                    <h1 class="form-title">Yeni bir makale oluştur ve platformda paylaş</h1>

                    <p class="form-text">
                        Bu ekrandan yeni içerik ekleyebilir, başlık ve metin bilgilerini girerek
                        platformdaki makale akışına yeni bir yazı kazandırabilirsin.
                    </p>

                    <div class="feature-list">
                        <div class="feature-item">
                            <strong>Kolay içerik ekleme</strong>
                            <span>Başlık ve içerik alanlarını doldurarak yeni makaleni hızlıca oluşturabilirsin.</span>
                        </div>

                        <div class="feature-item">
                            <strong>Düzenli yayın akışı</strong>
                            <span>Eklediğin içerikler liste ve detay sayfalarında düzenli biçimde görüntülenir.</span>
                        </div>

                        <div class="feature-item">
                            <strong>Kullanıcıya özel işlem</strong>
                            <span>Giriş yapan kullanıcı olarak kendi içeriklerini sisteme ekleyebilirsin.</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sağ taraf: form -->
            <div class="col-lg-6">
                <div class="form-card">
                    <h2>Yeni Makale Ekle</h2>
                    <p>Başlık ve içerik bilgilerini girerek yeni bir kayıt oluştur.</p>

                    <% if (error != null) { %>
                        <div class="alert alert-danger">
                            Makale eklenirken bir hata oluştu. Bilgileri kontrol ederek tekrar dene.
                        </div>
                    <% } %>

                    <!-- Makale ekleme formu -->
                    <form action="<%= contextPath %>/add-article" method="post">

                        <!-- Başlık alanı -->
                        <div class="mb-3">
                            <label class="form-label">Makale Başlığı</label>
                            <input type="text" name="title" class="form-control" placeholder="Makale başlığını gir" required>
                        </div>

                        <!-- İçerik alanı -->
                        <div class="mb-3">
                            <label class="form-label">Makale İçeriği</label>
                            <textarea name="content" rows="8" class="form-control" placeholder="Makale içeriğini yaz" required></textarea>
                        </div>

                        <!-- Form gönderme butonu -->
                        <button type="submit" class="btn-main btn-primary-clean w-100">Makale Ekle</button>
                    </form>

                    <!-- Alt bağlantılar -->
                    <div class="helper-links">
                        <a href="<%= contextPath %>/articles.jsp">Makale Listesine Dön</a>
                        <a href="<%= contextPath %>/profile.jsp">Profilime Git</a>
                    </div>
                </div>
            </div>

        </div>
    </div>
</section>

<!-- Alt bilgi -->
<footer class="site-footer">
    <div class="container">
        © 2026 PortalApp • Yeni içerik oluşturma
    </div>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>