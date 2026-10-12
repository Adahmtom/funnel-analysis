-- Step-to-step conversion by device using conditional aggregation.
WITH steps AS (
  SELECT e.visitor_id, v.device,
         MAX(e.event_name = 'template_start') AS started,
         MAX(e.event_name = 'form_complete')  AS completed,
         MAX(e.event_name = 'paywall_view')   AS paywall
  FROM events e
  JOIN visitors v ON v.visitor_id = e.visitor_id
  GROUP BY e.visitor_id, v.device
),
joined AS (
  SELECT s.*, (b.visitor_id IS NOT NULL) AS purchased
  FROM steps s LEFT JOIN subscriptions b ON b.visitor_id = s.visitor_id
)
SELECT device,
       COUNT(*)                                        AS visitors,
       ROUND(1.0 * SUM(started)   / COUNT(*), 4)       AS landing_to_start,
       ROUND(1.0 * SUM(completed) / SUM(started), 4)   AS start_to_complete,
       ROUND(1.0 * SUM(paywall)   / SUM(completed), 4) AS complete_to_paywall,
       ROUND(1.0 * SUM(purchased) / SUM(paywall), 4)   AS paywall_to_purchase,
       ROUND(1.0 * SUM(purchased) / COUNT(*), 4)       AS overall_conversion
FROM joined
GROUP BY device
ORDER BY visitors DESC;
