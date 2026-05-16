# Hospital Management SQL Analysis

## Project Overview
An end-to-end SQL analysis of a hospital management database covering 50 patients, 10 doctors across 3 branches and 12 months of billing data (2023). The goal was to extract actionable business insights that support hospital management decisions and not just 
handle data.

---
## Business Problem
The hospital needed to understand:
- Why revenue collection is low  
- Which doctors and branches are underperforming  
- How patient behavior affects revenue and operations 

---

## Database Schema
**5 relational tables:**
- Patients (50 records)
- Doctors (10 records)
- Appointments (200 records)
- Treatments (155 records)
- Billing (200 records)

---
## Entity Relationship Diagram
![ERD Diagram](hospital_erd.png)

---

## Tools Used
- PostgreSQL 17
- pgAdmin

---

## SQL Techniques Used
- Window Functions (`RANK`, `SUM OVER`, `COUNT OVER`)  
- Conditional Aggregation (`CASE WHEN`)  
- Subqueries  
- Date Functions (`DATE_TRUNC`, `EXTRACT`, `AGE`, `TO_CHAR`)  
- Views (7 reusable views created)  
- Joins (`LEFT JOIN`, `INNER JOIN`)  
- `NULLIF` for safe division  
- Foreign Keys & relational design

--- 

## Key Business Findings

### Revenue
- Total billed: **$551,249.85**  
- Total collected: **$173,424.90 (31.47%)**  
- Failed payments: **$193,212.94** (exceeds collections)  
- Worst month: **February (8.27%)**  
- Best month: **June (53.57%)**

---

### Appointments
- Total: **200**
- Completed: **46 (23%)**
- No-shows: **52 (26%)**
- Cancelled: **51 (25.5%)**
> No-shows exceed completed appointments

---

### Doctors & Branches
- Top doctor: **Robert Davis (Oncology)**  
  - 38% completion rate  
  - $40,166 revenue  
- Top branch: **Central Hospital ($229,039)**  
- Lowest branch: **Westside Clinic ($160,179)**  

---

### Patients

- Total patients: **50**
- Loyal (3+ visits): **56.25%**
- Returning (2–3 visits): **43.75%**
- One-time patients: **0**
  
> Strong retention but very small patient base

---

### Treatments

- Top revenue driver: **Chemotherapy ($128,855)**  
- Followed by:
  - MRI: $116,098  
  - X-Ray: $110,653

--- 

## Key Insights & Business Impact

### 1. Revenue Leakage is Critical
**Insight:**  
Failed payments exceed collected revenue.

**Impact:**  
The hospital is losing more money than it collects, threatening financial sustainability.

---

### 2. Operational Inefficiency from No-Shows
**Insight:**  
More appointments are missed than completed.

**Impact:**  
Wasted doctor time and lost revenue opportunities.

---

### 3. Revenue is Concentrated
**Insight:**  
One doctor and one branch contribute disproportionately.

**Impact:**  
Performance imbalance suggests management or operational gaps.

---

### 4. Strong Retention, Weak Acquisition

**Insight:**  
100% of patients return, but total patient count is very low.

**Impact:**  
Growth is limited by poor patient acquisition, not retention.

---

### 5. Service Revenue is Highly Concentrated
**Insight:**  
A few treatments drive most revenue.

**Impact:**  
Dependency risk if demand shifts or services are disrupted.

---

## Recommendations

### Revenue & Billing
- Audit failed payments immediately ($193K impact)  
- Implement automated billing and payment reminders  
- Review insurance claim processing  

---

### Operations
- Shift more appointments to Saturdays (0% no-show rate)  
- Introduce SMS/email reminders for weekday appointments  

---

### Performance Management
- Analyze top-performing doctor workflows  
- Replicate Central Hospital’s operational model across branches  

---

### Growth Strategy
- Launch patient acquisition campaigns  
- Expand outreach and referral programs  

---

### Service Optimization

- Focus on high-revenue treatments (e.g., Chemotherapy)  
- Develop follow-up programs to increase repeat treatments

---

## Project Structure
- 1_create tables.sql
- 2_data cleaning.sql
- 3_revenue analysis.sql
- 4_doctor performance.sql
- 5_operational analysis.sql
- 6_patient analysis.sql
- 7_treatment analysis.sql
- 8_views.sql
- hospital_erd.png
