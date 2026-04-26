<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // Projenin kök yolunu alır
    // Böylece linkler dinamik olarak çalışır
    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">

    <!-- Mobil uyumluluk için viewport ayarı -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Şifremi Unuttum | PortalApp</title>

    <!-- Bootstrap CSS bağlantısı -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        /* -----------------------------------
           Genel renk ve tasarım değişkenleri
        ----------------------------------- */
        :root {
            --primary: #2563eb;
            --primary-dark: #1d4ed8;
            --warning: #f59e0b;
            --warning-dark: #d97706;
            --text: #0f172a;
            --muted: #64748b;
            --line: #e2e8f0;
            --surface: rgba(255,255,255,0.9);
            --shadow: 0 20px 50px rgba(15, 23, 42, 0.08);
        }

        /* Tüm elemanlar için kutu modeli */
        * {
            box-sizing: border-box;
        }

        /* Sayfanın genel görünümü */
        body {
            margin: 0;
            font-family: "Inter", "Segoe UI", Arial, sans-serif;
            color: var(--text);
            background: radial-gradient(circle at top left, #fff7ed 0%, #fffaf5 35%, #f8fafc 100%);
        }

        /* Linklerin alt çizgisini kaldırır */
        a {
            text-decoration: none;
        }

        /* -----------------------------------
           Navbar alanı
           Sayfa aşağı inince üstte sabit kalır
        ----------------------------------- */
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

        /* -----------------------------------
           Ortak buton yapısı
        ----------------------------------- */
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

        /* Turuncu ana buton */
        .btn-warning-clean {
            background: var(--warning);
            color: #fff;
            box-shadow: 0 12px 24px rgba(245, 158, 11, 0.18);
        }

        .btn-warning-clean:hover {
            background: var(--warning-dark);
            color: #fff;
            transform: translateY(-1px);
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

        /* -----------------------------------
           Şifremi unuttum sayfasının ana bölümü
        ----------------------------------- */
        .forgot-section {
            min-height: calc(100vh - 76px);
            display: flex;
            align-items: center;
            padding: 40px 0;
        }

        /* İçeriği ortalar ve maksimum genişlik verir */
        .forgot-wrapper {
            max-width: 1100px;
            margin: 0 auto;
        }

        /* Sol bilgi alanı */
        .forgot-info {
            padding-right: 30px;
        }

        /* Küçük üst etiket */
        .forgot-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 16px;
            border-radius: 999px;
            background: #fff7ed;
            color: var(--warning-dark);
            font-size: 0.92rem;
            font-weight: 700;
            margin-bottom: 22px;
        }

        /* Büyük başlık */
        .forgot-title {
            font-size: clamp(2rem, 4.5vw, 3.3rem);
            line-height: 1.08;
            font-weight: 800;
            letter-spacing: -0.05em;
            margin-bottom: 18px;
        }

        /* Açıklama metni */
        .forgot-text {
            color: var(--muted);
            font-size: 1.05rem;
            line-height: 1.9;
            max-width: 540px;
            margin-bottom: 28px;
        }

        /* Sol taraftaki bilgi kutuları */
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

        /* Sağ taraftaki form kartı */
        .forgot-card {
            background: var(--surface);
            border: 1px solid rgba(226, 232, 240, 0.9);
            border-radius: 28px;
            padding: 34px;
            box-shadow: var(--shadow);
        }

        .forgot-card h2 {
            font-size: 1.9rem;
            font-weight: 800;
            letter-spacing: -0.03em;
            margin-bottom: 8px;
        }

        .forgot-card p {
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

        .form-control:focus {
            border-color: #fdba74;
        }

        /* Yardımcı linkler */
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
            .forgot-section {
                padding: 28px 0 40px;
            }

            .forgot-info {
                padding-right: 0;
                margin-bottom: 26px;
            }

            .forgot-card {
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

        <!-- Mobil menü açma butonu -->
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
                    <a class="nav-link" href="<%= contextPath %>/login.jsp">Giriş Yap</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Şifremi unuttum ana bölümü -->
<section class="forgot-section">
    <div class="container forgot-wrapper">
        <div class="row align-items-center g-4">

            <!-- Sol taraf: bilgilendirme -->
            <div class="col-lg-6">
                <div class="forgot-info">
                    <div class="forgot-badge">PortalApp • şifre yenileme</div>

                    <h1 class="forgot-title">Şifreni yenile ve hesabına yeniden erişim sağla</h1>

                    <p class="forgot-text">
                        E-posta adresini ve yeni şifreni girerek hesabının şifresini güncelleyebilirsin.
                        Bu işlem sonrasında yeni şifren ile giriş yapabilirsin.
                    </p>

                    <div class="feature-list">
                        <div class="feature-item">
                            <strong>Kolay yenileme</strong>
                            <span>E-posta ve yeni şifre bilgisi ile işlemini hızlıca tamamlayabilirsin.</span>
                        </div>

                        <div class="feature-item">
                            <strong>Doğrudan güncelleme</strong>
                            <span>Girdiğin yeni şifre doğrudan veritabanında güncellenir.</span>
                        </div>

                        <div class="feature-item">
                            <strong>Girişe geri dön</strong>
                            <span>İşlem sonrası yeni şifren ile tekrar giriş sayfasına geçebilirsin.</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sağ taraf: form -->
            <div class="col-lg-6">
                <div class="forgot-card">
                    <h2>Şifremi Unuttum</h2>
                    <p>Şifreni güncellemek için bilgilerini gir.</p>

                    <!-- Form forgot-password servletine gönderilir -->
                    <form action="<%= contextPath %>/forgot-password" method="post">

                        <!-- E-posta alanı -->
                        <div class="mb-3">
                            <label class="form-label">E-posta</label>
                            <input type="email" name="email" class="form-control" placeholder="E-posta adresini gir" required>
                        </div>

                        <!-- Yeni şifre alanı -->
                        <div class="mb-3">
                            <label class="form-label">Yeni Şifre</label>
                            <input type="password" name="newPassword" class="form-control" placeholder="Yeni şifreni gir" required>
                        </div>

                        <!-- Form gönderme butonu -->
                        <button type="submit" class="btn-main btn-warning-clean w-100">Şifreyi Güncelle</button>
                    </form>

                    <!-- Yardımcı bağlantılar -->
                    <div class="helper-links">
                        <a href="<%= contextPath %>/login.jsp">Giriş Sayfasına Dön</a>
                        <a href="<%= contextPath %>/register.jsp">Yeni Hesap Oluştur</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Alt bilgi -->
<footer class="site-footer">
    <div class="container">
        © 2026 PortalApp • Şifre yenileme işlemi
    </div>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>