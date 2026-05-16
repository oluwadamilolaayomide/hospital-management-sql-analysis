-- CREATION OF DATABASE & TABLES
CREATE DATABASE HospitalManagement;

CREATE TABLE IF NOT EXISTS patients(
patient_id VARCHAR(10) PRIMARY KEY,
first_name VARCHAR(100) NOT NULL,
last_name VARCHAR(100) NOT NULL,
gender CHAR(1),
date_of_birth DATE,
contact_number VARCHAR(11),
address TEXT,
registration_date DATE,
insurance_provider VARCHAR(50),
insurance_number VARCHAR(100),
email VARCHAR(150)
);

CREATE TABLE IF NOT EXISTS doctors(
doctor_id CHAR(10) PRIMARY KEY,
first_name VARCHAR(100) NOT NULL,
last_name VARCHAR(100) NOT NULL,
specialization VARCHAR(100),
phone_number CHAR(11),
years_experience INT,
hospital_branch VARCHAR(100),
email VARCHAR(200)
);


CREATE TABLE IF NOT EXISTS appointments(
appointment_id CHAR(10) PRIMARY KEY,
patient_id CHAR(10),
doctor_id CHAR(10),
appointment_date DATE,
appointment_time TIME,
reason_for_visit VARCHAR(100),
status VARCHAR(51),
FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE IF NOT EXISTS treatments(
treatment_id CHAR(10) PRIMARY KEY,
appointment_id CHAR(10),
treatment_type VARCHAR(100),
description VARCHAR(100),
cost  DECIMAL(10,2),
treatment_date DATE,
FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

CREATE TABLE IF NOT EXISTS billing(
bill_id CHAR(10) PRIMARY KEY,
patient_id CHAR(10),
treatment_id CHAR(10),
bill_date DATE,
amount DECIMAL(10,2),
payment_method VARCHAR(100),
payment_status VARCHAR(51),
FOREIGN KEY(patient_id) REFERENCES patients(patient_id),
FOREIGN KEY (treatment_id) REFERENCES treatments(treatment_id)
);