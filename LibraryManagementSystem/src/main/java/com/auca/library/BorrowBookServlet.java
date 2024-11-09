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
        List<Book> availableBooks = getAvailableBooks();
        request.setAttribute("availableBooks", availableBooks);
        request.getRequestDispatcher("borrowBook.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String role = (String) session.getAttribute("role");
    
        if ("HOD".equals(role) || "Dean".equals(role) || "Teacher".equals(role)) {
            response.sendRedirect("accessDenied.jsp?error=accessDenied");
            return;
        } else if (session == null || role == null || (!"student".equals(role) && !"teacher".equals(role))) {
            response.sendRedirect("login.jsp?error=accessDenied");
            return;
        }
    
        String bookId = request.getParameter("bookId");
        String username = (String) session.getAttribute("username");
        String returnDateStr = request.getParameter("returnDate");
    
        try (Connection connection = DatabaseConnection.getConnection()) {
            connection.setAutoCommit(false);
    
            if (hasReachedBorrowLimit(connection, username)) {
                response.sendRedirect("borrowBook.jsp?error=borrowLimitReached");
                return;
            }
    
            if (!isBookAvailable(connection, bookId)) {
                response.sendRedirect("borrowBook.jsp?error=bookNotAvailable");
                return;
            }
    
            LocalDate returnDate = LocalDate.parse(returnDateStr);
            boolean borrowSuccess = processBorrowRequest(connection, bookId, username, returnDate);
    
            if (borrowSuccess) {
                connection.commit();
                response.sendRedirect("studentDashboard.jsp?message=borrowSuccess");
            } else {
                connection.rollback();
                response.sendRedirect("borrowBook.jsp?error=borrowFailed");
            }
    
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing borrow request", e);
            response.sendRedirect("borrowBook.jsp?error=databaseError");
        }
    }
    

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
        // Get user's membership and associated max_books limit
        String membershipQuery = "SELECT memberships.max_books FROM users " +
                                 "JOIN memberships ON users.membership = memberships.type " +
                                 "WHERE users.username = ?";
        try (PreparedStatement membershipStmt = connection.prepareStatement(membershipQuery)) {
            membershipStmt.setString(1, username);
            ResultSet membershipRs = membershipStmt.executeQuery();

            if (membershipRs.next()) {
                int maxBooks = membershipRs.getInt("max_books");

                // Check the current borrowed books count
                String borrowCountQuery = "SELECT COUNT(*) AS borrow_count FROM borrows " +
                                          "WHERE user_id = (SELECT id FROM users WHERE username = ?) " +
                                          "AND return_date IS NULL";
                try (PreparedStatement countStmt = connection.prepareStatement(borrowCountQuery)) {
                    countStmt.setString(1, username);
                    ResultSet countRs = countStmt.executeQuery();

                    if (countRs.next()) {
                        int borrowedCount = countRs.getInt("borrow_count");
                        return borrowedCount >= maxBooks;
                    }
                }
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

    private boolean processBorrowRequest(Connection connection, String bookId, String username, LocalDate returnDate) throws SQLException {
        LocalDate borrowDate = LocalDate.now();
    
        String borrowSql = "INSERT INTO borrows (user_id, book_id, borrow_date, due_date, return_date, fine) " +
                "VALUES ((SELECT id FROM users WHERE username = ?), ?, ?, ?, NULL, 0.0)";
        try (PreparedStatement statement = connection.prepareStatement(borrowSql)) {
            statement.setString(1, username);
            statement.setString(2, bookId);
            statement.setDate(3, Date.valueOf(borrowDate));
            statement.setDate(4, Date.valueOf(returnDate));
    
            int rowsAffected = statement.executeUpdate();
    
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
    

    private boolean processBorrowRequest(Connection connection, String bookId, String username) throws SQLException {
        LocalDate borrowDate = LocalDate.now();
        LocalDate dueDate = borrowDate.plusDays(14);
    
        String borrowSql = "INSERT INTO borrows (user_id, book_id, borrow_date, due_date, return_date, fine) " +
                "VALUES ((SELECT id FROM users WHERE username = ?), ?, ?, ?, NULL, 0.0)";
        try (PreparedStatement statement = connection.prepareStatement(borrowSql)) {
            statement.setString(1, username);
            statement.setString(2, bookId);
            statement.setDate(3, Date.valueOf(borrowDate));
            statement.setDate(4, Date.valueOf(dueDate));
    
            int rowsAffected = statement.executeUpdate();
            
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
