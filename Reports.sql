 -- 1 --
/*
 View
 (Query)للتقارير المتكررة لأنها بتخزن الاستعلام  
 وبتظهره كجدول جاهز.

 تقرير المخزون الصالح للاستخدام الفوري 
(vw_ReadyBloodStock)
هذا التقرير يجمع البيانات من 4 جداول ليعطيك الأكياس المختبرة والآمنة فقط.
*/

CREATE VIEW vw_ReadyBloodStock AS
SELECT 
    bb.blood_id,
    a.blood_group,
    d.quantity_of_Blood AS Quantity,
    bk.bank_name,
    bk.location AS Bank_Location,
    a.analyse_date
FROM Blood_Bag bb
JOIN Analyse a ON bb.blood_id = a.blood_id
JOIN Donate d ON bb.blood_id = d.blood_id
JOIN Blood_Bank bk ON d.bank_id = bk.bank_id
LEFT JOIN Blood_Bag_Diseases bbd ON bb.blood_id = bbd.blood_id
WHERE a.result = 'Safe' 
  AND bbd.blood_id IS NULL -- التأكد من خلوها من الأمراض


-- 2 --
/*
Functions
(للحسابات المخصصة)

  Function 
  لحساب تاريخ التبرع القادم المسموح به
بدل ما تحسب 60 يوم يدوي، 
Function
دي بتطلع التاريخ فوراً.
*/

CREATE FUNCTION fn_NextEligibleDate (@last_donation DATE)
RETURNS DATE
AS
BEGIN
    RETURN DATEADD(DAY, 60, @last_donation);
END

-- مثال لاستخدامها في تقرير المانحين:
SELECT donor_name, last_donation_date, dbo.fn_NextEligibleDate(last_donation_date) 
AS Next_Possible_Donation
FROM Donor


 -- 3 --
/*
Table-valued Function 

 لعرض رصيد فصيلة دم معينة
بتبعت لها الفصيلة
، بترجع لك جدول بالبنوك اللي فيها الفصيلة دي وكميتها.
*/

CREATE FUNCTION fn_GetStockByGroup (@blood_group VARCHAR(5))
RETURNS TABLE
AS
RETURN (
    SELECT bank_name, SUM(quantity_of_Blood) as Total_Quantity
    FROM vw_ReadyBloodStock -- استخدمنا الـ View اللي عملناها فوق!
    WHERE blood_group = @blood_group
    GROUP BY bank_name
)

 -- 4 --
/*
Cursors
(للعمليات السطرية)
 بنستخدمه لما نحتاج نلف على البيانات "سطر سطر" عشان نطلع تقرير نصي أو نبعت تنبيهات.


تقرير ملخص النواقص للمستشفيات
التقرير ده بيلف على المستشفيات اللي طالبة دم ومش متوفر، ويطبع رسالة تنبيه.
*/


DECLARE @h_name VARCHAR(100), @b_group VARCHAR(5), @needed INT;

DECLARE cur_ShortageReport CURSOR FOR
SELECT h.hospital_name, r.blood_group_needed, r.blood_quantity_needed
FROM Register r
JOIN Hospital h ON r.hospital_id = h.hospital_id
WHERE NOT EXISTS (SELECT 1 FROM vw_ReadyBloodStock v WHERE v.blood_group = r.blood_group_needed);

OPEN cur_ShortageReport;
FETCH NEXT FROM cur_ShortageReport INTO @h_name, @b_group, @needed;

PRINT '--- ALERT: BLOOD SHORTAGE REPORT ---';
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Hospital: ' + @h_name + ' needs ' + CAST(@needed AS VARCHAR) + ' units of Group (' + @b_group + ') - STATUS: NOT AVAILABLE';
    FETCH NEXT FROM cur_ShortageReport INTO @h_name, @b_group, @needed;
END;

CLOSE cur_ShortageReport;
DEALLOCATE cur_ShortageReport;



-- 5 --
/*
تقرير إحصائي شامل
(Utilizing Groups & Aggregates)

تقرير للمديرين يوضح نسبة الأكياس المصابة بالأمراض مقارنة بالأكياس السليمة.
*/
CREATE VIEW vw_RiskAssessmentReport AS
SELECT 
    bk.bank_name,
    COUNT(bb.blood_id) AS Total_Bags,
    SUM(CASE WHEN a.result = 'Safe' THEN 1 ELSE 0 END) AS Healthy_Bags,
    SUM(CASE WHEN bbd.blood_id IS NOT NULL THEN 1 ELSE 0 END) AS Infected_Bags,
    (CAST(SUM(CASE WHEN bbd.blood_id IS NOT NULL THEN 1 ELSE 0 END) AS FLOAT) / COUNT(bb.blood_id)) * 100 AS Infection_Rate_Percentage
FROM Blood_Bank bk
LEFT JOIN Donate d ON bk.bank_id = d.bank_id
LEFT JOIN Blood_Bag bb ON d.blood_id = bb.blood_id
LEFT JOIN Analyse a ON bb.blood_id = a.blood_id
LEFT JOIN Blood_Bag_Diseases bbd ON bb.blood_id = bbd.blood_id
GROUP BY bk.bank_name;

