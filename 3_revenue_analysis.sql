-- REVENUE ANALYSIS
-- 1. Monthly revenue performance
CREATE VIEW monthly_revenue AS
SELECT 
  TO_CHAR(DATE_TRUNC('month', bill_date),'Month YYYY') AS month,
  SUM(amount) AS total_billed,
  SUM(CASE WHEN payment_status = 'Paid' THEN amount ELSE 0 END) AS collected,
  SUM(CASE WHEN payment_status = 'Unpaid' THEN amount ELSE 0 END) AS unpaid,
  SUM(CASE WHEN payment_status = 'Pending' THEN amount ELSE 0 END) AS pending,
  ROUND(SUM(CASE WHEN payment_status = 'Paid' THEN amount ELSE 0 END) 
    /NULLIF (SUM(amount),0) * 100, 2) AS collection_rate_percentage
FROM billing
GROUP BY month
ORDER BY month;

-- 2i. Payment Method Breakdown
SELECT 
	payment_method,
	COUNT(*) AS transaction_count,
	SUM(amount) AS total_amount,
	ROUND(AVG(amount),2) AS avg_bill,
	ROUND(COUNT(*)*100 / SUM(COUNT(*)) OVER(), 2) AS percentage_of_transactions
	FROM billing
	GROUP BY payment_method
	ORDER BY total_amount DESC;
-- 2ii. Payment Status Overview
SELECT 
	payment_status,
	COUNT(*) AS total_transactions,
	SUM(amount) AS total_amount,
	ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER(), 2) AS percentage_of_transactions 
	FROM BILLING 
	GROUP BY payment_status
	ORDER BY total_amount DESC;

