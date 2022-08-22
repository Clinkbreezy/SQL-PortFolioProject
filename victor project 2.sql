







					--------STANDARDIZE DATE FPRMAT---------


select SaleDate, convert(date,saledate)
from victorprojectdata.dbo.nashvilleHousing


update nashvilleHousing
set SaleDate = convert(date,saledate)

alter table nashvilleHousing
add saledateconverted date;

update nashvilleHousing
set SaleDateconverted = convert(date,saledate)

					

				-----------POPULATING PROPERTY ADDRESS DATA------------


select A.ParcelID, A.PropertyAddress, B.ParcelID,
B.PropertyAddress, ISNULL(A.propertyaddress, b.PropertyAddress)
from victorprojectdata.dbo.nashvilleHousing A
JOIN victorprojectdata.dbo.nashvilleHousing B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ]<> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL


update A
SET PropertyAddress = isNULL(A.propertyaddress, B.propertyaddress)
from victorprojectdata.dbo.nashvilleHousing A
JOIN victorprojectdata.dbo.nashvilleHousing B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ]<> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

select *
from victorprojectdata.dbo.nashvilleHousing
--where PropertyAddress is null

					-------BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMN (ADDRESS, CITY AND STATE)--------

select PropertyAddress
from victorprojectdata.dbo.nashvilleHousing

select SUBSTRING(propertyaddress,1,charindex(',', propertyaddress)-1) as address,
SUBSTRING(propertyaddress,charindex(',', propertyaddress)+1, len(propertyaddress)) as address
from victorprojectdata.dbo.nashvilleHousing

alter table nashvilleHousing
add PropertySplitAddress nvarchar (255);


update nashvilleHousing
set PropertySplitAddress = SUBSTRING(propertyaddress,1,charindex(',', propertyaddress)-1)



alter table nashvilleHousing
add PropertySplitCity nvarchar (255);

update nashvilleHousing
set PropertySplitCity = SUBSTRING(propertyaddress,charindex(',', propertyaddress)+1, len(propertyaddress))


						------OR-------

SELECT OwnerAddress
from victorprojectdata.dbo.nashvilleHousing

SELECT PARSENAME(REPLACE(OWNERADDRESS, ',', '.'),3),
PARSENAME(REPLACE(OWNERADDRESS, ',', '.'),2),
PARSENAME(REPLACE(OWNERADDRESS, ',', '.'),1)
from victorprojectdata.dbo.nashvilleHousing



alter table nashvilleHousing
add OwnerSplitAddress nvarchar (255);

update nashvilleHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OWNERADDRESS, ',', '.'),3)


alter table nashvilleHousing
add OwnerSplitCity nvarchar (255);

update nashvilleHousing
set OwnerSplitCity = PARSENAME(REPLACE(OWNERADDRESS, ',', '.'),2)


alter table nashvilleHousing
add OwnerSplitState nvarchar (255);

update nashvilleHousing
set OwnerSplitState = PARSENAME(REPLACE(OWNERADDRESS, ',', '.'),1)


				-------CHANGE Y AND N TO YES AND NO IN "SOLD AS VACANT" FIELD-----------


select distinct(SoldAsVacant), count(soldasvacant)
from victorprojectdata.dbo.nashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant,
case when SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
from victorprojectdata.dbo.nashvilleHousing

update nashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END

					-------REMOVE DUPLICATE---------

select *, ROW_NUMBER()OVER(PARTITION BY
ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
Order By UniqueID) row_num
from victorprojectdata.dbo.nashvilleHousing

				USING CTE
WITH ROWNUMCTE AS (
 select *, ROW_NUMBER()OVER(PARTITION BY
ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
Order By UniqueID) row_num
from victorprojectdata.dbo.nashvilleHousing
)
select *
FROM ROWNUMCTE
WHERE row_num > 1
order by PropertyAddress


					--------DELETE UNUSED COLUMNS-------


SELECT *
from victorprojectdata.dbo.nashvilleHousing

ALTER TABLE victorprojectdata.dbo.nashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate