<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.auca.library.Book" %>
<%
    List<Book> books = (List<Book>) request.getAttribute("books");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Books</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
<div class="container">
    <h2>Manage Books</h2>
    <table border="1">
        <thead>
            <tr>
                <th>Title</th>
                <th>Author</th>
                <th>ISBN</th>
                <th>Category</th>
                <th>Status</th>
                <th>Actions</th>
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
                        <td>
                            <!-- Action buttons (e.g., Edit, Delete) -->
                            <a href="editBook.jsp?id=<%= book.getId() %>">Edit</a> |
                            <a href="deleteBook?id=<%= book.getId() %>">Delete</a>
                        </td>
                    </tr>
            <%     } 
            } else { %>
                <tr>
                    <td colspan="6">No books available</td>
                </tr>
            <% } %>
        </tbody>
    </table>
</div>
</body>
</html>
