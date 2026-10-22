# RepoPulse — GitHub Repository Activity Tracker

RepoPulse is a database-driven application developed to manage and analyze GitHub-style repository activity using MySQL and Java JDBC. The project demonstrates the practical application of relational database concepts, SQL programming, transaction management, database security, and Java database connectivity.

The system maintains information about repositories, application users, contributors, memberships, commits, issues, and issue-status changes. It provides a command-line interface through which users can manage repository records and retrieve activity information.

This project was developed as a Database Management Systems (DBMS) course project.

## Table of Contents

* [Overview](#overview)
* [Objectives](#objectives)
* [Features](#features)
* [Technology Stack](#technology-stack)
* [System Architecture](#system-architecture)
* [Database Design](#database-design)
* [SQL Features](#sql-features)
* [Java Application](#java-application)
* [Project Structure](#project-structure)
* [Prerequisites](#prerequisites)
* [Installation and Setup](#installation-and-setup)
* [Running the Application](#running-the-application)
* [Database Access Control](#database-access-control)
* [Testing and Verification](#testing-and-verification)
* [Security Considerations](#security-considerations)
* [Limitations](#limitations)
* [Future Enhancements](#future-enhancements)
* [Learning Outcomes](#learning-outcomes)
* [Author](#author)

## Overview

Managing repository information involves maintaining relationships between repositories, contributors, commits, and issues. Without a structured database, this information can become difficult to organize, retrieve, and analyze consistently.

RepoPulse addresses this problem by using a relational database to store repository-related information and SQL queries to generate meaningful activity reports.

The project consists of two primary components:

1. **MySQL database:** Stores structured repository data and implements relational constraints, SQL queries, stored routines, triggers, transactions, and indexes.
2. **Java JDBC application:** Connects to the database and provides a menu-driven interface for repository management and activity reporting.

The project uses manually prepared sample data representing GitHub-style activity. It does not currently retrieve live information from the GitHub API.

## Objectives

The main objectives of RepoPulse are:

* Design and implement a relational database with multiple related entities.
* Apply primary keys, foreign keys, unique constraints, and other integrity rules where appropriate.
* Organize data according to normalization principles.
* Demonstrate SQL retrieval, filtering, sorting, joins, subqueries, and aggregate functions.
* Implement stored procedures, functions, and triggers.
* Demonstrate transaction management using `COMMIT`, `ROLLBACK`, and `SAVEPOINT`.
* Connect a Java application to MySQL using JDBC.
* Implement repository CRUD operations using parameterized SQL statements.
* Generate repository activity and open-issue reports.
* Demonstrate database access control through users with different privileges.

## Features

### Repository Management

The Java application supports the following repository operations:

* View all repositories.
* Search for repositories.
* Add a new repository.
* Update existing repository information.
* Delete a repository when permitted by database constraints.

Repository records include information such as the repository name, GitHub URL, description, visibility, creation timestamp, and application user responsible for tracking the repository.

### Repository Activity Reporting

RepoPulse retrieves activity information from related database tables.

The reporting features include:

* Repository activity summaries.
* Total commit counts.
* Total issue counts.
* Open-issue counts.
* Open issues associated with repositories.

### Relational Data Management

The database organizes repository activity into separate entities rather than storing all information in a single table.

This approach reduces unnecessary duplication and supports consistent relationships between repositories, contributors, memberships, commits, and issues.

### Transaction Demonstration

The project demonstrates transaction management using SQL transaction statements and a Java transaction workflow.

The Java demonstration includes updates to issue records, a savepoint, rollback to the savepoint, and transaction completion.

### Database Security

The project includes a database access-control demonstration with separate administrator and viewer users.

The administrator is granted data-management privileges, while the viewer is restricted to read-only access.

## Technology Stack

| Technology        | Purpose                                                 |
| ----------------- | ------------------------------------------------------- |
| Java              | Application logic and command-line interface            |
| MySQL             | Relational database management                          |
| JDBC              | Communication between Java and MySQL                    |
| MySQL Connector/J | JDBC driver for MySQL                                   |
| Apache Maven      | Dependency management and project build                 |
| SQL               | Database creation, querying, and manipulation           |
| Git and GitHub    | Version control and project hosting                     |
| dotenv-java       | Loading local database configuration from a `.env` file |

The Java project uses Maven and the `com.repopulse` package. Its entry point is `com.repopulse.Main`.

## System Architecture

RepoPulse follows a simple layered architecture.

```text
                 USER
                   |
                   v
        +----------------------+
        |  Java Console Menu   |
        |      Main.java       |
        +----------------------+
                   |
                   v
        +----------------------+
        |    RepositoryDAO     |
        | Database Operations  |
        +----------------------+
                   |
                   v
        +----------------------+
        |     DBConnection     |
        |   JDBC Connection    |
        +----------------------+
                   |
                   v
        +----------------------+
        |       MySQL          |
        |     repopulse_db     |
        +----------------------+
                   |
          +--------+---------+
          |        |         |
          v        v         v
       Queries   Routines  Transactions
```

### Architecture Components

**Java Console Menu:** Accepts user input and provides access to the application's repository-management and reporting operations.

**RepositoryDAO:** Encapsulates database operations and executes SQL statements through JDBC.

**DBConnection:** Establishes a connection to MySQL using JDBC and reads database credentials from configuration.

**MySQL Database:** Stores the project's relational data and executes SQL queries, stored routines, triggers, and transactions.

**SQL Scripts:** Define and populate the database and demonstrate its queries, routines, indexing, transactions, and access-control configuration.

## Database Design

The database is named `repopulse_db` and contains seven principal tables.

| Table              | Description                                                                |
| ------------------ | -------------------------------------------------------------------------- |
| `AppUser`          | Stores application users and their roles.                                  |
| `Repository`       | Stores repository details and the user tracking each repository.           |
| `Contributor`      | Stores contributor identities and display information.                     |
| `Membership`       | Represents contributors associated with repositories.                      |
| `commits`          | Stores commit information associated with repositories and contributors.   |
| `Issue`            | Stores repository issues, their status, reporters, and optional assignees. |
| `IssueStatusAudit` | Stores records of issue-status changes.                                    |

### Entity Relationships

The database models the following relationships:

* An application user can track multiple repositories.
* A repository can have multiple contributors through the `Membership` table.
* A contributor can belong to multiple repositories.
* A repository can contain multiple commits.
* A contributor can author multiple commits.
* A repository can contain multiple issues.
* A contributor can report issues and may be assigned issues.
* Issue-status changes can generate audit records through a database trigger.

Primary keys identify individual records, while foreign keys enforce selected relationships between tables. Unique constraints prevent duplicate repository memberships, duplicate commit hashes within the same repository, and duplicate issue numbers within the same repository.

The `AppUser` and `Contributor` entities are intentionally maintained as separate concepts. Application users interact with RepoPulse, whereas contributors represent developers associated with repository activity.

The `IssueStatusAudit` table is designed to preserve historical status-change information independently of the current issue record.

### Sample Data

The project includes illustrative sample data for all seven tables. The initial dataset contains approximately ten records in each principal entity table, with audit records generated when issue statuses change.

The exact number of audit records may vary because they depend on the status changes performed during testing.

The data is manually prepared and does not represent a live synchronization with GitHub.

## SQL Features

The SQL scripts demonstrate the following database concepts.

### Data Definition and Integrity

* Table creation and schema definition.
* Primary keys and foreign keys.
* Unique constraints.
* Appropriate column types and nullability.
* Domain restrictions for issue status.
* Relationships between repositories, contributors, commits, and issues.

### Data Manipulation

The project demonstrates:

* `INSERT` for adding records.
* `UPDATE` for modifying records.
* `DELETE` for removing eligible records.
* `SELECT` for retrieving information.

### Data Retrieval and Analysis

The queries demonstrate:

* Filtering with `WHERE`.
* Sorting with `ORDER BY`.
* Combining tables with `JOIN` and `LEFT JOIN`.
* Aggregation using `COUNT()`.
* Grouping with `GROUP BY`.
* Filtering grouped results using `HAVING`, where applicable.
* Nested queries using subqueries.
* Repository activity and open-issue reports.

### Stored Procedure

The stored procedure `GetRepositoryActivity` accepts a repository ID and returns a summary containing the repository name, total commits, total issues, and open issues.

This demonstrates how database logic can be encapsulated in a reusable routine.

### Stored Function

The function `GetOpenIssueCount` accepts a repository ID and returns the number of open issues associated with that repository.

It demonstrates the use of a stored function to calculate and return a database value.

### Trigger and Audit Logging

The trigger `trg_issue_status_audit` runs after an issue's status is updated.

When the old and new statuses differ, the trigger inserts an audit record containing the issue ID, old status, new status, and change timestamp.

This demonstrates how triggers can automatically maintain an audit trail in response to database changes.

### Indexes

The project defines indexes intended to improve common query patterns:

| Index                         | Indexed Columns                                 | Purpose                                                      |
| ----------------------------- | ----------------------------------------------- | ------------------------------------------------------------ |
| `idx_repository_name`         | `Repository.repo_name`                          | Supports repository-name searches.                           |
| `idx_commits_repository_date` | `commits.repository_id`, `commits.committed_at` | Supports repository-specific commit queries involving dates. |
| `idx_issue_repository_status` | `Issue.repository_id`, `Issue.status`           | Supports filtering issues by repository and status.          |

The effectiveness of these indexes depends on table size, query structure, and the execution plans selected by MySQL.

### Transaction Management

The project demonstrates the following transaction statements:

* `START TRANSACTION` to begin a transaction.
* `SAVEPOINT` to establish a point to which a transaction can be partially rolled back.
* `ROLLBACK TO SAVEPOINT` to undo changes made after a savepoint.
* `COMMIT` to make transaction changes permanent.
* `ROLLBACK` to cancel uncommitted changes.

These operations illustrate how related database modifications can be controlled to preserve consistency.

## Java Application

The Java application connects to the MySQL database through JDBC.

### JDBC Implementation

The application uses the following JDBC components:

* `DriverManager` to establish database connections.
* `Connection` to represent an active database connection.
* `PreparedStatement` to execute parameterized SQL statements.
* `CallableStatement` to invoke stored procedures.
* `ResultSet` to process query results.
* `SQLException` to handle database errors.

Database connections and other JDBC resources should be managed with appropriate cleanup, including try-with-resources where applicable.

### Application Menu

The console application provides the following operations:

| Option | Operation                         |
| ------ | --------------------------------- |
| 1      | View all repositories             |
| 2      | Search repositories               |
| 3      | Add a repository                  |
| 4      | Update a repository               |
| 5      | Delete a repository               |
| 6      | View repository activity          |
| 7      | View open issues                  |
| 8      | Exit                              |
| 9      | Run the transaction demonstration |

The application uses the repository DAO to perform database operations and retrieve report data.

## Project Structure

The repository is organized into SQL scripts, sample data, and a Java Maven application.

```text
RepoPulse/
|
+-- data/
|   +-- SQL scripts for sample data
|
+-- queries/
|   +-- queries.sql
|   +-- routines.sql
|   +-- indexes.sql
|   +-- access_control.sql
|   +-- transaction-related SQL script(s)
|
+-- java-app/
|   +-- pom.xml
|   +-- .env                  # Local configuration; not committed
|   +-- src/
|       +-- main/
|           +-- java/
|               +-- com/
|                   +-- repopulse/
|                       +-- Main.java
|                       +-- DBConnection.java
|                       +-- RepositoryDAO.java
|
+-- .gitignore
+-- README.md
```

The exact names and locations of the schema-creation and data-insertion scripts may differ according to the files committed to the repository. Run those scripts in the order required by their dependencies.

Generated Maven build output, including the `java-app/target/` directory, is not part of the source code.

## Prerequisites

Before running RepoPulse, ensure that the following are installed:

1. **Java Development Kit (JDK):** The project is configured for Java release 26.
2. **Apache Maven:** Required to build and run the Java application.
3. **MySQL Server:** Required to create and operate the `repopulse_db` database.
4. **Git:** Recommended for cloning and managing the repository.

The MySQL Connector/J driver and other Java dependencies are declared in the Maven project configuration.

## Installation and Setup

### 1. Clone the Repository

Clone the repository from GitHub and enter the project directory:

```bash
git clone <YOUR_REPOSITORY_URL>
cd RepoPulse
```

Replace `<YOUR_REPOSITORY_URL>` with the actual URL of your GitHub repository.

### 2. Create the Database

Start MySQL and connect through the MySQL command-line client.

Execute the schema-creation SQL scripts from the repository in dependency order. Create the tables before running scripts that insert sample data or define routines and triggers that depend on those tables.

Ensure that the database is named:

```sql
CREATE DATABASE repopulse_db;
```

If the database has already been created, select it instead:

```sql
USE repopulse_db;
```

Run the applicable schema and data scripts from the repository. Then execute the query, routine, trigger, index, transaction, and access-control scripts as required.

Some scripts depend on existing tables, data, or database privileges. Review their contents and follow their intended execution order.

### 3. Verify the Database

Select the database:

```sql
USE repopulse_db;
```

List the tables:

```sql
SHOW TABLES;
```

Check the number of records in a table:

```sql
SELECT COUNT(*) AS total_repositories
FROM Repository;
```

Repeat the relevant checks for the other tables to verify that schema creation and sample-data insertion completed successfully.

### 4. Configure Database Credentials

Navigate to the Java application directory:

```powershell
cd java-app
```

Create a local file named `.env` in this directory.

Add the following configuration:

```dotenv
REPOPULSE_DB_USER=root
REPOPULSE_DB_PASSWORD=your_actual_mysql_password
```

Replace the example password with the password for your local MySQL account. If you use a different database user, enter that username instead.

The application reads these values through `dotenv-java`, with environment variables available as a fallback.

The default JDBC connection URL is:

```text
jdbc:mysql://localhost:3306/repopulse_db
```

If MySQL runs on another host or port, update the connection URL in `DBConnection.java` accordingly.

**Important:** Never commit `.env` or expose database passwords in source code, screenshots, documentation, or public repositories.

### 5. Build the Java Application

From the `java-app` directory, run:

```powershell
mvn clean compile
```

A successful build should end with:

```text
BUILD SUCCESS
```

### 6. Run the Application

Start RepoPulse using:

```powershell
mvn exec:java
```

Run the command from the `java-app` directory so that the application can locate its local `.env` file.

If the application reports that credentials are missing, verify the filename, file location, configuration keys, and current working directory.

## Running the Application

After the database connection is established, the console menu is displayed.

A typical workflow is:

1. Select the option to view all repositories.
2. Search for a repository by name.
3. Add or update a repository.
4. View repository activity.
5. Review open issues.
6. Run the transaction demonstration.
7. Exit the application.

The actual results depend on the records currently stored in `repopulse_db`.

The application requires a running MySQL server and valid database credentials. The database schema and sample data must be created before the Java application can perform its operations.

## Database Access Control

RepoPulse includes an SQL script for demonstrating separate database accounts with different privileges.

### Administrator

The administrator account is granted the privileges required for data management, including:

* `SELECT`
* `INSERT`
* `UPDATE`
* `DELETE`

### Viewer

The viewer account is granted read-only access through `SELECT` privileges.

Write operations such as `UPDATE` are denied when the viewer lacks the necessary privileges.

The access-control script demonstrates the use of `GRANT` and `REVOKE` and illustrates how database permissions can restrict operations independently of the application interface.

Execute the access-control script using an appropriately privileged MySQL account. Account names, passwords, and grants should be reviewed before use in any shared or production environment.

The application must connect using the database account whose permissions match the operations being tested.

## Testing and Verification

The project was tested through SQL execution and the Java console application.

The principal verification activities include:

| Test Area             | Verification                                                           |
| --------------------- | ---------------------------------------------------------------------- |
| Database creation     | Confirmed that the database tables were created.                       |
| Sample data           | Verified that sample records could be inserted and queried.            |
| SQL queries           | Executed retrieval and reporting queries against the database.         |
| Stored procedure      | Tested repository activity retrieval.                                  |
| Stored function       | Tested open-issue counting.                                            |
| Trigger               | Verified issue-status audit record creation when status changes.       |
| Transactions          | Tested commit, rollback, and savepoint behavior.                       |
| JDBC connection       | Verified application connectivity to MySQL.                            |
| Repository management | Tested the implemented repository operations through the console menu. |
| Activity reports      | Tested repository activity and open-issue reports.                     |
| Access control        | Tested the differing privileges of administrator and viewer accounts.  |

Successful execution of the SQL scripts, database routines, and Java application demonstrates the integration of relational database functionality with an application layer.

## Security Considerations

RepoPulse incorporates several practices intended to improve the security and reliability of database access:

* Database credentials are stored outside the Java source code.
* The local `.env` file is excluded from version control.
* Parameterized JDBC statements are used for repository operations to reduce SQL injection risk.
* Database constraints help prevent invalid relationships and duplicate records.
* Separate database accounts demonstrate the principle of granting only the privileges needed for a role.

These measures are appropriate for a course project. A production system would require additional controls, such as stronger credential management, secure deployment configuration, detailed audit logging, and appropriate authentication and authorization at the application level.

## Limitations

The current version of RepoPulse has the following limitations:

* Repository activity is based on manually prepared sample data.
* Live GitHub API integration is not implemented.
* The interface is command-line based rather than graphical or web-based.
* Reporting is limited to the queries and routines implemented in the project.
* The application is designed primarily as an educational demonstration rather than a production service.

## Future Enhancements

Possible extensions include:

* Integrating the GitHub REST API to retrieve real repository information.
* Scheduling periodic synchronization of commits, contributors, and issues.
* Building a web interface or graphical dashboard.
* Adding visual analytics for commit activity and issue trends.
* Supporting date-range filters and more detailed contributor statistics.
* Introducing application-level authentication and role-based authorization.
* Adding automated tests and database migration scripts.
* Improving logging and error reporting.
* Deploying the application with secure external configuration.

These enhancements could transform RepoPulse from a database coursework project into a more comprehensive repository analytics application.

## Learning Outcomes

Developing RepoPulse provided practical experience with:

* Relational database design and entity relationships.
* Primary keys, foreign keys, unique constraints, and data integrity.
* Database normalization and redundancy reduction.
* SQL data manipulation and analytical queries.
* Stored procedures, stored functions, and triggers.
* Transaction control and savepoints.
* Indexing and query performance considerations.
* Java database connectivity through JDBC.
* Parameterized SQL statements and database error handling.
* Maven-based Java project management.
* Database access control and privilege management.
* Version control and project documentation.

## Author

**Project:** RepoPulse — GitHub Repository Activity Tracker
**Category:** Database Management Systems (DBMS) Course Project
**Database:** MySQL
**Application Language:** Java
**Connectivity:** JDBC
**Build Tool:** Apache Maven

Developed for educational purposes to demonstrate the integration of relational database concepts, SQL programming, and Java application development.
