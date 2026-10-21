package com.repopulse;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/repopulse_db";

    private static final String USER = System.getenv("REPOPULSE_DB_USER");

    private static final String PASSWORD = System.getenv("REPOPULSE_DB_PASSWORD");

    public static Connection getConnection() throws SQLException {
        if (USER == null || PASSWORD == null) {
            throw new SQLException(
                    "Database credentials are missing. Set REPOPULSE_DB_USER " +
                            "and REPOPULSE_DB_PASSWORD environment variables.");
        }

        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

}
