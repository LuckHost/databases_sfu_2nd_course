-- Поиск заметок, содержащих определенный тег (например, #важно)
SELECT 
    n.note_id,
    n.title,
    u.username,
    n.updated_at
FROM 
    notes n
JOIN 
    users u ON n.user_id = u.user_id
WHERE 
    n.content LIKE '%#важно%' AND
    n.user_id = 1
ORDER BY 
    n.updated_at DESC;