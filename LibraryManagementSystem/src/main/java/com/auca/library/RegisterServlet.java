package com.auca.library;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;


//@WebServlet("/RegisterServlet") 
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String membership = request.getParameter("membership");
        String phoneNumber = request.getParameter("phoneNumber");

        // Location details
        String province = request.getParameter("province");
        String district = request.getParameter("district");
        String sector = request.getParameter("sector");
        String cell = request.getParameter("cell");
        String village = request.getParameter("village");

        // Hash the password before storing it
        String hashedPassword = PasswordUtils.hashPassword(password);

        boolean isRegistered = saveUserToDatabase(username, hashedPassword, role, membership, phoneNumber, province, district, sector, cell, village);

        if (isRegistered) {
            response.sendRedirect("login.jsp?message=registered");
        } else {
            response.sendRedirect("register.jsp?error=registrationFailed");
        }
    }

    private boolean saveUserToDatabase(String username, String hashedPassword, String role, String membership,
                                       String phoneNumber, String province, String district, String sector, String cell, String village) {
        try (Connection connection = DatabaseConnection.getConnection()) {
            // Insert into locations table
            String locationSql = "INSERT INTO locations (province, district, sector, cell, village) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement locationStmt = connection.prepareStatement(locationSql, PreparedStatement.RETURN_GENERATED_KEYS);
            locationStmt.setString(1, province);
            locationStmt.setString(2, district);
            locationStmt.setString(3, sector);
            locationStmt.setString(4, cell);
            locationStmt.setString(5, village);
            locationStmt.executeUpdate();

            // Get the generated location ID
            int locationId = 0;
            var generatedKeys = locationStmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                locationId = generatedKeys.getInt(1);
            }

            // Insert into users table with status as 'pending'
            String userSql = "INSERT INTO users (username, password, role, membership, phoneNumber, location_id, status) VALUES (?, ?, ?, ?, ?, ?, 'pending')";
            PreparedStatement userStmt = connection.prepareStatement(userSql);
            userStmt.setString(1, username);
            userStmt.setString(2, hashedPassword);
            userStmt.setString(3, role);
            userStmt.setString(4, membership);
            userStmt.setString(5, phoneNumber);
            userStmt.setInt(6, locationId);

            int rowsAffected = userStmt.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
