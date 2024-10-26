<!-- src/main/webapp/login.jsp -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login - AUCA Library Management System</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
<div class="container">
    <header>
        <h2>AUCA Library Management System</h2>
    </header>
    <form action="loginServlet" method="post">
        <h3>Login</h3>
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required>
        
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required>
        
        <button type="submit">Login</button>
    </form>
    <footer>
        <p>&copy; 2024 AUCA Library</p>
    </footer>
</div>
</body>
</html>
