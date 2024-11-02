package com.auca.library;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;


//@WebServlet("/StudentDashboardServlet") 
public class StudentDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String username = (String) session.getAttribute("username");
        
        if (username != null) {
            // Fetch data for the student dashboard
            List<BorrowedBook> borrowedBooks = getBorrowedBooks(username);
            int borrowedBooksCount = borrowedBooks.size(); // count borrowed books
            int overdueFines = getOverdueFines(username);  // calculate overdue fines if applicable
    
            // Set attributes for JSP
            request.setAttribute("borrowedBooksCount", borrowedBooksCount);
            request.setAttribute("overdueFines", overdueFines);
            request.setAttribute("borrowedBooks", borrowedBooks);
    
            // Forward to studentDashboard.jsp
            request.getRequestDispatcher("studentDashboard.jsp").forward(request, response);
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

    private int getOverdueFines(String username) {
        int fine = 0;
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "SELECT SUM(fine) AS totalFine FROM borrows WHERE user_id = (SELECT id FROM users WHERE username = ?) AND due_date < NOW() AND return_date IS NULL";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, username);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                fine = resultSet.getInt("totalFine");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return fine;
    }

    private List<BorrowedBook> getBorrowedBooks(String username) {
        List<BorrowedBook> borrowedBooks = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "SELECT b.title, b.author, br.due_date, IF(br.due_date < NOW(), 'Overdue', 'On Time') AS status " +
                         "FROM borrows br JOIN books b ON br.book_id = b.id " +
                         "WHERE br.user_id = (SELECT id FROM users WHERE username = ?) AND br.return_date IS NULL";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, username);
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                String title = resultSet.getString("title");
                String author = resultSet.getString("author");
                String dueDate = resultSet.getString("due_date");
                String status = resultSet.getString("status");
                borrowedBooks.add(new BorrowedBook(title, author, dueDate, status));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return borrowedBooks;
    }
}
