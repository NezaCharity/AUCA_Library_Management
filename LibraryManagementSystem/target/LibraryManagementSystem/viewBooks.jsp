<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.auca.library.Book, java.util.ArrayList" %>
<%
    List<Book> availableBooks = (List<Book>) request.getAttribute("availableBooks");
    if (availableBooks == null) {
        availableBooks = new ArrayList<>();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Available Books</title>
</head>
<body>
    <h2>Available Books</h2>
    <table border="1">
        <thead>
            <tr>
                <th>Title</th>
                <th>Author</th>
                <th>ISBN</th>
                <th>Category</th>
            </tr>
        </thead>
        <tbody>
            <% if (!availableBooks.isEmpty()) { 
                for (Book book : availableBooks) { %>
                    <tr>
                        <td><%= book.getTitle() %></td>
                        <td><%= book.getAuthor() %></td>
                        <td><%= book.getIsbn() %></td>
                        <td><%= book.getCategory() %></td>
                    </tr>
            <%   }
               } else { %>
                <tr><td colspan="4">No available books</td></tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>
