<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.ArrayList, com.auca.library.Book" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>HOD Dashboard</title>
</head>
<body>
<div class="container">
    <h2>HOD Dashboard - Overview</h2>
    <!-- Display books and borrow requests relevant to HODs -->
    <h3>Library Books</h3>
    <table>
        <thead>
            <tr><th>Title</th><th>Author</th><th>Category</th><th>Status</th></tr>
        </thead>
        <tbody>
            <% List<Book> books = (List<Book>) request.getAttribute("books");
               if (books != null) {
                   for (Book book : books) { %>
                       <tr>
                           <td><%= book.getTitle() %></td>
                           <td><%= book.getAuthor() %></td>
                           <td><%= book.getCategory() %></td>
                           <td><%= book.getStatus() %></td>
                       </tr>
            <%     }
               } %>
        </tbody>
    </table>
</div>
</body>
</html>
