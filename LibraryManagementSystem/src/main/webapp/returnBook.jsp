<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.auca.library.Book" %>
<%
    List<Book> borrowedBooks = (List<Book>) request.getAttribute("borrowedBooks");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Return a Book</title>
</head>
<body>
    <h2>Return a Book</h2>
    
    <% if (borrowedBooks == null || borrowedBooks.isEmpty()) { %>
        <p>You have no books to return.</p>
    <% } else { %>
        <form action="ReturnBookServlet" method="post">
            <label for="bookId">Select Book to Return:</label>
            <select id="bookId" name="bookId" required>
                <% for (Book book : borrowedBooks) { %>
                    <option value="<%= book.getId() %>"><%= book.getTitle() %> - Due: <%= request.getAttribute("dueDate_" + book.getId()) %></option>
                <% } %>
            </select>
            
            <label for="returnDate">Return Date:</label>
            <input type="date" id="returnDate" name="returnDate" required>

            <button type="submit">Return Book</button>
        </form>
    <% } %>
</body>
</html>
