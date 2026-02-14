
--create database Blood_Bank
--use Blood_Bank


--create table structure

CREATE TABLE Manager (
    manager_id INT,
    manager_name VARCHAR(100),
    manager_phone VARCHAR(20),
    manager_address VARCHAR(150),

    CONSTRAINT PK_Manager PRIMARY KEY (manager_id)
);

CREATE TABLE Blood_Bank (
    bank_id INT,
    bank_name VARCHAR(100),
    location VARCHAR(100),
    manager_id INT,

    CONSTRAINT PK_BloodBank PRIMARY KEY (bank_id),
    CONSTRAINT UQ_BloodBank_Manager UNIQUE (manager_id),
    CONSTRAINT FK_BloodBank_Manager 
        FOREIGN KEY (manager_id) REFERENCES Manager(manager_id)
);


CREATE TABLE Donor (
    donor_id INT,
    donor_name VARCHAR(100),
    donor_gender VARCHAR(10),
    donor_age INT,
    donor_address VARCHAR(150),
    donor_phone VARCHAR(20),
    last_donation_date DATE,

    CONSTRAINT PK_Donor PRIMARY KEY (donor_id)
);

CREATE TABLE Disease (
    disease_id INT,
    disease_name VARCHAR(100),

    CONSTRAINT PK_Disease PRIMARY KEY (disease_id)
);

CREATE TABLE Blood_Bag (
    blood_id INT PRIMARY KEY,
);

CREATE TABLE Clinical_Analyst (
    clinical_id INT,
    clinical_name VARCHAR(100),
    bank_id INT,
    CONSTRAINT PK_ClinicalAnalyst PRIMARY KEY (clinical_id),
    CONSTRAINT FK_ClinicalAnalyst_Blood_bank FOREIGN KEY (bank_id) REFERENCES Blood_bank(bank_id)
);

CREATE TABLE Donate (
    donor_id INT,
    bank_id INT,
    blood_id INT,
    quantity_of_Blood DECIMAL(5,2),
    donor_Date_of_Donation DATE,
    CONSTRAINT PK_Donate PRIMARY KEY (donor_id, bank_id, blood_id),
    CONSTRAINT UQ_Blood_Bag_Single_Donation UNIQUE (blood_id),
    CONSTRAINT FK_Donate_Donor FOREIGN KEY (donor_id) REFERENCES Donor(donor_id),
    CONSTRAINT FK_Donate_Bank FOREIGN KEY (bank_id) REFERENCES Blood_bank(bank_id),
    CONSTRAINT FK_Donate_Blood FOREIGN KEY (blood_id) REFERENCES Blood_Bag(blood_id)
);

CREATE TABLE Analyse (
    clinical_id INT,
    blood_id INT,
    blood_group VARCHAR(5),
    analyse_date DATE,
    result VARCHAR(50),
    CONSTRAINT PK_Analyse PRIMARY KEY (blood_id), -- مش هيتكرر كيس الدم يُحلل مرة واحدة
    CONSTRAINT FK_Analyse_Analyst FOREIGN KEY (clinical_id) REFERENCES Clinical_Analyst(clinical_id),
    CONSTRAINT FK_Analyse_Blood FOREIGN KEY (blood_id) REFERENCES Blood_Bag(blood_id)
);

CREATE TABLE Hospital (
    hospital_id INT,
    hospital_name VARCHAR(100),
    hospital_location VARCHAR(255),
    hospital_phone VARCHAR(20),
    CONSTRAINT PK_Hospital PRIMARY KEY (hospital_id)
);

CREATE TABLE Supply (
    bank_id INT,
    hospital_id INT,
    supply_date DATE,
    quantity INT,
    CONSTRAINT PK_Supply PRIMARY KEY (bank_id, hospital_id, supply_date),
    CONSTRAINT FK_Supply_Bank FOREIGN KEY (bank_id) REFERENCES Blood_bank(bank_id),
    CONSTRAINT FK_Supply_Hospital FOREIGN KEY (hospital_id) REFERENCES Hospital(hospital_id)
);

