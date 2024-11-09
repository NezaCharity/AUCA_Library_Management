package com.auca.library;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

//@WebServlet("/DeleteBookServlet")
public class DeleteBookServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int bookId = Integer.parseInt(request.getParameter("id"));

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement("DELETE FROM books WHERE id = ?")) {

            statement.setInt(1, bookId);
            int rowsDeleted = statement.executeUpdate();

            if (rowsDeleted > 0) {
                response.sendRedirect("LibrarianServlet?action=manageBooks&message=bookDeleted");
            } else {
                response.sendRedirect("LibrarianServlet?action=manageBooks&error=deleteFailed");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("LibrarianServlet?action=manageBooks&error=databaseError");
        } catch (Exception e) {  // Catching the generic Exception
            e.printStackTrace();
            response.sendRedirect("LibrarianServlet?action=manageBooks&error=generalError");
        }
    }
}
