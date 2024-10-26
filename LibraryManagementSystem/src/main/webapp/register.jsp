<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register - AUCA Library Management</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
<div class="container">
    <header>
        <h2>Create Your AUCA Library Account</h2>
    </header>
    <div class="card">
        <form action="registerServlet" method="post">
            <h3>Register</h3>
            
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>
            
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>

            <label for="role">Role:</label>
            <select id="role" name="role" required>
                <option value="student">Student</option>
                <option value="teacher">Teacher</option>
                <option value="librarian">Librarian</option>
                <option value="HOD">Head of Department</option>
                <option value="dean">Dean</option>
            </select>

            <label for="membership">Membership Type:</label>
            <select id="membership" name="membership" required>
                <option value="gold">Gold</option>
                <option value="silver">Silver</option>
                <option value="striver">Striver</option>
            </select>

            <label for="location">Location:</label>
            <input type="text" id="location" name="location" placeholder="Enter your location (District)">

            <button type="submit">Register</button>
            <p>Already have an account? <a href="login.jsp">Login here</a></p>
        </form>
    </div>
</div>
</body>
</html>
