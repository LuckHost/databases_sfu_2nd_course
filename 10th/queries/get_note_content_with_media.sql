-- Получение полного содержимого заметки с медиафайлами в правильном порядке
SELECT 
    n.note_id,
    n.title,
    n.content,
    n.updated_at,
    json_agg(
        json_build_object(
            'position', m.position,
            'type', m.type,
            'url', m.url
        ) ORDER BY m.position
    ) AS media_files
FROM 
    notes n
LEFT JOIN 
    media m ON n.note_id = m.note_id
WHERE 
    n.note_id = 1
GROUP BY 
    n.note_id;