CREATE DATABASE households_db;

\c households_db

CREATE TABLE households (
    LCLid TEXT PRIMARY KEY,
    stdorToU TEXT,
    Acorn TEXT,
    Acorn_grouped TEXT,
    file TEXT
);