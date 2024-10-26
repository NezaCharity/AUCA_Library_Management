<!-- src/main/webapp/jsp/librarianInterface.jsp -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.auca.library.User" %>
<jsp:useBean id="userList" class="java.util.ArrayList" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Librarian Dashboard - AUCA Library</title>
    <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
<div class="container">
    <header>
        <h2>Librarian Dashboard</h2>
    </header>

    <h3>Membership Requests</h3>
    <ul>
        <c:forEach items="${userList}" var="user">
            <li>${user.username} - ${user.membership} <button>Approve</button></li>
        </c:forEach>
    </ul>

    <h3>Assign Book to Shelf</h3>
    <form action="assignBookServlet" method="post">
        <label for="bookId">Book ID:</label>
        <input type="text" id="bookId" name="bookId" required>
        
        <label for="shelfId">Shelf ID:</label>
        <input type="text" id="shelfId" name="shelfId" required>
        
        <button type="submit">Assign</button>
    </form>

    <h3>Check Room Book Count</h3>
    <form action="checkRoomServlet" method="get">
        <label for="roomId">Room ID:</label>
        <input type="text" id="roomId" name="roomId" required>
        
        <button type="submit">Check</button>
    </form>

    <footer>
        <button onclick="navigateTo('../login.jsp')">Logout</button>
    </footer>
</div>
<script src="../js/scripts.js"></script>
</body>
</html>
