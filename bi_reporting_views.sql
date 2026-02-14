-- ====================================
-- BLOOD BANK SYSTEM - BI REPORTING VIEWS
-- Comprehensive Views for Business Intelligence & Analytics
-- Microsoft SQL Server (T-SQL)
-- ====================================

-- ====================================
-- 1. INVENTORY & STOCK MANAGEMENT VIEWS
-- ====================================

-- View: Blood Inventory Current Status
CREATE VIEW vw_BloodInventoryStatus AS
SELECT 
    bl.bank_id,
    bl.bank_name,
    bl.location AS bank_location,
    a.blood_group,
    COUNT(DISTINCT bb.blood_id) AS total_bags,
    SUM(d.quantity_of_Blood) AS total_quantity_ml,
    SUM(CASE WHEN a.result = 'Safe' AND bbd.blood_id IS NULL THEN 1 ELSE 0 END) AS safe_bags,
    SUM(CASE WHEN a.result = 'Safe' AND bbd.blood_id IS NULL THEN d.quantity_of_Blood ELSE 0 END) AS safe_quantity_ml,
    SUM(CASE WHEN a.result != 'Safe' OR bbd.blood_id IS NOT NULL THEN 1 ELSE 0 END) AS unsafe_bags,
    SUM(CASE WHEN a.result != 'Safe' OR bbd.blood_id IS NOT NULL THEN d.quantity_of_Blood ELSE 0 END) AS unsafe_quantity_ml,
    MAX(d.donor_Date_of_Donation) AS last_donation_date,
    MIN(d.donor_Date_of_Donation) AS oldest_donation_date,
    DATEDIFF(DAY, MIN(d.donor_Date_of_Donation), GETDATE()) AS oldest_blood_age_days
FROM Blood_Bank bl
INNER JOIN Donate d ON bl.bank_id = d.bank_id
INNER JOIN Blood_Bag bb ON d.blood_id = bb.blood_id
INNER JOIN Analyse a ON bb.blood_id = a.blood_id
LEFT JOIN Blood_Bag_Diseases bbd ON bb.blood_id = bbd.blood_id
GROUP BY bl.bank_id, bl.bank_name, bl.location, a.blood_group;
GO

-- Example 1: Check current blood inventory
SELECT * FROM vw_BloodInventoryStatus;

-- View: Blood Expiry Alert (Blood older than 35 days - typically 42 days shelf life)
CREATE VIEW vw_BloodExpiryAlert AS
SELECT 
    bl.bank_id,
    bl.bank_name,
    bb.blood_id,
    a.blood_group,
    d.quantity_of_Blood,
    d.donor_Date_of_Donation,
    DATEDIFF(DAY, d.donor_Date_of_Donation, GETDATE()) AS age_in_days,
    42 - DATEDIFF(DAY, d.donor_Date_of_Donation, GETDATE()) AS days_until_expiry,
    CASE 
        WHEN DATEDIFF(DAY, d.donor_Date_of_Donation, GETDATE()) >= 42 THEN 'Expired'
        WHEN DATEDIFF(DAY, d.donor_Date_of_Donation, GETDATE()) >= 35 THEN 'Critical - Expiring Soon'
        WHEN DATEDIFF(DAY, d.donor_Date_of_Donation, GETDATE()) >= 28 THEN 'Warning - Near Expiry'
        ELSE 'Good'
    END AS expiry_status
FROM Blood_Bank bl
INNER JOIN Donate d ON bl.bank_id = d.bank_id
INNER JOIN Blood_Bag bb ON d.blood_id = bb.blood_id
INNER JOIN Analyse a ON bb.blood_id = a.blood_id
LEFT JOIN Blood_Bag_Diseases bbd ON bb.blood_id = bbd.blood_id
WHERE a.result = 'Safe' AND bbd.blood_id IS NULL;
GO

-- View: Blood Group Availability Summary
CREATE VIEW vw_BloodGroupAvailability AS
SELECT 
    a.blood_group,
    COUNT(DISTINCT bb.blood_id) AS available_bags,
    SUM(d.quantity_of_Blood) AS available_quantity_ml,
    COUNT(DISTINCT bl.bank_id) AS banks_with_stock,
    AVG(DATEDIFF(DAY, d.donor_Date_of_Donation, GETDATE())) AS avg_blood_age_days
