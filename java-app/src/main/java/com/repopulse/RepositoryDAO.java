package com.repopulse;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


public class RepositoryDAO {
    public void displayUsers() {
        String sql = "SELECT user_id, username FROM AppUser ORDER BY user_id";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql);
                ResultSet resultSet = statement.executeQuery()) {

            System.out.println("\n--- Users who can track repositories ---");

            while (resultSet.next()) {
                System.out.println(
                        resultSet.getInt("user_id") + " - " +
                                resultSet.getString("username"));
            }

        } catch (SQLException e) {
            System.err.println("Could not retrieve users: " + e.getMessage());
        }
    }

    public void displayAllRepositories() {
        String sql = """
                SELECT repository_id, repo_name, github_url,
                       visibility, created_at
                FROM Repository
                ORDER BY repository_id
                """;

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql);
                ResultSet resultSet = statement.executeQuery()) {

            System.out.println("\n========== REPOSITORIES ==========");

            boolean found = false;

            while (resultSet.next()) {
                found = true;

                System.out.println("Repository ID : "
                        + resultSet.getInt("repository_id"));

                System.out.println("Name          : "
                        + resultSet.getString("repo_name"));

                System.out.println("GitHub URL    : "
                        + resultSet.getString("github_url"));

                System.out.println("Visibility    : "
                        + resultSet.getString("visibility"));

                System.out.println("Created At    : "
                        + resultSet.getTimestamp("created_at"));

                System.out.println("----------------------------------");
            }

            if (!found) {
                System.out.println("No repositories found.");
            }

        } catch (SQLException e) {
            System.err.println("Could not retrieve repositories: "
                    + e.getMessage());
        }
    }

    public void searchRepository(String searchTerm) {
        String sql = """
                SELECT repository_id, repo_name, github_url, visibility
                FROM Repository
                WHERE repo_name LIKE ?
                ORDER BY repository_id
                """;

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, "%" + searchTerm + "%");

            try (ResultSet resultSet = statement.executeQuery()) {
                boolean found = false;

                while (resultSet.next()) {
                    found = true;

                    System.out.println("\nRepository ID: "
                            + resultSet.getInt("repository_id"));
                    System.out.println("Name: "
                            + resultSet.getString("repo_name"));
                    System.out.println("URL: "
                            + resultSet.getString("github_url"));
                    System.out.println("Visibility: "
                            + resultSet.getString("visibility"));
                }

                if (!found) {
                    System.out.println("No matching repositories found.");
                }
            }

        } catch (SQLException e) {
            System.err.println("Search failed: " + e.getMessage());
        }
    }

    public void addRepository(
            String name,
            String githubUrl,
            String description,
            String visibility,
            int trackedByUserId) {

        String sql = """
                INSERT INTO Repository
                    (repo_name, github_url, description, visibility,
                     created_at, tracked_by_user_id)
                VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP, ?)
                """;

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, name);
            statement.setString(2, githubUrl);
            statement.setString(3, description);
            statement.setString(4, visibility);
            statement.setInt(5, trackedByUserId);

            int rowsInserted = statement.executeUpdate();

            if (rowsInserted > 0) {
                System.out.println("Repository added successfully!");
            }

        } catch (SQLException e) {
            System.err.println("Could not add repository: " + e.getMessage());
        }
    }

    public void updateRepository(
            int repositoryId,
            String name,
            String githubUrl,
            String description,
            String visibility) {

        String sql = """
                UPDATE Repository
                SET repo_name = ?,
                    github_url = ?,
                    description = ?,
                    visibility = ?
                WHERE repository_id = ?
                """;

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, name);
            statement.setString(2, githubUrl);
            statement.setString(3, description);
            statement.setString(4, visibility);
            statement.setInt(5, repositoryId);

            int rowsUpdated = statement.executeUpdate();

            if (rowsUpdated > 0) {
                System.out.println("Repository updated successfully.");
            } else {
                System.out.println("No repository found with that ID.");
            }

        } catch (SQLException e) {
            System.err.println("Update failed: " + e.getMessage());
        }
    }

    public void deleteRepository(int repositoryId) {
        String sql = """
                DELETE FROM Repository
                WHERE repository_id = ?
                """;

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, repositoryId);

            int rowsDeleted = statement.executeUpdate();

            if (rowsDeleted > 0) {
                System.out.println("Repository deleted successfully.");
            } else {
                System.out.println("No repository found with that ID.");
            }

        } catch (SQLException e) {
            System.err.println(
                    "Delete failed. The repository may have related records. "
                            + e.getMessage());
        }
    }

    public void displayRepositoryActivity(int repositoryId) {
        String sql = "{CALL GetRepositoryActivity(?)}";

        try (Connection connection = DBConnection.getConnection();
                java.sql.CallableStatement statement = connection.prepareCall(sql)) {

            statement.setInt(1, repositoryId);

            boolean hasResult = statement.execute();

            if (hasResult) {
                try (ResultSet resultSet = statement.getResultSet()) {
                    if (resultSet.next()) {
                        System.out.println("\n===== REPOSITORY ACTIVITY =====");
                        System.out.println("Repository: "
                                + resultSet.getString("repo_name"));
                        System.out.println("Total commits: "
                                + resultSet.getInt("total_commits"));
                        System.out.println("Total issues: "
                                + resultSet.getInt("total_issues"));
                        System.out.println("Open issues: "
                                + resultSet.getInt("open_issues"));
                    } else {
                        System.out.println("No activity report returned.");
                    }
                }
            } else {
                System.out.println("The procedure did not return a result set.");
            }

        } catch (SQLException e) {
            System.err.println("Could not retrieve activity: " + e.getMessage());
        }
    }

    public void displayOpenIssues() {
        String sql = """
                SELECT i.issue_id,
                       i.issue_number,
                       i.title,
                       i.repository_id,
                       r.repo_name,
                       i.created_at
                FROM Issue i
                JOIN Repository r
                    ON i.repository_id = r.repository_id
                WHERE i.status = 'OPEN'
                ORDER BY r.repo_name, i.issue_number
                """;

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql);
                ResultSet resultSet = statement.executeQuery()) {

            System.out.println("\n========== OPEN ISSUES ==========");

            boolean found = false;

            while (resultSet.next()) {
                found = true;

                System.out.println("\nIssue ID: "
                        + resultSet.getInt("issue_id"));
                System.out.println("Issue number: "
                        + resultSet.getInt("issue_number"));
                System.out.println("Repository: "
                        + resultSet.getString("repo_name"));
                System.out.println("Title: "
                        + resultSet.getString("title"));
                System.out.println("Created: "
                        + resultSet.getTimestamp("created_at"));
                System.out.println("----------------------------------");
            }

            if (!found) {
                System.out.println("There are no open issues.");
            }

        } catch (SQLException e) {
            System.err.println("Could not retrieve open issues: "
                    + e.getMessage());
        }
    }

    public void runIssueTransaction(
            int firstIssueId,
            int secondIssueId,
            boolean commitTransaction) {

        String sql = """
                UPDATE Issue
                SET status = 'CLOSED'
                WHERE issue_id = ?
                  AND status = 'OPEN'
                """;

        try (Connection connection = DBConnection.getConnection()) {

            // Disable automatic commits so we control the transaction.
            connection.setAutoCommit(false);

            try (PreparedStatement statement = connection.prepareStatement(sql)) {

                // Update the first issue.
                statement.setInt(1, firstIssueId);

                int firstUpdated = statement.executeUpdate();

                if (firstUpdated != 1) {
                    throw new SQLException(
                            "First issue was not found or is not OPEN.");
                }

                System.out.println("First issue updated inside transaction.");

                // Create a savepoint after the first update.
                java.sql.Savepoint savepoint = connection.setSavepoint("after_first_issue");

                // Attempt to update the second issue.
                statement.setInt(1, secondIssueId);

                int secondUpdated = statement.executeUpdate();

                if (secondUpdated == 1) {
                    System.out.println(
                            "Second issue updated inside transaction.");
                } else {
                    System.out.println(
                            "Second issue was not found or is not OPEN.");
                }

                // Undo the second update, keeping the first update pending.
                connection.rollback(savepoint);

                System.out.println(
                        "Rolled back to savepoint; second update was undone.");

                if (commitTransaction) {
                    connection.commit();
                    System.out.println(
                            "Transaction committed. First issue is now CLOSED.");
                } else {
                    connection.rollback();
                    System.out.println(
                            "Transaction rolled back. First issue remains unchanged.");
                }
            }

        } catch (SQLException e) {
            System.err.println("Transaction failed: " + e.getMessage());
        }
    }
}
