CREATE TABLE repository_contributors (
    repository_id INT NOT NULL,
    contributor_id INT NOT NULL,
    contributor_role VARCHAR(20) NOT NULL CHECK (contributor_role IN ('MAINTAINER', 'CONTRIBUTOR')),
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (repository_id, contributor_id),
    FOREIGN KEY (repository_id) REFERENCES repositories(id),
    FOREIGN KEY (contributor_id) REFERENCES contributors(id)
);