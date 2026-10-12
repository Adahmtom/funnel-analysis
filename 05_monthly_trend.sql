-- Monthly visitors, purchases and conversion with month-over-month change (window functions).
WITH monthly AS (
  SELECT strftime('%Y-%m', v.first_visit_ts)  AS month,
         COUNT(*)                              AS visitors,
         COUNT(s.user_id)                      AS purchases
  FROM visitors v
  LEFT JOIN subscriptions s ON s.visitor_id = v.visitor_id
  GROUP BY month
)
SELECT month, visitors, purchases,
       ROUND(1.0 * purchases / visitors, 4)                                     AS conversion,
       ROUND(1.0 * purchases / visitors
             - LAG(1.0 * purchases / visitors) OVER (ORDER BY month), 4)        AS conversion_mom_change,
       SUM(purchases) OVER (ORDER BY month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_purchases,
       ROUND(AVG(1.0 * purchases / visitors) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 4)
                                                                                AS conversion_3mo_avg
FROM monthly
ORDER BY month;
