CREATE INDEX idx_repository_name ON Repository (repo_name);

CREATE INDEX idx_commits_repository_date ON commits (repository_id, committed_at);

CREATE INDEX idx_issue_repository_status ON Issue (repository_id, status);