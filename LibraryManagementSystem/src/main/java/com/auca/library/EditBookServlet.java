package com.auca.library;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

// Update the annotation for URL mapping
//@WebServlet("/EditBookServlet")
public class EditBookServlet extends HttpServlet {

    // Handles retrieving the book details and forwarding them to editBook.jsp
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve the book ID from the request
        int bookId = Integer.parseInt(request.getParameter("id"));

        // Database connection and query to get book details
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(
                 "SELECT title, author, isbn, category, status FROM books WHERE id = ?"
             )) {

            statement.setInt(1, bookId);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                // Set book details as request attributes
                request.setAttribute("bookId", bookId);
                request.setAttribute("title", resultSet.getString("title"));
                request.setAttribute("author", resultSet.getString("author"));
                request.setAttribute("isbn", resultSet.getString("isbn"));
                request.setAttribute("category", resultSet.getString("category"));
                request.setAttribute("status", resultSet.getString("status"));

                // Forward to editBook.jsp to display the data
                request.getRequestDispatcher("editBook.jsp").forward(request, response);
            } else {
                // Redirect if the book is not found
                response.sendRedirect("manageBooks.jsp?error=bookNotFound");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("manageBooks.jsp?error=databaseError");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manageBooks.jsp?error=generalError");
        }
    }

    // Handles updating the book details
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String isbn = request.getParameter("isbn");
        String category = request.getParameter("category");
        String status = request.getParameter("status");

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(
                 "UPDATE books SET title = ?, author = ?, isbn = ?, category = ?, status = ? WHERE id = ?"
             )) {

            statement.setString(1, title);
            statement.setString(2, author);
            statement.setString(3, isbn);
            statement.setString(4, category);
            statement.setString(5, status);
            statement.setInt(6, bookId);

            int rowsUpdated = statement.executeUpdate();

            if (rowsUpdated > 0) {
                response.sendRedirect("LibrarianServlet?action=manageBooks&message=bookUpdated");
            
            } else {
                response.sendRedirect("manageBooks.jsp?error=updateFailed");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("manageBooks.jsp?error=databaseError");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manageBooks.jsp?error=generalError");
        }
    }
}
