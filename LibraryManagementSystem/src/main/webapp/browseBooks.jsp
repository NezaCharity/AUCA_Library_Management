<!-- src/main/webapp/jsp/browseBooks.jsp -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <div class="card">
        <input type="text" id="search" placeholder="Search by title or category">
        <ul id="bookList">
            <!-- Book items populated from server -->
        </ul>
    </div>
</div>
<script src="../js/scripts.js"></script>
</body>
</html>
