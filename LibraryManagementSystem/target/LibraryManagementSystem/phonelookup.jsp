<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Phone Lookup - AUCA Library Management</title>
</head>
<body>
<div class="container">
    <h2>Phone Lookup</h2>
    <form action="PhoneLookupServlet" method="get">
        <label for="phoneNumber">Enter Phone Number:</label>
        <input type="text" id="phoneNumber" name="phoneNumber" required pattern="[0-9]{10}" placeholder="e.g., 0781234567">
        <button type="submit">Lookup</button>
    </form>

    <%
        String province = request.getParameter("province");
        String error = request.getParameter("error");
        if (province != null) {
    %>
        <p>Province: <strong><%= province %></strong></p>
    <%
        } else if (error != null) {
    %>
        <p style="color: red;"><%= error %></p>
    <%
        }
    %>
</div>
</body>
</html>
