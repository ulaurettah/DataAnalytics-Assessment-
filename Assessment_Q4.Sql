with Customer_transactions As (
	-- Count of total transactions and sum of transaction amount per customer
    select
		savings_savingsaccount.owner_id,
        count(*) As Total_transactions,
        sum(savings_savingsaccount.confirmed_amount) As Total_transaction_amount
	from
		savings_savingsaccount
	group by
		savings_savingsaccount.owner_id
),
Customer_tenure As (
	-- Calculate account tenure in months for each customer
    select
		users_customuser.id As owner_id,
        timestampdiff(Month, users_customuser.date_joined, Current_date) As Total_tenure_months,
        floor(timestampdiff(Month, users_customuser.date_joined,Current_date))/12 As Tenure_years,
        TIMESTAMPDIFF(MONTH, users_customuser.date_joined, CURRENT_DATE) % 12 AS remaining_months
	from
		users_customuser
)
-- Calculate and order by estimated CLV
select
	Customer_transactions.owner_id As customer_id,
    users_customuser.first_name as Name,
    Customer_tenure.Total_tenure_months,
    Customer_transactions.Total_transactions,
    Customer_transactions.Total_transaction_amount,
    (cast(Customer_transactions.Total_transactions As Real)/Customer_tenure.Total_tenure_months)*12*(0.001*(cast(Customer_transactions.Total_transaction_amount As real)/100)) As estimated_Clv
from
	Customer_transactions
join
	Customer_tenure on Customer_transactions.owner_id=Customer_tenure.owner_id
join 
	users_customuser on Customer_transactions.owner_id=users_customuser.id
order by
	estimated_Clv desc;
        

    
    