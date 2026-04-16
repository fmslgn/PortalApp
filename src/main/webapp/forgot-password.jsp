<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Şifremi Unuttum</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow">
                <div class="card-header text-center">
                    <h3>Şifremi Unuttum</h3>
                </div>
                <div class="card-body">
                    <form action="forgot-password" method="post">
                        <div class="mb-3">
                            <label class="form-label">E-posta</label>
                            <input type="email" name="email" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Yeni Şifre</label>
                            <input type="password" name="newPassword" class="form-control" required>
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-warning">Şifreyi Güncelle</button>
                        </div>
                    </form>
                </div>
                <div class="card-footer text-center">
                    <a href="login.jsp">Giriş sayfasına dön</a>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>