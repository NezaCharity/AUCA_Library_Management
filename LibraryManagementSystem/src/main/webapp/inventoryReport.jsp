<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.ArrayList, com.auca.library.RoomInventory" %>
<%
    List<RoomInventory> roomInventories = (List<RoomInventory>) request.getAttribute("roomInventories");
    if (roomInventories == null) {
        roomInventories = new ArrayList<>();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Inventory Report</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css">
</head>
<body>
    <div class="container">
        <h2>Library Inventory Report</h2>
        <table>
            <thead>
                <tr>
                    <th>Room Name</th>
                    <th>Book Count</th>
                </tr>
            </thead>
            <tbody>
                <% for (RoomInventory inventory : roomInventories) { %>
                    <tr>
                        <td><%= inventory.getRoomName() %></td>
                        <td><%= inventory.getBookCount() %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>
