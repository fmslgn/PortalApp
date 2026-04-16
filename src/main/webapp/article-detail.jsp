<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Makale Detayı</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="card shadow">
        <div class="card-body">
            <%
                String idStr = request.getParameter("id");

                if (idStr != null) {
                    int id = Integer.parseInt(idStr);

                    try {
                        Connection conn = DBConnection.getConnection();

                        String updateSql = "UPDATE articles SET view_count = view_count + 1 WHERE id = ?";
                        PreparedStatement updatePs = conn.prepareStatement(updateSql);
                        updatePs.setInt(1, id);
                        updatePs.executeUpdate();
                        updatePs.close();

                        String selectSql = "SELECT articles.title, articles.content, articles.view_count, users.fullname " +
                                           "FROM articles INNER JOIN users ON articles.user_id = users.id WHERE articles.id = ?";
                        PreparedStatement ps = conn.prepareStatement(selectSql);
                        ps.setInt(1, id);
                        ResultSet rs = ps.executeQuery();

                        if (rs.next()) {
            %>
                            <h2><%= rs.getString("title") %></h2>
                            <p><strong>Yazar:</strong> <%= rs.getString("fullname") %></p>
                            <p><strong>Okunma:</strong> <%= rs.getInt("view_count") %></p>
                            <hr>
                            <p><%= rs.getString("content") %></p>
            <%
                        } else {
                            out.println("<p>Makale bulunamadı.</p>");
                        }

                        rs.close();
                        ps.close();
                        conn.close();

                    } catch (Exception e) {
                        out.println("<p>Hata: " + e.getMessage() + "</p>");
                    }
                } else {
                    out.println("<p>Geçersiz makale.</p>");
                }
            %>
        </div>
        <div class="card-footer text-center">
            <a href="articles.jsp">Makale listesine dön</a>
        </div>
    </div>
</div>

</body>
</html>