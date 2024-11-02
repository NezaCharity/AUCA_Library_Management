<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register Book</title>
    <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
<div class="container">
    <h2>Register a New Book</h2>
    <form action="${pageContext.request.contextPath}/RegisterBookServlet" method="post">
        <input type="hidden" name="action" value="registerBook">
        
        <label for="title">Book Title:</label>
        <input type="text" id="title" name="title" required>

        <label for="author">Author:</label>
        <input type="text" id="author" name="author" required>

        <label for="isbn">ISBN:</label>
        <input type="text" id="isbn" name="isbn" required>

        <label for="category">Category:</label>
        <input type="text" id="category" name="category" required>

        <button type="submit">Register Book</button>
    </form>
</div>
</body>
</html>