FROM Blood_Bag bb
INNER JOIN Analyse a ON bb.blood_id = a.blood_id
INNER JOIN Donate d ON bb.blood_id = d.blood_id
INNER JOIN Blood_Bank bl ON d.bank_id = bl.bank_id
LEFT JOIN Blood_Bag_Diseases bbd ON bb.blood_id = bbd.blood_id
WHERE a.result = 'Safe' 
  AND bbd.blood_id IS NULL
  AND DATEDIFF(DAY, d.donor_Date_of_Donation, GETDATE()) < 42
GROUP BY a.blood_group;
GO

-- ====================================
-- 2. DONATION PERFORMANCE VIEWS
-- ====================================

-- View: Donation Trends (Daily/Monthly)
CREATE VIEW vw_DonationTrends AS
SELECT 
    YEAR(donor_Date_of_Donation) AS donation_year,
    MONTH(donor_Date_of_Donation) AS donation_month,
    DATENAME(MONTH, donor_Date_of_Donation) AS month_name,
    COUNT(DISTINCT donor_id) AS unique_donors,
    COUNT(blood_id) AS total_donations,
    SUM(quantity_of_Blood) AS total_quantity_ml,
    AVG(quantity_of_Blood) AS avg_donation_ml,
    bl.bank_name,
    bl.bank_id
FROM Donate d
INNER JOIN Blood_Bank bl ON d.bank_id = bl.bank_id
GROUP BY YEAR(donor_Date_of_Donation), MONTH(donor_Date_of_Donation), 
         DATENAME(MONTH, donor_Date_of_Donation), bl.bank_id, bl.bank_name;
GO

-- View: Top Donors
CREATE VIEW vw_TopDonors AS
SELECT 
    don.donor_id,
    don.donor_name,
    don.donor_gender,
    don.donor_age,
    don.donor_phone,
    don.donor_address,
    COUNT(d.blood_id) AS total_donations,
    SUM(d.quantity_of_Blood) AS total_donated_ml,
    MIN(d.donor_Date_of_Donation) AS first_donation_date,
    MAX(d.donor_Date_of_Donation) AS last_donation_date,
    DATEDIFF(MONTH, MIN(d.donor_Date_of_Donation), MAX(d.donor_Date_of_Donation)) AS donation_span_months,
    CASE 
        WHEN COUNT(d.blood_id) >= 10 THEN 'VIP Donor'
        WHEN COUNT(d.blood_id) >= 5 THEN 'Regular Donor'
        WHEN COUNT(d.blood_id) >= 2 THEN 'Repeat Donor'
        ELSE 'First Time Donor'
    END AS donor_category
FROM Donor don
LEFT JOIN Donate d ON don.donor_id = d.donor_id
GROUP BY don.donor_id, don.donor_name, don.donor_gender, don.donor_age, 
         don.donor_phone, don.donor_address;
GO

-- View: Donor Demographics
CREATE VIEW vw_DonorDemographics AS
SELECT 
    donor_gender,
    CASE 
        WHEN donor_age < 20 THEN '18-19'
        WHEN donor_age BETWEEN 20 AND 29 THEN '20-29'
        WHEN donor_age BETWEEN 30 AND 39 THEN '30-39'
        WHEN donor_age BETWEEN 40 AND 49 THEN '40-49'
        WHEN donor_age >= 50 THEN '50+'
    END AS age_group,
    COUNT(DISTINCT donor_id) AS donor_count,
    COUNT(d.blood_id) AS total_donations,
    SUM(d.quantity_of_Blood) AS total_quantity_ml,
    AVG(donor_age) AS avg_age
FROM Donor don
LEFT JOIN Donate d ON don.donor_id = d.donor_id
GROUP BY donor_gender, 
    CASE 
        WHEN donor_age < 20 THEN '18-19'
        WHEN donor_age BETWEEN 20 AND 29 THEN '20-29'
        WHEN donor_age BETWEEN 30 AND 39 THEN '30-39'
        WHEN donor_age BETWEEN 40 AND 49 THEN '40-49'
        WHEN donor_age >= 50 THEN '50+'
    END;
