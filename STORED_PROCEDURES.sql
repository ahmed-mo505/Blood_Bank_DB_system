

-- ====================================

-- BLOOD BANK SYSTEM - STORED PROCEDURES
-- Implementation of Stored Procedures for Data Manipulation
-- (Insertion, Updating, Deletion)

-- ====================================


-- ====================================
-- 1. MANAGER TABLE PROCEDURES
-- ====================================

-- Insert Manager
CREATE PROCEDURE sp_InsertManager
    @manager_id INT,
    @manager_name VARCHAR(100),
    @manager_phone VARCHAR(20),
    @manager_address VARCHAR(150)
AS
BEGIN
    INSERT INTO Manager (manager_id, manager_name, manager_phone, manager_address)
    VALUES (@manager_id, @manager_name, @manager_phone, @manager_address);
END;
GO

-- Update Manager
CREATE PROCEDURE sp_UpdateManager
    @manager_id INT,
    @manager_name VARCHAR(100),
    @manager_phone VARCHAR(20),
    @manager_address VARCHAR(150)
AS
BEGIN
    UPDATE Manager
    SET manager_name = @manager_name,
        manager_phone = @manager_phone,
        manager_address = @manager_address
    WHERE manager_id = @manager_id;
END;
GO

-- Delete Manager
CREATE PROCEDURE sp_DeleteManager
    @manager_id INT
AS
BEGIN
    DELETE FROM Manager WHERE manager_id = @manager_id;
END;
GO


-- ====================================
-- 2. BLOOD_BANK TABLE PROCEDURES
-- ====================================

-- Insert Blood Bank
CREATE PROCEDURE sp_InsertBloodBank
    @bank_id INT,
    @bank_name VARCHAR(100),
    @location VARCHAR(100),
    @manager_id INT
AS
BEGIN
    INSERT INTO Blood_Bank (bank_id, bank_name, location, manager_id)
    VALUES (@bank_id, @bank_name, @location, @manager_id);
END;
GO

-- Update Blood Bank
CREATE PROCEDURE sp_UpdateBloodBank
    @bank_id INT,
    @bank_name VARCHAR(100),
    @location VARCHAR(100),
    @manager_id INT
AS
BEGIN
    UPDATE Blood_Bank
    SET bank_name = @bank_name,
        location = @location,
        manager_id = @manager_id
    WHERE bank_id = @bank_id;
END;
GO

-- Delete Blood Bank
CREATE PROCEDURE sp_DeleteBloodBank
    @bank_id INT
AS
BEGIN
    DELETE FROM Blood_Bank WHERE bank_id = @bank_id;
END;
GO


-- ====================================
-- 3. DONOR TABLE PROCEDURES
-- ====================================

-- Insert Donor
CREATE PROCEDURE sp_InsertDonor
    @donor_id INT,
    @donor_name VARCHAR(100),
    @donor_gender VARCHAR(10),
    @donor_age INT,
    @donor_address VARCHAR(150),
    @donor_phone VARCHAR(20),
    @last_donation_date DATE
AS
BEGIN
    INSERT INTO Donor (donor_id, donor_name, donor_gender, donor_age, donor_address, donor_phone, last_donation_date)
    VALUES (@donor_id, @donor_name, @donor_gender, @donor_age, @donor_address, @donor_phone, @last_donation_date);
END;
GO

-- Update Donor
CREATE PROCEDURE sp_UpdateDonor
    @donor_id INT,
    @donor_name VARCHAR(100),
    @donor_gender VARCHAR(10),
    @donor_age INT,
    @donor_address VARCHAR(150),
    @donor_phone VARCHAR(20),
    @last_donation_date DATE
AS
BEGIN
    UPDATE Donor
    SET donor_name = @donor_name,
        donor_gender = @donor_gender,
        donor_age = @donor_age,
        donor_address = @donor_address,
        donor_phone = @donor_phone,
        last_donation_date = @last_donation_date
    WHERE donor_id = @donor_id;
END;
GO

-- Delete Donor
CREATE PROCEDURE sp_DeleteDonor
    @donor_id INT
AS
BEGIN
    DELETE FROM Donor WHERE donor_id = @donor_id;
END;
GO



-- ====================================
-- 4. DISEASE TABLE PROCEDURES
-- ====================================

-- Insert Disease
CREATE PROCEDURE sp_InsertDisease
    @disease_id INT,
    @disease_name VARCHAR(100)
AS
BEGIN
    INSERT INTO Disease (disease_id, disease_name)
    VALUES (@disease_id, @disease_name);
END;
GO

