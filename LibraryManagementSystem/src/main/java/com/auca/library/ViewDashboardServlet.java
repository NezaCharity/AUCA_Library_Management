package com.auca.library;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ViewDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try (Connection connection = DatabaseConnection.getConnection()) {
            // Retrieve and set data for dashboard view
            List<Book> books = getBooks(connection);
            List<BorrowRequest> borrowRequests = getBorrowRequests(connection);
            List<User> users = getUsers(connection);

            int totalBooks = books.size();
            int pendingRequests = (int) borrowRequests.stream().filter(b -> "pending".equalsIgnoreCase(b.getStatus())).count();
            int approvedMembers = (int) users.stream().filter(u -> "approved".equalsIgnoreCase(u.getStatus())).count();

            // Set attributes for JSP
            request.setAttribute("books", books);
            request.setAttribute("borrowRequests", borrowRequests);
            request.setAttribute("users", users);
            request.setAttribute("totalBooks", totalBooks);
            request.setAttribute("pendingRequests", pendingRequests);
            request.setAttribute("approvedMembers", approvedMembers);

            // Debugging output to check data
            System.out.println("Total Books: " + totalBooks);
            System.out.println("Pending Requests: " + pendingRequests);
            System.out.println("Approved Members: " + approvedMembers);

            // Forward to viewDashboard.jsp
            request.getRequestDispatcher("viewDashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("errorPage.jsp?error=databaseError");
        }
    }

    private List<Book> getBooks(Connection connection) throws Exception {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT id, title, author, isbn, category, status FROM books";
        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                books.add(new Book(
                    resultSet.getInt("id"),
                    resultSet.getString("title"),
                    resultSet.getString("author"),
                    resultSet.getString("isbn"),
                    resultSet.getString("category"),
                    resultSet.getString("status")
                ));
            }
        }
        System.out.println("Books retrieved: " + books.size());
        return books;
    }

    private List<BorrowRequest> getBorrowRequests(Connection connection) throws Exception {
        List<BorrowRequest> borrowRequests = new ArrayList<>();
        String sql = "SELECT user_id, book_id, status, request_date FROM borrow_requests";
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
                    
                }
        }
        System.out.println("Borrow requests retrieved: " + borrowRequests.size());
        return borrowRequests;
    }

    private List<User> getUsers(Connection connection) throws Exception {
        List<User> users = new ArrayList<>();
        String sql = "SELECT id, username, role, membership, phone_number, fine, created_at, status FROM users";
        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                users.add(new User(
                    resultSet.getInt("id"),
                    resultSet.getString("username"),
                    resultSet.getString("role"),
                    resultSet.getString("membership"),
                    resultSet.getString("phone_number"),
                    resultSet.getDouble("fine"),
                    resultSet.getTimestamp("created_at"),
                    resultSet.getString("status")
                ));
            }
        }
        System.out.println("Users retrieved: " + users.size());
        return users;
    }
}
