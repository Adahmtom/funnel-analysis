-- Where is the form step losing people? Completion rate by document type x device,
-- among visitors who started a template.
WITH started AS (
  SELECT DISTINCT visitor_id FROM events WHERE event_name = 'template_start'
),
completed AS (
  SELECT DISTINCT visitor_id FROM events WHERE event_name = 'form_complete'
)
SELECT v.landing_doc_type AS doc_type,
       v.device,
       COUNT(*)                                                  AS starters,
       SUM(c.visitor_id IS NOT NULL)                             AS completers,
       ROUND(1.0 * SUM(c.visitor_id IS NOT NULL) / COUNT(*), 4)  AS completion_rate
FROM started s
JOIN visitors v       ON v.visitor_id = s.visitor_id
LEFT JOIN completed c ON c.visitor_id = s.visitor_id
WHERE v.device IN ('desktop', 'mobile')
GROUP BY v.landing_doc_type, v.device
ORDER BY doc_type, device;
