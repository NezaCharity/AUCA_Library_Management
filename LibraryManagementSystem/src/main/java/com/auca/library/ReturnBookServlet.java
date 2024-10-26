// src/main/java/com/auca/library/ReturnBookServlet.java

package com.auca.library;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;


@WebServlet("/returnBookServlet")
public class ReturnBookServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = (String) request.getSession().getAttribute("username");
        String bookId = request.getParameter("bookId");

        boolean isLate = checkIfReturnIsLate(bookId);
        if (isLate) {
            applyLateFee(username, bookId);
        }

        returnBook(username, bookId);
        response.sendRedirect("jsp/browseBooks.jsp?message=returned");
    }

    private boolean checkIfReturnIsLate(String bookId) {
        return true; // Placeholder for due date check
    }

    private void applyLateFee(String username, String bookId) {
        // Implement fee application
    }

    private void returnBook(String username, String bookId) {
        // Implement book return logic in DB
    }
}
