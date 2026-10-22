package com.repopulse;

import io.github.cdimascio.dotenv.Dotenv;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL = "jdbc:mysql://localhost:3306/repopulse_db";

    private static final Dotenv dotenv = Dotenv.configure()
            .directory(".")
            .ignoreIfMissing()
            .load();

    private static final String USER = dotenv.get(
            "REPOPULSE_DB_USER",
            System.getenv("REPOPULSE_DB_USER"));

    private static final String PASSWORD = dotenv.get(
            "REPOPULSE_DB_PASSWORD",
            System.getenv("REPOPULSE_DB_PASSWORD"));

    public static Connection getConnection() throws SQLException {
        if (USER == null || USER.isBlank()
                || PASSWORD == null || PASSWORD.isBlank()) {
            throw new SQLException(
                    "Database credentials are missing. " +
                            "Set REPOPULSE_DB_USER and REPOPULSE_DB_PASSWORD " +
                            "in java-app/.env or your environment.");
        }

        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
