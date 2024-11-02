<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.auca.library.Book" %>
<%@ page import="com.auca.library.Shelf" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Assign Book to Shelf</title>
    <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
<div class="container">
    <h2>Assign Book to a Shelf</h2>
    <form action="LibrarianServlet" method="post">
        <input type="hidden" name="action" value="assignShelf">
        
        <label for="bookId">Select Book:</label>
        <select id="bookId" name="bookId" required>
            <option value="">Select a Book</option>
            <% 
                List<Book> books = (List<Book>) request.getAttribute("books");
                if (books != null && !books.isEmpty()) {
                    for (Book book : books) { 
            %>
                <option value="<%= book.getId() %>"><%= book.getTitle() %></option>
            <% 
                    } 
                } else { 
            %>
                <option value="">No books available</option>
            <% 
                } 
            %>
        </select>

        <label for="shelfId">Select Shelf:</label>
        <select id="shelfId" name="shelfId" required>
            <option value="">Select a Shelf</option>
            <% 
                List<Shelf> shelves = (List<Shelf>) request.getAttribute("shelves");
                if (shelves != null && !shelves.isEmpty()) {
                    for (Shelf shelf : shelves) { 
            %>
                <option value="<%= shelf.getId() %>"><%= shelf.getName() %></option>
            <% 
                    } 
                } else { 
            %>
                <option value="">No shelves available</option>
            <% 
                } 
            %>
        </select>

        <button type="submit">Assign Shelf</button>
    </form>
</div>
</body>
</html>
