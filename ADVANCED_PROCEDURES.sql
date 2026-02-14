
-- ====================================
-- ADVANCED PROCEDURES FOR COMPLEX OPERATIONS
-- ====================================

-- Complete Donation Process (Insert Donor, Blood Bag, and Donation in one transaction)
CREATE PROCEDURE sp_CompleteDonationProcess
    @donor_id INT,
    @donor_name VARCHAR(100),
    @donor_gender VARCHAR(10),
    @donor_age INT,
    @donor_address VARCHAR(150),
    @donor_phone VARCHAR(20),
    @bank_id INT,
    @blood_id INT,
    @quantity DECIMAL(5,2),
    @donation_date DATE
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Check if donor exists
        IF NOT EXISTS (SELECT 1 FROM Donor WHERE donor_id = @donor_id)
        BEGIN
            -- Insert new donor
            INSERT INTO Donor (donor_id, donor_name, donor_gender, donor_age, donor_address, donor_phone, last_donation_date)
            VALUES (@donor_id, @donor_name, @donor_gender, @donor_age, @donor_address, @donor_phone, @donation_date);
        END
        ELSE
        BEGIN
            -- Update existing donor's last donation date
            UPDATE Donor 
            SET last_donation_date = @donation_date 
            WHERE donor_id = @donor_id;
        END
        
        -- Insert Blood Bag
        INSERT INTO Blood_Bag (blood_id) VALUES (@blood_id);
        
        -- Insert Donation
        INSERT INTO Donate (donor_id, bank_id, blood_id, quantity_of_Blood, donor_Date_of_Donation)
        VALUES (@donor_id, @bank_id, @blood_id, @quantity, @donation_date);
        
        COMMIT TRANSACTION;
        SELECT 'Success: Donation process completed' AS Message;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Error: ' + ERROR_MESSAGE() AS Message;
    END CATCH
END;
GO

-- Get Available Blood by Group
CREATE PROCEDURE sp_GetAvailableBloodByGroup
    @blood_group VARCHAR(5)
AS
BEGIN
    SELECT 
        bb.blood_id,
        a.blood_group,
        a.result,
        d.quantity_of_Blood,
        d.donor_Date_of_Donation,
        bl.bank_name
    FROM Blood_Bag bb
    INNER JOIN Analyse a ON bb.blood_id = a.blood_id
    INNER JOIN Donate d ON bb.blood_id = d.blood_id
    INNER JOIN Blood_Bank bl ON d.bank_id = bl.bank_id
    WHERE a.blood_group = @blood_group 
    AND a.result = 'Safe'
    AND bb.blood_id NOT IN (SELECT blood_id FROM Blood_Bag_Diseases);
END;
GO

-- Get Donor Eligibility Check (history of Doner)
CREATE PROCEDURE sp_CheckDonorEligibility
    @donor_id INT
AS
BEGIN
    DECLARE @disease_count INT;
    DECLARE @last_donation DATE;
    DECLARE @days_since_donation INT;
    
    -- Check for dangerous diseases
    SELECT @disease_count = COUNT(*)
    FROM Donor_Diseases dd
    INNER JOIN Disease d ON dd.disease_id = d.disease_id
    WHERE dd.donor_id = @donor_id
    AND d.disease_name IN ('HIV', 'Hepatitis B', 'Hepatitis C', 'Syphilis', 'Malaria');
    
    -- Get last donation date
    SELECT @last_donation = last_donation_date
    FROM Donor
    WHERE donor_id = @donor_id;
    
    -- Calculate days since last donation
    IF @last_donation IS NOT NULL
        SET @days_since_donation = DATEDIFF(DAY, @last_donation, GETDATE());
    ELSE
        SET @days_since_donation = 999; -- No previous donation
    
    -- Return eligibility status
    IF @disease_count > 0
        SELECT 'Not Eligible' AS Status, 'Donor has dangerous disease' AS Reason;
    ELSE IF @days_since_donation < 56
        SELECT 'Not Eligible' AS Status, 'Must wait ' + CAST((56 - @days_since_donation) AS VARCHAR) + ' more days' AS Reason;
    ELSE
        SELECT 'Eligible' AS Status, 'Donor can donate' AS Reason;
END;
GO

-- Get Blood Inventory Summary by Bank
CREATE PROCEDURE sp_GetBloodInventorySummary
    @bank_id INT = NULL
AS
BEGIN
    SELECT 
        bl.bank_id,
        bl.bank_name,
        a.blood_group,
        COUNT(bb.blood_id) AS Total_Bags,
        SUM(d.quantity_of_Blood) AS Total_Quantity_ml,
        SUM(CASE WHEN a.result = 'Safe' AND bbd.blood_id IS NULL THEN 1 ELSE 0 END) AS Safe_Bags,
        SUM(CASE WHEN a.result != 'Safe' OR bbd.blood_id IS NOT NULL THEN 1 ELSE 0 END) AS Unsafe_Bags
    FROM Blood_Bank bl
    INNER JOIN Donate d ON bl.bank_id = d.bank_id
    INNER JOIN Blood_Bag bb ON d.blood_id = bb.blood_id
    INNER JOIN Analyse a ON bb.blood_id = a.blood_id
    LEFT JOIN Blood_Bag_Diseases bbd ON bb.blood_id = bbd.blood_id
    WHERE (@bank_id IS NULL OR bl.bank_id = @bank_id)
    GROUP BY bl.bank_id, bl.bank_name, a.blood_group
    ORDER BY bl.bank_name, a.blood_group;
END;
GO

-- Get Patient Blood Needs
CREATE PROCEDURE sp_GetPatientBloodNeeds
    @hospital_id INT = NULL
AS
BEGIN
    SELECT 
        h.hospital_name,
        p.patient_name,
        r.blood_group_needed,
        r.blood_quantity_needed,
        r.date_of_intake,
        -- Check if blood is available
        CASE 
            WHEN EXISTS (
                SELECT 1 
                FROM Analyse a 
                INNER JOIN Blood_Bag bb ON a.blood_id = bb.blood_id
                WHERE a.blood_group = r.blood_group_needed 
                AND a.result = 'Safe'
                AND bb.blood_id NOT IN (SELECT blood_id FROM Blood_Bag_Diseases)
            ) THEN 'Available'
            ELSE 'Not Available'
        END AS Blood_Availability
    FROM Register r
    INNER JOIN Hospital h ON r.hospital_id = h.hospital_id
    INNER JOIN Patient p ON r.patient_id = p.patient_id
    WHERE (@hospital_id IS NULL OR h.hospital_id = @hospital_id)
    ORDER BY r.date_of_intake;
END;
GO



/*
-- Example: Get Available Blood
EXEC sp_GetAvailableBloodByGroup @blood_group = 'A+';

-- Example: Check Donor Eligibility
EXEC sp_CheckDonorEligibility @donor_id = 1;

-- Example: Get Blood Inventory Summary
EXEC sp_GetBloodInventorySummary @bank_id = 1;

-- Example: Get Patient Blood Needs
EXEC sp_GetPatientBloodNeeds @hospital_id = 1;
*/