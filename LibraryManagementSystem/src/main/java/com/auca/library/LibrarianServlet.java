// src/main/java/com/auca/library/LibrarianServlet.java

package com.auca.library;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/librarianServlet")
public class LibrarianServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action) {
            case "approveMember":
                approveMember(request.getParameter("username"));
                response.sendRedirect("WEB-INF/jsp/librarianInterface.jsp?message=approved");
                break;
            case "assignShelf":
                assignShelf(request.getParameter("bookId"), request.getParameter("shelfId"));
                response.sendRedirect("WEB-INF/jsp/librarianInterface.jsp?message=assigned");
                break;
            case "checkRoomBooks":
                int count = checkBooksInRoom(request.getParameter("roomId"));
                response.sendRedirect("WEB-INF/jsp/librarianInterface.jsp?count=" + count);
                break;
        }
    }

    private void approveMember(String username) {
        // Implement approval logic in DB
    }

    private void assignShelf(String bookId, String shelfId) {
        // Implement shelf assignment in DB
    }

    private int checkBooksInRoom(String roomId) {
        return 10; // Placeholder for DB count
    }
}