CREATE TABLE Patient (
    patient_id INT,
    patient_name VARCHAR(100),
    patient_gender VARCHAR(10),
    patient_address VARCHAR(150),
    patient_phone VARCHAR(20),

    CONSTRAINT PK_Patient PRIMARY KEY (patient_id)
);

CREATE TABLE Register (
    hospital_id INT,
    patient_id INT,
    date_of_intake DATE,
    blood_group_needed VARCHAR(5),
    blood_quantity_needed INT,

    CONSTRAINT PK_Register PRIMARY KEY (hospital_id, patient_id),

    CONSTRAINT FK_Register_Hospital 
        FOREIGN KEY (hospital_id) REFERENCES Hospital(hospital_id),

    CONSTRAINT FK_Register_Patient 
        FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);


CREATE TABLE Donor_Diseases (
    donor_id INT,
    disease_id INT,
    PRIMARY KEY (donor_id, disease_id),
    FOREIGN KEY (donor_id) REFERENCES Donor(donor_id),
    FOREIGN KEY (disease_id) REFERENCES Disease(disease_id)
);

CREATE TABLE Blood_Bag_Diseases (
    blood_id INT,
    disease_id INT,
    PRIMARY KEY (blood_id, disease_id),
    FOREIGN KEY (blood_id) REFERENCES Blood_Bag(blood_id),
    FOREIGN KEY (disease_id) REFERENCES Disease(disease_id)
);





-- ====================================
-- BLOOD BANK SYSTEM - INSERT DATA
-- At least 10 records per table
-- All data in English
-- ====================================



-- 1. INSERT INTO Manager (10 records)
INSERT INTO Manager (manager_id, manager_name, manager_phone, manager_address) VALUES
(1, 'Ahmed Mohamed Hassan', '01012345678', '15 Al-Gomhoreya Street, Cairo'),
(2, 'Sara Ali Mahmoud', '01087654321', '28 Al-Nasr Street, Alexandria'),
(3, 'Mahmoud Khaled Ibrahim', '01123456789', '42 Al-Haram Street, Giza'),
(4, 'Fatma Ahmed Said', '01198765432', '7 Al-Galaa Street, Mansoura'),
(5, 'Omar Hassan Ali', '01234567890', '19 Al-Bahr Street, Ismailia'),
(6, 'Mona Samir Fahmy', '01567890123', '33 Al-Mahatta Street, Tanta'),
(7, 'Yasser Mohamed Abdullah', '01678901234', '51 Al-Geish Street, Assiut'),
(8, 'Hoda Ibrahim Hussein', '01789012345', '12 Corniche Street, Luxor'),
(9, 'Tarek Adel Ramadan', '01890123456', '25 Al-Souk Street, Benha'),
(10, 'Nora Khaled Saleh', '01901234567', '8 University Street, Zagazig');


-- 2. INSERT INTO Blood_Bank (10 records)
INSERT INTO Blood_Bank (bank_id, bank_name, location, manager_id) VALUES
(1, 'Central Blood Bank - Cairo', 'Downtown, Cairo', 1),
(2, 'Main Blood Bank - Alexandria', 'Smoha, Alexandria', 2),
(3, 'Giza Blood Bank', 'Dokki, Giza', 3),
(4, 'Mansoura General Blood Bank', 'Mit Ghamr, Mansoura', 4),
(5, 'Ismailia Blood Bank', 'Al-Salam District, Ismailia', 5),
(6, 'Tanta University Blood Bank', 'University Area, Tanta', 6),
(7, 'Assiut Central Blood Bank', 'Al-Walideya District, Assiut', 7),
(8, 'Luxor Blood Bank', 'Karnak, Luxor', 8),
(9, 'Benha Blood Bank', 'City Center, Benha', 9),
(10, 'Zagazig Blood Bank', 'Al-Sagha, Zagazig', 10);


