<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.auca.library.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Approve Members</title>
    <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
<div class="container">
    <h2>Approve Membership Requests</h2>
    <table>
        <thead>
            <tr>
                <th>Username</th>
                <th>Role</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <% 
                List<User> pendingMembers = (List<User>) request.getAttribute("pendingMembers");
                for (User member : pendingMembers) { 
            %>
            <tr>
                <td><%= member.getUsername() %></td>
                <td><%= member.getRole() %></td>
                <td>
                    <form action="LibrarianServlet" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="approveMember">
                        <input type="hidden" name="username" value="<%= member.getUsername() %>">
                        <button type="submit">Approve</button>
                    </form>
                    <form action="LibrarianServlet" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="rejectMember">
                        <input type="hidden" name="username" value="<%= member.getUsername() %>">
                        <button type="submit" class="reject">Reject</button>
                    </form>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</div>
</body>
</html>