-- Update Disease
CREATE PROCEDURE sp_UpdateDisease
    @disease_id INT,
    @disease_name VARCHAR(100)
AS
BEGIN
    UPDATE Disease
    SET disease_name = @disease_name
    WHERE disease_id = @disease_id;
END;
GO

-- Delete Disease
CREATE PROCEDURE sp_DeleteDisease
    @disease_id INT
AS
BEGIN
    DELETE FROM Disease WHERE disease_id = @disease_id;
END;
GO


-- ====================================
-- 5. BLOOD_BAG TABLE PROCEDURES
-- ====================================

-- Insert Blood Bag
CREATE PROCEDURE sp_InsertBloodBag
    @blood_id INT
AS
BEGIN
    INSERT INTO Blood_Bag (blood_id)
    VALUES (@blood_id);
END;
GO

-- Delete Blood Bag
CREATE PROCEDURE sp_DeleteBloodBag
    @blood_id INT
AS
BEGIN
    DELETE FROM Blood_Bag WHERE blood_id = @blood_id;
END;
GO

-- ====================================
-- 6. CLINICAL_ANALYST TABLE PROCEDURES
-- ====================================

-- Insert Clinical Analyst
CREATE PROCEDURE sp_InsertClinicalAnalyst
    @clinical_id INT,
    @clinical_name VARCHAR(100),
    @bank_id INT
AS
BEGIN
    INSERT INTO Clinical_Analyst (clinical_id, clinical_name, bank_id)
    VALUES (@clinical_id, @clinical_name, @bank_id);
END;
GO

-- Update Clinical Analyst
CREATE PROCEDURE sp_UpdateClinicalAnalyst
    @clinical_id INT,
    @clinical_name VARCHAR(100),
    @bank_id INT
AS
BEGIN
    UPDATE Clinical_Analyst
    SET clinical_name = @clinical_name,
        bank_id = @bank_id
    WHERE clinical_id = @clinical_id;
END;
GO

-- Delete Clinical Analyst
CREATE PROCEDURE sp_DeleteClinicalAnalyst
    @clinical_id INT
AS
BEGIN
    DELETE FROM Clinical_Analyst WHERE clinical_id = @clinical_id;
END;
GO

-- ====================================
-- 7. HOSPITAL TABLE PROCEDURES
-- ====================================

-- Insert Hospital
CREATE PROCEDURE sp_InsertHospital
    @hospital_id INT,
    @hospital_name VARCHAR(100),
    @hospital_location VARCHAR(255),
    @hospital_phone VARCHAR(20)
AS
BEGIN
    INSERT INTO Hospital (hospital_id, hospital_name, hospital_location, hospital_phone)
    VALUES (@hospital_id, @hospital_name, @hospital_location, @hospital_phone);
END;
GO

-- Update Hospital
CREATE PROCEDURE sp_UpdateHospital
    @hospital_id INT,
    @hospital_name VARCHAR(100),
    @hospital_location VARCHAR(255),
    @hospital_phone VARCHAR(20)
AS
BEGIN
    UPDATE Hospital
    SET hospital_name = @hospital_name,
        hospital_location = @hospital_location,
        hospital_phone = @hospital_phone
    WHERE hospital_id = @hospital_id;
END;
GO

-- Delete Hospital
CREATE PROCEDURE sp_DeleteHospital
    @hospital_id INT
AS
BEGIN
    DELETE FROM Hospital WHERE hospital_id = @hospital_id;
END;
GO


-- ====================================
-- 8. PATIENT TABLE PROCEDURES
-- ====================================

-- Insert Patient
CREATE PROCEDURE sp_InsertPatient
    @patient_id INT,
    @patient_name VARCHAR(100),
    @patient_gender VARCHAR(10),
    @patient_address VARCHAR(150),
    @patient_phone VARCHAR(20)
AS
BEGIN
    INSERT INTO Patient (patient_id, patient_name, patient_gender, patient_address, patient_phone)
    VALUES (@patient_id, @patient_name, @patient_gender, @patient_address, @patient_phone);
END;
GO

-- Update Patient
CREATE PROCEDURE sp_UpdatePatient
    @patient_id INT,
    @patient_name VARCHAR(100),
    @patient_gender VARCHAR(10),
    @patient_address VARCHAR(150),
    @patient_phone VARCHAR(20)
AS
BEGIN
    UPDATE Patient
    SET patient_name = @patient_name,
        patient_gender = @patient_gender,
        patient_address = @patient_address,
        patient_phone = @patient_phone
    WHERE patient_id = @patient_id;
