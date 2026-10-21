--- 1. Test ROLLBACK and SAVEPOINT
USE repopulse_db;

START TRANSACTION;

UPDATE Issue
SET
    status = 'CLOSED'
WHERE
    issue_id = 1;

SAVEPOINT after_first_update;

UPDATE Issue
SET
    status = 'OPEN'
WHERE
    issue_id = 2;

ROLLBACK TO SAVEPOINT after_first_update;

ROLLBACK;

SELECT
    issue_id,
    status
FROM
    Issue
WHERE
    issue_id IN (1, 2);