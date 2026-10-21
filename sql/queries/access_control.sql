USE repopulse_db;

-- Create the Admin and Viewer database users.
CREATE USER IF NOT EXISTS 'repopulse_admin'@'localhost'
IDENTIFIED BY 'Admin_Test_2026!';

CREATE USER IF NOT EXISTS 'repopulse_viewer'@'localhost'
IDENTIFIED BY 'Viewer_Test_2026!';

-- Admin can read and modify RepoPulse data.
GRANT SELECT, INSERT, UPDATE, DELETE
ON repopulse_db.*
TO 'repopulse_admin'@'localhost';

-- Viewer can only read RepoPulse data.
GRANT SELECT
ON repopulse_db.*
TO 'repopulse_viewer'@'localhost';

-- Display the granted privileges.
SHOW GRANTS FOR 'repopulse_admin'@'localhost';
SHOW GRANTS FOR 'repopulse_viewer'@'localhost';
