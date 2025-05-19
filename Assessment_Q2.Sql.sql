With Monthly_transaction As(
	-- counts the number of transactions per customers
	select 
    savings_savingsaccount.owner_id,
    date_format(savings_savingsaccount.transaction_date, '%Y-%m') As Transaction_month,
    count(*) As monthly_transaction_count
    from
		savings_savingsaccount
	group by
		savings_savingsaccount.owner_id,
        Transaction_month
),
Avrg_monthly_transaction As (
-- average number of transaction per customers across all months
select
	Monthly_transaction.owner_id,
    cast(sum(monthly_transaction_count) As Real)/ count(Monthly_transaction.transaction_month) As avg_transaction_per_month
From
	Monthly_transaction
group by
	Monthly_transaction.owner_id
),
Customer_frequency_category As (
-- categorizing customers based on average monthly transaction frequency
select
	amt.owner_id,
	amt.avg_transaction_per_month,
	case
		when amt.avg_transaction_per_month>= 10 Then 'High Frequency'
        when amt.avg_transaction_per_month between 3 and 9 Then 'Medium Frequency'
        Else 'Low frequency'
	End As Frequency_category
	from
		Avrg_monthly_transaction amt
)
-- catergorising customer counts and average frequency
select
	customer_frequency_category.frequency_category,
    count(customer_frequency_category.owner_id) As Customer_count,
    round(Avg(customer_frequency_category.avg_transaction_per_month), 2) As Avg_transactions_per_month
from
	customer_frequency_category
Group by
	customer_frequency_category.frequency_category
order by 
	case  customer_frequency_category.frequency_category
		when 'High Frequency' Then 1
        When 'Medium Frequency'Then 2
        When 'Low Frequency'Then 3 
	End;