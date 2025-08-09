-- Insert into task_types
INSERT INTO task_types (type_name) VALUES
('Design'),
('Development'),
('Research');

-- Insert into collaborators
INSERT INTO collaborators (name, email) VALUES
('Alice Johnson', 'alice@example.com'),
('Bob Smith', 'bob@example.com'),
('Charlie Lee', 'charlie@example.com');

-- Insert into tasks
INSERT INTO tasks (task_name, status, description, task_type_id, assigned_user_id, last_updated, created_at) VALUES
('Landing Page Design', 'stuck', 'Design the homepage layout', 7, 7, '2025-08-05', '2025-08-01'),
('API Development', 'resolved', 'Develop the user authentication API', 8, 8, '2025-08-06', '2025-08-02'),
('Market Research', 'stuck', 'Research competitor platforms', 9, 9, '2025-08-06', '2025-08-03');

-- Insert into task_collaborators
INSERT INTO task_collaborators (task_id, user_id, role) VALUES
(7, 8, 'Reviewer'),
(7, 9, 'Designer'),
(9, 7, 'Support');

-- Insert into resources
INSERT INTO resources (task_id, resource_name, is_available) VALUES
(7, 'Figma License', 1),
(7, 'Brand Guidelines', 0),
(9, 'Survey Tool', 1);

-- Insert into suggestions
INSERT INTO suggestions (task_id, suggestion_text, created_at) VALUES
(7, 'Use the new branding elements in layout.', '2025-08-06 09:00:00'),
(9, 'Consider analyzing 3 more competitors.', '2025-08-06 09:30:00');

-- Insert into task_logs
INSERT INTO task_logs (task_id, status_before, status_after, changed_at) VALUES
(7, 'resolved', 'stuck', '2025-08-06 08:30:00'),
(9, 'resolved', 'stuck', '2025-08-05 13:45:00');