select * from data_cleaning..NashvilleHousing 

--standardizing the date format

update NashvilleHousing
set SaleDate = convert(date,SaleDate)

select SaleDate
from data_cleaning..NashvilleHousing 



--populating property address date

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From data_cleaning..NashvilleHousing a
JOIN data_cleaning..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From data_cleaning..NashvilleHousing a
JOIN data_cleaning..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

select PropertyAddress
from data_cleaning..NashvilleHousing 




--removing duplicate values

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From data_cleaning..NashvilleHousing
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

Select *
From data_cleaning..NashvilleHousing



--breaking out address in individual columns (address,city,state)

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From data_cleaning..NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From data_cleaning..NashvilleHousing



-- deleting unused columns


ALTER TABLE data_cleaning..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

Select *
From data_cleaning..NashvilleHousing