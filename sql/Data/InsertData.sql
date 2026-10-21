-- 1. Inser appuser
INSERT INTO
    AppUser (username, email, role)
VALUES
    ('admin1', 'admin@repopulse.com', 'ADMIN'),
    ('viewer1', 'viewer@repopulse.com', 'VIEWER');


-- 2. Insert contributors
INSERT INTO
    Contributor (github_username, display_name)
VALUES
    ('krish-dev', 'Krish'),
    ('alex-codes', 'Alex Morgan'),
    ('sam-builds', 'Sam Wilson'),
    ('jordan-dev', 'Jordan Lee'),
    ('taylor-tech', 'Taylor Smith');


-- 3. Insert repository
INSERT INTO
    Repository (
        repo_name,
        github_url,
        description,
        visibility,
        created_at,
        tracked_by_user_id
    )
VALUES
    (
        'FlowForge',
        'https://github.com/krish-dev/flowforge',
        'PostgreSQL-backed background job queue',
        'PUBLIC',
        '2026-01-15 10:00:00',
        1
    ),
    (
        'RepoPulse',
        'https://github.com/krish-dev/repopulse',
        'GitHub repository activity tracking system',
        'PUBLIC',
        '2026-02-10 11:30:00',
        1
    ),
    (
        'TaskBoard',
        'https://github.com/alex-codes/taskboard',
        'Collaborative task management application',
        'PUBLIC',
        '2025-11-20 09:15:00',
        2
    ),
    (
        'CodeNotes',
        'https://github.com/sam-builds/codenotes',
        'A simple developer notes application',
        'PRIVATE',
        '2026-03-05 14:00:00',
        1
    ),
    (
        'DevTracker',
        'https://github.com/jordan-dev/devtracker',
        'Developer productivity tracking tool',
        'PUBLIC',
        '2025-09-12 16:45:00',
        2
    );

-- 4. Insert membership
INSERT INTO
    Membership (
        repository_id,
        contributor_id,
        membership_since,
        contribution_role
    )
VALUES
    (1, 1, '2026-01-15', 'Maintainer'),
    (1, 2, '2026-01-20', 'Developer'),
    (1, 3, '2026-02-01', 'Contributor'),
    (2, 1, '2026-02-10', 'Maintainer'),
    (2, 4, '2026-02-15', 'Developer'),
    (2, 5, '2026-02-20', 'Contributor'),
    (3, 2, '2025-11-20', 'Maintainer'),
    (3, 3, '2025-12-01', 'Developer'),
    (4, 3, '2026-03-05', 'Maintainer'),
    (5, 4, '2025-09-12', 'Maintainer');


-- 5. Insert commits
INSERT INTO
    commits (
        repository_id,
        contributor_id,
        commit_hash,
        commit_message,
        committed_at
    )
VALUES
    (
        1,
        1,
        'a100000000000000000000000000000000000001',
        'Initialize job queue project',
        '2026-01-16 09:30:00'
    ),
    (
        1,
        2,
        'a200000000000000000000000000000000000002',
        'Add worker processing logic',
        '2026-01-21 14:20:00'
    ),
    (
        1,
        3,
        'a300000000000000000000000000000000000003',
        'Improve error handling',
        '2026-02-02 11:15:00'
    ),
    (
        2,
        1,
        'b100000000000000000000000000000000000001',
        'Create initial database schema',
        '2026-02-11 10:00:00'
    ),
    (
        2,
        4,
        'b200000000000000000000000000000000000002',
        'Add repository tracking feature',
        '2026-02-16 13:45:00'
    ),
    (
        2,
        5,
        'b300000000000000000000000000000000000003',
        'Improve activity report layout',
        '2026-02-22 16:10:00'
    ),
    (
        3,
        2,
        'c100000000000000000000000000000000000001',
        'Create task board interface',
        '2025-11-22 12:00:00'
    ),
    (
        3,
        3,
        'c200000000000000000000000000000000000002',
        'Add task status updates',
        '2025-12-03 15:30:00'
    ),
    (
        4,
        3,
        'd100000000000000000000000000000000000001',
        'Initialize developer notes',
        '2026-03-06 09:00:00'
    ),
    (
        5,
        4,
        'e100000000000000000000000000000000000001',
        'Add productivity summary',
        '2025-09-14 17:00:00'
    );


-- 6. Insert issue
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
        1,
        'Worker crashes during processing',
        'OPEN',
        2,
        1,
        '2026-01-18 10:00:00'
    ),
    (
        1,
        2,
        'Retry mechanism needs improvement',
        'CLOSED',
        3,
        2,
        '2026-01-22 11:30:00'
    ),
    (
        2,
        1,
        'Repository activity count is incorrect',
        'OPEN',
        4,
        1,
        '2026-02-12 09:15:00'
    ),
    (
        2,
        2,
        'Add contributor summary report',
        'CLOSED',
        5,
        4,
        '2026-02-17 14:00:00'
    ),
    (
        2,
        3,
        'Improve issue filtering',
        'OPEN',
        2,
        NULL,
        '2026-02-23 16:20:00'
    ),
    (
        3,
        1,
        'Task status does not update',
        'OPEN',
        3,
        2,
        '2025-11-25 12:00:00'
    ),
    (
        3,
        2,
        'Fix task sorting',
        'CLOSED',
        2,
        3,
        '2025-12-05 13:45:00'
    ),
    (
        4,
        1,
        'Notes are not saved correctly',
        'OPEN',
        3,
        NULL,
        '2026-03-08 10:30:00'
    ),
    (
        5,
        1,
        'Monthly report has incorrect totals',
        'CLOSED',
        4,
        5,
        '2025-09-18 15:00:00'
    ),
    (
        5,
        2,
        'Add date-based filtering',
        'OPEN',
        5,
        4,
        '2025-09-20 11:15:00'
    );