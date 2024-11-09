<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.ArrayList, com.auca.library.Book" %>
<%
    List<Book> availableBooks = (List<Book>) request.getAttribute("availableBooks");
    if (availableBooks == null) {
        availableBooks = new ArrayList<>();
    }
    Boolean borrowLimitReached = (Boolean) request.getAttribute("borrowLimitReached");
    if (borrowLimitReached == null) {
        borrowLimitReached = false;
    }
%>
<% if (request.getParameter("error") != null && "borrowLimitReached".equals(request.getParameter("error"))) { %>
    <p style="color: red;">You have reached your borrow limit. Please return some books to borrow new ones.</p>
<% } %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Borrow a Book</title>
    <style>
        .message {
            color: red;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
            color: #333;
        }
        label, select, button {
            display: block;
            width: 100%;
            margin: 10px 0;
            font-size: 16px;
        }
        button {
            padding: 10px;
            color: #fff;
            background-color: #007bff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        button:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Borrow a Book</h2>
    <% if (borrowLimitReached) { %>
        <p class="message">You have reached your borrowing limit for your membership. Please return a book to borrow a new one.</p>
    <% } else { %>
        <form action="BorrowBookServlet" method="post">
            <label for="bookId">Select Book:</label>
            <select id="bookId" name="bookId" required>
                <option value="">Choose a Book</option>
                <% for (Book book : availableBooks) { %>
                    <option value="<%= book.getId() %>"><%= book.getTitle() %> - <%= book.getAuthor() %></option>
                <% } %>
            </select>
            <label for="returnDate">Select Return Date:</label>
            <input type="date" id="returnDate" name="returnDate" required>
            <button type="submit">Borrow</button>
        </form>
    <% } %>
</div>
</body>
</html>
