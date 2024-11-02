package com.auca.library;

public class RoomInventory {
    private String roomName;
    private int bookCount;

    public RoomInventory(String roomName, int bookCount) {
        this.roomName = roomName;
        this.bookCount = bookCount;
    }

    public String getRoomName() {
        return roomName;
    }

    public int getBookCount() {
        return bookCount;
    }
}
