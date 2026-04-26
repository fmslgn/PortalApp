<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // Projenin kök yolunu alır.
    // Böylece bağlantılar sabit yazılmadan dinamik olarak çalışır.
    String contextPath = request.getContextPath();

    // URL üzerinden gelen hata parametresini alır.
    // Örnek: login.jsp?error=true
    String error = request.getParameter("error");

    // Kayıt işleminden sonra gelen başarı parametresi
    // Örnek: login.jsp?registered=true
    String registered = request.getParameter("registered");

    // Şifre yenileme işleminden sonra gelen başarı parametresi
    // Örnek: login.jsp?reset=success
    String reset = request.getParameter("reset");
%>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">

    <!-- Mobil cihazlarda sayfanın düzgün ölçeklenmesi için -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Giriş Yap | PortalApp</title>

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
            --bg: #f8fafc;
            --surface: rgba(255,255,255,0.9);
            --shadow: 0 20px 50px rgba(15, 23, 42, 0.08);
        }

        /* Tüm elemanlarda kutu modeli */
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

        /* Alt çizgileri kaldırır */
        a {
            text-decoration: none;
        }

        /* --------------------------------------------------
           Navbar alanı
           sticky olduğu için sayfa kayınca üstte sabit kalır
        -------------------------------------------------- */
        .site-navbar {
            position: sticky;
            top: 0;
            z-index: 1050;
            background: rgba(255,255,255,0.92);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(226, 232, 240, 0.85);
        }

        /* Logo / marka yazısı */
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

        /* Menü bağlantıları üzerine gelince renk değişir */
        .nav-link:hover {
            color: var(--primary) !important;
        }

        /* --------------------------------------------------
           Ortak buton yapısı
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

        /* Ana giriş butonu */
        .btn-primary-clean {
            background: var(--primary);
            color: #fff;
            box-shadow: 0 12px 24px rgba(37, 99, 235, 0.16);
        }

        /* Giriş butonunun hover durumu */
        .btn-primary-clean:hover {
            background: var(--primary-dark);
            color: #fff;
            transform: translateY(-1px);
        }

        /* --------------------------------------------------
           Sayfanın ana giriş bölümü
        -------------------------------------------------- */
        .login-section {
            min-height: calc(100vh - 76px);
            display: flex;
            align-items: center;
            padding: 40px 0;
        }

        /* İçeriği ortalar ve maksimum genişlik verir */
        .login-wrapper {
            max-width: 1100px;
            margin: 0 auto;
        }

        /* Sol tanıtım alanının sağdan boşluğu */
        .login-info {
            padding-right: 30px;
        }

        /* Küçük bilgi etiketi */
        .login-badge {
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

        /* Sol taraftaki büyük başlık */
        .login-title {
            font-size: clamp(2rem, 4.5vw, 3.3rem);
            line-height: 1.08;
            font-weight: 800;
            letter-spacing: -0.05em;
            margin-bottom: 18px;
        }

        /* Sol taraftaki açıklama yazısı */
        .login-text {
            color: var(--muted);
            font-size: 1.05rem;
            line-height: 1.9;
            max-width: 540px;
            margin-bottom: 28px;
        }

        /* Bilgilendirme kutularının bulunduğu alan */
        .feature-list {
            display: grid;
            gap: 14px;
            max-width: 520px;
        }

        /* Tek bir bilgilendirme kartı */
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

        /* --------------------------------------------------
           Sağ taraftaki giriş kartı
        -------------------------------------------------- */
        .login-card {
            background: var(--surface);
            border: 1px solid rgba(226, 232, 240, 0.9);
            border-radius: 28px;
            padding: 34px;
            box-shadow: var(--shadow);
        }

        /* Kart başlığı */
        .login-card h2 {
            font-size: 1.9rem;
            font-weight: 800;
            letter-spacing: -0.03em;
            margin-bottom: 8px;
        }

        /* Kart açıklama metni */
        .login-card p {
            color: var(--muted);
            margin-bottom: 24px;
        }

        /* Form etiketleri */
        .form-label {
            font-weight: 600;
            color: #334155;
            margin-bottom: 8px;
        }

        /* Input alanları */
        .form-control {
            border-radius: 14px;
            padding: 14px 16px;
            border: 1px solid var(--line);
            box-shadow: none !important;
        }

        /* Input seçilince kenarlık rengi */
        .form-control:focus {
            border-color: #93c5fd;
        }

        /* Form altı yardımcı bağlantılar */
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

        /* Uyarı / başarı mesaj kutuları */
        .alert {
            border-radius: 16px;
            padding: 14px 16px;
            margin-bottom: 18px;
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
            .login-section {
                padding: 28px 0 40px;
            }

            .login-info {
                padding-right: 0;
                margin-bottom: 26px;
            }

            .login-card {
                padding: 26px 20px;
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

                <!-- Ana sayfa bağlantısı -->
                <li class="nav-item">
                    <a class="nav-link" href="<%= contextPath %>/index.jsp">Ana Sayfa</a>
                </li>

                <!-- Makaleler sayfası -->
                <li class="nav-item">
                    <a class="nav-link" href="<%= contextPath %>/articles.jsp">Makaleler</a>
                </li>

                <!-- Kayıt sayfası -->
                <li class="nav-item">
                    <a class="nav-link" href="<%= contextPath %>/register.jsp">Kayıt Ol</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Ana giriş bölümü -->
<section class="login-section">
    <div class="container login-wrapper">
        <div class="row align-items-center g-4">

            <!-- Sol taraf: tanıtım alanı -->
            <div class="col-lg-6">
                <div class="login-info">

                    <!-- Küçük üst bilgi etiketi -->
                    <div class="login-badge">PortalApp • kullanıcı girişi</div>

                    <!-- Sol başlık -->
                    <h1 class="login-title">Hesabına giriş yap ve içerik yönetimine devam et</h1>

                    <!-- Açıklama metni -->
                    <p class="login-text">
                        PortalApp hesabın ile giriş yaptıktan sonra makalelerini yönetebilir,
                        içerik ekleme işlemlerine geçebilir ve sisteme daha aktif şekilde dahil olabilirsin.
                    </p>

                    <!-- Bilgi kartları -->
                    <div class="feature-list">

                        <div class="feature-item">
                            <strong>Hızlı erişim</strong>
                            <span>Hesabına giriş yaptıktan sonra içerik yönetim bağlantılarına daha kolay ulaşırsın.</span>
                        </div>

                        <div class="feature-item">
                            <strong>Güvenli oturum</strong>
                            <span>Session tabanlı yapı ile kullanıcı deneyimi daha düzenli ve kontrollü ilerler.</span>
                        </div>

                        <div class="feature-item">
                            <strong>Kolay kullanım</strong>
                            <span>Sade arayüz sayesinde giriş işlemlerini kısa sürede tamamlayabilirsin.</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sağ taraf: giriş formu -->
            <div class="col-lg-6">
                <div class="login-card">

                    <!-- Kart başlığı -->
                    <h2>Giriş Yap</h2>
                    <p>Devam etmek için kullanıcı bilgilerini gir.</p>

                    <!-- Hata varsa göster -->
                    <% if (error != null) { %>
                        <div class="alert alert-danger">
                            Kullanıcı adı veya şifre hatalı.
                        </div>
                    <% } %>

                    <!-- Kayıt başarılıysa göster -->
                    <% if (registered != null) { %>
                        <div class="alert alert-success">
                            Kayıt işlemi başarılı. Şimdi giriş yapabilirsin.
                        </div>
                    <% } %>

                    <!-- Şifre yenileme başarılıysa göster -->
                    <% if (reset != null) { %>
                        <div class="alert alert-success">
                            Şifren başarıyla güncellendi. Yeni şifren ile giriş yapabilirsin.
                        </div>
                    <% } %>

                    <!-- Giriş formu -->
                    <form action="<%= contextPath %>/login" method="post">

                        <!-- E-posta veya kullanıcı adı -->
                        <div class="mb-3">
                            <label class="form-label">E-posta veya kullanıcı adı</label>
                            <input type="text" name="email" class="form-control" placeholder="Bilgini gir" required>
                        </div>

                        <!-- Şifre alanı -->
                        <div class="mb-3">
                            <label class="form-label">Şifre</label>
                            <input type="password" name="password" class="form-control" placeholder="Şifreni gir" required>
                        </div>

                        <!-- Form gönderme butonu -->
                        <button type="submit" class="btn-main btn-primary-clean w-100">Giriş Yap</button>
                    </form>

                    <!-- Yardımcı bağlantılar -->
                    <div class="helper-links">
                        <a href="<%= contextPath %>/forgot-password.jsp">Şifremi Unuttum</a>
                        <a href="<%= contextPath %>/register.jsp">Hesabın yok mu? Kayıt Ol</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Alt bilgi -->
<footer class="site-footer">
    <div class="container">
        © 2026 PortalApp • Güvenli kullanıcı girişi
    </div>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>