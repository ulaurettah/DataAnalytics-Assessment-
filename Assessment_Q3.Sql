	select
		plans_plan.id As plan_id,
		plans_plan.owner_id,
		plans_plan.plan_type_id,
		max(savings_savingsaccount.transaction_date) As last_transaction_date,
		datediff(current_date, (MAX(savings_savingsaccount.transaction_date))) As days_inactive 
	from
		plans_plan
	left join
		savings_savingsaccount on plans_plan.id=savings_savingsaccount.plan_id 
        and savings_savingsaccount.confirmed_amount>0
	Group By
		plans_plan.owner_id, plans_plan.id, plans_plan.plan_type_id
	having
		last_transaction_date IS NULL OR
		last_transaction_date < Date_sub(current_date, interval 365 Day)
	order by
		days_inactive Desc;
