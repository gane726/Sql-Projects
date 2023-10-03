-- Print details of shipments (sales) where amounts are > 2,000 and boxes are <100?

select *
from sales
where Amount >2000 and Boxes <100
order by Amount desc,Boxes desc;

-- How many shipments (sales) each of the sales persons had in the month of January 2022?

select p.Salesperson,count(*) as TotalShipments
from people as p
inner join sales as s on p.SPID = s.SPID
where s.SaleDate between '2022-01-01' and '2022-01-31'
group by p.Salesperson
order by TotalShipments desc;

-- Which product sells more boxes? Milk Bars or Eclairs?
select pr.Product,sum(s.Boxes) as TotalBoxes
from products as pr
inner join sales as s on pr.PID = s.PID
where pr.Product in ('Milk Bars','Eclairs')
group by pr.Product;

-- Which product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs?

select pr.Product,sum(s.Boxes) as TotalBoxes
from products as pr
inner join sales as s on pr.PID = s.PID
where (pr.Product in ('Milk Bars','Eclairs')) and (s.SaleDate between '2022-02-01' and '2022-02-07')
group by pr.Product;


-- Which shipments had under 100 customers & under 100 boxes? Did any of them occur on Wednesday?
select SaleDate,dayname(SaleDate);
select * from sales;

select *,dayname(SaleDate)
from sales
where (Customers < 100 and Boxes < 100) and dayname(SaleDate)= 'Wednesday';

-- What are the names of salespersons who had at least one shipment (sale) in the first 7 days of January 2022?
select p.Salesperson,count(*) as Shipments
from people as p
inner join sales as s on p.SPID = s.SPID
where s.SaleDate between '2022-01-01' and '2022-01-07'
group by p.Salesperson
having count(*)>=1;

-- Which salespersons did not make any shipments in the first 7 days of January 2022?
select p.Salesperson
from people as p
where p.SPID not in (select s.SPID from sales as s)