-- 3. INSERT INTO Donor (15 records)
INSERT INTO Donor (donor_id, donor_name, donor_gender, donor_age, donor_address, donor_phone, last_donation_date) VALUES
(1, 'Mohamed Ali Ahmed', 'Male', 28, 'Nasr City, Cairo', '01011111111', '2025-12-15'),
(2, 'Fatma Hassan Mahmoud', 'Female', 32, 'Maadi, Cairo', '01022222222', '2025-11-20'),
(3, 'Omar Khaled Said', 'Male', 25, 'Heliopolis, Cairo', '01033333333', '2026-01-10'),
(4, 'Nora Ibrahim Ali', 'Female', 29, 'Zamalek, Cairo', '01044444444', '2025-10-05'),
(5, 'Karim Youssef Hassan', 'Male', 35, 'Mohandessin, Giza', '01055555555', '2025-12-01'),
(6, 'Mona Samir Khaled', 'Female', 27, 'Dokki, Giza', '01066666666', '2026-01-15'),
(7, 'Ahmed Ramadan Mohamed', 'Male', 30, 'Haram, Giza', '01077777777', '2025-11-10'),
(8, 'Sara Adel Fathy', 'Female', 26, 'Smoha, Alexandria', '01088888888', '2025-12-20'),
(9, 'Hossam El-Din Tarek', 'Male', 33, 'Miami, Alexandria', '01099999999', '2026-01-05'),
(10, 'Hoda Mahmoud Saleh', 'Female', 31, 'Sidi Gaber, Alexandria', '01010101010', '2025-11-25'),
(11, 'Yasser Fahmy Ahmed', 'Male', 29, 'Mansoura', '01020202020', '2025-12-10'),
(12, 'Rania Khaled Hussein', 'Female', 28, 'Tanta', '01030303030', '2026-01-20'),
(13, 'Mahmoud Said Ali', 'Male', 34, 'Assiut', '01040404040', '2025-10-15'),
(14, 'Laila Abdullah Mohamed', 'Female', 30, 'Luxor', '01050505050', '2025-11-30'),
(15, 'Amr Hassan Ibrahim', 'Male', 27, 'Benha', '01060606060', '2025-12-25');



-- 4. INSERT INTO Disease (12 records)
INSERT INTO Disease (disease_id, disease_name) VALUES
(1, 'Diabetes'),
(2, 'Hypertension'),
(3, 'Hepatitis B'),
(4, 'Hepatitis C'),
(5, 'HIV'),
(6, 'Malaria'),
(7, 'Syphilis'),
(8, 'Heart Disease'),
(9, 'Sickle Cell Anemia'),
(10, 'Hemophilia'),
(11, 'Cancer'),
(12, 'Asthma');

-- 5. INSERT INTO Blood_Bag (15 records)
INSERT INTO Blood_Bag (blood_id) VALUES
(1), (2), (3), (4), (5), (6), (7), (8), (9), (10),
(11), (12), (13), (14), (15);

-- 6. INSERT INTO Clinical_Analyst (12 records)
INSERT INTO Clinical_Analyst (clinical_id, clinical_name, bank_id) VALUES
(1, 'Dr. Amira Mahmoud El-Sayed', 1),
(2, 'Dr. Hassan Ibrahim Abdullah', 1),
(3, 'Dr. Nadia Khaled Fahmy', 2),
(4, 'Dr. Tarek Said Mahmoud', 2),
(5, 'Dr. Samar Ali Hassan', 3),
(6, 'Dr. Mohamed Adel Ramadan', 4),
(7, 'Dr. Hala Youssef Ahmed', 5),
(8, 'Dr. Ahmed Saleh Mohamed', 6),
(9, 'Dr. Reham Hussein Ali', 7),
(10, 'Dr. Walid Fathy Khaled', 8),
(11, 'Dr. Iman Samir Hassan', 9),
(12, 'Dr. Karim Abdullah Ibrahim', 10);

