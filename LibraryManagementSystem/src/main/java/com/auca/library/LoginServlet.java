// src/main/java/com/auca/library/LoginServlet.java

package com.auca.library;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

//@WebServlet("/loginServlet")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Hash the entered password for comparison
        String hashedPassword = PasswordUtils.hashPassword(password);

        String role = authenticateUser(username, hashedPassword);

        if (role != null) {
            HttpSession session = request.getSession();
            session.setAttribute("username", username);  // Username retrieved from login
            session.setAttribute("role", role);      // userRole should be assigned based on the user's role
            
            

            // Redirect based on role
            switch (role) {
                case "librarian":
                    response.sendRedirect(request.getContextPath() + "/librarianDashboard.jsp");
                    break;
                case "teacher":
                    response.sendRedirect(request.getContextPath() + "/teacherDashboard.jsp");
                    break;
                case "student":
                response.sendRedirect(request.getContextPath() + "/studentDashboard.jsp");

                    break;
                default:
                    // If the role doesn't match any specific dashboard, redirect to a generic page or show an error
                    response.sendRedirect("login.jsp?error=invalidRole");
            }
        } else {
            // Invalid login, redirect back to login page with an error message
            response.sendRedirect("login.jsp?error=invalidCredentials");
        }
    }

    private String authenticateUser(String username, String hashedPassword) {
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "SELECT role FROM users WHERE username = ? AND password = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, username);
            statement.setString(2, hashedPassword);

            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getString("role");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
