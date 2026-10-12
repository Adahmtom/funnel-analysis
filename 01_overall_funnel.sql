-- Overall funnel, Jan 2025 - Jun 2026.
-- Counts DISTINCT visitors per step so duplicate events can't inflate the numbers.
WITH steps AS (
  SELECT visitor_id,
         MAX(event_name = 'landing_view')   AS landing,
         MAX(event_name = 'template_start') AS started,
         MAX(event_name = 'form_complete')  AS completed,
         MAX(event_name = 'paywall_view')   AS paywall
  FROM events
  GROUP BY visitor_id
),
buyers AS (SELECT DISTINCT visitor_id FROM subscriptions)   -- billing system = source of truth for purchases
SELECT 'landing_view'   AS step, 1 AS step_order, SUM(landing)   AS visitors FROM steps
UNION ALL SELECT 'template_start', 2, SUM(started)   FROM steps
UNION ALL SELECT 'form_complete',  3, SUM(completed) FROM steps
UNION ALL SELECT 'paywall_view',   4, SUM(paywall)   FROM steps
UNION ALL SELECT 'purchase',       5, COUNT(*)       FROM buyers
ORDER BY step_order;