GO

-- ====================================
-- 3. QUALITY CONTROL & SAFETY VIEWS
-- ====================================

-- View: Blood Rejection Rate
CREATE VIEW vw_BloodRejectionRate AS
SELECT 
    YEAR(a.analyse_date) AS analysis_year,
    MONTH(a.analyse_date) AS analysis_month,
    DATENAME(MONTH, a.analyse_date) AS month_name,
    bl.bank_id,
    bl.bank_name,
    COUNT(a.blood_id) AS total_analyzed,
    SUM(CASE WHEN a.result = 'Safe' THEN 1 ELSE 0 END) AS safe_count,
    SUM(CASE WHEN a.result != 'Safe' THEN 1 ELSE 0 END) AS rejected_count,
    CAST(SUM(CASE WHEN a.result != 'Safe' THEN 1 ELSE 0 END) * 100.0 / COUNT(a.blood_id) AS DECIMAL(5,2)) AS rejection_rate_percent
FROM Analyse a
INNER JOIN Blood_Bag bb ON a.blood_id = bb.blood_id
INNER JOIN Donate d ON bb.blood_id = d.blood_id
INNER JOIN Blood_Bank bl ON d.bank_id = bl.bank_id
GROUP BY YEAR(a.analyse_date), MONTH(a.analyse_date), 
         DATENAME(MONTH, a.analyse_date), bl.bank_id, bl.bank_name;
GO

-- View: Disease Detection Summary
CREATE VIEW vw_DiseaseDetection AS
SELECT 
    dis.disease_id,
    dis.disease_name,
    COUNT(DISTINCT bbd.blood_id) AS blood_bags_affected,
    COUNT(DISTINCT dd.donor_id) AS donors_affected,
    SUM(d.quantity_of_Blood) AS total_rejected_ml,
    YEAR(don.donor_Date_of_Donation) AS detection_year,
    MONTH(don.donor_Date_of_Donation) AS detection_month
FROM Disease dis
LEFT JOIN Blood_Bag_Diseases bbd ON dis.disease_id = bbd.disease_id
LEFT JOIN Donor_Diseases dd ON dis.disease_id = dd.disease_id
LEFT JOIN Donate don ON bbd.blood_id = don.blood_id
LEFT JOIN Donate d ON bbd.blood_id = d.blood_id
GROUP BY dis.disease_id, dis.disease_name, 
         YEAR(don.donor_Date_of_Donation), MONTH(don.donor_Date_of_Donation);
GO

-- View: Clinical Analyst Performance
CREATE VIEW vw_AnalystPerformance AS
SELECT 
    ca.clinical_id,
    ca.clinical_name,
    bl.bank_name,
    COUNT(a.blood_id) AS total_analyses,
    COUNT(DISTINCT CAST(a.analyse_date AS DATE)) AS working_days,
    CAST(COUNT(a.blood_id) * 1.0 / NULLIF(COUNT(DISTINCT CAST(a.analyse_date AS DATE)), 0) AS DECIMAL(5,2)) AS avg_analyses_per_day,
    SUM(CASE WHEN a.result = 'Safe' THEN 1 ELSE 0 END) AS safe_results,
    SUM(CASE WHEN a.result != 'Safe' THEN 1 ELSE 0 END) AS unsafe_results,
    MIN(a.analyse_date) AS first_analysis_date,
    MAX(a.analyse_date) AS last_analysis_date
FROM Clinical_Analyst ca
LEFT JOIN Analyse a ON ca.clinical_id = a.clinical_id
INNER JOIN Blood_Bank bl ON ca.bank_id = bl.bank_id
GROUP BY ca.clinical_id, ca.clinical_name, bl.bank_name;
GO

-- ====================================
-- 4. SUPPLY & DISTRIBUTION VIEWS
-- ====================================

