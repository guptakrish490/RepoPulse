--- 1. JOIN — Repository details with tracking users
SELECT
    r.repository_id,
    r.repo_name,
    r.github_url,
    r.visibility,
    u.username AS tracked_by
FROM
    Repository r
    INNER JOIN AppUser u ON r.tracked_by_user_id = u.user_id;



--- 2. GROUP BY and HAVING — Repositories with at least one commit
SELECT
    r.repo_name,
    COUNT(c.commit_id) AS total_commits
FROM
    Repository r
    LEFT JOIN commits c ON r.repository_id = c.repository_id
GROUP BY
    r.repository_id,
    r.repo_name
HAVING
    COUNT(c.commit_id) >= 1
ORDER BY
    total_commits DESC;



--- 3. Subquery — Contributors who have authored commits
SELECT
    contributor_id,
    github_username,
    display_name
FROM
    Contributor
WHERE
    contributor_id IN (
        SELECT DISTINCT
            contributor_id
        FROM
            commits
    );



--- 4. Analytical report — Issue status by repository
SELECT
    r.repo_name,
    COUNT(i.issue_id) AS total_issues,
    SUM(
        CASE
            WHEN i.status = 'OPEN' THEN 1
            ELSE 0
        END
    ) AS open_issues,
    SUM(
        CASE
            WHEN i.status = 'CLOSED' THEN 1
            ELSE 0
        END
    ) AS closed_issues
FROM
    Repository r
    LEFT JOIN Issue i ON r.repository_id = i.repository_id
GROUP BY
    r.repository_id,
    r.repo_name
ORDER BY
    total_issues DESC;

--- 5. INSERT — Add a new issue
INSERT INTO
    Issue (
        repository_id,
        issue_number,
        title,
        status,
        reporter_id,
        assignee_id,
        created_at
    )
VALUES
    (
        1,
        3,
        'Add repository activity summary',
        'OPEN',
        1,
        NULL,
        NOW ()
    );



--- 6. UPDATE — Close an issue
UPDATE Issue
SET
    status = 'CLOSED'
WHERE
    repository_id = 1
    AND issue_number = 3;



--- 7. DELETE — Remove the test issue
DELETE FROM Issue
WHERE
    repository_id = 1
    AND issue_number = 3;