<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.ArrayList, com.auca.library.Shelf, com.auca.library.Room" %>
<%
    List<Shelf> shelves = (List<Shelf>) request.getAttribute("shelves");
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");

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
</head>
<body>
    <h2>Assign Shelf to Room</h2>
    <form action="AssignRoomServlet" method="post">
        <label for="shelfId">Select Shelf:</label>
        <select name="shelfId" id="shelfId">
            <option value="">Select a Shelf</option>
            <% for (Shelf shelf : shelves) { %>
                <option value="<%= shelf.getId() %>"><%= shelf.getName() %></option>
            <% } %>
        </select>

        <label for="roomId">Select Room:</label>
        <select name="roomId" id="roomId">
            <option value="">Select a Room</option>
            <% for (Room room : rooms) { %>
                <option value="<%= room.getId() %>"><%= room.getName() %></option>
            <% } %>
        </select>

        <button type="submit">Assign</button>
    </form>
</body>
</html>
