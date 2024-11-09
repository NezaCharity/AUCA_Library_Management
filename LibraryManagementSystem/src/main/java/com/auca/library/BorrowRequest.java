package com.auca.library;

import java.util.Date;

public class BorrowRequest {
    private String username;
    private String bookTitle;
    private String status;
    private Date requestDate;

    // Constructor
    public BorrowRequest(String username, String bookTitle, String status, Date requestDate) {
        this.username = username;
        this.bookTitle = bookTitle;
        this.status = status;
        this.requestDate = requestDate;
    }

    // Getters and setters
    public String getUsername() {
        return username;
    }

    public String getBookTitle() {
        return bookTitle;
    }

    public String getStatus() {
        return status;
    }

    public Date getRequestDate() {
        return requestDate;
    }
}
