-- 1. How many different nodes make up the Data Bank network?
select distinct node_id
from customer_nodes
order by node_id asc; -- Total 5 different nodes that Data Bank netword provides to the customer

-- 2. How many nodes are there in each region?
select region_id , count(node_id) as TotalNodes_InEachRegion
from customer_nodes
group by region_id
order by TotalNodes_InEachRegion desc;

-- 3. How many customers are divided among the regions?
select region_id,count(customer_id) as Total_Customers
from customer_nodes
group by region_id
order by Total_Customers desc;

-- 4. Determine the total amount of transactions for each region name.
select cn.region_id,reg.region_name,sum(ct.txn_amount) as Total_TransactionAmounts
from customer_nodes as cn
inner join customer_transactions as ct on cn.customer_id = ct.customer_id
inner join regions as reg on cn.region_id = reg.region_id
group by cn.region_id,reg.region_name
order by Total_TransactionAmounts desc;

-- 5. How long does it take on an average to move clients to a new node?
select round(avg(datediff(end_date,start_date)),2) as avg_days
from customer_nodes
where end_date != "9999-12-31";

-- 6. What is the unique count and total amount for each transaction type?
select txn_type,count(*) as count,sum(txn_amount) as TotalAmount
from customer_transactions
group by txn_type;

-- 7. What is the average number and size of past deposits across all customers?
select round(count(customer_id)/(select count(distinct customer_id) from customer_transactions),2) as Avg_deposit_amount
from customer_transactions
where txn_type="deposit";

-- 8. For each month - how many Data Bank customers make more than 1 deposit and 
-- at least either 1 purchase or 1 withdrawal in a single month?

with transaction_cte as 
(
	select customer_id , extract(month from txn_date) as Transaction_Month,
    sum(if(txn_type = "deposit",1,0)) as deposit_count,
    sum(if(txn_type = "withdrawal",1,0)) as withdrawal_count,
    sum(if(txn_type = "purchase",1,0)) as purchase_count
    from customer_transactions
    group by customer_id , extract(month from txn_date)
)

select Transaction_Month, count(distinct customer_id) as Customers
from transaction_cte
where deposit_count>1 and withdrawal_count = 1 or purchase_count = 1
group by Transaction_Month;




