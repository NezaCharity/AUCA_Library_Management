// src/main/java/com/auca/library/BorrowBookServlet.java

package com.auca.library;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/borrowBookServlet")
public class BorrowBookServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = (String) request.getSession().getAttribute("username");
        String bookId = request.getParameter("bookId");

        // Check borrowing limit and membership rules (placeholder logic)
        if (canUserBorrowMoreBooks(username)) {
            borrowBook(username, bookId);
            response.sendRedirect("jsp/browseBooks.jsp?message=borrowed");
        } else {
            response.sendRedirect("jsp/browseBooks.jsp?error=limitExceeded");
        }
    }

    private boolean canUserBorrowMoreBooks(String username) {
        return true; // Placeholder, implement actual DB checks
    }

    private void borrowBook(String username, String bookId) {
        // Implement DB logic for borrowing a book
    }
}
