--- 1. Stored procedure — Repository activity summary
-- CALL GetRepositoryActivity(1);
USE repopulse_db;

DELIMITER // 
CREATE PROCEDURE GetRepositoryActivity (IN p_repository_id INT) 
BEGIN
SELECT
    r.repository_id,
    r.repo_name,
    (
        SELECT
            COUNT(*)
        FROM
            commits c
        WHERE
            c.repository_id = r.repository_id
    ) AS total_commits,
    (
        SELECT
            COUNT(*)
        FROM
            Issue i
        WHERE
            i.repository_id = r.repository_id
    ) AS total_issues,
    (
        SELECT
            COUNT(*)
        FROM
            Issue i
        WHERE
            i.repository_id = r.repository_id
            AND i.status = 'OPEN'
    ) AS open_issues
FROM
    Repository r
WHERE
    r.repository_id = p_repository_id;

END // 
DELIMITER;



--- 2. User-defined function — Count open issues
-- SELECT GetOpenIssueCount(1) AS open_issues;
DELIMITER / / CREATE FUNCTION GetOpenIssueCount (p_repository_id INT) RETURNS INT READS SQL DATA BEGIN DECLARE v_open_count INT DEFAULT 0;

SELECT
    COUNT(*) INTO v_open_count
FROM
    Issue
WHERE
    repository_id = p_repository_id
    AND status = 'OPEN';

RETURN v_open_count;

END // 
DELIMITER;


--- 3. Trigger — Audit issue status changes
CREATE TABLE
    IF NOT EXISTS IssueStatusAudit (
        audit_id INT AUTO_INCREMENT PRIMARY KEY,
        issue_id INT NOT NULL,
        old_status ENUM ('OPEN', 'CLOSED') NOT NULL,
        new_status ENUM ('OPEN', 'CLOSED') NOT NULL,
        changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    ) ENGINE = InnoDB;


DELIMITER // 
CREATE TRIGGER trg_issue_status_audit AFTER
UPDATE ON Issue FOR EACH ROW BEGIN IF OLD.status <> NEW.status THEN
INSERT INTO
    IssueStatusAudit (issue_id, old_status, new_status)
VALUES
    (OLD.issue_id, OLD.status, NEW.status);

END IF;

END // 
DELIMITER;