<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.ArrayList, com.auca.library.RoomInventory" %>
<%
    int totalBooks = (request.getAttribute("totalBooks") != null) ? (int) request.getAttribute("totalBooks") : 0;
    List<String> pendingMembers = (List<String>) request.getAttribute("pendingMembers");
    if (pendingMembers == null) {
        pendingMembers = new ArrayList<>();
    }
    int approvedMembers = (request.getAttribute("approvedMembers") != null) ? (int) request.getAttribute("approvedMembers") : 0;
    List<RoomInventory> roomInventories = (List<RoomInventory>) request.getAttribute("roomInventories");
    if (roomInventories == null) {
        roomInventories = new ArrayList<>();
    }
    String username = (String) session.getAttribute("username");
    
%>
<% out.println("Total Books (Debug): " + totalBooks); %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Librarian Dashboard</title>
    <link rel="stylesheet" href="css/styles.css">
    <style>
        /* Styling for the dashboard */
        .dashboard-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
        }
        .header {
            background-color: #4CAF50;
            color: #fff;
            padding: 20px;
            text-align: center;
            border-radius: 8px;
        }
        .stats-panel, .notifications-panel {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        .stats-panel {
            display: flex;
            justify-content: space-around;
        }
        .stat-box {
            text-align: center;
        }
        .stat-box h3 {
            font-size: 2em;
            margin-bottom: 5px;
        }
        .notification-item button {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
        }
        .notification-item button.reject {
            background-color: #e74c3c;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <div class="header">
            <h2>Welcome, <%= username %></h2>
            <p>Manage library resources, requests, and more</p>
        </div>
    
        <!-- Statistics Panel -->
        <div class="stats-panel">
            <div class="stat-box">
                <h3><%= totalBooks %></h3>
                <p>Total Books</p>
            </div>
            
            <div class="stat-box">
                <h3><%= pendingMembers.size() %></h3>
                <p>Pending Membership Requests</p>
            </div>
            <div class="stat-box">
                <h3><%= approvedMembers %></h3>
                <p>Approved Members</p>
            </div>
        </div>
    
        <!-- Quick Links -->
        <div class="quick-links">
            <div class="link-card">
                <a href="LibrarianServlet?action=manageBooks.jsp">📚 Manage Books</a>
               <br>
               <a href="manageBooks.jsp">Click here to manage your books</a>
                <p>Add, edit, or delete books from the library collection.</p>
            </div>
            <div class="link-card">
                
                <a href="LibrarianServlet?action=approveMembers.jsp">✔️ Approve Members</a>
               <br>
               <a href="approveMembers.jsp">click here to approve members</a>
              
                
                <p>Review and approve pending membership requests.</p>
            </div>
            <div class="link-card">
                
                <a href="LibrarianServlet?action=assignShelf.jsp">🗄️ Assign Shelf</a>
                <br>
                <a href="assignShelf.jsp">click here to assign shelf</a>
               
                <p>Assign books to a specific shelf in the library.</p>
            </div>
            <div class="link-card">
               
                <a href="LibrarianServlet?action=assignRoom.jsp">🏢 Assign Room</a>
                <br>
                <a href="assignRoom.jsp">click here to assign room</a>
               
                <p>Assign shelves to a specific room in the library.</p>
            </div>
            <div class="link-card">
                
                <a href="LibrarianServlet?action=registerBook.jsp">📖 Register Book</a>
                <br>
                <a href="registerBook.jsp">click here to register your Books</a>
               
                <p>Register new books to the library collection.</p>
            </div>
            <div class="link-card">
                
                <a href="LibrarianServlet?action=inventoryReport.jsp">📊 Inventory Report</a>
                <br>
                <a href="inventoryReport">click here to check your inventory</a>
               
                <p>View detailed reports on library resources.</p>
            </div>
            <div class="link-card">
                
                <a href="LibrarianServlet?action=createShelf.jsp">📚 Create Shelf</a>
                <br>
                <a href="createShelf.jsp">click here to create shelf</a>
               
                <p>Create shelves to assign books here.</p>
            </div>
            

        </div>
    
        <!-- Room Inventory Panel -->
        <div class="room-inventory-panel">
            <h3>Room Inventory</h3>
            <table>
                <thead>
                    <tr>
                        <th>Room Name</th>
                        <th>Book Count</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (!roomInventories.isEmpty()) {
                        for (RoomInventory room : roomInventories) { %>
                            <tr>
                                <td><%= room.getRoomName() %></td>
                                <td><%= room.getBookCount() %></td>
                            </tr>
                        <% }
                    } else { %>
                        <tr>
                            <td colspan="2">No room inventory data available</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    
        <!-- Notifications Panel -->
        <div class="notifications-panel">
            <h3>Pending Membership Requests</h3>
            <% if (!pendingMembers.isEmpty()) {
                for (String member : pendingMembers) { %>
                    <div class="notification-item">
                        <span><%= member %> - Membership Request</span>
                        <form action="LibrarianServlet" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="approveMember">
                            <input type="hidden" name="username" value="<%= member %>">
                            <button type="submit">Approve</button>
                        </form>
                        <form action="LibrarianServlet" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="rejectMember">
                            <input type="hidden" name="username" value="<%= member %>">
                            <button type="submit" class="reject">Reject</button>
                        </form>
                    </div>
                <% }
            } else { %>
                <p>No pending membership requests.</p>
            <% } %>
        </div>
    </div>
    </body>
</html>
