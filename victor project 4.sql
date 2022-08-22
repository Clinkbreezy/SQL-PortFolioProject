


---populating ownersplitaddress, ownersplitcity and ownersplitstate----

select propertysplitaddress, propertysplitcity, isnull(OwnerSplitAddress,propertysplitaddress),
isnull(OwnerSplitCity, propertysplitcity), isnull(OwnerSplitState, 'TN')
from victorprojectdata.dbo.nashvilleHousing

update victorprojectdata.dbo.nashvilleHousing
set OwnerSplitAddress = isnull(OwnerSplitAddress,propertysplitaddress)

update victorprojectdata.dbo.nashvilleHousing
set OwnerSplitCity = isnull(OwnerSplitCity,propertysplitcity)

update victorprojectdata.dbo.nashvilleHousing
set OwnerSplitState = isnull(OwnerSplitState, 'TN')



					-----LOOKING AT HOME THAT ARE BUILT FROM YEAR 2000 AND ABOVE THAT ARE SOLD FOR OVER A MILLION-------

SELECT *
from victorprojectdata.dbo.nashvilleHousing
where YearBuilt >= 2000 and SalePrice >= 1000000
ORDER BY [UniqueID ]


				------LOOKING AT HOMES THAT ARE SOLD FOR OVER A MILLION-------------

USE CTE PRCvsLAB

with PRCvsLAB([UniqueID ], OwnerName, LandUse, SalePrice, PRICE_RANGE) AS
(SELECT [UniqueID ], OwnerName, LandUse, SalePrice,
case when SalePrice < 100000
then 'SMALL PRICE'
else
case when SalePrice >= 100000 and SalePrice < 500000
then 'MEDIUM PRICE'
else
case when saleprice >= 500000 and saleprice < 1000000
then 'HIGH PRICE'
else 'OVER 1million'
end end end AS PRICE_RANGE
from victorprojectdata.dbo.nashvilleHousing)
SELECT *
FROM PRCvsLAB
WHERE PRICE_RANGE = 'OVER 1million'
ORDER BY [UniqueID ]

			---ADDING 100000 TO THE SALEPRICE DATA-----

SELECT (SalePrice + 100000) AS NEW_SALE_PRICE, *
from victorprojectdata.dbo.nashvilleHousing
ORDER BY [UniqueID ]

				------LOOKING AT PROFILES IN ANTIOCH CITY THAT SOLD THEIR HOMES FOR SMALL PRICE-------

with PRCvsLAB([UniqueID ], OwnerName, LandUse, OwnerSplitAddress, OwnerSplitCity, OwnerSplitState, SalePrice, PRICE_RANGE) AS
(SELECT [UniqueID ], OwnerName, LandUse, OwnerSplitAddress, OwnerSplitCity, OwnerSplitState, SalePrice,
case when SalePrice < 100000
then 'SMALL PRICE'
else
case when SalePrice >= 100000 and SalePrice < 500000
then 'MEDIUM PRICE'
else
case when saleprice >= 500000 and saleprice < 1000000
then 'HIGH PRICE'
else 'OVER 1million'
end end end AS PRICE_RANGE
from victorprojectdata.dbo.nashvilleHousing)
SELECT *
FROM PRCvsLAB
WHERE OwnerSplitCity LIKE '%ANTIOCH%' AND PRICE_RANGE = 'SMALL PRICE'
ORDER BY [UniqueID ]

				------LOOKINGG AT TOTAL NUMBER OF HOME SOLD PER CITY------

select DISTINCT(OwnerSplitCity), COUNT(UniqueID) as TOTAL_NUMBER
from victorprojectdata.dbo.nashvilleHousing
GROUP BY OwnerSplitCity
order by 1

				-------CONVERTING SALEDATECONVERTED DATA FROM NULL TO DEFAULT DATE------

SELECT SQL_VARIANT_PROPERTY(SALEDATECONVERTED, 'BASETYPE')
from victorprojectdata.dbo.nashvilleHousing
				
SELECT CONVERT(datetime, ISNULL(SALEDATECONVERTED, ' '))
from victorprojectdata.dbo.nashvilleHousing

update victorprojectdata.dbo.nashvilleHousing
set SALEDATECONVERTED = CONVERT(datetime, ISNULL(SALEDATECONVERTED, ' '))

SELECT saledateconverted, *
from victorprojectdata.dbo.nashvilleHousing