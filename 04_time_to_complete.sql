-- Minutes from template_start to form_complete for each completer (median is computed in Python;
-- SQLite has no MEDIAN). Uses MIN() per visitor to ignore any duplicate events.
WITH s AS (
  SELECT visitor_id, MIN(event_ts) AS start_ts FROM events
  WHERE event_name = 'template_start' GROUP BY visitor_id
),
c AS (
  SELECT visitor_id, MIN(event_ts) AS complete_ts FROM events
  WHERE event_name = 'form_complete' GROUP BY visitor_id
)
SELECT v.device, v.landing_doc_type AS doc_type,
       (julianday(c.complete_ts) - julianday(s.start_ts)) * 24 * 60 AS minutes_to_complete
FROM s
JOIN c ON c.visitor_id = s.visitor_id
JOIN visitors v ON v.visitor_id = s.visitor_id;
