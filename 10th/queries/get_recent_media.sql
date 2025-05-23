-- Параметр: user_id, days
SELECT 
    m.media_id,
    mt.name AS type,
    m.storage_path,
    m.uploaded_at,
    n.title AS note_title,
    n.note_id
FROM 
    media m
JOIN 
    media_types mt ON m.type_id = mt.type_id
JOIN 
    notes n ON m.note_id = n.note_id
WHERE 
    m.user_id = :user_id AND
    m.uploaded_at >= NOW() - INTERVAL ':days days'
ORDER BY 
    m.uploaded_at DESC
LIMIT 20;