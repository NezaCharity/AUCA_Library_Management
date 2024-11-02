package com.auca.library;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AssignShelfServlet extends HttpServlet {
    
    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    List<Book> books = getAvailableBooks();
    List<Shelf> shelves = getAvailableShelves();

    if (books == null) {
        books = new ArrayList<>();
    }
    if (shelves == null) {
        shelves = new ArrayList<>();
    }

    request.setAttribute("books", books);
    request.setAttribute("shelves", shelves);

    request.getRequestDispatcher("assignShelf.jsp").forward(request, response);
}


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookId = request.getParameter("bookId");
        String shelfId = request.getParameter("shelfId");

        if (bookId != null && shelfId != null) {
            assignShelf(bookId, shelfId);
        }

        response.sendRedirect("librarianDashboard.jsp?message=shelfAssigned");
    }
    private List<Book> getAvailableBooks() {
        List<Book> books = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "SELECT id, title FROM books WHERE shelf_id IS NULL";
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                books.add(new Book(resultSet.getInt("id"), resultSet.getString("title")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return books;
    }
    
    private List<Shelf> getAvailableShelves() {
        List<Shelf> shelves = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "SELECT id, name FROM shelves";
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                shelves.add(new Shelf(resultSet.getInt("id"), resultSet.getString("name")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return shelves;
    }
    

    private void assignShelf(String bookId, String shelfId) {
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "UPDATE books SET shelf_id = ? WHERE id = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, shelfId);
            statement.setString(2, bookId);
            statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
