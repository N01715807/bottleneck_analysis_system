SE bottleneck_analysis_system;

-- 1) Insert minimal test data
INSERT INTO task_types (type_name) VALUES ('Demo Type');
SET @type_id = LAST_INSERT_ID();

INSERT INTO collaborators (name, email) VALUES ('Demo User', CONCAT('demo_', UUID(), '@test.com'));
SET @user_id = LAST_INSERT_ID();

INSERT INTO tasks (task_name, status, description, task_type_id, assigned_user_id, last_updated, created_at)
VALUES ('Demo Task', 'stuck', 'Waiting for approval from client.', @type_id, @user_id, CURDATE(), CURDATE());
SET @task_id = LAST_INSERT_ID();

INSERT INTO resources (task_id, resource_name, is_available)
VALUES (@task_id, 'Wait Approval', 0);

-- 2) Test View (should show the stuck task)
SELECT * FROM stuck_tasks WHERE task_id = @task_id;

-- 3) Test Trigger (update status to log changes)
UPDATE tasks SET status = 'resolved' WHERE task_id = @task_id;
UPDATE tasks SET status = 'stuck' WHERE task_id = @task_id;
SELECT * FROM task_logs WHERE task_id = @task_id;

-- 4) Test Procedure (simulate inactivity + run suggestions)
UPDATE tasks 
SET last_updated = DATE_SUB(CURDATE(), INTERVAL 10 DAY) 
WHERE task_id = @task_id;

CALL usp_generate_suggestions();
SELECT * FROM suggestions WHERE task_id = @task_id;