-- 7. INSERT INTO Donate (15 records)
INSERT INTO Donate (donor_id, bank_id, blood_id, quantity_of_Blood, donor_Date_of_Donation) VALUES
(1, 1, 1, 450.00, '2025-12-15'),
(2, 1, 2, 450.00, '2025-11-20'),
(3, 1, 3, 450.00, '2026-01-10'),
(4, 2, 4, 450.00, '2025-10-05'),
(5, 2, 5, 450.00, '2025-12-01'),
(6, 3, 6, 450.00, '2026-01-15'),
(7, 3, 7, 450.00, '2025-11-10'),
(8, 2, 8, 450.00, '2025-12-20'),
(9, 2, 9, 450.00, '2026-01-05'),
(10, 2, 10, 450.00, '2025-11-25'),
(11, 4, 11, 450.00, '2025-12-10'),
(12, 6, 12, 450.00, '2026-01-20'),
(13, 7, 13, 450.00, '2025-10-15'),
(14, 8, 14, 450.00, '2025-11-30'),
(15, 9, 15, 450.00, '2025-12-25');

-- 8. INSERT INTO Analyse (15 records)
INSERT INTO Analyse (clinical_id, blood_id, blood_group, analyse_date, result) VALUES
(1, 1, 'A+', '2025-12-16', 'Safe'),
(2, 2, 'O-', '2025-11-21', 'Safe'),
(1, 3, 'B+', '2026-01-11', 'Safe'),
(3, 4, 'AB+', '2025-10-06', 'Safe'),
(4, 5, 'A-', '2025-12-02', 'Safe'),
(5, 6, 'O+', '2026-01-16', 'Safe'),
(5, 7, 'B-', '2025-11-11', 'Unsafe - Hepatitis B'),
(3, 8, 'A+', '2025-12-21', 'Safe'),
(4, 9, 'AB-', '2026-01-06', 'Safe'),
(3, 10, 'O+', '2025-11-26', 'Safe'),
(6, 11, 'A+', '2025-12-11', 'Safe'),
(8, 12, 'B+', '2026-01-21', 'Safe'),
(9, 13, 'O-', '2025-10-16', 'Unsafe - HIV'),
(10, 14, 'A-', '2025-12-01', 'Safe'),
(11, 15, 'AB+', '2025-12-26', 'Safe');

-- 9. INSERT INTO Hospital (12 records)
INSERT INTO Hospital (hospital_id, hospital_name, hospital_location, hospital_phone) VALUES
(1, 'Kasr Al-Ainy Hospital', 'El-Manial, Cairo', '0223654789'),
(2, 'Ain Shams Specialized Hospital', 'Abbasia, Cairo', '0224567890'),
(3, 'Kasr Al-Ainy French Hospital', 'El-Manial, Cairo', '0223987456'),
(4, 'Alexandria University Hospital', 'Al-Shatby, Alexandria', '0334567891'),
(5, 'Al-Mowasah Hospital', 'Fleming, Alexandria', '0335678902'),
(6, 'Giza General Hospital', 'Dokki, Giza', '0237890123'),
(7, 'Mansoura University Hospital', 'University Area, Mansoura', '0502345678'),
(8, 'Tanta University Hospital', 'Sekket El-Mahalla, Tanta', '0403456789'),
(9, 'Assiut University Hospital', 'Al-Walideya, Assiut', '0882567890'),
(10, 'Luxor General Hospital', 'Karnak, Luxor', '0952678901'),
(11, 'Benha Teaching Hospital', 'Downtown, Benha', '0133789012'),
(12, 'Zagazig General Hospital', 'Al-Sagha, Zagazig', '0552890123');


