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
        String password = request.getParameter("password"); // plain password from user
        String role = request.getParameter("role");
        String membership = request.getParameter("membership");

        // Location details
        String district = request.getParameter("district");
        String sector = request.getParameter("sector");
        String cell = request.getParameter("cell");
        String village = request.getParameter("village");

        // Hash the password before storing it
        String hashedPassword = PasswordUtils.hashPassword(password);

        boolean isRegistered = saveUserToDatabase(username, hashedPassword, role, membership, district, sector, cell, village);

        if (isRegistered) {
            response.sendRedirect("login.jsp?message=registered");
        } else {
            response.sendRedirect("register.jsp?error=registrationFailed");
        }
    }

    private boolean saveUserToDatabase(String username, String hashedPassword, String role, String membership,
                                       String district, String sector, String cell, String village) {
        try (Connection connection = DatabaseConnection.getConnection()) {
            // Insert into location table first
            String locationSql = "INSERT INTO locations (district, sector, cell, village) VALUES (?, ?, ?, ?)";
            PreparedStatement locationStmt = connection.prepareStatement(locationSql, PreparedStatement.RETURN_GENERATED_KEYS);
            locationStmt.setString(1, district);
            locationStmt.setString(2, sector);
            locationStmt.setString(3, cell);
            locationStmt.setString(4, village);
            locationStmt.executeUpdate();

            // Get the generated location ID
            int locationId = 0;
            var generatedKeys = locationStmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                locationId = generatedKeys.getInt(1);
            }

            // Insert into users table with hashed password
            String userSql = "INSERT INTO users (username, password, role, membership, location_id) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement userStmt = connection.prepareStatement(userSql);
            userStmt.setString(1, username);
            userStmt.setString(2, hashedPassword); // Save hashed password
            userStmt.setString(3, role);
            userStmt.setString(4, membership);
            userStmt.setInt(5, locationId);

            int rowsAffected = userStmt.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
