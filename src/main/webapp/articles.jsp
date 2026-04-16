<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Makale Listesi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="card shadow">
        <div class="card-header text-center">
            <h3>Makale Listesi</h3>
        </div>
        <div class="card-body">
            <%
                try {
                    Connection conn = DBConnection.getConnection();
                    String sql = "SELECT articles.id, articles.title, articles.view_count, users.fullname " +
                                 "FROM articles INNER JOIN users ON articles.user_id = users.id ORDER BY articles.id DESC";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery();

                    while (rs.next()) {
            %>
                        <div class="border rounded p-3 mb-3 bg-white">
                            <h4><%= rs.getString("title") %></h4>
                            <p><strong>Yazar:</strong> <%= rs.getString("fullname") %></p>
                            <p><strong>Okunma:</strong> <%= rs.getInt("view_count") %></p>
                            <a href="article-detail.jsp?id=<%= rs.getInt("id") %>" class="btn btn-primary btn-sm">Detay</a>
                            <a href="edit-article.jsp?id=<%= rs.getInt("id") %>" class="btn btn-warning btn-sm">Güncelle</a>
                            <a href="delete-article?id=<%= rs.getInt("id") %>" class="btn btn-danger btn-sm"onclick="return confirm('Bu makaleyi silmek istediğinize emin misiniz?');">Sil</a>
                        </div>
            <%
                    }

                    rs.close();
                    ps.close();
                    conn.close();
                } catch (Exception e) {
                    out.println("<p>Hata: " + e.getMessage() + "</p>");
                }
            %>
        </div>
        <div class="card-footer text-center">
            <a href="index.jsp">Ana sayfaya dön</a>
        </div>
    </div>
</div>

</body>
</html>