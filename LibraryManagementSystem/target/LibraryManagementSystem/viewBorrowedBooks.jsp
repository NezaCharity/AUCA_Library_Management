<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.ArrayList, com.auca.library.Book" %>
<%
    List<Book> borrowedBooks = (List<Book>) request.getAttribute("borrowedBooks");
    if (borrowedBooks == null) {
        borrowedBooks = new ArrayList<>();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Borrowed Books</title>
</head>
<body>
    <h2>Borrowed Books</h2>
    <table border="1">
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
            <% if (!borrowedBooks.isEmpty()) { 
                for (Book book : borrowedBooks) { %>
                    <tr>
                        <td><%= book.getTitle() %></td>
                        <td><%= book.getAuthor() %></td>
                        <td><%= book.getIsbn() %></td>
                        <td><%= book.getCategory() %></td>
                        <td><%= book.getStatus() %></td>
                    </tr>
            <%   }
               } else { %>
                <tr><td colspan="5">No borrowed books</td></tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>
