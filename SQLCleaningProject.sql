
Select *
From PortfolioProject..NashvilleHousing

Select SaleDate
From PortfolioProject..NashvilleHousing

Update PortfolioProject..NashvilleHousing
Set SaleDate=CONVERT(Date, SaleDate)

ALTER  TABLE PortfolioProject..NashvilleHousing
Add SaleDateConverted Date;

Update PortfolioProject..NashvilleHousing
Set SaleDateConverted=CONVERT(Date, SaleDate)

Select SaleDateConverted
From PortfolioProject..NashvilleHousing

--Address
Select *
From PortfolioProject..NashvilleHousing
Where PropertyAddress is null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
		, ISNULL(a.propertyaddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	on a.ParcelID=b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress  = ISNULL(a.propertyaddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	on a.ParcelID=b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--Breaking out address
Select PropertyAddress
From PortfolioProject..NashvilleHousing

Select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
From PortfolioProject..NashvilleHousing

Select SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, Len(PropertyAddress)) as Address
From PortfolioProject..NashvilleHousing

Alter table PortfolioProject..NashvilleHousing
Add PropertySplitAddress Nvarchar(255)
Update PortfolioProject..NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter table PortfolioProject..NashvilleHousing
Add PropertySplitCity Nvarchar(255)
Update PortfolioProject..NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, Len(PropertyAddress))


Select SUBSTRING(OwnerAddress, 1, CHARINDEX(',', OwnerAddress)-1) as Address
From PortfolioProject..NashvilleHousing

Select SUBSTRING(PropertyAddress, CHARINDEX(',', OwnerAddress)+1, Len(OwnerAddress)-4) as Address
From PortfolioProject..NashvilleHousing

Select SUBSTRING(PropertyAddress, CHARINDEX(',', OwnerAddress)+1, Len(OwnerAddress)-4) as Address
From PortfolioProject..NashvilleHousing

Select PARSENAME(Replace(OwnerAddress, ',', '.') ,3)
		, PARSENAME(Replace(OwnerAddress, ',', '.') ,2)
		, PARSENAME(Replace(OwnerAddress, ',', '.') ,1)
From  PortfolioProject..NashvilleHousing



Alter table PortfolioProject..NashvilleHousing
Add OwnerSplitAddress Nvarchar(255)
Update PortfolioProject..NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.') ,3)

Alter table PortfolioProject..NashvilleHousing
Add OwnerSplitCity Nvarchar(255)
Update PortfolioProject..NashvilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.') ,2)

Alter table PortfolioProject..NashvilleHousing
Add OwnerSplitState Nvarchar(255)
Update PortfolioProject..NashvilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.') ,1)


Select SoldAsVacant
		, CASE When SoldAsVacant  = 'Y' then 'Yes'
			 When SoldAsVacant  = 'N' then 'No'
			 Else SoldAsVacant
			 END
From  PortfolioProject..NashvilleHousing


Update PortfolioProject..NashvilleHousing
Set SoldAsVacant = CASE When SoldAsVacant  = 'Y' then 'Yes'
			 When SoldAsVacant  = 'N' then 'No'
			 Else SoldAsVacant
			 END

Select Distinct SoldAsVacant
From  PortfolioProject..NashvilleHousing

--Remove duplicate
WITH RowNumCTE as(
Select *, ROW_NUMBER() Over (Partition By ParcelID,
							PropertyAddress,
							SalePrice,
							SaleDate,
							LegalReference
							Order by UniqueID) row_num
From  PortfolioProject..NashvilleHousing
)
Delete
From RowNumCTE
Where Row_num > 1


--Delete Unused Cols
Alter Table PortfolioProject..NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate









