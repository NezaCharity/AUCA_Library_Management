<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create Shelf</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
<div class="container">
    <h2>Create a New Shelf</h2>
    <form action="${pageContext.request.contextPath}/LibrarianServlet" method="post">
        <input type="hidden" name="action" value="createShelf">
        
        <label for="shelfName">Shelf Name:</label>
        <input type="text" id="shelfName" name="shelfName" required>
    
        <label for="roomId">Room:</label>
        <select id="roomId" name="roomId" required>
            <c:forEach var="room" items="${rooms}">
                <option value="${room.id}">${room.name}</option>
            </c:forEach>
        </select>
    
        <button type="submit">Register Shelf</button>
    </form>
    
    
</div>
</body>
</html>
