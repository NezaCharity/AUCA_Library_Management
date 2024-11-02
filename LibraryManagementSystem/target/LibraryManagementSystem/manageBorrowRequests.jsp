<!-- src/main/webapp/WEB-INF/jsp/manageBorrowRequests.jsp -->
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
    <title>Manage Borrow Requests</title>
</head>
<body>
    <h2>Borrow Requests</h2>
    <table>
        <tr>
            <th>Username</th>
            <th>Book</th>
            <th>Status</th>
            <th>Action</th>
        </tr>
        <% 
            // Assuming a list of borrow requests is passed from a servlet
            List<BorrowRequest> requests = (List<BorrowRequest>) request.getAttribute("requests");
            for (BorrowRequest req : requests) { 
        %>
            <tr>
                <td><%= req.getUsername() %></td>
                <td><%= req.getBookTitle() %></td>
                <td><%= req.getStatus() %></td>
                <td>
                    <form action="approveBorrowServlet" method="post" style="display:inline;">
                        <input type="hidden" name="requestId" value="<%= req.getId() %>">
                        <button type="submit">Approve</button>
                    </form>
                    <form action="rejectBorrowServlet" method="post" style="display:inline;">
                        <input type="hidden" name="requestId" value="<%= req.getId() %>">
                        <button type="submit">Reject</button>
                    </form>
                </td>
            </tr>
        <% } %>
    </table>
</body>
</html>
