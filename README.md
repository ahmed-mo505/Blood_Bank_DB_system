# 🩸 Blood Bank Management System

A relational database system designed to manage all operations of a blood bank, including donor registration, blood collection and analysis, inventory management, and distribution to hospitals.

---

## 📋 Table of Contents

- [Overview](#overview)
- [ERD Diagram](#erd-diagram)
- [Database Schema](#database-schema)
- [Project Files](#project-files)
- [Business Rules](#business-rules)
- [BI Reporting Views](#bi-reporting-views)
- [Stored Procedures](#stored-procedures)
- [How to Run](#how-to-run)
- [Tech Stack](#tech-stack)

---

## 🔍 Overview

This system covers the full lifecycle of blood from donation to patient delivery:

```
Donor → Donation → Blood Bag → Analysis → Blood Bank → Supply → Hospital → Patient
```

The system tracks every step ensuring blood safety, proper inventory management, and efficient distribution to hospitals based on patient needs.

---

## 🗂️ ERD Diagram

The system is built around **8 core entities** connected through **6 relationships**:

| Entity | Description |
|---|---|
| `Donor` | People who donate blood |
| `Disease` | Medical conditions tracked for donors and blood bags |
| `Blood_Bag` | Individual units of donated blood |
| `Clinical_Analyst` | Lab staff who test blood bags |
| `Blood_Bank` | Facilities that store and manage blood |
| `Manager` | Administrators who manage blood banks |
| `Hospital` | Medical facilities that receive blood |
| `Patient` | Individuals registered to receive blood |

### Relationships

| Relationship | Entities | Cardinality | Attributes |
|---|---|---|---|
| `Donate` | Donor ↔ Blood_Bag | M:M | quantity, date |
| `Analyse` | Blood_Bag ↔ Clinical_Analyst | M:M | blood_group, date, result |
| `Manage` | Manager ↔ Blood_Bank | 1:M | — |
| `Has` | Blood_Bank ↔ Clinical_Analyst | 1:M | — |
| `Supply` | Blood_Bank ↔ Hospital | M:M | quantity, date |
| `Register` | Hospital ↔ Patient | M:M | blood_group_needed, quantity_needed, date |

---

## 🏗️ Database Schema

### 14 Tables Total

**Entity Tables (8):**
- `Manager` — manager_id, manager_name, manager_phone, manager_address
- `Blood_Bank` — bank_id, bank_name, location, manager_id
- `Donor` — donor_id, donor_name, donor_gender, donor_age, donor_address, donor_phone, last_donation_date
- `Disease` — disease_id, disease_name
- `Blood_Bag` — blood_id
- `Clinical_Analyst` — clinical_id, clinical_name, bank_id
- `Hospital` — hospital_id, hospital_name, hospital_location, hospital_phone
- `Patient` — patient_id, patient_name, patient_gender, patient_address, patient_phone

**Relationship Tables (6):**
- `Donate` — (donor_id, bank_id, blood_id), quantity_of_Blood, donor_Date_of_Donation
- `Analyse` — blood_id (PK), clinical_id, blood_group, analyse_date, result
- `Supply` — (bank_id, hospital_id, supply_date), quantity
- `Register` — (hospital_id, patient_id), date_of_intake, blood_group_needed, blood_quantity_needed
- `Donor_Diseases` — (donor_id, disease_id)
- `Blood_Bag_Diseases` — (blood_id, disease_id)

---

## 📁 Project Files

```
blood-bank-db/
│
├── 📄 blood_bank_schema.sql          # CREATE TABLE statements
├── 📄 blood_bank_inserts_english.sql # Sample data (INSERT statements)
├── 📄 delete_all_data.sql            # Clean up scripts
├── 📄 stored_procedures.sql          # All stored procedures (T-SQL)
└── 📄 bi_reporting_views.sql         # BI reporting views
```

---

## ✅ Business Rules

### Donor Rules
- Donor age must be between **18 and 65 years**
- Minimum gap between donations is **56 days (8 weeks)**
- Donors with dangerous diseases **(HIV, Hepatitis B/C, Syphilis, Malaria)** are not eligible
- Female donors must not be **pregnant or breastfeeding**

### Blood Bag Rules
- Every blood bag must be **analysed before being supplied**
- Blood shelf life is **42 days** from donation date
- Unsafe blood bags **cannot be supplied** to any hospital

### Blood Bank Rules
- Each blood bank is managed by **exactly one manager**
- Total blood supplied **cannot exceed** available safe inventory

### Hospital & Patient Rules
- A patient can only be registered if **blood of their required group is available**
- Blood quantity supplied to a hospital **cannot exceed** what was received from blood banks

### Clinical Analyst Rules
- Each blood bag is **analysed only once**
- An analyst can only analyse blood bags from **their assigned blood bank**

---

## 📊 BI Reporting Views

**7 Categories | 20 Views**

### Inventory & Stock Management
| View | Description |
|---|---|
| `vw_BloodInventoryStatus` | Current stock per blood group per bank |
| `vw_BloodExpiryAlert` | Bags nearing or past expiry (42 day shelf life) |
| `vw_BloodGroupAvailability` | Available safe blood summarized by blood group |

### Donation Performance
| View | Description |
|---|---|
| `vw_DonationTrends` | Monthly and yearly donation trends |
| `vw_TopDonors` | Donors ranked by total contributions |
| `vw_DonorDemographics` | Breakdown by age group and gender |

### Quality Control & Safety
| View | Description |
|---|---|
| `vw_BloodRejectionRate` | Rejection rate per bank per month |
| `vw_DiseaseDetection` | Diseases found in blood bags and donors |
| `vw_AnalystPerformance` | Output and accuracy per clinical analyst |

### Supply & Distribution
| View | Description |
|---|---|
| `vw_SupplyChainPerformance` | Blood bank to hospital supply metrics |
| `vw_HospitalDemand` | Demand analysis and fulfillment rate per hospital |
| `vw_BloodBankHospitalNetwork` | Relationship map between banks and hospitals |

### Patient & Demand
| View | Description |
|---|---|
| `vw_PatientBloodRequirements` | Patient needs with availability status |
| `vw_DemandVsSupply` | Blood group demand vs available supply |

### KPIs & Dashboards
| View | Description |
|---|---|
| `vw_BloodBankKPIs` | Core operational KPIs per bank |
| `vw_MonthlyPerformanceDashboard` | Aggregated monthly performance metrics |

### Alerts
| View | Description |
|---|---|
| `vw_CriticalAlerts` | Low stock, expiry warnings, and unmet demand |

---

## ⚙️ Stored Procedures

**42 Procedures covering all tables:**

### Basic CRUD Procedures
Each table has dedicated procedures for **Insert**, **Update**, and **Delete**:

```sql
-- Examples
EXEC sp_InsertDonor @donor_id=1, @donor_name='John Smith', ...
EXEC sp_UpdateDonor @donor_id=1, @donor_name='John Smith Jr.', ...
EXEC sp_DeleteDonor @donor_id=1
```

### Advanced Procedures

| Procedure | Description |
|---|---|
| `sp_CompleteDonationProcess` | Full donation workflow in a single transaction |
| `sp_CheckDonorEligibility` | Validates donor against disease and time rules |
| `sp_GetAvailableBloodByGroup` | Returns safe blood bags filtered by blood group |
| `sp_GetBloodInventorySummary` | Inventory summary per bank with safe/unsafe counts |
| `sp_GetPatientBloodNeeds` | Lists patient needs with real-time availability check |

---

## 🚀 How to Run

### Prerequisites
- Microsoft SQL Server (2016 or later)
- SQL Server Management Studio (SSMS)

### Steps

**1. Create the Database**
```sql
CREATE DATABASE BloodBankDB;
USE BloodBankDB;
```

**2. Run the Schema**
```sql
-- Run in order:
blood_bank_schema.sql
```

**3. Insert Sample Data**
```sql
blood_bank_inserts_english.sql
```

**4. Create Stored Procedures**
```sql
stored_procedures.sql
```

**5. Create BI Views**
```sql
bi_reporting_views.sql
```

**6. Test the System**
```sql
-- Check inventory
SELECT * FROM vw_BloodInventoryStatus;

-- Check critical alerts
SELECT * FROM vw_CriticalAlerts ORDER BY priority;

-- Check donor eligibility
EXEC sp_CheckDonorEligibility @donor_id = 1;

-- Get available A+ blood
EXEC sp_GetAvailableBloodByGroup @blood_group = 'A+';
```

---

## 🛠️ Tech Stack

| Tool | Purpose |
|---|---|
| **Microsoft SQL Server** | Database engine |
| **T-SQL** | Query language and stored procedures |
| **SSMS** | Database management and development |
| **Power BI / Tableau** | BI dashboards using the reporting views |

---

## 👥 Sample Data Summary

| Table | Records |
|---|---|
| Manager | 10 |
| Blood_Bank | 10 |
| Donor | 15 |
| Disease | 12 |
| Blood_Bag | 15 |
| Clinical_Analyst | 12 |
| Donate | 15 |
| Analyse | 15 |
| Hospital | 12 |
| Supply | 13 |
| Patient | 15 |
| Register | 12 |
| Donor_Diseases | 15 |
| Blood_Bag_Diseases | 10 |

---

## 📌 Key Design Decisions

- **Blood bags are tracked individually** from donation through analysis to hospital delivery
- **Unsafe blood** (failed analysis or disease detected) is flagged and excluded from all supply operations
- **42-day shelf life** is enforced in views and alerts to prevent expired blood from being used
- **56-day donation gap** is enforced per donor to protect donor health
- **All M:M relationships** are resolved with bridge tables containing relevant attributes
- **Supply quantities** are always validated against available safe inventory

---

*Built as a database design and implementation project covering ER Modeling, Schema Design, T-SQL Stored Procedures, and BI Reporting.*
