-- Параметры: user_id, tag_name
SELECT 
    n.note_id,
    n.title,
    LEFT(n.content, 100) AS preview,
    n.updated_at,
    COUNT(m.media_id) AS media_count
FROM 
    notes n
LEFT JOIN 
    media m ON n.note_id = m.note_id
JOIN 
    note_tags nt ON n.note_id = nt.note_id
WHERE 
    n.user_id = :user_id AND
    n.deleted_at IS NULL AND
    nt.tag_name = :tag_name
GROUP BY 
    n.note_id
ORDER BY 
    n.updated_at DESC;