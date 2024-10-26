<!-- src/main/webapp/jsp/dashboard.jsp -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.util.Objects" %>
<%
    HttpSession session = request.getSession(false);
    String role = Objects.toString(session.getAttribute("role"), "");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - AUCA Library</title>
    <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
<header class="navbar">
    <h3>Welcome to the AUCA Library</h3>
    <nav>
        <a href="../login.jsp">Logout</a>
    </nav>
</header>
<div class="container">
    <div class="card">
        <h3>Main Dashboard</h3>
        <% if ("librarian".equals(role)) { %>
            <button onclick="navigateTo('librarianInterface.jsp')">Librarian Dashboard</button>
        <% } %>
        <button onclick="navigateTo('browseBooks.jsp')">Browse Books</button>
    </div>
</div>
<script src="../js/scripts.js"></script>
</body>
</html>
