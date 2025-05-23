SELECT 
    n.note_id,
    n.title,
    ts_headline('english', n.content, plainto_tsquery('рецепт')) AS content_highlight,
    n.updated_at,
    array_agg(DISTINCT nt.tag_name) AS tags
FROM 
    notes n
LEFT JOIN 
    note_tags nt ON n.note_id = nt.note_id
WHERE 
    n.user_id = 1 AND
    n.deleted_at IS NULL AND
    (
        n.content @@ plainto_tsquery('рецепт') OR
        n.title ILIKE '%рецепт%' OR
        nt.tag_name ILIKE '%рецепт%'
    )
GROUP BY 
    n.note_id
ORDER BY 
    ts_rank(to_tsvector('english', n.content), plainto_tsquery('рецепт')) DESC;