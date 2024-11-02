<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.ArrayList, com.auca.library.Book, com.auca.library.Shelf" %>
<%
    List<Book> books = (List<Book>) request.getAttribute("books");
    List<Shelf> shelves = (List<Shelf>) request.getAttribute("shelves");

    if (books == null) {
        books = new ArrayList<>(); // Initialize to avoid null pointer exceptions
    }
    if (shelves == null) {
        shelves = new ArrayList<>();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head><title>Assign Shelf</title></head>
<body>
    <form action="AssignShelfServlet" method="post">
        <label for="bookId">Select Book:</label>
        <select name="bookId" id="bookId">
            <option value="">Select a Book</option>
            <% for (Book book : books) { %>
                <option value="<%= book.getId() %>"><%= book.getTitle() %></option>
            <% } %>
        </select>

        <label for="shelfId">Select Shelf:</label>
        <select name="shelfId" id="shelfId">
            <option value="">Select a Shelf</option>
            <% for (Shelf shelf : shelves) { %>
                <option value="<%= shelf.getId() %>"><%= shelf.getName() %></option>
            <% } %>
        </select>

        <button type="submit">Assign Shelf</button>
    </form>
</body>
</html>