-- View: Supply Chain Performance
CREATE VIEW vw_SupplyChainPerformance AS
SELECT 
    YEAR(s.supply_date) AS supply_year,
    MONTH(s.supply_date) AS supply_month,
    DATENAME(MONTH, s.supply_date) AS month_name,
    bl.bank_id,
    bl.bank_name AS blood_bank,
    h.hospital_id,
    h.hospital_name,
    COUNT(*) AS total_supplies,
    SUM(s.quantity) AS total_quantity_supplied_ml,
    AVG(s.quantity) AS avg_supply_quantity_ml,
    MIN(s.supply_date) AS first_supply_date,
    MAX(s.supply_date) AS last_supply_date
FROM Supply s
INNER JOIN Blood_Bank bl ON s.bank_id = bl.bank_id
INNER JOIN Hospital h ON s.hospital_id = h.hospital_id
GROUP BY YEAR(s.supply_date), MONTH(s.supply_date), DATENAME(MONTH, s.supply_date),
         bl.bank_id, bl.bank_name, h.hospital_id, h.hospital_name;
GO

-- View: Hospital Demand Analysis
CREATE VIEW vw_HospitalDemand AS
SELECT 
    h.hospital_id,
    h.hospital_name,
    h.hospital_location,
    r.blood_group_needed,
    COUNT(DISTINCT r.patient_id) AS total_patients,
    SUM(r.blood_quantity_needed) AS total_blood_needed_ml,
    AVG(r.blood_quantity_needed) AS avg_blood_per_patient_ml,
    SUM(CASE WHEN s.quantity IS NOT NULL THEN s.quantity ELSE 0 END) AS total_blood_supplied_ml,
    SUM(r.blood_quantity_needed) - SUM(CASE WHEN s.quantity IS NOT NULL THEN s.quantity ELSE 0 END) AS blood_shortage_ml,
    CAST(SUM(CASE WHEN s.quantity IS NOT NULL THEN s.quantity ELSE 0 END) * 100.0 / 
         NULLIF(SUM(r.blood_quantity_needed), 0) AS DECIMAL(5,2)) AS fulfillment_rate_percent
FROM Hospital h
INNER JOIN Register r ON h.hospital_id = r.hospital_id
LEFT JOIN Supply s ON h.hospital_id = s.hospital_id
GROUP BY h.hospital_id, h.hospital_name, h.hospital_location, r.blood_group_needed;
GO

-- View: Blood Bank to Hospital Network
CREATE VIEW vw_BloodBankHospitalNetwork AS
SELECT 
    bl.bank_id,
    bl.bank_name,
    bl.location AS bank_location,
    h.hospital_id,
    h.hospital_name,
    h.hospital_location,
    COUNT(DISTINCT s.supply_date) AS total_supply_instances,
    SUM(s.quantity) AS total_quantity_supplied_ml,
    MIN(s.supply_date) AS first_supply_date,
    MAX(s.supply_date) AS last_supply_date,
    DATEDIFF(DAY, MAX(s.supply_date), GETDATE()) AS days_since_last_supply
FROM Blood_Bank bl
INNER JOIN Supply s ON bl.bank_id = s.bank_id
INNER JOIN Hospital h ON s.hospital_id = h.hospital_id
GROUP BY bl.bank_id, bl.bank_name, bl.location, 
         h.hospital_id, h.hospital_name, h.hospital_location;
GO

-- ====================================
-- 5. PATIENT & DEMAND VIEWS
-- ====================================

-- View: Patient Blood Requirements
CREATE VIEW vw_PatientBloodRequirements AS
SELECT 
    p.patient_id,
    p.patient_name,
    p.patient_gender,
    p.patient_address,
    h.hospital_name,
    r.blood_group_needed,
    r.blood_quantity_needed,
    r.date_of_intake,
    DATEDIFF(DAY, r.date_of_intake, GETDATE()) AS days_waiting,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM Analyse a 
            WHERE a.blood_group = r.blood_group_needed 
            AND a.result = 'Safe'
        ) THEN 'Available'
        ELSE 'Not Available'
    END AS blood_availability_status
FROM Patient p
INNER JOIN Register r ON p.patient_id = r.patient_id
INNER JOIN Hospital h ON r.hospital_id = h.hospital_id;
GO

