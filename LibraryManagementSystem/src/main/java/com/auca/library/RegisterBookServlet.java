
package com.auca.library;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class RegisterBookServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String isbn = request.getParameter("isbn");
        String category = request.getParameter("category");

        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "INSERT INTO books (title, author, isbn, category, status) VALUES (?, ?, ?, ?, 'available')";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, title);
            statement.setString(2, author);
            statement.setString(3, isbn);
            statement.setString(4, category);
            statement.executeUpdate();

            response.sendRedirect("librarianDashboard.jsp?message=bookRegistered");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("registerBook.jsp?error=databaseError");
        }
    }
}
