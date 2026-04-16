<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String fullname = (String) session.getAttribute("fullname");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>PortalApp</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="card shadow">
        <div class="card-body">
            <h1>PortalApp</h1>

            <% if (fullname != null) { %>
                <h3>Hoş geldin, <%= fullname %></h3>
                <p>Giriş yaptın ve session çalışıyor.</p>
            <% } else { %>
                <h3>Hoş geldin, ziyaretçi</h3>
                <p>Henüz giriş yapmadın.</p>
            <% } %>

            <hr>

            <% if (fullname != null) { %>
                <a href="article-form.jsp" class="btn btn-primary">Makale Ekle</a>
                <a href="articles.jsp" class="btn btn-info">Makaleleri Gör</a>
                <a href="logout" class="btn btn-danger">Çıkış Yap</a>
            <% } else { %>
                <a href="register.jsp" class="btn btn-primary">Kayıt Ol</a>
                <a href="login.jsp" class="btn btn-success">Giriş Yap</a>
                <a href="articles.jsp" class="btn btn-info">Makaleleri Gör</a>
            <% } %>
        </div>
    </div>
</div>

</body>
</html>