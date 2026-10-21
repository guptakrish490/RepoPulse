package com.repopulse;

import java.util.Scanner;
import java.sql.Connection;
import java.sql.SQLException;

public class Main {

    public static void main(String[] args) {
        RepositoryDAO repositoryDAO = new RepositoryDAO();

        try (Connection connection = DBConnection.getConnection()) {
            System.out.println("Connected to database: "
                    + connection.getCatalog());
        } catch (SQLException e) {
            System.err.println("Database connection failed: "
                    + e.getMessage());
            return;
        }

        try (Scanner scanner = new Scanner(System.in)) {
            boolean running = true;

            while (running) {
                System.out.println("\n========== RepoPulse ==========");
                System.out.println("1. View all repositories");
                System.out.println("2. Search repositories");
                System.out.println("3. Add repository");
                System.out.println("4. Update repository");
                System.out.println("5. Delete repository");
                System.out.println("6. View repository activity");
                System.out.println("7. View open issues");
                System.out.println("8. Demonstrate JDBC transaction");
                System.out.println("9. Exit");
                System.out.print("Choose an option: ");

                String choice = scanner.nextLine().trim();

                switch (choice) {
                    case "1" ->
                        repositoryDAO.displayAllRepositories();

                    case "2" -> {
                        System.out.print("Enter repository name to search: ");
                        String term = scanner.nextLine().trim();

                        if (!term.isEmpty()) {
                            repositoryDAO.searchRepository(term);
                        } else {
                            System.out.println("Search term cannot be empty.");
                        }
                    }

                    case "3" -> {
                        repositoryDAO.displayUsers();

                        System.out.print("Enter repository name: ");
                        String name = scanner.nextLine().trim();

                        System.out.print("Enter GitHub URL: ");
                        String url = scanner.nextLine().trim();

                        System.out.print("Enter description: ");
                        String description = scanner.nextLine().trim();

                        System.out.print("Visibility (PUBLIC/PRIVATE): ");
                        String visibility = scanner.nextLine().trim().toUpperCase();

                        System.out.print("Enter tracking user's ID from the list: ");
                        String userIdInput = scanner.nextLine().trim();

                        try {
                            int userId = Integer.parseInt(userIdInput);

                            if (name.isEmpty() || url.isEmpty()) {
                                System.out.println("Name and URL cannot be empty.");
                            } else if (!visibility.equals("PUBLIC")
                                    && !visibility.equals("PRIVATE")) {
                                System.out.println("Visibility must be PUBLIC or PRIVATE.");
                            } else {
                                repositoryDAO.addRepository(
                                        name, url, description, visibility, userId);
                            }

                        } catch (NumberFormatException e) {
                            System.out.println("User ID must be a valid number.");
                        }
                    }

                    case "4" -> {
                        System.out.print("Repository ID to update: ");
                        String idInput = scanner.nextLine().trim();

                        try {
                            int id = Integer.parseInt(idInput);

                            System.out.print("New repository name: ");
                            String name = scanner.nextLine().trim();

                            System.out.print("New GitHub URL: ");
                            String url = scanner.nextLine().trim();

                            System.out.print("New description: ");
                            String description = scanner.nextLine().trim();

                            System.out.print("Visibility (PUBLIC/PRIVATE): ");
                            String visibility = scanner.nextLine().trim().toUpperCase();

                            if (name.isEmpty() || url.isEmpty()) {
                                System.out.println("Name and URL cannot be empty.");
                            } else if (!visibility.equals("PUBLIC")
                                    && !visibility.equals("PRIVATE")) {
                                System.out.println("Visibility must be PUBLIC or PRIVATE.");
                            } else {
                                repositoryDAO.updateRepository(
                                        id, name, url, description, visibility);
                            }

                        } catch (NumberFormatException e) {
                            System.out.println("Repository ID must be a number.");
                        }
                    }

                    case "5" -> {
                        System.out.print("Repository ID to delete: ");
                        String idInput = scanner.nextLine().trim();

                        try {
                            int id = Integer.parseInt(idInput);

                            System.out.print(
                                    "Are you sure you want to delete repository " + id
                                            + "? (yes/no): ");

                            String confirmation = scanner.nextLine().trim();

                            if (confirmation.equalsIgnoreCase("yes")) {
                                repositoryDAO.deleteRepository(id);
                            } else {
                                System.out.println("Deletion cancelled.");
                            }

                        } catch (NumberFormatException e) {
                            System.out.println("Repository ID must be a number.");
                        }
                    }

                    case "6" -> {
                        System.out.print("Enter repository ID: ");
                        String idInput = scanner.nextLine().trim();

                        try {
                            int repositoryId = Integer.parseInt(idInput);
                            repositoryDAO.displayRepositoryActivity(repositoryId);
                        } catch (NumberFormatException e) {
                            System.out.println("Repository ID must be a number.");
                        }
                    }

                    case "7" -> repositoryDAO.displayOpenIssues();
                    case "8" -> {
                        System.out.print("Enter first OPEN issue ID: ");
                        String firstInput = scanner.nextLine().trim();

                        System.out.print("Enter second OPEN issue ID: ");
                        String secondInput = scanner.nextLine().trim();

                        try {
                            int firstId = Integer.parseInt(firstInput);
                            int secondId = Integer.parseInt(secondInput);

                            if (firstId == secondId) {
                                System.out.println("Please enter two different issue IDs.");
                                break;
                            }

                            System.out.print("Commit first update, or rollback everything? (commit/rollback): ");
                            String decision = scanner.nextLine().trim();

                            if (decision.equalsIgnoreCase("commit")) {
                                repositoryDAO.runIssueTransaction(firstId, secondId, true);
                            } else if (decision.equalsIgnoreCase("rollback")) {
                                repositoryDAO.runIssueTransaction(firstId, secondId, false);
                            } else {
                                System.out.println("Invalid choice. Transaction not started.");
                            }

                        } catch (NumberFormatException e) {
                            System.out.println("Issue IDs must be numeric.");
                        }
                    }
                    case "9" -> {
                        running = false;
                        System.out.println("Thank you for using RepoPulse!");
                    }

                    default ->
                        System.out.println(
                                "Invalid choice. Enter a number from 1 to 8.");
                }
            }
        }
    }
}