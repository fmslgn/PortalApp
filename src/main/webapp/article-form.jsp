<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String fullname = (String) session.getAttribute("fullname");
    if (fullname == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Makale Ekle</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow">
                <div class="card-header text-center">
                    <h3>Yeni Makale Ekle</h3>
                </div>
                <div class="card-body">
                    <form action="add-article" method="post">
                        <div class="mb-3">
                            <label class="form-label">Makale Başlığı</label>
                            <input type="text" name="title" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Makale İçeriği</label>
                            <textarea name="content" rows="8" class="form-control" required></textarea>
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary">Makale Ekle</button>
                        </div>
                    </form>
                </div>
                <div class="card-footer text-center">
                    <a href="index.jsp">Ana sayfaya dön</a>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>