-- 10. INSERT INTO Supply (13 records)
-- Total donations = 15 x 450ml = 6,750 ml
-- Safe blood bags after analysis = 13 bags (2 unsafe: bags 7 and 13)
-- Safe blood available = 13 x 450ml = 5,850 ml
-- Total supplied below = 5,400 ml (leaving 450ml in inventory)
INSERT INTO Supply (bank_id, hospital_id, supply_date, quantity) VALUES
(1, 1, '2026-01-15', 450),  -- 1 bag
(1, 2, '2026-01-20', 450),  -- 1 bag
(1, 3, '2026-01-25', 450),  -- 1 bag
(2, 4, '2026-01-18', 900),  -- 2 bags
(2, 5, '2026-01-22', 450),  -- 1 bag
(3, 6, '2026-01-16', 450),  -- 1 bag
(4, 7, '2026-01-19', 450),  -- 1 bag
(5, 7, '2026-01-23', 450),  -- 1 bag
(6, 8, '2026-01-17', 450),  -- 1 bag
(8, 10, '2026-01-24', 450), -- 1 bag
(9, 11, '2026-01-26', 450), -- 1 bag
(10, 12, '2026-01-27', 450),-- 1 bag
(2, 1, '2026-01-29', 450);  -- 1 bag
-- Total supplied = 5,400 ml (12 bags supplied, 1 bag remains in inventory)
-- Unsafe bags (7 & 13) are discarded and not supplied


-- 11. INSERT INTO Patient (15 records)
INSERT INTO Patient (patient_id, patient_name, patient_gender, patient_address, patient_phone) VALUES
(1, 'Mona Samir Mohamed', 'Female', 'Zamalek, Cairo', '01111111111'),
(2, 'Karim Youssef Ali', 'Male', 'Dokki, Giza', '01222222222'),
(3, 'Nadia Hassan Ahmed', 'Female', 'Nasr City, Cairo', '01333333333'),
(4, 'Ahmed Khaled Ibrahim', 'Male', 'Maadi, Cairo', '01444444444'),
(5, 'Sara Mahmoud Fahmy', 'Female', 'Smoha, Alexandria', '01555555555'),
(6, 'Omar Adel Ramadan', 'Male', 'Miami, Alexandria', '01666666666'),
(7, 'Hoda Saleh Hussein', 'Female', 'Mohandessin, Giza', '01777777777'),
(8, 'Tarek Said Mohamed', 'Male', 'Mansoura', '01888888888'),
(9, 'Laila Abdullah Ali', 'Female', 'Tanta', '01999999999'),
(10, 'Yasser Fathy Khaled', 'Male', 'Assiut', '01101010101'),
(11, 'Rania Hassan Mahmoud', 'Female', 'Luxor', '01202020202'),
(12, 'Mahmoud Ali Ahmed', 'Male', 'Benha', '01303030303'),
(13, 'Fatma Khaled Said', 'Female', 'Zagazig', '01404040404'),
(14, 'Hossam Ibrahim Mohamed', 'Male', 'Heliopolis, Cairo', '01505050505'),
(15, 'Iman Samir Hassan', 'Female', 'Haram, Giza', '01606060606');

-- 12. INSERT INTO Register (12 records)
-- Only registering patients when blood is available
-- 12 bags supplied, so only 12 patients can be registered and served
INSERT INTO Register (hospital_id, patient_id, date_of_intake, blood_group_needed, blood_quantity_needed) VALUES
(1, 1, '2026-01-25', 'A+', 450),
(2, 3, '2026-01-27', 'B+', 450),
(3, 4, '2026-01-28', 'AB+', 450),
(4, 5, '2026-01-20', 'A-', 450),
(5, 6, '2026-01-22', 'O+', 900),  -- This patient needs 2 bags
(6, 7, '2026-01-23', 'B-', 450),
(7, 8, '2026-01-24', 'A+', 450),
(9, 10, '2026-01-26', 'O+', 450),
(10, 11, '2026-01-27', 'A+', 450),
(11, 12, '2026-01-28', 'B+', 450),
(12, 13, '2026-01-29', 'O-', 450),
(1, 14, '2026-01-30', 'A-', 450);
-- Total blood needed = 5,400 ml (12 bags) which matches supply exactly
-- Patient 6 needs 2 bags (900ml), others need 1 bag each (450ml)

