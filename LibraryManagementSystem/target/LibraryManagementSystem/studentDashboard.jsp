<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.ArrayList, com.auca.library.Book" %>
<%
    // Validate session and permissions
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
    double overdueFines = (request.getAttribute("overdueFines") != null) ? (double) request.getAttribute("overdueFines") : 0.0;

    // Combine overdue fines with any fine parameter from URL
    String fineParam = request.getParameter("fine");
    if (fineParam != null) {
        overdueFines += Double.parseDouble(fineParam);
    }

    List<Book> borrowedBooks = (List<Book>) request.getAttribute("borrowedBooks");
    if (borrowedBooks == null) {
        borrowedBooks = new ArrayList<>();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Dashboard</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css">
    <style>
        .dashboard-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        .header {
            background-color: #3498db;
            color: #fff;
            padding: 20px;
            text-align: center;
            border-radius: 8px;
            font-size: 1.2em;
        }
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
            font-size: 1.05em;
        }
        .borrowed-books-panel {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 1em;
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
        <!-- Header section with account summary -->
        <div class="header">
            <h2>Welcome, <%= username %></h2>
            <p>Your Library Account Overview</p>
            <div>
                <!-- <span>Borrowed Books: <strong><%= borrowedBooksCount %></strong></span> | -->
                <span>Overdue Fines: <strong>$<%= overdueFines %></strong></span>
            </div>
        </div>

        <!-- Recent Fine Notification -->
        <% if (fineParam != null && Double.parseDouble(fineParam) > 0) { %>
            <p style="color: red; text-align: center;">You were charged a fine of $<%= fineParam %> for a late return.</p>
        <% } %>

        <!-- Quick Links -->
        <div class="quick-links">
            <div class="link-card">
                <a href="LibrarianServlet?action=viewAvailableBooks">📚 View Available Books</a>
                <p>Browse the collection of books available for borrowing.</p>
            </div>
            <div class="link-card">
                <a href="BorrowBookServlet?action=borrowBook">📘 Borrow Books</a>
                <p>Select and borrow a book from the library collection.</p>
            </div>
            <div class="link-card">
                <a href="LibrarianServlet?action=viewBorrowedBooks">📖 View Borrowed Books</a>
                <p>View and manage the books you have currently borrowed.</p>
            </div>
            <div class="link-card">
                <a href="ReturnBookServlet?action=returnBook">📥 Return Books</a>
                <p>Return borrowed books by specifying the return date.</p>
            </div>
        </div>

        <!-- Borrowed Books Table -->
        <!-- <div class="borrowed-books-panel">
            <h3>Currently Borrowed Books</h3>
            <table>
                <thead>
                    <tr>
                        <th>Title</th>
                        <th>Author</th>
                        <th>Due Date</th>
                        <th>Status</th>
                        <th>Return</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (borrowedBooks.isEmpty()) { %>
                        <tr>
                            <td colspan="5">No borrowed books.</td>
                        </tr>
                    <% } else { %>
                        <% for (Book book : borrowedBooks) { %>
                            <tr>
                                <td><%= book.getTitle() %></td>
                                <td><%= book.getAuthor() %></td>
                                <td><%= request.getAttribute("dueDate_" + book.getId()) != null ? request.getAttribute("dueDate_" + book.getId()) : "N/A" %></td>
                                <td>
                                    <span class="<%= "Overdue".equals(request.getAttribute("status_" + book.getId())) ? "status-overdue" : "status-on-time" %>">
                                        <%= request.getAttribute("status_" + book.getId()) != null ? request.getAttribute("status_" + book.getId()) : "N/A" %>
                                    </span>
                                </td>
                                <td>
                                    <form action="ReturnBookServlet" method="post">
                                        <input type="hidden" name="bookId" value="<%= book.getId() %>">
                                        <button type="submit">Return</button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                    <% } %>
                </tbody>
            </table>
        </div> -->
    </div>
</body>
</html>
