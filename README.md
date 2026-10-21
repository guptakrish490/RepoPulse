# RepoPulse — GitHub Repository Activity Tracker

## Introduction
RepoPulse is a database-backed application designed to organise and track GitHub repository information. It stores tracked repositories, contributor profiles, repository membership records, commit history and issue details. 
It supports repository management, activity tracking and analytical reports about contributions and issues.
The project is meant to demonstrate practical DBMS concepts through a working MySQL database and a Java JDBC application. 
The database is MySQL, the application is written in Java, and the two are connected through JDBC using MySQL Connector/J. The initial data is manually entered or seeded with SQL scripts.

## Problem Statement

Developers often work on multiple GitHub repositories, each containing commits, contributors, and issues. Understanding repository activity across these projects can become difficult when information is scattered across different repositories.

RepoPulse is a database management application designed to organize and track GitHub repository information. It stores repository details, contributor information, commit records, and issue details in a relational database. It allows users to manage tracked repositories and generate reports about development activity.

The application uses MySQL for data storage and Java JDBC for database operations.

## Objectives

1. Design and build a MySQL database for tracked repositories, contributor profiles, repository memberships, commits and issues.
2. Manage repositories and contributors, and track commits and issues.
3. Produce repository activity reports and contribution and issue summaries, including unresolved issues.
4. Connect the database to a Java application using JDBC.
5. Apply the DBMS concepts from the course: ER modelling, normalization, constraints, stored programs, transactions and query design.