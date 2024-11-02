package com.auca.library;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;

public class LibrarianServlet extends HttpServlet {

  @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    String action = request.getParameter("action");

    if ("assignShelf".equals(action)) {
        List<Book> books = getAvailableBooks();
        List<Shelf> shelves = getAvailableShelves();
        List<Room> rooms = getRooms();

        request.setAttribute("books", books);
        request.setAttribute("shelves", shelves);
        request.setAttribute("rooms", rooms);
        request.getRequestDispatcher("assignShelf.jsp").forward(request, response);

    } else if ("viewBorrowedBooks".equals(action)) {
        HttpSession session = request.getSession(false);
        String role = (String) session.getAttribute("role");

        if ("student".equals(role)) {
            List<Book> borrowedBooks = getBorrowedBooksForStudent((String) session.getAttribute("username"));
            request.setAttribute("borrowedBooks", borrowedBooks);
            request.getRequestDispatcher("viewBorrowedBooks.jsp").forward(request, response);
        } else {
            response.sendRedirect("librarianDashboard.jsp?error=accessDenied");
        }

    } else if ("viewAvailableBooks".equals(action)) {
        List<Book> availableBooks = getAvailableBooks();
        request.setAttribute("availableBooks", availableBooks);
        request.getRequestDispatcher("viewBooks.jsp").forward(request, response);
    }else if("inventoryReport".equals(action)) {
            List<RoomInventory> roomInventories = getRoomInventories();
            request.setAttribute("roomInventories", roomInventories);
            request.getRequestDispatcher("inventoryReport.jsp").forward(request, response);
        

    } else if ("manageBooks".equals(action)) {
        List<Book> books = getBooks();
        request.setAttribute("books", books);
        request.getRequestDispatcher("manageBooks.jsp").forward(request, response);

    } else if ("createShelf".equals(action)) {
        List<Room> rooms = getRooms();
        request.setAttribute("rooms", rooms);
        request.getRequestDispatcher("createShelf.jsp").forward(request, response);

    } else if ("assignRoom".equals(action)) {
        // This handles the action for assigning a room
        List<Shelf> shelves = getAvailableShelves();
        List<Room> rooms = getRooms();
        
        if (shelves == null) {
            shelves = new ArrayList<>(); // Initialize if null
        }
        if (rooms == null) {
            rooms = new ArrayList<>(); // Initialize if null
        }

        request.setAttribute("shelves", shelves);
        request.setAttribute("rooms", rooms);
        request.getRequestDispatcher("assignRoom.jsp").forward(request, response);

    } else if ("viewBooks".equals(action)) {
        List<Book> availableBooks = getAvailableBooks();
        request.setAttribute("availableBooks", availableBooks);
        request.getRequestDispatcher("viewBooks.jsp").forward(request, response);
    } else {
        request.setAttribute("totalBooks", getTotalBooks());
        request.setAttribute("pendingMembers", getPendingMembers());
        request.setAttribute("approvedMembers", getApprovedMembers());
        request.setAttribute("roomInventories", getRoomInventories());
        request.getRequestDispatcher("librarianDashboard.jsp").forward(request, response);
    }
}

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action) {
            case "assignShelf":
                String bookId = request.getParameter("bookId");
                String shelfId = request.getParameter("shelfId");
                assignShelf(bookId, shelfId);
                response.sendRedirect("librarianDashboard.jsp?message=shelfAssigned");
                break;
            case "approveMember":
                approveMember(request.getParameter("username"));
                response.sendRedirect("librarianDashboard.jsp?message=memberApproved");
                break;
            case "createShelf":
                String shelfName = request.getParameter("shelfName");
                int roomId = Integer.parseInt(request.getParameter("roomId"));
                createShelf(shelfName, roomId);
                response.sendRedirect("librarianDashboard.jsp?message=shelfCreated");
                break;  
            case "rejectMember":
                rejectMember(request.getParameter("username"));
                response.sendRedirect("librarianDashboard.jsp?message=memberRejected");
                break;
            case "registerBook":
                String title = request.getParameter("title");
                String author = request.getParameter("author");
                String isbn = request.getParameter("isbn");
                String category = request.getParameter("category");
                registerBook(title, author, isbn, category);
                response.sendRedirect("librarianDashboard.jsp?message=bookRegistered");
                break;
            default:
                response.sendRedirect("librarianDashboard.jsp?error=invalidAction");
                break;
        }
    }
    private List<Book> getBorrowedBooksForStudent(String username) {
        List<Book> borrowedBooks = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "SELECT b.id, b.title, b.author, b.isbn, b.category, b.status FROM books b " +
                         "JOIN borrows br ON b.id = br.book_id " +
                         "JOIN users u ON br.user_id = u.id " +
                         "WHERE u.username = ? AND b.status = 'borrowed'";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, username);
            ResultSet resultSet = statement.executeQuery();
    
            while (resultSet.next()) {
                int id = resultSet.getInt("id");
                String title = resultSet.getString("title");
                String author = resultSet.getString("author");
                String isbn = resultSet.getString("isbn");
                String category = resultSet.getString("category");
                String status = resultSet.getString("status");
    
                borrowedBooks.add(new Book(id, title, author, isbn, category, status));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return borrowedBooks;
    }
    

    private List<Shelf> getAvailableShelves() {
        List<Shelf> shelves = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "SELECT id, name FROM shelves";
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet resultSet = statement.executeQuery();
    
            while (resultSet.next()) {
                int id = resultSet.getInt("id");
                String name = resultSet.getString("name");
    
                shelves.add(new Shelf(id, name));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return shelves;
    }
    

    private List<Room> getRooms() {
        List<Room> rooms = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "SELECT id, name FROM rooms";
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet resultSet = statement.executeQuery();
    
            while (resultSet.next()) {
               int id = resultSet.getInt("id");
                String name = resultSet.getString("name");
                rooms.add(new Room(id, name));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rooms;
    }
    
    

    private void createShelf(String shelfName, int roomId) {
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "INSERT INTO shelves (name, room_id) VALUES (?, ?)";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, shelfName);
            statement.setInt(2, roomId);
            statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private List<Book> getBooks() {
        List<Book> books = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "SELECT id, title, author, isbn, category, status FROM books";
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                int id = resultSet.getInt("id");
                String title = resultSet.getString("title");
                String author = resultSet.getString("author");
                String isbn = resultSet.getString("isbn");
                String category = resultSet.getString("category");
                String status = resultSet.getString("status");

                books.add(new Book(id, title, author, isbn, category, status));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return books;
    }

   // Method to retrieve available books from the database
   private List<Book> getAvailableBooks() {
    List<Book> books = new ArrayList<>();
    try (Connection connection = DatabaseConnection.getConnection()) {
        String sql = "SELECT id, title, author, isbn, category, status FROM books WHERE status = 'available'";
        PreparedStatement statement = connection.prepareStatement(sql);
        ResultSet resultSet = statement.executeQuery();

        while (resultSet.next()) {
            int id = resultSet.getInt("id");
            String title = resultSet.getString("title");
            String author = resultSet.getString("author");
            String isbn = resultSet.getString("isbn");
            String category = resultSet.getString("category");
            String status = resultSet.getString("status");

            books.add(new Book(id, title, author, isbn, category, status));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return books;
}

private List<BorrowedBook> getBorrowedBooks(String username) {
    List<BorrowedBook> borrowedBooks = new ArrayList<>();
    try (Connection connection = DatabaseConnection.getConnection()) {
        String sql = "SELECT b.title, b.author, br.borrow_date, br.due_date, " +
                     "CASE WHEN br.return_date IS NULL AND br.due_date < CURRENT_DATE THEN 'Overdue' ELSE 'On Time' END AS status " +
                     "FROM books b " +
                     "JOIN borrows br ON b.id = br.book_id " +
                     "JOIN users u ON br.user_id = u.id " +
                     "WHERE u.username = ? AND br.return_date IS NULL";
        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setString(1, username);
        ResultSet resultSet = statement.executeQuery();

        while (resultSet.next()) {
            String title = resultSet.getString("title");
            String author = resultSet.getString("author");
            Date borrowDate = resultSet.getDate("borrow_date");
            Date dueDate = resultSet.getDate("due_date");
            String status = resultSet.getString("status");

            borrowedBooks.add(new BorrowedBook(title, author, borrowDate, dueDate, status));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return borrowedBooks;
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

    private void approveMember(String username) {
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "UPDATE users SET status = 'approved' WHERE username = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, username);
            statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void rejectMember(String username) {
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "UPDATE users SET status = 'rejected' WHERE username = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, username);
            statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void registerBook(String title, String author, String isbn, String category) {
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "INSERT INTO books (title, author, isbn, category, status) VALUES (?, ?, ?, ?, 'available')";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, title);
            statement.setString(2, author);
            statement.setString(3, isbn);
            statement.setString(4, category);
            statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private int getTotalBooks() {
        int totalBooks = 0;
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "SELECT COUNT(*) AS total FROM books";
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                totalBooks = resultSet.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return totalBooks;
    }

    private List<String> getPendingMembers() {
        List<String> pendingMembers = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "SELECT username FROM users WHERE status = 'pending'";
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                pendingMembers.add(resultSet.getString("username"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return pendingMembers;
    }

    private int getApprovedMembers() {
        int approvedMembers = 0;
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "SELECT COUNT(*) AS total FROM users WHERE status = 'approved'";
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                approvedMembers = resultSet.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return approvedMembers;
    }

    private List<RoomInventory> getRoomInventories() {
        List<RoomInventory> roomInventories = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "SELECT r.name AS roomName, COUNT(b.id) AS bookCount " +
                         "FROM rooms r LEFT JOIN shelves s ON r.id = s.room_id " +
                         "LEFT JOIN books b ON s.id = b.shelf_id " +
                         "GROUP BY r.name";
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet resultSet = statement.executeQuery();
    
            while (resultSet.next()) {
                String roomName = resultSet.getString("roomName");
                int bookCount = resultSet.getInt("bookCount");
                roomInventories.add(new RoomInventory(roomName, bookCount));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return roomInventories;
    }
    
}
