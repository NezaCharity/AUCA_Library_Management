package com.auca.library;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

public class ReturnBookServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = (String) request.getSession().getAttribute("username");
        
        try (Connection connection = DatabaseConnection.getConnection()) {
            // Retrieve books borrowed by the user that haven't been returned
            String sql = "SELECT books.id, books.title, books.author, borrows.due_date FROM books " +
                         "JOIN borrows ON books.id = borrows.book_id " +
                         "JOIN users ON borrows.user_id = users.id " +
                         "WHERE users.username = ? AND borrows.return_date IS NULL";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, username);
                ResultSet resultSet = statement.executeQuery();
                
                List<Book> borrowedBooks = new ArrayList<>();
                while (resultSet.next()) {
                    int id = resultSet.getInt("id");
                    String title = resultSet.getString("title");
                    String author = resultSet.getString("author");
                    Date dueDate = resultSet.getDate("due_date");

                    Book book = new Book(id, title, author, null, null, "borrowed");
                    borrowedBooks.add(book);

                    // Set due date as a request attribute
                    request.setAttribute("dueDate_" + id, dueDate.toString());
                }

                // Set borrowed books in the request
                request.setAttribute("borrowedBooks", borrowedBooks);

                // Forward to returnBook.jsp
                request.getRequestDispatcher("returnBook.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("errorPage.jsp?error=databaseError");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookId = request.getParameter("bookId");
        String returnDateParam = request.getParameter("returnDate"); // Retrieve return date from form
        String username = (String) request.getSession().getAttribute("username");
    
        try (Connection connection = DatabaseConnection.getConnection()) {
            connection.setAutoCommit(false);
    
            // Parse the actual return date provided by the user
            LocalDate actualReturnDate = LocalDate.parse(returnDateParam);
    
            // Retrieve the due date for this borrowed book
            String selectSql = "SELECT due_date FROM borrows WHERE user_id = (SELECT id FROM users WHERE username = ?) AND book_id = ? AND return_date IS NULL";
            try (PreparedStatement selectStmt = connection.prepareStatement(selectSql)) {
                selectStmt.setString(1, username);
                selectStmt.setString(2, bookId);
    
                ResultSet resultSet = selectStmt.executeQuery();
    
                if (resultSet.next()) {
                    LocalDate dueDate = resultSet.getDate("due_date").toLocalDate();
    
                    // Calculate fine if the book is returned late
                    long daysLate = ChronoUnit.DAYS.between(dueDate, actualReturnDate);
                    double fine = (daysLate > 0) ? daysLate * 0.5 : 0.0; // $0.5 per day late
    
                    // Update the borrow record with the return date and fine
                    String updateSql = "UPDATE borrows SET return_date = ?, fine = ? WHERE user_id = (SELECT id FROM users WHERE username = ?) AND book_id = ?";
                    try (PreparedStatement updateStmt = connection.prepareStatement(updateSql)) {
                        updateStmt.setDate(1, java.sql.Date.valueOf(actualReturnDate));
                        updateStmt.setDouble(2, fine);
                        updateStmt.setString(3, username);
                        updateStmt.setString(4, bookId);
    
                        updateStmt.executeUpdate();
                    }
    
                    // Update book status to 'available'
                    String updateBookStatusSql = "UPDATE books SET status = 'available' WHERE id = ?";
                    try (PreparedStatement updateBookStmt = connection.prepareStatement(updateBookStatusSql)) {
                        updateBookStmt.setString(1, bookId);
                        updateBookStmt.executeUpdate();
                    }
    
                    connection.commit();
                    // Redirect to student dashboard with a success message and fine amount if applicable
                    response.sendRedirect("studentDashboard.jsp?message=returnSuccess&fine=" + fine);
                } else {
                    connection.rollback();
                    response.sendRedirect("returnBook.jsp?error=bookNotFound");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("studentDashboard.jsp?error=returnError");
        }
    }
    
}
