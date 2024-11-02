package com.auca.library;

import java.sql.Date;

public class BorrowedBook {
    private String title;
    private String author;
    private String dueDate;
    private String status;
    private Date borrowDate;

    // Constructor for StudentDashboardServlet (all String parameters)
    public BorrowedBook(String title, String author, String dueDate, String status) {
        this.title = title;
        this.author = author;
        this.dueDate = dueDate;
        this.status = status;
    }

    // Constructor for LibrarianServlet (Date objects for borrowDate and dueDate)
    public BorrowedBook(String title, String author, Date borrowDate, Date dueDate, String status) {
        this.title = title;
        this.author = author;
        this.borrowDate = borrowDate;
        this.dueDate = (dueDate != null) ? dueDate.toString() : null; // Convert Date to String
        this.status = status;
    }

    // Getters and setters
    public String getTitle() { return title; }
    public String getAuthor() { return author; }
    public String getDueDate() { return dueDate; }
    public String getStatus() { return status; }
    public Date getBorrowDate() { return borrowDate; }
}
