-- Channel performance: conversion and first-payment revenue per visitor by acquisition channel.
SELECT v.channel,
       COUNT(*)                                          AS visitors,
       COUNT(s.user_id)                                  AS purchases,
       ROUND(1.0 * COUNT(s.user_id) / COUNT(*), 4)       AS conversion,
       ROUND(COALESCE(SUM(p.amount), 0), 2)              AS first_payment_revenue,
       ROUND(COALESCE(SUM(p.amount), 0) / COUNT(*), 3)   AS revenue_per_visitor
FROM visitors v
LEFT JOIN subscriptions s ON s.visitor_id = v.visitor_id
LEFT JOIN payments p      ON p.user_id = s.user_id AND p.payment_type = 'new'
GROUP BY v.channel
ORDER BY revenue_per_visitor DESC;
