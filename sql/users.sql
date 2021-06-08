CREATE TABLE users (
    id       INTEGER      PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(255) NOT NULL UNIQUE,
    email    VARCHAR(255) NOT NULL UNIQUE,
    created  INTEGER      NOT NULL,
    password TEXT         NOT NULL,
);