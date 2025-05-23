SELECT 
    n.*,
    u.username,
    json_agg(
        json_build_object(
            'media_id', m.media_id,
            'type', mt.name,
            'position', m.position,
            'url', m.storage_path,
            'width', m.width,
            'height', m.height
        ) ORDER BY m.position
    ) FILTER (WHERE m.media_id IS NOT NULL) AS media,
    array_agg(DISTINCT nt.tag_name) FILTER (WHERE nt.tag_name IS NOT NULL) AS tags
FROM 
    notes n
JOIN 
    users u ON n.user_id = u.user_id
LEFT JOIN 
    media m ON n.note_id = m.note_id
LEFT JOIN 
    media_types mt ON m.type_id = mt.type_id
LEFT JOIN 
    note_tags nt ON n.note_id = nt.note_id
WHERE 
    n.note_id = 1
GROUP BY 
    n.note_id, u.user_id;