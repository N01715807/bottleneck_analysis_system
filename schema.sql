-- create database --
create database bottleneck_analysis_system;

-- use database --
use bottleneck_analysis_system;

-- CREATE TABLE task_types --
CREATE TABLE task_types(
    task_type_id INT AUTO_INCREMENT,
    type_name VARCHAR(50),
    PRIMARY KEY(task_type_id)
);

-- CREATE TABLE collaborators --
CREATE TABLE collaborators(
    user_id INT AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    PRIMARY KEY(user_id)
);

-- CREATE TABLE tasks --
CREATE TABLE tasks (
    task_id INT AUTO_INCREMENT,
    task_name VARCHAR(100),
    status ENUM('stuck','resolved'),
    description TEXT,
    task_type_id INT,
    assigned_user_id INT,
    last_updated DATE,
    created_at DATE,
    PRIMARY KEY (task_id),
    FOREIGN KEY (task_type_id) REFERENCES task_types(task_type_id),
    FOREIGN KEY (assigned_user_id) REFERENCES collaborators(user_id)
);

-- CREATE TABLE task_collaborators --
CREATE TABLE task_collaborators (
    task_id INT,
    user_id INT,
    role VARCHAR(50),
    PRIMARY KEY(task_id,user_id),
    FOREIGN KEY(task_id) REFERENCES tasks(task_id),
    FOREIGN KEY(user_id) REFERENCES collaborators(user_id)
);

-- CREATE TABLE resources --
CREATE TABLE resources (
    resource_id INT AUTO_INCREMENT,
    task_id INT,
    resource_name VARCHAR(100),
    is_available BOOLEAN,
    PRIMARY KEY (resource_id),
    FOREIGN KEY (task_id) REFERENCES tasks (task_id)
);

-- CREATE TABLE suggestions --
CREATE TABLE suggestions (
    suggestion_id INT AUTO_INCREMENT,
    task_id INT,
    suggestion_text TEXT,
    created_at DATETIME,
    PRIMARY KEY (suggestion_id),
    FOREIGN KEY (task_id) REFERENCES tasks (task_id)
);

-- CREATE TABLE task_logs --
CREATE TABLE task_logs (
    log_id INT AUTO_INCREMENT,
    task_id INT,
    status_before VARCHAR(50),
    status_after VARCHAR(50),
    changed_at DATETIME,
    PRIMARY KEY (log_id),
    FOREIGN KEY (task_id) REFERENCES tasks (task_id)
);