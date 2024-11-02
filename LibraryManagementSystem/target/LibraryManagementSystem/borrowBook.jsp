<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.ArrayList, com.auca.library.Book" %>
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
    <title>Borrow a Book</title>
</head>
<body>
    <h2>Borrow a Book</h2>
    <form action="BorrowBookServlet" method="post">
        <label for="bookId">Select Book:</label>
        <select id="bookId" name="bookId" required>
            <option value="">Choose a Book</option>
            <% for (Book book : availableBooks) { %>
                <option value="<%= book.getId() %>"><%= book.getTitle() %> - <%= book.getAuthor() %></option>
            <% } %>
        </select>
        <button type="submit">Borrow</button>
    </form>
</body>
</html>