END;
GO

-- Delete Patient
CREATE PROCEDURE sp_DeletePatient
    @patient_id INT
AS
BEGIN
    DELETE FROM Patient WHERE patient_id = @patient_id;
END;
GO


-- ====================================
-- 9. DONATE TABLE PROCEDURES
-- ====================================

-- Insert Donation
CREATE PROCEDURE sp_InsertDonation
    @donor_id INT,
    @bank_id INT,
    @blood_id INT,
    @quantity_of_Blood DECIMAL(5,2),
    @donor_Date_of_Donation DATE
AS
BEGIN
    INSERT INTO Donate (donor_id, bank_id, blood_id, quantity_of_Blood, donor_Date_of_Donation)
    VALUES (@donor_id, @bank_id, @blood_id, @quantity_of_Blood, @donor_Date_of_Donation);
    
    -- Update donor's last donation date
    UPDATE Donor
    SET last_donation_date = @donor_Date_of_Donation
    WHERE donor_id = @donor_id;
END;
GO

-- Update Donation
CREATE PROCEDURE sp_UpdateDonation
    @donor_id INT,
    @bank_id INT,
    @blood_id INT,
    @quantity_of_Blood DECIMAL(5,2),
    @donor_Date_of_Donation DATE
AS
BEGIN
    UPDATE Donate
    SET quantity_of_Blood = @quantity_of_Blood,
        donor_Date_of_Donation = @donor_Date_of_Donation
    WHERE donor_id = @donor_id AND bank_id = @bank_id AND blood_id = @blood_id;
END;
GO

-- Delete Donation
CREATE PROCEDURE sp_DeleteDonation
    @donor_id INT,
    @bank_id INT,
    @blood_id INT
AS
BEGIN
    DELETE FROM Donate 
    WHERE donor_id = @donor_id AND bank_id = @bank_id AND blood_id = @blood_id;
END;
GO


-- ====================================
-- 10. ANALYSE TABLE PROCEDURES
-- ====================================

-- Insert Analysis
CREATE PROCEDURE sp_InsertAnalysis
    @clinical_id INT,
    @blood_id INT,
    @blood_group VARCHAR(5),
    @analyse_date DATE,
    @result VARCHAR(50)
AS
BEGIN
    INSERT INTO Analyse (clinical_id, blood_id, blood_group, analyse_date, result)
    VALUES (@clinical_id, @blood_id, @blood_group, @analyse_date, @result);
END;
GO

-- Update Analysis
CREATE PROCEDURE sp_UpdateAnalysis
    @blood_id INT,
    @clinical_id INT,
    @blood_group VARCHAR(5),
    @analyse_date DATE,
    @result VARCHAR(50)
AS
BEGIN
    UPDATE Analyse
    SET clinical_id = @clinical_id,
        blood_group = @blood_group,
        analyse_date = @analyse_date,
        result = @result
    WHERE blood_id = @blood_id;
END;
GO

-- Delete Analysis
CREATE PROCEDURE sp_DeleteAnalysis
    @blood_id INT
AS
BEGIN
    DELETE FROM Analyse WHERE blood_id = @blood_id;
END;
GO

-- ====================================
-- 11. SUPPLY TABLE PROCEDURES
-- ====================================

-- Insert Supply
CREATE PROCEDURE sp_InsertSupply
    @bank_id INT,
    @hospital_id INT,
    @supply_date DATE,
    @quantity INT
AS
BEGIN
    INSERT INTO Supply (bank_id, hospital_id, supply_date, quantity)
    VALUES (@bank_id, @hospital_id, @supply_date, @quantity);
END;
GO

-- Update Supply
CREATE PROCEDURE sp_UpdateSupply
    @bank_id INT,
    @hospital_id INT,
    @supply_date DATE,
    @quantity INT
AS
BEGIN
    UPDATE Supply
    SET quantity = @quantity
    WHERE bank_id = @bank_id AND hospital_id = @hospital_id AND supply_date = @supply_date;
END;
GO

-- Delete Supply
CREATE PROCEDURE sp_DeleteSupply
    @bank_id INT,
    @hospital_id INT,
    @supply_date DATE
AS
BEGIN
    DELETE FROM Supply 
    WHERE bank_id = @bank_id AND hospital_id = @hospital_id AND supply_date = @supply_date;
END;
GO


-- ====================================
-- 12. REGISTER TABLE PROCEDURES
-- ====================================

-- Insert Registration
CREATE PROCEDURE sp_InsertRegistration
    @hospital_id INT,
    @patient_id INT,
    @date_of_intake DATE,
    @blood_group_needed VARCHAR(5),
    @blood_quantity_needed INT
