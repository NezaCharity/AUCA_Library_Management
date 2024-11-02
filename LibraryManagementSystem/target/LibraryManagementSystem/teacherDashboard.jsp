<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession session = request.getSession(false);
    String role = (String) session.getAttribute("role");

    if (session == null || role == null || (!"teacher".equals(role) && !"student".equals(role))) {
        response.sendRedirect("../login.jsp?error=accessDenied");
        return;
    }

    // Example data for demonstration (replace with data from database)
    String username = (String) session.getAttribute("username");
    int borrowedBooksCount = 2;
    int overdueBooksCount = 1;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Teacher Dashboard</title>
    <link rel="stylesheet" href="../css/styles.css">
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
        <p>Your Library Activity Overview</p>
        <div>
            <span>Borrowed Books: <strong><%= borrowedBooksCount %></strong></span> |
            <span>Overdue Books: <strong><%= overdueBooksCount %></strong></span>
        </div>
    </div>

    <!-- Quick Links -->
    <div class="quick-links">
        <div class="link-card">
            <a href="viewBooks.jsp">📚 View Available Books</a>
            <p>Browse the collection of books available for borrowing.</p>
        </div>
        <div class="link-card">
            <a href="borrowBook.jsp">📖 Borrow a Book</a>
            <p>Select and borrow a book from the library collection.</p>
        </div>
        <div class="link-card">
            <a href="viewBorrowedBooks.jsp">📋 My Borrowed Books</a>
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
                <% 
                    // Example data, replace with dynamic content from the database
                    String[][] borrowedBooks = { 
                        {"Educational Psychology", "John Doe", "2024-11-10", "On Time"},
                        {"Advanced Mathematics", "Jane Smith", "2024-11-05", "Overdue"}
                    };
                    for (String[] book : borrowedBooks) { 
                        String statusClass = "Overdue".equals(book[3]) ? "status-overdue" : "status-on-time";
                %>
                    <tr>
                        <td><%= book[0] %></td>
                        <td><%= book[1] %></td>
                        <td><%= book[2] %></td>
                        <td><span class="<%= statusClass %>"><%= book[3] %></span></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <!-- Notifications Panel -->
    <div class="notifications-panel">
        <h3>Notifications</h3>
        <div class="notification-item">
            <p><strong>Overdue:</strong> "Advanced Mathematics" was due on 2024-11-05. Please return it as soon as possible to avoid additional fines.</p>
        </div>
        <div class="notification-item">
            <p>New arrivals in <strong>Education</strong> category! Check out the latest books in the <a href="viewBooks.jsp">Available Books</a> section.</p>
        </div>
        <!-- More notifications can be added here -->
    </div>
</div>
</body>
</html>
