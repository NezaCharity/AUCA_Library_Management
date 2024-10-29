<!-- src/main/webapp/jsp/librarianInterface.jsp -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Librarian Dashboard</title>
    <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
<div class="container">
    <header>
        <h2>Librarian Dashboard</h2>
    </header>
    <div class="card">
        <h3>Membership Approvals</h3>
        <ul>
            <li>User1 <button onclick="showAlert('Approved')">Approve</button></li>
            <li>User2 <button onclick="showAlert('Approved')">Approve</button></li>
        </ul>
    </div>
    <div class="card">
        <h3>Assign Book to Shelf</h3>
        <form action="assignBookServlet" method="post">
            <input type="text" name="bookId" placeholder="Book ID">
            <input type="text" name="shelfId" placeholder="Shelf ID">
            <button type="submit">Assign</button>
        </form>
    </div>
</div>
<script src="../js/scripts.js"></script>
</body>
</html>
