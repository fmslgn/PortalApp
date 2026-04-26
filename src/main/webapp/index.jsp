<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // Oturumdan kullanıcının tam adını alır
    String fullname = (String) session.getAttribute("fullname");

    // Kullanıcı giriş yapmış mı kontrol eder
    boolean isLoggedIn = (fullname != null && !fullname.trim().isEmpty());

    // Projenin kök yolunu alır
    String contextPath = request.getContextPath();

    // Session içinden profil resmi dosya adı alınır
    String profileImage = (String) session.getAttribute("profileImage");

    // Profil resmi varsa gösterilecek URL hazırlanır
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

    <!-- Mobil uyumluluk için viewport ayarı -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>PortalApp</title>

    <!-- Bootstrap CSS bağlantısı -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        /* ------------------------------
           Renkler ve ortak tasarım değişkenleri
        ------------------------------ */
        :root {
            --primary: #2563eb;
            --primary-dark: #1d4ed8;
            --success: #10b981;
            --success-dark: #059669;
            --text: #0f172a;
            --muted: #64748b;
            --line: #e2e8f0;
            --soft: #f8fafc;
            --surface: rgba(255,255,255,0.88);
            --shadow: 0 20px 50px rgba(15, 23, 42, 0.08);
            --radius-xl: 30px;
            --radius-lg: 20px;
        }

        /* Tüm elemanlarda box modeli düzenlenir */
        * {
            box-sizing: border-box;
        }

        /* Sayfanın genel görünümü */
        body {
            margin: 0;
            font-family: "Inter", "Segoe UI", Arial, sans-serif;
            color: var(--text);
            background:
                radial-gradient(circle at top left, #e8f0ff 0%, #f8fbff 35%, #f8fafc 100%);
        }

        /* Linklerde alt çizgiyi kaldırır */
        a {
            text-decoration: none;
        }

        /* ------------------------------
           Navbar alanı
           Sticky olduğu için aşağı kaydırınca üstte kalır
        ------------------------------ */
        .site-navbar {
            position: sticky;
            top: 0;
            z-index: 1050;
            background: rgba(255,255,255,0.78);
            backdrop-filter: blur(14px);
            border-bottom: 1px solid rgba(226, 232, 240, 0.9);
        }

        /* Sol üstteki PortalApp yazısı */
        .navbar-brand {
            font-size: 1.45rem;
            font-weight: 800;
            color: var(--text) !important;
            letter-spacing: -0.03em;
        }

        /* Navbar bağlantıları */
        .nav-link {
            color: #334155 !important;
            font-weight: 600;
            transition: 0.2s ease;
        }

        /* Navbar link hover efekti */
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

        /* ------------------------------
           Ortak buton yapısı
        ------------------------------ */
        .btn-main {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 14px 24px;
            border-radius: 16px;
            font-weight: 700;
            border: 1px solid transparent;
            transition: 0.2s ease;
        }

        /* Buton hover durumunda hafif yukarı çıkar */
        .btn-main:hover {
            transform: translateY(-2px);
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

        /* Yeşil buton */
        .btn-success-clean {
            background: var(--success);
            color: #fff;
            box-shadow: 0 12px 24px rgba(16, 185, 129, 0.16);
        }

        .btn-success-clean:hover {
            background: var(--success-dark);
            color: #fff;
        }

        /* ------------------------------
           Ana hero bölümü
        ------------------------------ */
        .hero-section {
            min-height: calc(100vh - 76px);
            display: flex;
            align-items: center;
            padding: 60px 0;
        }

        /* Hero kutusunun ana kapsayıcısı */
        .hero-wrapper {
            max-width: 920px;
            margin: 0 auto;
            text-align: center;
            background: var(--surface);
            border: 1px solid rgba(226, 232, 240, 0.9);
            border-radius: var(--radius-xl);
            padding: 56px 42px;
            box-shadow: var(--shadow);
        }

        /* Üstteki küçük etiket */
        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 18px;
            border-radius: 999px;
            background: #eff6ff;
            color: var(--primary);
            font-size: 0.95rem;
            font-weight: 700;
            margin-bottom: 24px;
        }

        /* Ana başlık */
        .hero-title {
            font-size: clamp(2.2rem, 5vw, 4.1rem);
            line-height: 1.08;
            font-weight: 800;
            letter-spacing: -0.05em;
            margin-bottom: 22px;
        }

        /* Başlık altı açıklama yazısı */
        .hero-text {
            max-width: 760px;
            margin: 0 auto 28px;
            color: var(--muted);
            font-size: 1.14rem;
            line-height: 1.9;
        }

        /* Kullanıcı durumu bilgi kutusu */
        .hero-status {
            max-width: 720px;
            margin: 0 auto 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            padding: 16px 20px;
            border: 1px solid var(--line);
            border-radius: 18px;
            background: #fff;
            color: #334155;
        }

        /* Durum kutusundaki yeşil nokta */
        .hero-status-dot {
            width: 11px;
            height: 11px;
            border-radius: 50%;
            background: var(--success);
            flex: 0 0 11px;
        }

        /* Butonların yer aldığı alan */
        .hero-actions {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 14px;
            margin-bottom: 34px;
        }

        /* Alt üç küçük bilgi kartının grid yapısı */
        .mini-features {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 18px;
            margin-top: 8px;
        }

        /* Tek tek küçük kartlar */
        .mini-card {
            background: #fff;
            border: 1px solid var(--line);
            border-radius: var(--radius-lg);
            padding: 22px 18px;
            text-align: left;
            box-shadow: 0 10px 24px rgba(15, 23, 42, 0.04);
        }

        .mini-card h5 {
            font-size: 1.05rem;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .mini-card p {
            margin: 0;
            color: var(--muted);
            line-height: 1.75;
            font-size: 0.98rem;
        }

        /* Alt bilgi / footer */
        .site-footer {
            padding: 24px 0 28px;
            text-align: center;
            color: var(--muted);
            font-size: 0.96rem;
        }

        /* ------------------------------
           Tablet ve daha küçük ekranlar
        ------------------------------ */
        @media (max-width: 991px) {
            .hero-wrapper {
                padding: 42px 24px;
            }

            .mini-features {
                grid-template-columns: 1fr;
            }
        }

        /* ------------------------------
           Telefon ekranları
        ------------------------------ */
        @media (max-width: 576px) {
            .hero-section {
                padding: 34px 0;
            }

            .hero-wrapper {
                padding: 34px 18px;
                border-radius: 24px;
            }

            .hero-text {
                font-size: 1rem;
            }

            .hero-status {
                align-items: flex-start;
                justify-content: flex-start;
                text-align: left;
            }

            .hero-actions .btn-main {
                width: 100%;
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

        <!-- Mobil menü açma butonu -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Menü bağlantıları -->
        <div class="collapse navbar-collapse" id="mainNav">
            <ul class="navbar-nav ms-auto align-items-lg-center gap-lg-2">

                <!-- Ana sayfa linki -->
                <li class="nav-item">
                    <a class="nav-link" href="<%= contextPath %>/index.jsp">Ana Sayfa</a>
                </li>

                <!-- Makaleler sayfası -->
                <li class="nav-item">
                    <a class="nav-link" href="<%= contextPath %>/articles.jsp">Makaleler</a>
                </li>

                <!-- Kullanıcı giriş yaptıysa gösterilecek menü -->
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

                    <!-- Kullanıcı giriş yapmadıysa gösterilecek menü -->
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

<!-- Ana karşılama bölümü -->
<section class="hero-section">
    <div class="container">
        <div class="hero-wrapper">

            <!-- Küçük üst etiket -->
            <div class="hero-badge">PortalApp • içerik yönetim platformu</div>

            <!-- Başlık: kullanıcı giriş yaptıysa adını gösterir -->
            <h1 class="hero-title">
                <% if (isLoggedIn) { %>
                    Hoş geldin, <%= fullname %>
                <% } else { %>
                    İçerikleri keşfet, yönet ve daha düzenli bir deneyim yaşa
                <% } %>
            </h1>

            <!-- Açıklama metni -->
            <p class="hero-text">
                PortalApp üzerinden içerikleri görüntüleyebilir, kullanıcı hesabınla giriş yaptıktan sonra
                makale yönetimi işlemlerini gerçekleştirebilir ve sistemi daha sade, modern ve düzenli bir yapıda kullanabilirsin.
            </p>

            <!-- Kullanıcı durum bilgisi -->
            <div class="hero-status">
                <span class="hero-status-dot"></span>
                <span>
                    <% if (isLoggedIn) { %>
                        Oturumun aktif. Makaleleri yönetebilir ve yeni içerik eklemeye başlayabilirsin.
                    <% } else { %>
                        Henüz giriş yapmadın. İçerikleri inceleyebilir veya hemen hesap oluşturabilirsin.
                    <% } %>
                </span>
            </div>

            <!-- Ana aksiyon butonları -->
            <div class="hero-actions">
                <% if (isLoggedIn) { %>
                    <a href="<%= contextPath %>/articles.jsp" class="btn-main btn-primary-clean">Makaleleri Gör</a>
                    <a href="<%= contextPath %>/article-form.jsp" class="btn-main btn-success-clean">Yeni İçerik Ekle</a>
                    <a href="<%= contextPath %>/logout" class="btn-main btn-outline-clean">Çıkış Yap</a>
                <% } else { %>
                    <a href="<%= contextPath %>/articles.jsp" class="btn-main btn-primary-clean">Makaleleri İncele</a>
                    <a href="<%= contextPath %>/login.jsp" class="btn-main btn-outline-clean">Giriş Yap</a>
                    <a href="<%= contextPath %>/register.jsp" class="btn-main btn-success-clean">Kayıt Ol</a>
                <% } %>
            </div>

            <!-- Alt bilgi kartları -->
            <div class="mini-features">

                <!-- Kart 1 -->
                <div class="mini-card">
                    <h5>İçeriklere Eriş</h5>
                    <p>Makale listelerini görüntüle, detayları incele ve içerikleri düzenli biçimde takip et.</p>
                </div>

                <!-- Kart 2 -->
                <div class="mini-card">
                    <h5>Üyelik Akışı</h5>
                    <p>Kayıt ol, giriş yap ve sana özel daha aktif bir kullanım deneyimine kolayca geçiş yap.</p>
                </div>

                <!-- Kart 3 -->
                <div class="mini-card">
                    <h5>Yönetim Kolaylığı</h5>
                    <p>Yeni içerik ekle, mevcut içerikleri düzenle veya sil; tüm işlemleri sade bir yapı içinde yönet.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Alt bilgi -->
<footer class="site-footer">
    <div class="container">
        © 2026 PortalApp • JSP / Servlet tabanlı içerik portalı
    </div>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>