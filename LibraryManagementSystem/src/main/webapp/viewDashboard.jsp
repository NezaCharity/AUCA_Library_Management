<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.ArrayList, com.auca.library.Book, com.auca.library.BorrowRequest, com.auca.library.User" %>

<%-- Use session to retrieve role for access control --%>
<%
    String role = (session != null) ? (String) session.getAttribute("role") : null;

    if (session == null || role == null || (!role.equals("HOD") && !role.equals("Dean") && !role.equals("Teacher"))) {
        response.sendRedirect("login.jsp?error=accessDenied");
        return;
    }

    List<Book> books = (List<Book>) request.getAttribute("books");
    List<BorrowRequest> borrowRequests = (List<BorrowRequest>) request.getAttribute("borrowRequests");
    List<User> users = (List<User>) request.getAttribute("users");
    int totalBooks = (request.getAttribute("totalBooks") != null) ? (int) request.getAttribute("totalBooks") : 0;
    int pendingRequests = (request.getAttribute("pendingRequests") != null) ? (int) request.getAttribute("pendingRequests") : 0;
    int approvedMembers = (request.getAttribute("approvedMembers") != null) ? (int) request.getAttribute("approvedMembers") : 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Library Dashboard - View Only</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css">
    <style>
        .dashboard-container { max-width: 1200px; margin: 0 auto; padding: 20px; }
        h2, h3 { text-align: center; color: #333; }
        .stat-boxes { display: flex; justify-content: space-between; margin: 20px 0; }
        .stat-box { background-color: #3498db; color: #fff; padding: 20px; border-radius: 8px; text-align: center; width: 30%; }
        .table-container { margin-top: 30px; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        th, td { padding: 12px; border: 1px solid #ddd; text-align: center; }
        th { background-color: #f4f4f4; }
    </style>
</head>
<body>
<div class="dashboard-container">
    <h2>Welcome, <%= role %> - Library Dashboard (View Only)</h2>

    <!-- Statistics Section -->
    <div class="stat-boxes">
        <div class="stat-box">
            <h3>Total Books</h3>
            <p><strong><%= totalBooks %></strong></p>
        </div>
        <div class="stat-box">
            <h3>Pending Borrow Requests</h3>
            <p><strong><%= pendingRequests %></strong></p>
        </div>
        <div class="stat-box">
            <h3>Approved Members</h3>
            <p><strong><%= approvedMembers %></strong></p>
        </div>
    </div>

    <!-- Books Table -->
    <div class="table-container">
        <h3>Library Books</h3>
        <table>
            <thead>
                <tr>
                    <th>Title</th>
                    <th>Author</th>
                    <th>ISBN</th>
                    <th>Category</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <% if (books != null && !books.isEmpty()) { 
                    for (Book book : books) { %>
                        <tr>
                            <td><%= book.getTitle() %></td>
                            <td><%= book.getAuthor() %></td>
                            <td><%= book.getIsbn() %></td>
                            <td><%= book.getCategory() %></td>
                            <td><%= book.getStatus() %></td>
                        </tr>
                <%     } 
                } else { %>
                    <tr>
                        <td colspan="5">No books available</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <!-- Borrow Requests Table -->
    <div class="table-container">
        <h3>Borrow Requests</h3>
        <table>
            <thead>
                <tr>
                    <th>Username</th>
                    <th>Book Title</th>
                    <th>Status</th>
                    <th>Request Date</th>
                </tr>
            </thead>
            <tbody>
                <% if (borrowRequests != null && !borrowRequests.isEmpty()) { 
                    for (BorrowRequest requestItem : borrowRequests) { %>
                        <tr>
                            <td><%= requestItem.getUsername() %></td>
                            <td><%= requestItem.getBookTitle() %></td>
                            <td><%= requestItem.getStatus() %></td>
                            <td><%= requestItem.getRequestDate() %></td>
                        </tr>
                <%     } 
                } else { %>
                    <tr>
                        <td colspan="4">No borrow requests</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <!-- Users Table -->
    <div class="table-container">
        <h3>Library Members</h3>
        <table>
            <thead>
                <tr>
                    <th>Username</th>
                    <th>Role</th>
                    <th>Membership</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <% if (users != null && !users.isEmpty()) { 
                    for (User user : users) { %>
                        <tr>
                            <td><%= user.getUsername() %></td>
                            <td><%= user.getRole() %></td>
                            <td><%= user.getMembership() %></td>
                            <td><%= user.getStatus() %></td>
                        </tr>
                <%     } 
                } else { %>
                    <tr>
                        <td colspan="4">No members found</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
