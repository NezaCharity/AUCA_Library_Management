<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.ArrayList, com.auca.library.BorrowedBook" %>
<%
    if (session == null || session.getAttribute("role") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=accessDenied");
        return;
    }

    String role = (String) session.getAttribute("role");
    if (!"student".equals(role) && !"teacher".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=accessDenied");
        return;
    }

    String username = (String) session.getAttribute("username");
    int borrowedBooksCount = (request.getAttribute("borrowedBooksCount") != null) ? (int) request.getAttribute("borrowedBooksCount") : 0;
    int overdueFines = (request.getAttribute("overdueFines") != null) ? (int) request.getAttribute("overdueFines") : 0;
    List<BorrowedBook> borrowedBooks = (List<BorrowedBook>) request.getAttribute("borrowedBooks");
    if (borrowedBooks == null) {
        borrowedBooks = new ArrayList<>();  // Initialize with an empty list if null
    }
%>


<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Student Dashboard</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css">
    <style>
        /* Container */
        .dashboard-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        /* Header */
        .header {
            background-color: #3498db;
            color: #fff;
            padding: 20px;
            text-align: center;
            border-radius: 8px;
        }

        /* Quick Links */
        .quick-links {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            justify-content: space-between;
        }

        .link-card {
            background: #ECF0F1;
            width: 30%;
            padding: 15px;
            text-align: center;
            border-radius: 8px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s;
        }

        .link-card:hover {
            transform: translateY(-5px);
        }

        .link-card a {
            text-decoration: none;
            color: #2C3E50;
            font-weight: bold;
        }

        /* Borrowed Books Panel */
        .borrowed-books-panel {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }

        th {
            background-color: #f4f4f4;
            color: #333;
        }

        /* Notifications Panel */
        .notifications-panel {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        }

        .notification-item {
            border-bottom: 1px solid #BDC3C7;
            padding: 10px 0;
            color: #2C3E50;
        }

        .notification-item:last-child {
            border-bottom: none;
        }

        .notification-item p {
            margin: 0;
        }

        .notification-item strong {
            color: #e74c3c;
        }

        /* Status Colors */
        .status-on-time {
            color: green;
        }

        .status-overdue {
            color: red;
        }
    </style>
</head>

<body>
    <div class="dashboard-container">
        <div class="header">
            <h2>Welcome, <%= username %></h2>
            <p>Your Library Account Overview</p>
            <div>
                <span>Borrowed Books: <strong><%= borrowedBooksCount %></strong></span> |
                <span>Overdue Fines: <strong>$<%= overdueFines %></strong></span>
            </div>
        </div>
    
        <!-- Quick Links -->
        <div class="quick-links">
            <div class="link-card">
                <a href="LibrarianServlet?action=viewAvailableBooks">📚 View Available Books</a>

                <p>Browse the collection of books available for borrowing.</p>
            </div>
            <div class="link-card">
                <a href="BorrowBookServlet?action=borrowBook">📚 Borrow Books</a>

                <p>Select and borrow a book from the library collection.</p>
            </div>
            <div class="link-card">
                <a href="LibrarianServlet?action=viewBorrowedBooks">📚 View Borrowed Books</a>
                <p>View and manage the books you’ve currently borrowed.</p>
            </div>
           
            
        </div>
    
        <!-- Borrowed Books Panel -->
        <div class="borrowed-books-panel">
            <h3>Currently Borrowed Books</h3>
            <table>
                <thead>
                    <tr>
                        <th>Title</th>
                        <th>Author</th>
                        <th>Due Date</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (BorrowedBook book : borrowedBooks) { %>
                        <tr>
                            <td><%= book.getTitle() %></td>
                            <td><%= book.getAuthor() %></td>
                            <td><%= book.getDueDate() %></td>
                            <td>
                                <span class="<%= "Overdue".equals(book.getStatus()) ? "status-overdue" : "status-on-time" %>">
                                    <%= book.getStatus() %>
                                </span>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    </body>
    </html>
