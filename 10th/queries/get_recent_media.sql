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
    m.user_id = 1 AND
    m.uploaded_at >= NOW() - INTERVAL '30 days'
ORDER BY 
    m.uploaded_at DESC
LIMIT 20;