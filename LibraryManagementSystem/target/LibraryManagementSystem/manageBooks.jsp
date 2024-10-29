<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession session = request.getSession(false);
    String role = (String) session.getAttribute("role");

    if (session == null || role == null || !"librarian".equals(role)) {
        response.sendRedirect("../login.jsp?error=accessDenied");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Books</title>
    <link rel="stylesheet" href="../css/styles.css">
    <style>
        /* Page Container */
        .manage-books-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        /* Header */
        .header {
            background-color: #4CAF50;
            color: #fff;
            padding: 20px;
            text-align: center;
            border-radius: 8px;
        }

        /* Book List Table */
        .book-table-container {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }

        th {
            background-color: #f4f4f4;
            color: #333;
        }

        .action-buttons button {
            padding: 5px 10px;
            border: none;
            border-radius: 4px;
            color: #fff;
            cursor: pointer;
            margin-right: 5px;
        }

        .edit-button {
            background-color: #4CAF50;
        }

        .delete-button {
            background-color: #e74c3c;
        }

        /* Add New Book Form */
        .add-book-form {
            display: flex;
            flex-direction: column;
            gap: 10px;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        }

        .add-book-form input, .add-book-form select, .add-book-form button {
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #ddd;
        }

        .add-book-form button {
            background-color: #4CAF50;
            color: #fff;
            cursor: pointer;
            border: none;
        }

        /* Search and Filter */
        .search-container {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .search-container input, .search-container button {
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #ddd;
        }

        .search-container button {
            background-color: #4CAF50;
            color: white;
            cursor: pointer;
            border: none;
        }
    </style>
</head>
<body>
<div class="manage-books-container">
    <div class="header">
        <h2>Manage Books</h2>
        <p>Add, view, edit, or delete books in the library collection</p>
    </div>

    <!-- Search and Filter Section -->
    <div class="search-container">
        <input type="text" id="searchTitle" placeholder="Search by Title">
        <select id="filterCategory">
            <option value="">Filter by Category</option>
            <option value="Science">Science</option>
            <option value="Technology">Technology</option>
            <option value="Fiction">Fiction</option>
            <option value="Non-Fiction">Non-Fiction</option>
            <!-- Add more categories as needed -->
        </select>
        <button onclick="filterBooks()">Search</button>
    </div>

    <!-- Book List Table -->
    <div class="book-table-container">
        <table>
            <thead>
                <tr>
                    <th>Title</th>
                    <th>Author</th>
                    <th>Category</th>
                    <th>Availability</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    // Example data, replace with dynamic content from the database
                    String[][] books = { 
                        {"Introduction to Java", "James Gosling", "Technology", "Available"},
                        {"Advanced Python", "Guido van Rossum", "Technology", "Borrowed"},
                        {"Mystery of the Lost City", "John Doe", "Fiction", "Available"}
                    };
                    for (String[] book : books) { 
                %>
                    <tr>
                        <td><%= book[0] %></td>
                        <td><%= book[1] %></td>
                        <td><%= book[2] %></td>
                        <td><%= book[3] %></td>
                        <td class="action-buttons">
                            <button class="edit-button" onclick="editBook('<%= book[0] %>')">Edit</button>
                            <button class="delete-button" onclick="deleteBook('<%= book[0] %>')">Delete</button>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <!-- Add New Book Form -->
    <div class="add-book-form">
        <h3>Add New Book</h3>
        <form action="addBookServlet" method="post">
            <label for="title">Title:</label>
            <input type="text" id="title" name="title" required>

            <label for="author">Author:</label>
            <input type="text" id="author" name="author" required>

            <label for="category">Category:</label>
            <select id="category" name="category" required>
                <option value="Science">Science</option>
                <option value="Technology">Technology</option>
                <option value="Fiction">Fiction</option>
                <option value="Non-Fiction">Non-Fiction</option>
                <!-- Add more categories as needed -->
            </select>

            <button type="submit">Add Book</button>
        </form>
    </div>
</div>

<script>
    // JavaScript functions for edit and delete
    function editBook(title) {
        alert('Editing book: ' + title); 
        // Here you could redirect to an edit page or show an edit form with book details
    }

    function deleteBook(title) {
        const confirmation = confirm('Are you sure you want to delete the book: ' + title + '?');
        if (confirmation) {
            alert('Book deleted: ' + title);
            // Here you would make an actual delete request to the server
        }
    }

    function filterBooks() {
        const title = document.getElementById('searchTitle').value;
        const category = document.getElementById('filterCategory').value;
        alert('Filtering books by Title: ' + title + ' and Category: ' + category);
        // Here you would make an actual filter request to the server
    }
</script>
</body>
</html>
