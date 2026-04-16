<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%
    String fullname = (String) session.getAttribute("fullname");
    Integer userId = (Integer) session.getAttribute("userId");

    if (fullname == null || userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String idStr = request.getParameter("id");
    if (idStr == null) {
        out.println("Geçersiz makale.");
        return;
    }

    int articleId = Integer.parseInt(idStr);
    String title = "";
    String content = "";

    try {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM articles WHERE id = ? AND user_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, articleId);
        ps.setInt(2, userId);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            title = rs.getString("title");
            content = rs.getString("content");
        } else {
            out.println("Makale bulunamadı veya bu makale size ait değil.");
            rs.close();
            ps.close();
            conn.close();
            return;
        }

        rs.close();
        ps.close();
        conn.close();
    } catch (Exception e) {
        out.println("Hata: " + e.getMessage());
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Makale Güncelle</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow">
                <div class="card-header text-center">
                    <h3>Makale Güncelle</h3>
                </div>
                <div class="card-body">
                    <form action="update-article" method="post">
                        <input type="hidden" name="id" value="<%= articleId %>">

                        <div class="mb-3">
                            <label class="form-label">Makale Başlığı</label>
                            <input type="text" name="title" class="form-control" value="<%= title %>" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Makale İçeriği</label>
                            <textarea name="content" rows="8" class="form-control" required><%= content %></textarea>
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-warning">Makaleyi Güncelle</button>
                        </div>
                    </form>
                </div>
                <div class="card-footer text-center">
                    <a href="articles.jsp">Makale listesine dön</a>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>