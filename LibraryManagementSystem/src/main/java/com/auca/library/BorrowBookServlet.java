package com.auca.library;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

//@WebServlet("/BorrowBookServlet")
public class BorrowBookServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(BorrowBookServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve available books and forward to borrowBook.jsp
        List<Book> availableBooks = getAvailableBooks();
        request.setAttribute("availableBooks", availableBooks);
        request.getRequestDispatcher("borrowBook.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String role = (String) session.getAttribute("role");

        // Check user role for borrow eligibility
        if (session == null || role == null || (!"student".equals(role) && !"teacher".equals(role))) {
            response.sendRedirect("login.jsp?error=accessDenied");
            return;
        }

        String bookId = request.getParameter("bookId");
        String username = (String) session.getAttribute("username");

        try (Connection connection = DatabaseConnection.getConnection()) {
            connection.setAutoCommit(false); // Start transaction

            // Step 1: Check if the user has reached the borrow limit
            if (hasReachedBorrowLimit(connection, username)) {
                response.sendRedirect("borrowBook.jsp?error=borrowLimitReached");
                return;
            }

            // Step 2: Check if the book is available for borrowing
            if (!isBookAvailable(connection, bookId)) {
                response.sendRedirect("borrowBook.jsp?error=bookNotAvailable");
                return;
            }

            // Step 3: Process the borrow request with dates
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

    // Method to retrieve available books from the database
    private List<Book> getAvailableBooks() {
        List<Book> books = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "SELECT id, title, author, isbn, category, status FROM books WHERE status = 'available'";
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                int id = resultSet.getInt("id");
                String title = resultSet.getString("title");
                String author = resultSet.getString("author");
                String isbn = resultSet.getString("isbn");
                String category = resultSet.getString("category");
                String status = resultSet.getString("status");

                books.add(new Book(id, title, author, isbn, category, status));
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving available books", e);
        }
        return books;
    }

    private boolean hasReachedBorrowLimit(Connection connection, String username) throws SQLException {
        String borrowLimitSql = "SELECT COUNT(*) AS borrow_count FROM borrows WHERE user_id = (SELECT id FROM users WHERE username = ?) AND return_date IS NULL";
        try (PreparedStatement statement = connection.prepareStatement(borrowLimitSql)) {
            statement.setString(1, username);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                int borrowCount = resultSet.getInt("borrow_count");
                return borrowCount >= 5;
            }
        }
        return false;
    }

    private boolean isBookAvailable(Connection connection, String bookId) throws SQLException {
        String availabilitySql = "SELECT COUNT(*) AS available FROM books WHERE id = ? AND status = 'available'";
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
        LocalDate borrowDate = LocalDate.now();
        LocalDate dueDate = borrowDate.plusDays(14); // 2-week loan period
    
        // Insert a new borrow record
        String borrowSql = "INSERT INTO borrows (user_id, book_id, borrow_date, due_date, return_date, fine) " +
                "VALUES ((SELECT id FROM users WHERE username = ?), ?, ?, ?, NULL, 0.0)";
        try (PreparedStatement statement = connection.prepareStatement(borrowSql)) {
            statement.setString(1, username);
            statement.setString(2, bookId);
            statement.setDate(3, Date.valueOf(borrowDate));
            statement.setDate(4, Date.valueOf(dueDate));
    
            int rowsAffected = statement.executeUpdate();
            
            // If borrow record was inserted successfully, update the book status
            if (rowsAffected > 0) {
                String updateBookStatusSql = "UPDATE books SET status = 'borrowed' WHERE id = ?";
                try (PreparedStatement updateStmt = connection.prepareStatement(updateBookStatusSql)) {
                    updateStmt.setString(1, bookId);
                    updateStmt.executeUpdate();
                }
            }
            
            return rowsAffected > 0;
        }
    }
    
}
