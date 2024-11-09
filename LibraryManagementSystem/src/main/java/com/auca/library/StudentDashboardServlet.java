package com.auca.library;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;
import java.sql.*;


//@WebServlet("/StudentDashboardServlet") 
public class StudentDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String username = (String) session.getAttribute("username");
    
        if (username != null) {
            try {
                // Fetch data for the student dashboard
                List<Book> borrowedBooks = getBorrowedBooks(username, request);
                int borrowedBooksCount = borrowedBooks.size();
                double overdueFines = getOverdueFines(username);
    
                // Set attributes for JSP
                request.setAttribute("borrowedBooks", borrowedBooks);  // <-- Set the borrowedBooks attribute here
                request.setAttribute("borrowedBooksCount", borrowedBooksCount);
                request.setAttribute("overdueFines", overdueFines);
    
                // Forward to studentDashboard.jsp
                request.getRequestDispatcher("studentDashboard.jsp").forward(request, response);
    
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("errorPage.jsp?error=databaseError");
            }
        } else {
            // Redirect to login if username is null
            response.sendRedirect("login.jsp?error=accessDenied");
        }
    }
    


    private int getBorrowedBooksCount(String username) {
        int count = 0;
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "SELECT COUNT(*) AS count FROM borrows WHERE user_id = (SELECT id FROM users WHERE username = ?)";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, username);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                count = resultSet.getInt("count");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    // private int getOverdueFines(String username) {
    //     int fine = 0;
    //     try (Connection connection = DatabaseConnection.getConnection()) {
    //         String sql = "SELECT SUM(fine) AS totalFine FROM borrows WHERE user_id = (SELECT id FROM users WHERE username = ?) AND due_date < NOW() AND return_date IS NULL";
    //         PreparedStatement statement = connection.prepareStatement(sql);
    //         statement.setString(1, username);
    //         ResultSet resultSet = statement.executeQuery();
    //         if (resultSet.next()) {
    //             fine = resultSet.getInt("totalFine");
    //         }
    //     } catch (Exception e) {
    //         e.printStackTrace();
    //     }
    //     return fine;
    // }

    private List<Book> getBorrowedBooks(String username, HttpServletRequest request) throws Exception {
        List<Book> borrowedBooks = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "SELECT books.id, books.title, books.author, books.isbn, books.category, borrows.due_date, " +
                         "CASE WHEN borrows.due_date < CURDATE() THEN 'Overdue' ELSE 'On Time' END AS status " +
                         "FROM books " +
                         "JOIN borrows ON books.id = borrows.book_id " +
                         "JOIN users ON borrows.user_id = users.id " +
                         "WHERE users.username = ? AND borrows.return_date IS NULL";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, username);
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                int id = resultSet.getInt("id");
                String title = resultSet.getString("title");
                String author = resultSet.getString("author");
                String isbn = resultSet.getString("isbn");
                String category = resultSet.getString("category");
                Date dueDate = resultSet.getDate("due_date");
                String status = resultSet.getString("status");

                Book book = new Book(id, title, author, isbn, category, "borrowed");
                borrowedBooks.add(book);

                request.setAttribute("dueDate_" + id, dueDate.toString());
                request.setAttribute("status_" + id, status);
            }
        }
        return borrowedBooks;
    }

    private double getOverdueFines(String username) throws Exception {
        double totalFine = 0.0;
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "SELECT SUM(fine) AS total_fine FROM borrows " +
                         "WHERE user_id = (SELECT id FROM users WHERE username = ?) AND fine > 0";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, username);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                totalFine = resultSet.getDouble("total_fine");
            }
        }
        return totalFine;
    }

}
