


				----------JOINING THE TITLE, FIRSTNAME, MIDDLENAME, LASTNAME AND SUFFIX IN ONE COLUMN--------

select Title, FirstName, MiddleName, LastName, Suffix
from AdventureWorks2016.person.person

select ISNULL(title, ' ')+ ' ' + FirstName + ' '
+ ISNULL(MiddleName, ' ')+ ' ' + LastName
+ ISNULL(Suffix, ' ') FULLNAME
from AdventureWorks2016.person.person

					------LOOKING INTO INVENTORY FOR MOUNTAIN PARTS WITH NO COLOR----------

select *
from AdventureWorks2016.Production.Product
where Name like '%mountain%' and Color is null

						----CONTACTS THATS STAYS IN SANTA MONICA-------

select pp.BusinessEntityID, pa.AddressID, *
from AdventureWorks2016.Person.Person pp
join AdventureWorks2016.Person.Address pa
on pa.AddressID = pp.BusinessEntityID
where pa.City = 'santa monica'
order by pp.BusinessEntityID, pa.AddressID

					-----LOOKING AT TOTAL NUMMBERS OF PRICES AND COSTS--------


select sum(StandardPrice) as TotalStandardPrice, sum(LastReceiptCost) as TotalLastReceiptCost,
sum(MinOrderQty) as TotalMinOrderQty, sum(MaxOrderQty) as TotalMaxOrderQty,
sum(cast(OnOrderQty as numeric)) as TotalOnOrderQty
from AdventureWorks2016.Purchasing.ProductVendor


					-------LOOKING AT CUSTOMERS INFO WITHOUT STOREID-------

select *
from AdventureWorks2016.Sales.CustomerPII SCP
join AdventureWorks2016.Sales.Customer SC
ON SCP.CustomerID = SC.CustomerID
WHERE SC.STOREID IS NULL

				-------LOOKING AT PROFILE OF MARRIED FEMALE TECHNICIANS WITH THE HIGHEST SICKLEAVE HOURS------

select he.SickLeaveHours, *
from AdventureWorks2016.HumanResources.Employee HE
JOIN AdventureWorks2016.Person.Person PP
ON HE.BusinessEntityID = PP.BusinessEntityID
WHERE he.JobTitle LIKE '%Technician%' and he.MaritalStatus = 'm' and he.Gender = 'f'
order by he.SickLeaveHours desc

				------LOOKING AT PROFILE THAT GOT BONUSES-------

select *
from AdventureWorks2016.Person.Person pp
join AdventureWorks2016.Sales.SalesPerson ssp
on pp.BusinessEntityID = ssp.BusinessEntityID
where ssp.bonus <> '0.00'