<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.ArrayList, com.auca.library.Book" %>
<%
    List<Book> books = (List<Book>) request.getAttribute("books");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Books</title>
    <link rel="stylesheet" href="css/styles.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            color: #333;
        }

        .container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            color: #333;
        }

        .actions {
            text-align: right;
            margin-bottom: 10px;
        }

        .actions input, .actions select {
            padding: 5px;
            font-size: 1em;
            margin: 0 5px;
        }

        .search-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .search-bar input[type="text"] {
            padding: 8px;
            font-size: 1em;
            width: 60%;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .table-wrapper {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #3498db;
            color: #fff;
            cursor: pointer;
        }

        th.sortable:hover {
            background-color: #2980b9;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        .edit-btn, .delete-btn {
            padding: 5px 10px;
            color: #fff;
            border: none;
            border-radius: 4px;
            text-decoration: none;
        }

        .edit-btn {
            background-color: #27ae60;
        }

        .delete-btn {
            background-color: #e74c3c;
        }

        .delete-btn:hover, .edit-btn:hover {
            opacity: 0.8;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Manage Books</h2>

    <!-- Search and Filter Options -->
    <div class="search-bar">
        <input type="text" id="searchInput" placeholder="Search by title, author, ISBN, or category..." onkeyup="searchBooks()">
    </div>

    <div class="table-wrapper">
        <table id="booksTable">
            <thead>
                <tr>
                    <th onclick="sortTable(0)" class="sortable">Title</th>
                    <th onclick="sortTable(1)" class="sortable">Author</th>
                    <th onclick="sortTable(2)" class="sortable">ISBN</th>
                    <th onclick="sortTable(3)" class="sortable">Category</th>
                    <th onclick="sortTable(4)" class="sortable">Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (books != null && !books.isEmpty()) { 
                    for (Book book : books) { %>
                        <tr>
                            <td><%= book.getTitle() %></td>
                            <td><%= book.getAuthor() %></td>
                            <td><%= book.getIsbn() %></td>
                            <td><%= book.getCategory() %></td>
                            <td><%= book.getStatus() %></td>
                            <td>
                                <a href="editBook.jsp?id=<%= book.getId() %>" class="edit-btn">Edit</a>
                                <a href="deleteBook?id=<%= book.getId() %>" class="delete-btn" onclick="return confirm('Are you sure you want to delete this book?')">Delete</a>
                            </td>
                        </tr>
                <%     } 
                } else { %>
                    <tr>
                        <td colspan="6" style="text-align: center;">No books available</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<script>
    function searchBooks() {
        const input = document.getElementById("searchInput").value.toUpperCase();
        const table = document.getElementById("booksTable");
        const rows = table.getElementsByTagName("tr");

        for (let i = 1; i < rows.length; i++) {
            let found = false;
            const cells = rows[i].getElementsByTagName("td");
            for (let j = 0; j < cells.length - 1; j++) { // Exclude actions column
                if (cells[j] && cells[j].innerHTML.toUpperCase().indexOf(input) > -1) {
                    found = true;
                    break;
                }
            }
            rows[i].style.display = found ? "" : "none";
        }
    }

    function sortTable(columnIndex) {
        const table = document.getElementById("booksTable");
        let switching = true;
        let direction = "asc";
        
        while (switching) {
            switching = false;
            const rows = table.rows;
            for (let i = 1; i < rows.length - 1; i++) {
                let shouldSwitch = false;
                const x = rows[i].getElementsByTagName("td")[columnIndex];
                const y = rows[i + 1].getElementsByTagName("td")[columnIndex];

                if ((direction === "asc" && x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) ||
                    (direction === "desc" && x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase())) {
                    shouldSwitch = true;
                    break;
                }
            }
            if (shouldSwitch) {
                rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
                switching = true;
            } else if (!switching && direction === "asc") {
                direction = "desc";
                switching = true;
            }
        }
    }
</script>
</body>
</html>
