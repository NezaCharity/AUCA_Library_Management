<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.ArrayList, com.auca.library.Shelf, com.auca.library.Room" %>
<%
    List<Shelf> shelves = (List<Shelf>) request.getAttribute("shelves");
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");

    // Initialize with empty lists if null to avoid null pointer exceptions
    if (shelves == null) {
        shelves = new ArrayList<>();
    }
    if (rooms == null) {
        rooms = new ArrayList<>();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Assign Shelf to Room</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css">
    <style>
        /* Styling for the assign room page */
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.1);
            background-color: #f7f9fc;
        }

        h2 {
            text-align: center;
            color: #333;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        label {
            font-weight: bold;
            color: #555;
        }

        select, button {
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #ddd;
            font-size: 1em;
            width: 100%;
            box-sizing: border-box;
        }

        select:focus, button:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0px 0px 5px rgba(52, 152, 219, 0.3);
        }

        button {
            background-color: #3498db;
            color: #fff;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #2980b9;
        }

        .info-text {
            font-size: 0.9em;
            color: #666;
            text-align: center;
            margin-top: 10px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Assign Shelf to Room</h2>
    <form action="<%= request.getContextPath() %>/LibrarianServlet?action=assignShelfToRoom" method="post">
        <!-- Select Shelf -->
        <label for="shelfId">Select Shelf:</label>
        <select id="shelfId" name="shelfId" required>
            <option value="">Select a Shelf</option>
            <% for (Shelf shelf : shelves) { %>
                <option value="<%= shelf.getId() %>"><%= shelf.getName() %></option>
            <% } %>
        </select>

        <!-- Select Room -->
        <label for="roomId">Select Room:</label>
        <select id="roomId" name="roomId" required>
            <option value="">Select a Room</option>
            <% 
                List<Room> rooms = (List<Room>) request.getAttribute("rooms");
                if (rooms != null && !rooms.isEmpty()) {
                    for (Room room : rooms) { 
            %>
                        <option value="<%= room.getId() %>"><%= room.getName() %></option>
            <% 
                    }
                } else { 
            %>
                    <option value="">No rooms available</option>
            <% } %>
        </select>
        

        <!-- Submit Button -->
        <button type="submit">Assign Shelf to Room</button>
    </form>
    <p class="info-text">Ensure the shelf and room selections are correct before assigning.</p>
</div>
</body>
</html>
