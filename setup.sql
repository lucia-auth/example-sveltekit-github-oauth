CREATE TABLE user (
    id INTEGER NOT NULL PRIMARY KEY,
    github_id INTEGER NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE,
    username TEXT NOT NULL
);

CREATE INDEX github_id_index ON user(github_id);

CREATE TABLE session (
    id TEXT NOT NULL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES user(id),
    expires_at INTEGER NOT NULL
);