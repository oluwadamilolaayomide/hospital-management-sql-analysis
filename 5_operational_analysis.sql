-- OPERATIONAL ANALYSIS
-- 5.Financial Cost of No-Shows and Cancellations
CREATE VIEW apt_status_summary AS
SELECT 
  a.status,
  COUNT(*) AS appointment_count,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage_of_total,
  SUM(trt.cost) AS associated_revenue
FROM appointments a
LEFT JOIN treatments trt ON a.appointment_id = trt.appointment_id

-- 6.  Busiest Days of the Week
SELECT 
  TO_CHAR(appointment_date, 'Day') AS week_day,
  COUNT(*) AS total_appointments,
  COUNT(CASE WHEN status = 'Completed' THEN 1 END) AS completed,
  COUNT(CASE WHEN status = 'No-Show' THEN 1 END) AS no_shows,
  ROUND(COUNT(CASE WHEN status = 'No-Show' THEN 1 END) * 100.0 
    / COUNT(*), 2) AS no_show_rate_percentage
FROM appointments
GROUP BY week_day, EXTRACT(DOW FROM appointment_date)
ORDER BY EXTRACT(DOW FROM appointment_date);

