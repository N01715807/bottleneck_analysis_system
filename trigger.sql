-- Select the database
USE bottleneck_analysis_system;

-- Drop the trigger if it already exists
DROP TRIGGER IF EXISTS trg_update_task_log;

DELIMITER //

-- Create the trigger
CREATE TRIGGER trg_update_task_log
AFTER UPDATE ON tasks -- Fires AFTER an UPDATE is performed on the 'tasks' table
FOR EACH ROW -- Executes once for each updated row

BEGIN
  -- Only proceed if the 'status' value has actually changed
  IF NEW.status <> OLD.status THEN
    -- Insert a new log entry into 'task_logs' capturing the status change
    INSERT INTO task_logs (
        task_id,
        status_before,
        status_after,
        changed_at
    )
    VALUES (
        NEW.task_id,
        OLD.status,
        NEW.status,
        NOW()
    );
  END IF;
END //

DELIMITER ;