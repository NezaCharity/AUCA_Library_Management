<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Book</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <div class="container">
        <h2>Edit Book</h2>
        <form action="EditBookServlet" method="post">
            <input type="hidden" name="bookId" value="<%= request.getAttribute("bookId") %>">
            
            <label for="title">Title:</label>
            <input type="text" id="title" name="title" value="<%= request.getAttribute("title") %>" required>
            
            <label for="author">Author:</label>
            <input type="text" id="author" name="author" value="<%= request.getAttribute("author") %>" required>
            
            <label for="isbn">ISBN:</label>
            <input type="text" id="isbn" name="isbn" value="<%= request.getAttribute("isbn") %>" required>
            
            <label for="category">Category:</label>
            <input type="text" id="category" name="category" value="<%= request.getAttribute("category") %>" required>
            
            <label for="status">Status:</label>
            <select id="status" name="status" required>
                <option value="available" <%= "available".equals(request.getAttribute("status")) ? "selected" : "" %>>Available</option>
                <option value="borrowed" <%= "borrowed".equals(request.getAttribute("status")) ? "selected" : "" %>>Borrowed</option>
            </select>
            
            <button type="submit">Update Book</button>
        </form>
        <a href="manageBooks.jsp">Back to Manage Books</a>
    </div>
</body>
</html>