-- View: Blood Group Demand vs Supply
CREATE VIEW vw_DemandVsSupply AS
SELECT 
    COALESCE(demand.blood_group, supply.blood_group) AS blood_group,
    COALESCE(demand.total_demand_ml, 0) AS total_demand_ml,
    COALESCE(demand.patient_count, 0) AS total_patients_needing,
    COALESCE(supply.available_quantity_ml, 0) AS available_supply_ml,
    COALESCE(supply.available_bags, 0) AS available_bags,
    COALESCE(supply.available_quantity_ml, 0) - COALESCE(demand.total_demand_ml, 0) AS surplus_shortage_ml,
    CASE 
        WHEN COALESCE(supply.available_quantity_ml, 0) >= COALESCE(demand.total_demand_ml, 0) THEN 'Surplus'
        WHEN COALESCE(supply.available_quantity_ml, 0) = 0 THEN 'Critical Shortage'
        ELSE 'Shortage'
    END AS supply_status
FROM 
    (SELECT blood_group_needed AS blood_group, 
            SUM(blood_quantity_needed) AS total_demand_ml,
            COUNT(patient_id) AS patient_count
     FROM Register 
     GROUP BY blood_group_needed) demand
FULL OUTER JOIN 
    (SELECT blood_group, 
            SUM(d.quantity_of_Blood) AS available_quantity_ml,
            COUNT(bb.blood_id) AS available_bags
     FROM Blood_Bag bb
     INNER JOIN Analyse a ON bb.blood_id = a.blood_id
     INNER JOIN Donate d ON bb.blood_id = d.blood_id
     LEFT JOIN Blood_Bag_Diseases bbd ON bb.blood_id = bbd.blood_id
     WHERE a.result = 'Safe' AND bbd.blood_id IS NULL
     GROUP BY blood_group) supply
ON demand.blood_group = supply.blood_group;
GO

-- ====================================
-- 6. FINANCIAL & OPERATIONAL KPIs
-- ====================================

-- View: Blood Bank Operational KPIs
CREATE VIEW vw_BloodBankKPIs AS
SELECT 
    bl.bank_id,
    bl.bank_name,
    m.manager_name,
    -- Donation Metrics
    COUNT(DISTINCT d.donor_id) AS total_donors,
    COUNT(d.blood_id) AS total_donations,
    SUM(d.quantity_of_Blood) AS total_blood_collected_ml,
    -- Quality Metrics
    SUM(CASE WHEN a.result = 'Safe' AND bbd.blood_id IS NULL THEN 1 ELSE 0 END) AS safe_blood_bags,
    SUM(CASE WHEN a.result != 'Safe' OR bbd.blood_id IS NOT NULL THEN 1 ELSE 0 END) AS rejected_blood_bags,
    CAST(SUM(CASE WHEN a.result != 'Safe' OR bbd.blood_id IS NOT NULL THEN 1 ELSE 0 END) * 100.0 / 
         NULLIF(COUNT(d.blood_id), 0) AS DECIMAL(5,2)) AS rejection_rate_percent,
    -- Supply Metrics
    COUNT(DISTINCT s.hospital_id) AS hospitals_served,
    COUNT(DISTINCT s.supply_date) AS supply_instances,
    COALESCE(SUM(s.quantity), 0) AS total_blood_supplied_ml,
    -- Staff Metrics
    COUNT(DISTINCT ca.clinical_id) AS analysts_count
FROM Blood_Bank bl
LEFT JOIN Manager m ON bl.manager_id = m.manager_id
LEFT JOIN Donate d ON bl.bank_id = d.bank_id
LEFT JOIN Blood_Bag bb ON d.blood_id = bb.blood_id
LEFT JOIN Analyse a ON bb.blood_id = a.blood_id
LEFT JOIN Blood_Bag_Diseases bbd ON bb.blood_id = bbd.blood_id
LEFT JOIN Supply s ON bl.bank_id = s.bank_id
LEFT JOIN Clinical_Analyst ca ON bl.bank_id = ca.bank_id
GROUP BY bl.bank_id, bl.bank_name, m.manager_name;
GO

