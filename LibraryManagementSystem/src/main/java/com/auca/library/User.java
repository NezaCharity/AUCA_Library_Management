package com.auca.library;

import java.sql.Timestamp;

public class User {
    private int id;
    private String username;
    private String role;
    private String membership;
    private String phoneNumber;
    private double fine;
    private Timestamp createdAt;
    private String status;

    // Full constructor
    public User(int id, String username, String role, String membership, String phoneNumber, double fine, Timestamp createdAt, String status) {
        this.id = id;
        this.username = username;
        this.role = role;
        this.membership = membership;
        this.phoneNumber = phoneNumber;
        this.fine = fine;
        this.createdAt = createdAt;
        this.status = status;
    }

    // New constructor to match the parameters used in ViewDashboardServlet
    public User(String username, String role, String membership, String status) {
        this.username = username;
        this.role = role;
        this.membership = membership;
        this.status = status;
    }

    // Getters
    public int getId() {
        return id;
    }

    public String getUsername() {
        return username;
    }

    public String getRole() {
        return role;
    }

    public String getMembership() {
        return membership;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public double getFine() {
        return fine;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public String getStatus() {
        return status;
    }
}
