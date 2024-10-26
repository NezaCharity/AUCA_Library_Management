// src/main/java/com/auca/library/RegisterServlet.java

package com.auca.library;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/registerServlet")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String membership = request.getParameter("membership");

        String hashedPassword = hashPassword(password);

        // Save user in DB (pseudo-code, replace with actual DB insertion)
        boolean success = saveUserToDatabase(username, hashedPassword, role, membership);

        if (success) {
            response.sendRedirect("login.jsp?message=registered");
        } else {
            response.sendRedirect("register.jsp?error=registrationFailed");
        }
    }

    private String hashPassword(String password) {
        // Placeholder for hashing logic
        return password; // Implement hashing like BCrypt here
    }

    private boolean saveUserToDatabase(String username, String password, String role, String membership) {
        return true; // Implement actual DB insertion
    }
}
