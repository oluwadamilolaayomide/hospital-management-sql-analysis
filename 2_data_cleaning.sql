-- DATA CLEANING & VALIDATION
-- 1. Row counts
SELECT COUNT(*) AS total_patients FROM patients;
SELECT COUNT(*) AS total_doctors FROM doctors;
SELECT COUNT(*) AS total_appointments FROM appointments;
SELECT COUNT(*) AS total_treatments FROM treatments;
SELECT COUNT(*) AS total_bills FROM billing;

-- 2. Null check
-- Patients table null check
SELECT
  COUNT(*) FILTER (WHERE patient_id IS NULL) AS null_patient_id,
  COUNT(*) FILTER (WHERE first_name IS NULL) AS null_first_name,
  COUNT(*) FILTER (WHERE last_name IS NULL) AS null_last_name,
  COUNT(*) FILTER (WHERE gender IS NULL) AS null_gender,
  COUNT(*) FILTER (WHERE date_of_birth IS NULL) AS null_dob,
  COUNT(*) FILTER (WHERE insurance_provider IS NULL) AS null_insurance
FROM patients;

-- Doctors table null check
SELECT
  COUNT(*) FILTER (WHERE doctor_id IS NULL) AS null_doctor_id,
  COUNT(*) FILTER (WHERE specialization IS NULL) AS null_specialization,
  COUNT(*) FILTER (WHERE hospital_branch IS NULL) AS null_branch,
  COUNT(*) FILTER (WHERE years_experience IS NULL) AS null_experience
FROM doctors;

-- Appointments table null check
SELECT
  COUNT(*) FILTER (WHERE appointment_id IS NULL) AS null_appointment_id,
  COUNT(*) FILTER (WHERE patient_id IS NULL) AS null_patient_id,
  COUNT(*) FILTER (WHERE doctor_id IS NULL) AS null_doctor_id,
  COUNT(*) FILTER (WHERE appointment_date IS NULL) AS null_date,
  COUNT(*) FILTER (WHERE status IS NULL) AS null_status
FROM appointments;

-- Billing table null check
SELECT
  COUNT(*) FILTER (WHERE bill_id IS NULL) AS null_bill_id,
  COUNT(*) FILTER (WHERE patient_id IS NULL) AS null_patient_id,
  COUNT(*) FILTER (WHERE amount IS NULL) AS null_amount,
  COUNT(*) FILTER (WHERE payment_status IS NULL) AS null_payment_status,
  COUNT(*) FILTER (WHERE payment_method IS NULL) AS null_payment_method
FROM billing;

-- Treatments table null check
SELECT
  COUNT(*) FILTER (WHERE treatment_id IS NULL) AS null_treatment_id,
  COUNT(*) FILTER (WHERE appointment_id IS NULL) AS null_appointment_id,
  COUNT(*) FILTER (WHERE cost IS NULL) AS null_cost,
  COUNT(*) FILTER (WHERE treatment_type IS NULL) AS null_treatment_type
FROM treatments;


-- 3.Duplicates check
SELECT patient_id, COUNT(*) AS count
FROM patients
GROUP BY patient_id
HAVING COUNT(*) > 1;

-- Check for duplicate doctor records
SELECT doctor_id, COUNT(*) AS count
FROM doctors
GROUP BY doctor_id
HAVING COUNT(*) > 1;

-- Check for duplicate appointments
SELECT appointment_id, COUNT(*) AS count
FROM appointments
GROUP BY appointment_id
HAVING COUNT(*) > 1;

-- Check for duplicate bills
SELECT bill_id, COUNT(*) AS count
FROM billing
GROUP BY bill_id
HAVING COUNT(*) > 1;

-- 4.Confirms foreign keys are not broken
-- Appointments with no matching patient
SELECT a.appointment_id, a.patient_id
FROM appointments a
LEFT JOIN patients p ON a.patient_id = p.patient_id
WHERE p.patient_id IS NULL;

-- Appointments with no matching doctor
SELECT a.appointment_id, a.doctor_id
FROM appointments a
LEFT JOIN doctors d ON a.doctor_id = d.doctor_id
WHERE d.doctor_id IS NULL;

-- Billing with no matching patient
SELECT b.bill_id, b.patient_id
FROM billing b
LEFT JOIN patients p ON b.patient_id = p.patient_id
WHERE p.patient_id IS NULL;

-- Treatments with no matching appointment
SELECT t.treatment_id, t.appointment_id
FROM treatments t
LEFT JOIN appointments a ON t.appointment_id = a.appointment_id
WHERE a.appointment_id IS NULL;

-- 5. DISTINCT VALUE CHECKS
SELECT DISTINCT status FROM appointments;
SELECT DISTINCT payment_status FROM billing;
SELECT DISTINCT payment_method FROM billing;
SELECT DISTINCT specialization FROM doctors;
SELECT DISTINCT gender FROM patients;
SELECT DISTINCT hospital_branch FROM doctors;
SELECT DISTINCT insurance_provider FROM patients;

--6.Confirm negative or zero amounts in billing
SELECT COUNT(*) AS negative_amounts
FROM billing
WHERE amount <= 0;

-- Check for outliers in treatment cost
SELECT 
  MIN(cost) AS min_cost,
  MAX(cost) AS max_cost,
  ROUND(AVG(cost), 2) AS avg_cost
FROM treatments;

-- VALIDATION RESULTS SUMMARY
-- All queries returned 0 issues confirming:
-- No null values 
-- No duplicate primary keys
-- No broken foreign key references
-- No misspelled category values
-- No negtive or zero billing amounts
-- Dataset is clean and ready for analysis
