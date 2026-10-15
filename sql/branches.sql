CREATE TABLE branches(
    id SERIAL PRIMARY KEY,
    repository_id INT NOT NULL REFERENCES repositories(id) ON DELETE CASCADE,
    branch_name VARCHAR(150) NOT NULL,
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(repository_id, branch_name)
);