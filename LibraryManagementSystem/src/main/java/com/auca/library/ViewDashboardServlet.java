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
import java.util.ArrayList;
import java.util.List;

//@WebServlet("/ViewDashboardServlet")
public class ViewDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try (Connection connection = DatabaseConnection.getConnection()) {
            // Retrieve data for the dashboard
            List<Book> books = getBooks(connection);
            List<BorrowRequest> borrowRequests = getBorrowRequests(connection);
            List<User> users = getUsers(connection);

            // Set attributes for JSP
            request.setAttribute("books", books);
            request.setAttribute("borrowRequests", borrowRequests);
            request.setAttribute("users", users);
            request.setAttribute("totalBooks", books.size());
            request.setAttribute("pendingRequests", borrowRequests.size());
            request.setAttribute("approvedMembers", getApprovedMembersCount(users));

            // Forward to viewDashboard.jsp
            request.getRequestDispatcher("viewDashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("errorPage.jsp?error=databaseError");
        }
    }

    private List<Book> getBooks(Connection connection) throws SQLException {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT id, title, author, isbn, category, status FROM books";
        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                Book book = new Book(
                    resultSet.getInt("id"),
                    resultSet.getString("title"),
                    resultSet.getString("author"),
                    resultSet.getString("isbn"),
                    resultSet.getString("category"),
                    resultSet.getString("status")
                );
                books.add(book);
            }
        }
        return books;
    }
    
    private List<BorrowRequest> getBorrowRequests(Connection connection) throws SQLException {
        List<BorrowRequest> borrowRequests = new ArrayList<>();
        String sql = "SELECT username, book_title, status, request_date FROM borrow_requests";
        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                BorrowRequest request = new BorrowRequest(
                    resultSet.getString("username"),
                    resultSet.getString("book_title"),
                    resultSet.getString("status"),
                    resultSet.getDate("request_date")
                );
                borrowRequests.add(request);
            }
        }
        return borrowRequests;
    }

    private List<User> getUsers(Connection connection) throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT username, role, membership, status FROM users";
        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                User user = new User(
                    resultSet.getString("username"),
                    resultSet.getString("role"),
                    resultSet.getString("membership"),
                    resultSet.getString("status")
                );
                users.add(user);
            }
        }
        return users;
    }

    private int getApprovedMembersCount(List<User> users) {
        int count = 0;
        for (User user : users) {
            if ("approved".equalsIgnoreCase(user.getStatus())) {
                count++;
            }
        }
        return count;
    }
}