-- View: Monthly Performance Dashboard
CREATE VIEW vw_MonthlyPerformanceDashboard AS
SELECT 
    YEAR(activity_date) AS year,
    MONTH(activity_date) AS month,
    DATENAME(MONTH, activity_date) AS month_name,
    SUM(donations) AS total_donations,
    SUM(blood_collected_ml) AS total_blood_collected_ml,
    SUM(blood_supplied_ml) AS total_blood_supplied_ml,
    SUM(patients_registered) AS total_patients_registered,
    AVG(rejection_rate) AS avg_rejection_rate_percent
FROM (
    SELECT donor_Date_of_Donation AS activity_date, 
           COUNT(*) AS donations, 
           SUM(quantity_of_Blood) AS blood_collected_ml,
           0 AS blood_supplied_ml,
           0 AS patients_registered,
           0 AS rejection_rate
    FROM Donate 
    GROUP BY donor_Date_of_Donation
    
    UNION ALL
    
    SELECT supply_date AS activity_date,
           0 AS donations,
           0 AS blood_collected_ml,
           SUM(quantity) AS blood_supplied_ml,
           0 AS patients_registered,
           0 AS rejection_rate
    FROM Supply
    GROUP BY supply_date
    
    UNION ALL
    
    SELECT date_of_intake AS activity_date,
           0 AS donations,
           0 AS blood_collected_ml,
           0 AS blood_supplied_ml,
           COUNT(*) AS patients_registered,
           0 AS rejection_rate
    FROM Register
    GROUP BY date_of_intake
) combined
GROUP BY YEAR(activity_date), MONTH(activity_date), DATENAME(MONTH, activity_date);
GO

-- ====================================
-- 7. ALERTS & NOTIFICATIONS VIEWS
-- ====================================

-- View: Critical Alerts Dashboard
CREATE VIEW vw_CriticalAlerts AS
SELECT 
    'Low Stock Alert' AS alert_type,
    blood_group AS alert_detail,
    CAST(available_quantity_ml AS VARCHAR) + ' ml available' AS description,
    'High' AS priority
FROM vw_BloodGroupAvailability
WHERE available_quantity_ml < 1000

UNION ALL

SELECT 
    'Expiry Alert' AS alert_type,
    blood_group AS alert_detail,
    'Blood ID: ' + CAST(blood_id AS VARCHAR) + ' expires in ' + CAST(days_until_expiry AS VARCHAR) + ' days' AS description,
    CASE 
        WHEN days_until_expiry <= 0 THEN 'Critical'
        WHEN days_until_expiry <= 7 THEN 'High'
        ELSE 'Medium'
    END AS priority
FROM vw_BloodExpiryAlert
WHERE expiry_status IN ('Expired', 'Critical - Expiring Soon', 'Warning - Near Expiry')

UNION ALL

SELECT 
    'Unmet Demand Alert' AS alert_type,
    blood_group AS alert_detail,
    'Shortage: ' + CAST(ABS(surplus_shortage_ml) AS VARCHAR) + ' ml needed' AS description,
    'Critical' AS priority
FROM vw_DemandVsSupply
WHERE supply_status IN ('Shortage', 'Critical Shortage');
GO

-- ====================================
-- USAGE EXAMPLES
-- ====================================

/*


-- Example 2: View blood expiring soon
SELECT * FROM vw_BloodExpiryAlert 
WHERE expiry_status IN ('Critical - Expiring Soon', 'Warning - Near Expiry')
ORDER BY days_until_expiry;

-- Example 3: Top 10 donors
SELECT TOP 10 * FROM vw_TopDonors 
ORDER BY total_donations DESC;

-- Example 4: Blood rejection rate by bank
SELECT * FROM vw_BloodRejectionRate
ORDER BY rejection_rate_percent DESC;

-- Example 5: Hospital demand vs available supply
SELECT * FROM vw_DemandVsSupply
WHERE supply_status = 'Shortage';

-- Example 6: Monthly performance
SELECT * FROM vw_MonthlyPerformanceDashboard
ORDER BY year DESC, month DESC;

-- Example 7: Critical alerts
SELECT * FROM vw_CriticalAlerts
ORDER BY priority, alert_type;

-- Example 8: Blood bank KPIs
SELECT * FROM vw_BloodBankKPIs
ORDER BY total_donations DESC;
*/
