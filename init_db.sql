CREATE DATABASE postgres_db;

USE postgres_db;

-- created tables

--postgresql

-- User Table
CREATE TABLE users (
    userID SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    email VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Team table
CREATE TABLE teams (
    teamID SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Project Table
CREATE TABLE projects (
    projectID SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    team_id INT,
    FOREIGN KEY (team_id) REFERENCES teams(teamID)
);

-- Task Table
CREATE TABLE tasks (
    taskID SERIAL PRIMARY KEY,
    title VARCHAR(30) NOT NULL,
    description TEXT,
    status VARCHAR(30) CHECK (status IN ('TO-DO', 'IN PROGRESS', 'COMPLETED')) NOT NULL,
    project_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(projectID)
);

-- Comments Table
CREATE TABLE comments (
    user_id INT,
    task_id INT,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(userID),
    FOREIGN KEY (task_id) REFERENCES tasks(taskID),
    PRIMARY KEY (user_id, task_id)
);

-- User-Equipe Association Table
CREATE TABLE users_teams (
    team_id INT,
    user_id INT,
    begin_date DATE,
    PRIMARY KEY (team_id, user_id),
    FOREIGN KEY (team_id) REFERENCES teams(teamID),
    FOREIGN KEY (user_id) REFERENCES users(userID)
);

-- -- sqlServer
-- create table users (
--     userID INT IDENTITY(1,1),
--     name varchar(30) NOT NULL,
--     email varchar(50) NOT NULL,
--     password varchar(255) NOT NULL,
--     create_at timestamp default current_timestamp,
--     constraint pk_userID_user primary key (userID)
-- );

-- CREATE TABLE teams (
--     teamID INT IDENTITY(1,1),
--     name VARCHAR(30) NOT NULL,
--     description TEXT,
--     create_at timestamp default CURRENT_TIMESTAMP,
--     CONSTRAINT pk_teamID_team PRIMARY KEY (teamID)
-- );

-- CREATE TABLE projects (
--     projectID INT IDENTITY(1,1),
--     name VARCHAR(30) NOT NULL,
--     team_id INT,
--     CONSTRAINT fk_teamID_team FOREIGN KEY (team_id) REFERENCES teams (teamID),
--     CONSTRAINT pk_projectID_projects PRIMARY KEY (projectID)
-- );

-- CREATE TABLE tasks (
--     taskID INT IDENTITY(1,1),
--     title VARCHAR(30) NOT NULL,
--     description TEXT,
--     status VARCHAR(30) CHECK (status IN ('TO-DO', 'IN PROGRESS', 'COMPLETED')) NOT NULL, --only to three options
--     project_id INT,
--     created_at timestamp default CURRENT_TIMESTAMP,
--     CONSTRAINT fk_projectID_projects FOREIGN KEY (project_id) REFERENCES projects (projectID),
--     CONSTRAINT pk_taskID_tasks PRIMARY KEY (taskID)
-- );

-- CREATE TABLE comments (
--     user_id INT,
--     task_id INT,
--     comment TEXT NOT NULL,
--     created_at timestamp DEFAULT CURRENT_TIMESTAMP,
--     CONSTRAINT fk_userID_user FOREIGN KEY (user_id) REFERENCES users (userID),
--     CONSTRAINT fk_taskID_task FOREIGN KEY (task_id) REFERENCES tasks (taskID),
--     CONSTRAINT pk_userID_taskID_comments PRIMARY KEY (user_id, task_id)
-- );

-- CREATE TABLE users_teams (
--     team_id INT,
--     user_id INT,
--     begin_date DATE NOT NULL,
--     CONSTRAINT fk_teamID_team FOREIGN KEY (team_id) REFERENCES teams (teamID),
--     CONSTRAINT fk_userID_user FOREIGN KEY (user_id) REFERENCES users (userID),
--     CONSTRAINT pk_teamID_userID PRIMARY KEY (team_id, user_id)
-- );


-- End

-- Altered tables

-- add new column 
ALTER TABLE projects ADD create_at timestamp default CURRENT_TIMESTAMP;

-- I forgot to put the autoincrement in the ID columns and now?
-- postgreSql process

-- users table

-- Step 1: Add a new SERIAL column
ALTER TABLE users ADD COLUMN new_userID SERIAL;

-- Step 2: Update references (example for comments table)
UPDATE comments SET user_id = (SELECT new_userID FROM users WHERE userID = user_id);

-- Step 3: Remove the old column
ALTER TABLE users DROP COLUMN userID;

-- Step 4: Rename the new column
ALTER TABLE users RENAME COLUMN new_userID TO userID;

-- Step 5: Update constraints
ALTER TABLE users DROP CONSTRAINT pk_userID_user;
ALTER TABLE users ADD CONSTRAINT pk_userID_user PRIMARY KEY (userID);
ALTER TABLE comments DROP CONSTRAINT fk_userID_user;
ALTER TABLE comments ADD CONSTRAINT fk_userID_user FOREIGN KEY (user_id) REFERENCES users(userID);

-- SqlServer process
-- -- Step 1: Create a new column with the identity property
-- -- ALTER TABLE users
-- -- ADD new_userID INT IDENTITY(1,1);

-- -- ALTER TABLE comments
-- -- NOCHECK CONSTRAINT fk_userID_user;

-- -- Step 2: Copy data from the old column to the new column
-- -- SET IDENTITY_INSERT users ON; -- Allow insertion of values in the identity column
-- -- UPDATE users
-- -- SET new_userID = userID;

-- -- Step 3: Remove the old column
-- -- ALTER TABLE users
-- -- DROP COLUMN userID;

-- -- ALTER TABLE users
-- -- RENAME COLUMN new_userID TO userID;

-- -- ALTER TABLE comments
-- -- CHECK CONSTRAINT fk_userID_user;

-- -- ALTER TABLE comments
-- -- DROP CONSTRAINT fk_userID_user;

-- -- ALTER TABLE comments
-- -- ADD CONSTRAINT fk_userID_user FOREIGN KEY (user_id) REFERENCES users(userID);


-- For drop all tables
-- Remove foreign keys
ALTER TABLE comments DROP CONSTRAINT IF EXISTS fk_userID_user;
ALTER TABLE comments DROP CONSTRAINT IF EXISTS fk_taskID_task;
ALTER TABLE users_teams DROP CONSTRAINT IF EXISTS fk_teamID_team;
ALTER TABLE users_teams DROP CONSTRAINT IF EXISTS fk_userID_user;
ALTER TABLE tasks DROP CONSTRAINT IF EXISTS fk_projectID_projects;
ALTER TABLE projects DROP CONSTRAINT IF EXISTS fk_teamID_team;

-- Drop all tables
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS teams CASCADE;
DROP TABLE IF EXISTS projects CASCADE;
DROP TABLE IF EXISTS tasks CASCADE;
DROP TABLE IF EXISTS comments CASCADE;
DROP TABLE IF EXISTS users_teams CASCADE;


-- in SqlServer
-- Disable Foreign Key restrictions temporarily (optional, if necessary)
-- EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"

-- -- Drop the tables
-- DROP TABLE IF EXISTS comments;
-- DROP TABLE IF EXISTS users_teams;
-- DROP TABLE IF EXISTS tasks;
-- DROP TABLE IF EXISTS projects;
-- DROP TABLE IF EXISTS teams;
-- DROP TABLE IF EXISTS users;

-- Rehabilitate foreign key restrictions (optional, if necessary)
-- EXEC sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"