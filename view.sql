-- Create a view stuck_tasks to display all stuck tasks and their details --
CREATE view stuck_tasks AS
SELECT
t.task_name, -- Name of the task
t.created_at, -- When the task was created
t.last_updated, -- When the task was last updated
tt.type_name, -- The type/category of the task
-- tc.role, -- Role of each collaborator involved in the task
c.name AS assigned_name, -- Collaborator’s name
c.email AS assigned_email, -- Collaborator’s email address
-- r.resource_name, -- Name of the resource linked to the task
-- r.is_available -- Boolean: whether the resource is currently available

 -- Combine all collaborator roles and names (e.g., "Editor:Alice, Reviewer:Bob")
  GROUP_CONCAT(CONCAT(tc.role, ':', cc.name) SEPARATOR ', ') AS collaborators_info,

  -- Combine all resource names (e.g., "Camera, Tripod")
  GROUP_CONCAT(r.resource_name SEPARATOR ', ') AS resources,

  -- Combine all resource availability statuses (e.g., "1, 0, 1")
  GROUP_CONCAT(r.is_available SEPARATOR ', ') AS resource_availability

FROM tasks AS t
JOIN task_types AS tt ON t.task_type_id = tt.task_type_id   -- Join to get task type information
JOIN collaborators AS c ON t.assigned_user_id = c.user_id   -- Join to get the assigned user’s info
LEFT JOIN task_collaborators AS tc ON t.task_id = tc.task_id   -- Join to get other collaborators involved
LEFT JOIN resources AS r ON t.task_id = r.task_id   -- Join to get resource availability
LEFT JOIN collaborators AS cc ON tc.user_id = cc.user_id  -- Join to get detailed info (name, email) of each additional collaborator involved in the task
WHERE t.status = 'stuck'   -- Only include tasks marked as 'stuck'

GROUP BY t.task_id, t.task_name, t.created_at, t.last_updated, tt.type_name, c.name, c.email
ORDER BY t.last_updated DESC;   -- Sort by most recently updated