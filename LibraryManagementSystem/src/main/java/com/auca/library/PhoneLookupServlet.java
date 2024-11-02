package com.auca.library;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


//@WebServlet("/PhoneLookupServlet") 
public class PhoneLookupServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String phoneNumber = request.getParameter("phoneNumber");

        // Check if phone number is provided
        if (phoneNumber == null || phoneNumber.isEmpty()) {
            response.sendRedirect("phonelookup.jsp?error=Phone number required");
            return;
        }

        String provinceName = getProvinceByPhoneNumber(phoneNumber);

        // Redirect with province information or an error message
        if (provinceName != null) {
            response.sendRedirect("phonelookup.jsp?province=" + provinceName);
        } else {
            response.sendRedirect("phonelookup.jsp?error=Phone number not found");
        }
    }

    private String getProvinceByPhoneNumber(String phoneNumber) {
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "SELECT locations.province FROM users " +
                         "JOIN locations ON users.location_id = locations.id " +
                         "WHERE users.phoneNumber = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, phoneNumber);

            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getString("province");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
