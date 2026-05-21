--TREATMENT ANALYSIS
-- 10. Treatment Revenue Ranking
CREATE VIEW treatment_revenue AS
SELECT 
  treatment_type,
  COUNT(*) AS total_treatments,
  SUM(cost) AS total_revenue,
  ROUND(AVG(cost), 2) AS avg_cost,
  MIN(cost) AS min_cost,
  MAX(cost) AS max_cost,
  RANK() OVER (ORDER BY SUM(cost) DESC) AS revenue_rank
FROM treatments
GROUP BY treatment_type
ORDER BY total_revenue DESC;
