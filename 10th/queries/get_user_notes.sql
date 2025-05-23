SELECT 
    n.note_id,
    n.title,
    LEFT(n.content, 100) AS preview,
    n.created_at,
    n.updated_at,
    COUNT(m.media_id) AS media_count,
    ARRAY_AGG(DISTINCT nt.tag_name) AS tags
FROM 
    notes n
LEFT JOIN 
    media m ON n.note_id = m.note_id
LEFT JOIN 
    note_tags nt ON n.note_id = nt.note_id
WHERE 
    n.user_id = 1 AND
    n.deleted_at IS NULL
GROUP BY 
    n.note_id
ORDER BY 
    n.updated_at DESC
LIMIT 10 OFFSET 0;