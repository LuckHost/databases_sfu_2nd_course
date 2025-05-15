SELECT note_id, title, created_at, updated_at 
FROM notes 
WHERE user_id = 1 
ORDER BY updated_at DESC;