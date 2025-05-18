-- Получение статистики по пользователю (количество заметок, медиа, последняя активность)
SELECT 
    u.user_id,
    u.username,
    u.email,
    COUNT(DISTINCT n.note_id) AS notes_count,
    COUNT(DISTINCT m.media_id) AS media_count,
    MAX(n.updated_at) AS last_updated
FROM 
    users u
LEFT JOIN 
    notes n ON u.user_id = n.user_id
LEFT JOIN 
    media m ON u.user_id = m.user_id
WHERE 
    u.user_id = 1
GROUP BY 
    u.user_id;