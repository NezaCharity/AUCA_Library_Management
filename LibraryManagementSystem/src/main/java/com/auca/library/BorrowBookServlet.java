// src/main/java/com/auca/library/BorrowBookServlet.java

package com.auca.library;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/borrowBookServlet")
public class BorrowBookServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(BorrowBookServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String role = (String) session.getAttribute("role");

        // Check user role for borrow eligibility
        if (session == null || role == null || (!"student".equals(role) && !"teacher".equals(role) && !"librarian".equals(role))) {
            response.sendRedirect("login.jsp?error=accessDenied");
            return;
        }

        String bookId = request.getParameter("bookId");
        String username = (String) session.getAttribute("username");

        try (Connection connection = DatabaseConnection.getConnection()) {
            connection.setAutoCommit(false); // Start transaction

            // Step 1: Check if the user has reached borrow limit
            if (hasReachedBorrowLimit(connection, username)) {
                response.sendRedirect("borrowBook.jsp?error=borrowLimitReached");
                return;
            }

            // Step 2: Check if the book is available for borrowing
            if (!isBookAvailable(connection, bookId)) {
                response.sendRedirect("borrowBook.jsp?error=bookNotAvailable");
                return;
            }

            // Step 3: Process the borrow request
            boolean borrowSuccess = processBorrowRequest(connection, bookId, username);

            if (borrowSuccess) {
                connection.commit(); // Commit transaction if everything went well
                response.sendRedirect("studentDashboard.jsp?message=borrowSuccess");
            } else {
                connection.rollback(); // Rollback if borrow process failed
                response.sendRedirect("borrowBook.jsp?error=borrowFailed");
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing borrow request", e);
            response.sendRedirect("borrowBook.jsp?error=databaseError");
        }
    }

    private boolean hasReachedBorrowLimit(Connection connection, String username) throws SQLException {
        String borrowLimitSql = "SELECT COUNT(*) AS borrow_count FROM borrow_requests WHERE username = ? AND status = 'approved'";
        try (PreparedStatement statement = connection.prepareStatement(borrowLimitSql)) {
            statement.setString(1, username);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                int borrowCount = resultSet.getInt("borrow_count");
                // Assuming a limit of 5 books
                return borrowCount >= 5;
            }
        }
        return false;
    }

    private boolean isBookAvailable(Connection connection, String bookId) throws SQLException {
        String availabilitySql = "SELECT COUNT(*) AS available FROM books WHERE id = ? AND available = true";
        try (PreparedStatement statement = connection.prepareStatement(availabilitySql)) {
            statement.setString(1, bookId);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                int available = resultSet.getInt("available");
                return available > 0;
            }
        }
        return false;
    }

    private boolean processBorrowRequest(Connection connection, String bookId, String username) throws SQLException {
        String borrowSql = "INSERT INTO borrow_requests (book_id, username, status) VALUES (?, ?, 'pending')";
        try (PreparedStatement statement = connection.prepareStatement(borrowSql)) {
            statement.setString(1, bookId);
            statement.setString(2, username);
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        }
    }
}
