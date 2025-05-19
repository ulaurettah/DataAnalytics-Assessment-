	With fundedplantypes As(
	-- The CTE determines if each user have at least one funded savings plan and at least one funded investment plan
	select 
		savings_savingsaccount.owner_id,
		max(case when plans_plan.is_regular_savings=1 And savings_savingsaccount.amount>0 then 1 else 0 end) As funded_savings,
        max(case when plans_plan.is_a_fund=1 And savings_savingsaccount.amount>0 then 1 else 0 end) As funded_investment,
        sum(case when plans_plan.is_regular_savings=1 and savings_savingsaccount.confirmed_amount>0 then 1 else 0 end) As savings_count,
        sum(case when plans_plan.is_a_fund=1 and savings_savingsaccount.confirmed_amount>0 then 1 else 0 end) As Investment_count
	from 
		savings_savingsaccount
	join 
		plans_plan on savings_savingsaccount.plan_id=plans_plan.id
	group by owner_id
),
Total_deposits As (
	#The CTE calculates the total deposits of each user.
	select 
	owner_id,
	sum(confirmed_amount) as Total_deposit
	from 
	savings_savingsaccount
	group by 
	owner_id
)
select
	users_customuser.id as owner_id,
    users_customuser.first_name as name,
    fundedplantypes.savings_count,
    fundedplantypes.Investment_count,
    Total_deposits.Total_deposit
from
	users_customuser
join
	fundedplantypes on users_customuser.id=fundedplantypes.owner_id
join 
	Total_deposits on users_customuser.id=Total_deposits.owner_id
where
	fundedplantypes.funded_savings=1 
    and fundedplantypes.funded_investment=1
order by 
	Total_deposits.Total_deposit DESC
    limit 10;
