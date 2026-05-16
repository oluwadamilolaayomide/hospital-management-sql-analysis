-- DOCTOR PERFORMANCE
-- 3.Doctor Performance Scorecard
CREATE VIEW doctor_performance AS
SELECT 
  CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
  d.specialization,
  d.hospital_branch,
  d.years_experience,
  COUNT(a.appointment_id) AS total_appointments,
  COUNT(CASE WHEN a.status = 'Completed' THEN 1 END) AS completed,
  COUNT(CASE WHEN a.status = 'Cancelled' THEN 1 END) AS cancelled,
  COUNT(CASE WHEN a.status = 'No-Show' THEN 1 END) AS no_shows,
  ROUND(COUNT(CASE WHEN a.status = 'Completed' THEN 1 END) * 100.0 
    / COUNT(a.appointment_id), 0) AS completion_rate_percentage,
  SUM(t.cost) AS total_revenue_generated
FROM doctors d
LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
LEFT JOIN treatments t ON a.appointment_id = t.appointment_id
GROUP BY d.doctor_id, doctor_name, d.specialization, d.hospital_branch, d.years_experience
ORDER BY completion_rate_percentage ASC;

-- 4. Doctor Revenue Rank Within Specialization
CREATE VIEW doctor_revenue_rank AS
SELECT 
  CONCAT(doc.first_name, ' ', doc.last_name) AS doctor_name,
  doc.specialization,
  doc.hospital_branch,
  SUM(trt.cost) AS total_revenue,
  RANK() OVER (
    PARTITION BY doc.specialization 
    ORDER BY SUM(trt.cost) DESC
  ) AS revenue_rank_specialization
FROM doctors doc
JOIN appointments apt ON doc.doctor_id = apt.doctor_id
JOIN treatments trt ON apt.appointment_id = trt.appointment_id
GROUP BY doctor_name, doc.specialization, doc.hospital_branch
ORDER BY doc.specialization, revenue_rank_specialization;
SELECT * FROM doctor_revenue_rank;

