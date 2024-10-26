// src/main/java/com/auca/library/LoginServlet.java

package com.auca.library;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/loginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get username and password from the form
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Placeholder: Verify credentials (replace with actual database check)
        if (authenticateUser(username, password)) {
            // Get user role (replace with actual retrieval from database)
            String role = getUserRole(username);

            // Store user info in session
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            session.setAttribute("role", role);

            // Redirect based on role
            if ("librarian".equals(role)) {
                response.sendRedirect("WEB-INF/jsp/librarianInterface.jsp");
            } else {
                response.sendRedirect("jsp/browseBooks.jsp");
            }
        } else {
            // If authentication fails, redirect back to login page with an error message
            response.sendRedirect("login.jsp?error=invalid");
        }
    }

    // Placeholder method for user authentication
    private boolean authenticateUser(String username, String password) {
        // TODO: Replace with actual authentication logic (e.g., checking against a hashed password in the database)
        return "admin".equals(username) && "password".equals(password);
    }

    // Placeholder method to retrieve user role
    private String getUserRole(String username) {
        // TODO: Replace with actual role retrieval from database
        if ("admin".equals(username)) {
            return "librarian";
        }
        return "student";
    }
}
