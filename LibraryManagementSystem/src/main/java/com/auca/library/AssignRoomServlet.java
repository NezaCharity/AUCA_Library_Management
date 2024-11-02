package com.auca.library;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AssignRoomServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
    
        if ("assignRoom".equals(action)) {
            List<Shelf> shelves = getAvailableShelves();
            List<Room> rooms = getRooms();
    
            if (shelves == null) {
                shelves = new ArrayList<>(); // Ensure it's initialized
            }
            if (rooms == null) {
                rooms = new ArrayList<>(); // Ensure it's initialized
            }
    
            request.setAttribute("shelves", shelves);
            request.setAttribute("rooms", rooms);
            request.getRequestDispatcher("assignRoom.jsp").forward(request, response);
        } else {
            response.sendRedirect("librarianDashboard.jsp"); // Redirect if action is not assignRoom
        }
    }
    

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String shelfId = request.getParameter("shelfId");
        String roomId = request.getParameter("roomId");

        if (shelfId != null && roomId != null) {
            assignRoom(shelfId, roomId);
        }

        response.sendRedirect("librarianDashboard.jsp?message=roomAssigned");
    }

    private List<Shelf> getAvailableShelves() {
        List<Shelf> shelves = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "SELECT id, name FROM shelves";
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet resultSet = statement.executeQuery();
    
            while (resultSet.next()) {
                int id = resultSet.getInt("id");
                String name = resultSet.getString("name");
                shelves.add(new Shelf(id, name));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return shelves;
    }
    

    private List<Room> getRooms() {
        List<Room> rooms = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "SELECT id, name FROM rooms";
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                rooms.add(new Room(resultSet.getInt("id"), resultSet.getString("name")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rooms;
    }

    private void assignRoom(String shelfId, String roomId) {
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "UPDATE shelves SET room_id = ? WHERE id = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, roomId);
            statement.setString(2, shelfId);
            statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
