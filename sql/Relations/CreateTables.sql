--- 1. Create appuser
CREATE TABLE
    AppUser (
        user_id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(50) NOT NULL UNIQUE,
        email VARCHAR(254) NOT NULL UNIQUE,
        role ENUM ('ADMIN', 'VIEWER') NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    ) ENGINE = InnoDB;


--- 2. create contributors
CREATE TABLE
    Contributor (
        contributor_id INT AUTO_INCREMENT PRIMARY KEY,
        github_username VARCHAR(100) NOT NULL UNIQUE,
        display_name VARCHAR(150)
    ) ENGINE = InnoDB;


--- 3. create repository
CREATE TABLE
    Repository (
        repository_id INT AUTO_INCREMENT PRIMARY KEY,
        repo_name VARCHAR(100) NOT NULL,
        github_url VARCHAR(255) NOT NULL UNIQUE,
        description TEXT,
        visibility ENUM ('PUBLIC', 'PRIVATE') NOT NULL,
        created_at DATETIME,
        tracked_by_user_id INT NOT NULL,
        CONSTRAINT 
            fk_repository_user FOREIGN KEY (tracked_by_user_id) REFERENCES AppUser (user_id) 
            ON UPDATE CASCADE 
            ON DELETE RESTRICT
    ) ENGINE = InnoDB;


--- 4. create membership
CREATE TABLE
    Membership (
        membership_id INT AUTO_INCREMENT PRIMARY KEY,
        repository_id INT NOT NULL,
        contributor_id INT NOT NULL,
        membership_since DATE,
        contribution_role VARCHAR(50) NOT NULL,
        CONSTRAINT 
            uq_membership UNIQUE (repository_id, contributor_id),
        CONSTRAINT 
            fk_membership_repository FOREIGN KEY (repository_id) REFERENCES Repository (repository_id) 
            ON UPDATE CASCADE 
            ON DELETE CASCADE,
        CONSTRAINT 
            fk_membership_contributor FOREIGN KEY (contributor_id) REFERENCES Contributor (contributor_id) 
            ON UPDATE CASCADE
            ON DELETE RESTRICT
    ) ENGINE = InnoDB;


--- 5. create commits
CREATE TABLE
    commits (
        commit_id INT AUTO_INCREMENT PRIMARY KEY,
        repository_id INT NOT NULL,
        contributor_id INT NOT NULL,
        commit_hash VARCHAR(60) NOT NULL UNIQUE,
        commit_message TEXT NOT NULL,
        committed_at DATETIME,

        CONSTRAINT 
            uq_repository_commit UNIQUE (repository_id, commit_hash),
        CONSTRAINT fk_commit_repository
            FOREIGN KEY (repository_id) REFERENCES Repository(repository_id)
            ON UPDATE CASCADE
            ON DELETE CASCADE,
        CONSTRAINT fk_commit_contributor
            FOREIGN KEY (contributor_id) REFERENCES Contributor(contributor_id)
            ON UPDATE CASCADE
            ON DELETE RESTRICT
    );


--- 6. create issue
CREATE TABLE
    Issue (
        issue_id INT AUTO_INCREMENT PRIMARY KEY,
        repository_id INT NOT NULL,
        issue_number INT NOT NULL,
        title VARCHAR(255) NOT NULL,
        status ENUM ('OPEN', 'CLOSED') NOT NULL DEFAULT 'OPEN',
        reporter_id INT NOT NULL,
        assignee_id INT NULL,
        created_at DATETIME NOT NULL,
        CONSTRAINT uq_repository_issue 
            UNIQUE (repository_id, issue_number),
        CONSTRAINT fk_issue_repository 
            FOREIGN KEY (reporter_id) REFERENCES Contributor (contributor_id) 
            ON UPDATE CASCADE 
            ON DELETE CASCADE,
        CONSTRAINT fk_issue_reporter 
            FOREIGN KEY (reporter_id) REFERENCES Contributor (contributor_id) 
            ON UPDATE CASCADE 
            ON DELETE RESTRICT,
        CONSTRAINT fk_issue_assignee 
            FOREIGN KEY (assignee_id) REFERENCES Contributor (contributor_id) 
            ON UPDATE CASCADE 
            ON DELETE SET NULL
    ) ENGINE = InnoDB;