-- 13. INSERT INTO Donor_Diseases (15 records)
INSERT INTO Donor_Diseases (donor_id, disease_id) VALUES
(1, 1),  -- Mohamed Ali Ahmed - Diabetes
(2, 2),  -- Fatma Hassan Mahmoud - Hypertension
(4, 8),  -- Nora Ibrahim Ali - Heart Disease
(5, 1),  -- Karim Youssef Hassan - Diabetes
(6, 12), -- Mona Samir Khaled - Asthma
(7, 2),  -- Ahmed Ramadan Mohamed - Hypertension
(10, 1), -- Hoda Mahmoud Saleh - Diabetes
(11, 12),-- Yasser Fahmy Ahmed - Asthma
(12, 8), -- Rania Khaled Hussein - Heart Disease
(13, 11),-- Mahmoud Said Ali - Cancer
(1, 12), -- Mohamed Ali Ahmed - Asthma (has two diseases)
(5, 2),  -- Karim Youssef Hassan - Hypertension (has two diseases)
(14, 2), -- Laila Abdullah Mohamed - Hypertension
(15, 1), -- Amr Hassan Ibrahim - Diabetes
(8, 12); -- Sara Adel Fathy - Asthma

-- 14. INSERT INTO Blood_Bag_Diseases (10 records)
-- Blood bags that tested positive for dangerous diseases
INSERT INTO Blood_Bag_Diseases (blood_id, disease_id) VALUES
(7, 3),  -- Blood bag 7 - Hepatitis B
(13, 5), -- Blood bag 13 - HIV
(7, 4),  -- Blood bag 7 - Hepatitis C (bag has two diseases)
(11, 3), -- Blood bag 11 - Hepatitis B
(12, 5), -- Blood bag 12 - HIV
(14, 7), -- Blood bag 14 - Syphilis
(15, 3), -- Blood bag 15 - Hepatitis B
(9, 6),  -- Blood bag 9 - Malaria
(11, 7), -- Blood bag 11 - Syphilis (bag has two diseases)
(14, 6); -- Blood bag 14 - Malaria (bag has two diseases)


-- ====================================
-- VERIFICATION QUERIES
-- ====================================

-- Count records in each table
SELECT 'Manager' AS Table_Name, COUNT(*) AS Record_Count FROM Manager
UNION ALL
SELECT 'Blood_Bank', COUNT(*) FROM Blood_Bank
UNION ALL
SELECT 'Donor', COUNT(*) FROM Donor
UNION ALL
SELECT 'Disease', COUNT(*) FROM Disease
UNION ALL
SELECT 'Blood_Bag', COUNT(*) FROM Blood_Bag
UNION ALL
SELECT 'Clinical_Analyst', COUNT(*) FROM Clinical_Analyst
UNION ALL
SELECT 'Donate', COUNT(*) FROM Donate
UNION ALL
SELECT 'Analyse', COUNT(*) FROM Analyse
UNION ALL
SELECT 'Hospital', COUNT(*) FROM Hospital
UNION ALL
SELECT 'Supply', COUNT(*) FROM Supply
UNION ALL
SELECT 'Patient', COUNT(*) FROM Patient
UNION ALL
SELECT 'Register', COUNT(*) FROM Register
UNION ALL
SELECT 'Donor_Diseases', COUNT(*) FROM Donor_Diseases
UNION ALL
SELECT 'Blood_Bag_Diseases', COUNT(*) FROM Blood_Bag_Diseases;


