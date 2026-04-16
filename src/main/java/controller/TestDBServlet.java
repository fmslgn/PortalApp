package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.DBConnection;

@WebServlet("/test-db")
public class TestDBServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            Connection conn = DBConnection.getConnection();

            out.println("<html><body>");
            if (conn != null) {
                out.println("<h2>Veritabanı bağlantısı başarılı.</h2>");
                conn.close();
            } else {
                out.println("<h2>Veritabanı bağlantısı başarısız.</h2>");
            }
            out.println("</body></html>");
        } catch (Exception e) {
            out.println("<html><body>");
            out.println("<h2>Hata oluştu: " + e.getMessage() + "</h2>");
            out.println("</body></html>");
            e.printStackTrace();
        }
    }
}