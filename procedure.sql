USE bottleneck_analysis_system;
DROP PROCEDURE IF EXISTS usp_generate_suggestions;

DELIMITER //

CREATE PROCEDURE usp_generate_suggestions()
BEGIN
  /* Rule A: Unavailable resources */
  INSERT INTO suggestions (task_id, suggestion_text, created_at)
  SELECT DISTINCT
         t.task_id,
         'This task is stuck due to unavailable resources. Please provide the missing resources.',
         NOW()
  FROM tasks AS t
  JOIN resources AS r
    ON r.task_id = t.task_id
  WHERE t.status = 'stuck'
    AND r.is_available = 0
    AND NOT EXISTS (
          SELECT 1
          FROM suggestions s
          WHERE s.task_id = t.task_id
            AND s.suggestion_text = 'This task is stuck due to unavailable resources. Please provide the missing resources.'
        );

  /* Rule B: Inactive for more than 7 days (or never updated) */
  INSERT INTO suggestions (task_id, suggestion_text, created_at)
  SELECT DISTINCT
         t.task_id,
         'This task has been inactive for more than 7 days. Consider reviewing its priority or assigning additional help.',
         NOW()
  FROM tasks AS t
  WHERE t.status = 'stuck'
    AND (t.last_updated IS NULL OR DATEDIFF(CURDATE(), t.last_updated) > 7)
    AND NOT EXISTS (
          SELECT 1
          FROM suggestions s
          WHERE s.task_id = t.task_id
            AND s.suggestion_text = 'This task has been inactive for more than 7 days. Consider reviewing its priority or assigning additional help.'
        );

  /* Rule C: Pending approval (keyword-based) */
  INSERT INTO suggestions (task_id, suggestion_text, created_at)
  SELECT DISTINCT
         t.task_id,
         'This task appears to be waiting for approval. Please follow up with the approver.',
         NOW()
  FROM tasks AS t
  WHERE t.status = 'stuck'
    AND (
         LOWER(COALESCE(t.description, '')) LIKE '%waiting for approval%'
         OR LOWER(COALESCE(t.description, '')) LIKE '%approval%'
        )
    AND NOT EXISTS (
          SELECT 1
          FROM suggestions s
          WHERE s.task_id = t.task_id
            AND s.suggestion_text = 'This task appears to be waiting for approval. Please follow up with the approver.'
        );
END //

DELIMITER ;