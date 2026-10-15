CREATE TABLE repositories (
    id SERIAL PRIMARY KEY,
    repo_name VARCHAR(100) NOT NULL,
    repo_url VARCHAR(200) NOT NULL UNIQUE,
    primary_language VARCHAR(50) DEFAULT NULL,
    visibility VARCHAR(20) NOT NULL CHECK (visibility IN ('PUBLIC', 'PRIVATE')),
    owner_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    owner_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);