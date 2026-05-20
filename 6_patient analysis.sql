--PATIENT ANALYSIS
-- 7. Patient Retention Segment
 CREATE OR REPLACE VIEW patient_segment AS
SELECT 
  visit_segment,
  COUNT(patient_id) AS num_patients,
  ROUND(COUNT(patient_id) * 100.0 / SUM(COUNT(patient_id)) OVER(), 2) AS percentage_of_total
FROM (
  SELECT 
    p.patient_id,
    CASE 
      WHEN COUNT(a.appointment_id) = 0 THEN 'No Appointments'
      WHEN COUNT(a.appointment_id) BETWEEN 1 AND 3 THEN 'Occasional'
      WHEN COUNT(a.appointment_id) BETWEEN 4 AND 6 THEN 'Regular'
      WHEN COUNT(a.appointment_id) > 6 THEN 'Loyal'
    END AS visit_segment
  FROM patients p
  LEFT JOIN appointments a ON p.patient_id = a.patient_id
  GROUP BY p.patient_id
) AS patient_visits
GROUP BY visit_segment;

-- 8. Gender Insurance Breakdown
SELECT 
  p.gender,
  p.insurance_provider,
  COUNT(DISTINCT p.patient_id) AS total_patients,
  SUM(b.amount) AS total_billed,
  ROUND(AVG(b.amount), 2) AS avg_bill,
  ROUND(SUM(CASE WHEN b.payment_status = 'Unpaid' THEN b.amount ELSE 0 END) 
    / SUM(b.amount)* 100, 2) AS unpaid_rate_pct
FROM patients p
LEFT JOIN billing b ON p.patient_id = b.patient_id
GROUP BY p.gender, p.insurance_provider
ORDER BY total_billed DESC;

--9. Patient Age Group
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

