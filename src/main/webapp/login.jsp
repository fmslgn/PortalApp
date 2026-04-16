<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Giriş Yap</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow">
                <div class="card-header text-center">
                    <h3>Üye Giriş Formu</h3>
                </div>
                <div class="card-body">
                    <form action="login" method="post">
                        <div class="mb-3">
                            <label class="form-label">E-posta</label>
                            <input type="email" name="email" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Şifre</label>
                            <input type="password" name="password" class="form-control" required>
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-success">Giriş Yap</button>
                        </div>
                        <div class="text-center mt-3">
    						<a href="forgot-password.jsp">Şifremi Unuttum</a>
						</div>
                    </form>
                </div>
                <div class="card-footer text-center">
                    <a href="register.jsp">Hesabın yok mu? Kayıt ol</a>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>