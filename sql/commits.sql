CREATE TABLE commits (
    id SERIAL PRIMARY KEY,
    repository_id INT NOT NULL,
    contributor_id INT NOT NULL,
    branch_id INT NOT NULL,
    commit_hash VARCHAR(80) NOT NULL UNIQUE,
    commit_message TEXT NOT NULL ,
    committed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (repository_id, contributor_id) REFERENCES repository_contributors(repository_id, contributor_id),
    FOREIGN KEY (repository_id, branch_id) REFERENCES branches(repository_id, id),
    UNIQUE(repository_id, commit_hash)
);