AS
BEGIN
    INSERT INTO Register (hospital_id, patient_id, date_of_intake, blood_group_needed, blood_quantity_needed)
    VALUES (@hospital_id, @patient_id, @date_of_intake, @blood_group_needed, @blood_quantity_needed);
END;
GO

-- Update Registration
CREATE PROCEDURE sp_UpdateRegistration
    @hospital_id INT,
    @patient_id INT,
    @date_of_intake DATE,
    @blood_group_needed VARCHAR(5),
    @blood_quantity_needed INT
AS
BEGIN
    UPDATE Register
    SET date_of_intake = @date_of_intake,
        blood_group_needed = @blood_group_needed,
        blood_quantity_needed = @blood_quantity_needed
    WHERE hospital_id = @hospital_id AND patient_id = @patient_id;
END;
GO

-- Delete Registration
CREATE PROCEDURE sp_DeleteRegistration
    @hospital_id INT,
    @patient_id INT
AS
BEGIN
    DELETE FROM Register 
    WHERE hospital_id = @hospital_id AND patient_id = @patient_id;
END;
GO


-- ====================================
-- 13. DONOR_DISEASES TABLE PROCEDURES
-- ====================================

-- Insert Donor Disease
CREATE PROCEDURE sp_InsertDonorDisease
    @donor_id INT,
    @disease_id INT
AS
BEGIN
    INSERT INTO Donor_Diseases (donor_id, disease_id)
    VALUES (@donor_id, @disease_id);
END;
GO

-- Delete Donor Disease
CREATE PROCEDURE sp_DeleteDonorDisease
    @donor_id INT,
    @disease_id INT
AS
BEGIN
    DELETE FROM Donor_Diseases 
    WHERE donor_id = @donor_id AND disease_id = @disease_id;
END;
GO

-- Delete All Diseases for a Donor
CREATE PROCEDURE sp_DeleteAllDonorDiseases
    @donor_id INT
AS
BEGIN
    DELETE FROM Donor_Diseases WHERE donor_id = @donor_id;
END;
GO

-- ====================================
-- 14. BLOOD_BAG_DISEASES TABLE PROCEDURES
-- ====================================

-- Insert Blood Bag Disease
CREATE PROCEDURE sp_InsertBloodBagDisease
    @blood_id INT,
    @disease_id INT
AS
BEGIN
    INSERT INTO Blood_Bag_Diseases (blood_id, disease_id)
    VALUES (@blood_id, @disease_id);
END;
GO

-- Delete Blood Bag Disease
CREATE PROCEDURE sp_DeleteBloodBagDisease
    @blood_id INT,
    @disease_id INT
AS
BEGIN
    DELETE FROM Blood_Bag_Diseases 
    WHERE blood_id = @blood_id AND disease_id = @disease_id;
END;
GO

-- Delete All Diseases for a Blood Bag
CREATE PROCEDURE sp_DeleteAllBloodBagDiseases
    @blood_id INT
AS
BEGIN
    DELETE FROM Blood_Bag_Diseases WHERE blood_id = @blood_id;
END;
GO



-- ====================================
-- USAGE EXAMPLES (T-SQL)
-- ====================================

/*
-- Example: Insert a Manager
EXEC sp_InsertManager 
    @manager_id = 11, 
    @manager_name = 'John Smith', 
    @manager_phone = '01234567890', 
    @manager_address = '123 Main St, Cairo';

-- Example: Update a Manager
EXEC sp_UpdateManager 
    @manager_id = 11, 
    @manager_name = 'John Smith Jr.', 
    @manager_phone = '01234567890', 
    @manager_address = '123 Main St, Cairo';

-- Example: Delete a Manager
EXEC sp_DeleteManager @manager_id = 11;

-- Example: Insert a Donation
EXEC sp_InsertDonation 
    @donor_id = 1, 
    @bank_id = 1, 
    @blood_id = 16, 
    @quantity_of_Blood = 450.00, 
    @donor_Date_of_Donation = '2026-02-01';

-- Example: Complete Donation Process
EXEC sp_CompleteDonationProcess 
    @donor_id = 16, 
    @donor_name = 'Ali Hassan', 
    @donor_gender = 'Male', 
    @donor_age = 28, 
    @donor_address = 'Nasr City', 
    @donor_phone = '01234567890', 
    @bank_id = 1, 
    @blood_id = 16, 
    @quantity = 450.00, 
    @donation_date = '2026-02-01';

*/