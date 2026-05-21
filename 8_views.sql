--VIEWS
-- 1. Monthly revenue performance
CREATE VIEW monthly_revenue AS
SELECT 
  TO_CHAR(DATE_TRUNC('month', bill_date),'Month YYYY') AS month,
  SUM(amount) AS total_billed,
  SUM(CASE WHEN payment_status = 'Paid' THEN amount ELSE 0 END) AS collected,
  SUM(CASE WHEN payment_status = 'Unpaid' THEN amount ELSE 0 END) AS unpaid,
  SUM(CASE WHEN payment_status = 'Pending' THEN amount ELSE 0 END) AS pending,
  ROUND(SUM(CASE WHEN payment_status = 'Paid' THEN amount ELSE 0 END) 
    /NULLIF (SUM(amount),0) * 100, 2) AS collection_rate_percentage
FROM billing
GROUP BY month
ORDER BY month;

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

-- 5.Financial Cost of No-Shows and Cancellations
CREATE VIEW apt_status_summary AS
SELECT 
  a.status,
  COUNT(*) AS appointment_count,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage_of_total,
  SUM(trt.cost) AS associated_revenue
FROM appointments a
LEFT JOIN treatments trt ON a.appointment_id = trt.appointment_id
GROUP BY a.status;

-- 7. Patient Retention Segment
 CREATE VIEW patient_segment AS
SELECT 
  visit_segment,
  COUNT(patient_id) AS num_patients,
  ROUND(COUNT(patient_id) * 100 / SUM(COUNT(patient_id)) OVER(), 2) AS percentage_of_total
FROM (
  SELECT 
    patient_id,
    CASE 
      WHEN COUNT(appointment_id) = 1 THEN 'One-Time'
      WHEN COUNT(appointment_id) BETWEEN 2 AND 3 THEN 'Returning'
      WHEN COUNT(appointment_id) > 3 THEN 'Loyal'
    END AS visit_segment
  FROM appointments
  GROUP BY patient_id
) AS patient_segments
GROUP BY visit_segment
ORDER BY num_patients DESC;

--9. Patient Age Group
CREATE VIEW patient_age_revenue AS
SELECT 
  CASE 
    WHEN EXTRACT(YEAR FROM AGE(date_of_birth)) BETWEEN 0 AND 17 THEN 'Under 18'
    WHEN EXTRACT(YEAR FROM AGE(date_of_birth)) BETWEEN 18 AND 35 THEN '18-35'
    WHEN EXTRACT(YEAR FROM AGE(date_of_birth)) BETWEEN 36 AND 55 THEN '36-55'
    WHEN EXTRACT(YEAR FROM AGE(date_of_birth)) > 55 THEN '55+'
  END AS age_group,
  COUNT(DISTINCT p.patient_id) AS total_patients,
  ROUND(AVG(b.amount), 2) AS avg_spend,
  SUM(b.amount) AS total_revenue,
  ROUND(COUNT(DISTINCT p.patient_id) * 100 / SUM(COUNT(DISTINCT p.patient_id)) OVER(), 2) AS percentage_of_patients
FROM patients p
LEFT JOIN billing b ON p.patient_id = b.patient_id
GROUP BY age_group
ORDER BY total_revenue DESC;

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
