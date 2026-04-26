<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // Projenin kök yolunu alır
    // Böylece linkler sabit yazılmadan dinamik şekilde çalışır
    String contextPath = request.getContextPath();

    // URL üzerinden gelen hata parametresi alınır
    // Örnek: register.jsp?error=true
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">

    <!-- Mobil cihazlarda uyumlu görünüm için -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Kayıt Ol | PortalApp</title>

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

        /* Tüm elemanlarda kutu modeli düzeni */
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

        /* Link alt çizgisini kaldırır */
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

        /* --------------------------------------------------
           Kayıt sayfası ana bölümü
        -------------------------------------------------- */
        .register-section {
            min-height: calc(100vh - 76px);
            display: flex;
            align-items: center;
            padding: 40px 0;
        }

        /* İçeriği ortalar */
        .register-wrapper {
            max-width: 1100px;
            margin: 0 auto;
        }

        /* Sol bilgi alanı */
        .register-info {
            padding-right: 30px;
        }

        /* Küçük üst etiket */
        .register-badge {
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
        .register-title {
            font-size: clamp(2rem, 4.5vw, 3.3rem);
            line-height: 1.08;
            font-weight: 800;
            letter-spacing: -0.05em;
            margin-bottom: 18px;
        }

        /* Başlık altı açıklama */
        .register-text {
            color: var(--muted);
            font-size: 1.05rem;
            line-height: 1.9;
            max-width: 540px;
            margin-bottom: 28px;
        }

        /* Bilgi kutuları */
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

        /* Sağdaki form kartı */
        .register-card {
            background: var(--surface);
            border: 1px solid rgba(226, 232, 240, 0.9);
            border-radius: 28px;
            padding: 34px;
            box-shadow: var(--shadow);
        }

        .register-card h2 {
            font-size: 1.9rem;
            font-weight: 800;
            letter-spacing: -0.03em;
            margin-bottom: 8px;
        }

        .register-card p {
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
            border-color: #93c5fd;
        }

        /* Uyarı kutusu */
        .alert {
            border-radius: 16px;
            padding: 14px 16px;
            margin-bottom: 18px;
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

        /* Tablet ve mobil düzen */
        @media (max-width: 991px) {
            .register-section {
                padding: 28px 0 40px;
            }

            .register-info {
                padding-right: 0;
                margin-bottom: 26px;
            }

            .register-card {
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
                    <a class="nav-link" href="<%= contextPath %>/login.jsp">Giriş Yap</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Ana kayıt bölümü -->
<section class="register-section">
    <div class="container register-wrapper">
        <div class="row align-items-center g-4">

            <!-- Sol taraf bilgilendirme -->
            <div class="col-lg-6">
                <div class="register-info">
                    <div class="register-badge">PortalApp • kullanıcı kaydı</div>

                    <h1 class="register-title">Yeni hesabını oluştur ve platformu aktif kullanmaya başla</h1>

                    <p class="register-text">
                        PortalApp hesabını oluşturarak sisteme giriş yapabilir, makaleleri yönetebilir
                        ve içerik ekleme işlemlerine daha hızlı bir şekilde geçebilirsin.
                    </p>

                    <div class="feature-list">
                        <div class="feature-item">
                            <strong>Hızlı kayıt</strong>
                            <span>Kısa form yapısı sayesinde üyelik işlemini kolayca tamamlayabilirsin.</span>
                        </div>

                        <div class="feature-item">
                            <strong>İçerik yönetimi</strong>
                            <span>Kayıt olduktan sonra makale ekleme, düzenleme ve silme işlemlerine erişebilirsin.</span>
                        </div>

                        <div class="feature-item">
                            <strong>Düzenli deneyim</strong>
                            <span>Sade ve modern arayüz ile kullanıcı akışı daha anlaşılır ve kolay hale gelir.</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sağ taraf form -->
            <div class="col-lg-6">
                <div class="register-card">
                    <h2>Kayıt Ol</h2>
                    <p>Yeni bir hesap oluşturmak için bilgilerini gir.</p>

                    <% if (error != null) { %>
                        <div class="alert alert-danger">
                            Kayıt işlemi sırasında hata oluştu. E-posta zaten kayıtlı olabilir veya bilgiler eksik olabilir.
                        </div>
                    <% } %>

                    <!-- Kayıt formu -->
                    <form action="<%= contextPath %>/register" method="post">

                        <!-- Ad Soyad -->
                        <div class="mb-3">
                            <label class="form-label">Ad Soyad</label>
                            <input type="text" name="fullname" class="form-control" placeholder="Ad soyad gir" required>
                        </div>

                        <!-- E-posta -->
                        <div class="mb-3">
                            <label class="form-label">E-posta</label>
                            <input type="email" name="email" class="form-control" placeholder="E-posta adresi gir" required>
                        </div>

                        <!-- Şifre -->
                        <div class="mb-3">
                            <label class="form-label">Şifre</label>
                            <input type="password" name="password" class="form-control" placeholder="Şifre oluştur" required>
                        </div>

                        <!-- Gönderme butonu -->
                        <button type="submit" class="btn-main btn-primary-clean w-100">Kayıt Ol</button>
                    </form>

                    <!-- Alt linkler -->
                    <div class="helper-links">
                        <a href="<%= contextPath %>/login.jsp">Zaten hesabın var mı? Giriş Yap</a>
                        <a href="<%= contextPath %>/index.jsp">Ana Sayfaya Dön</a>
                    </div>
                </div>
            </div>

        </div>
    </div>
</section>

<!-- Alt bilgi -->
<footer class="site-footer">
    <div class="container">
        © 2026 PortalApp • Yeni kullanıcı kaydı
    </div>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>