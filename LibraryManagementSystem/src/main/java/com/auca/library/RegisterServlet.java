// src/main/java/com/auca/library/RegisterServlet.java

package com.auca.library;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/registerServlet")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String membership = request.getParameter("membership");
        String location = request.getParameter("location");

        boolean isRegistered = saveUserToDatabase(username, password, role, membership, location);

        if (isRegistered) {
            response.sendRedirect("login.jsp?message=registered");
        } else {
            response.sendRedirect("register.jsp?error=registrationFailed");
        }
    }

    private boolean saveUserToDatabase(String username, String password, String role, String membership, String location) {
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "INSERT INTO users (username, password, role, membership, location_id) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement statement = connection.prepareStatement(sql);

            statement.setString(1, username);
            statement.setString(2, password); // For security, hash the password before saving
            statement.setString(3, role);
            statement.setString(4, membership);
            statement.setString(5, location);

            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
