-- Параметры: user_id, search_query
SELECT 
    n.note_id,
    n.title,
    ts_headline('english', n.content, plainto_tsquery(:search_query)) AS content_highlight,
    n.updated_at,
    array_agg(DISTINCT nt.tag_name) AS tags
FROM 
    notes n
LEFT JOIN 
    note_tags nt ON n.note_id = nt.note_id
WHERE 
    n.user_id = :user_id AND
    n.deleted_at IS NULL AND
    (
        n.content @@ plainto_tsquery(:search_query) OR
        n.title ILIKE '%' || :search_query || '%' OR
        nt.tag_name ILIKE '%' || :search_query || '%'
    )
GROUP BY 
    n.note_id
ORDER BY 
    ts_rank(to_tsvector('english', n.content), plainto_tsquery(:search_query)) DESC;