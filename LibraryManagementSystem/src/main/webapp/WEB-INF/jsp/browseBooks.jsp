<!-- src/main/webapp/jsp/browseBooks.jsp -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.auca.library.Book" %>
<jsp:useBean id="bookList" class="java.util.ArrayList" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Browse Books - AUCA Library</title>
    <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
<div class="container">
    <header>
        <h2>Available Books</h2>
    </header>
    <ul>
        <c:forEach items="${bookList}" var="book">
            <li>
                <strong>${book.title}</strong> by ${book.author} (${book.category})
            </li>
        </c:forEach>
    </ul>
    <footer>
        <button onclick="navigateTo('../login.jsp')">Back to Login</button>
    </footer>
</div>
<script src="../js/scripts.js"></script>
</body>
</html>
