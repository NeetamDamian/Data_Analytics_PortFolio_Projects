Select * 
From SQLtutorial3_Data_Cleaning..Nashville_Housing

--Data Cleaning in SQL 
-- 1. Standardize Date format in SaleDate column

SELECT SaleDate
FROM SQLtutorial3_Data_Cleaning..Nashville_Housing

ALTER TABLE Nashville_Housing
ADD CorrectDate Date

UPDATE Nashville_Housing
SET CorrectDate = CONVERT(date,SaleDate)

-- So the new Date will be CorrectDate and we'll drop SaleDate

--2. Populate Property Address Data
SELECT *
From SQLtutorial3_Data_Cleaning..Nashville_Housing
--Where PropertyAddress is null
order by ParcelID


SELECT a.ParcelID, b.PropertyAddress, a.PropertyAddress, b.ParcelID, ISNULL(a.PropertyAddress, b.PropertyAddress)
From SQLtutorial3_Data_Cleaning..Nashville_Housing a 
join SQLtutorial3_Data_Cleaning..Nashville_Housing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From SQLtutorial3_Data_Cleaning..Nashville_Housing a 
join SQLtutorial3_Data_Cleaning..Nashville_Housing b
	on a.ParcelID = b.ParcelID
where a.PropertyAddress is null
	and a.[UniqueID ] <> b.[UniqueID ]



--3. Breaking PropertyAddress into Address, City , State

SELECT PropertyAddress
FROM SQLtutorial3_Data_Cleaning..Nashville_Housing

--- we try to use substring to seperate the propertyAddress with comma as a delimiter

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as SplitAddress,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, Len(PropertyAddress)) as SplitCity
FROM SQLtutorial3_Data_Cleaning..Nashville_Housing

-- altering and updating the table to add the splitAddress column and the splitCity

ALTER TABLE Nashville_Housing
ADD SplitCity nvarchar(255);

ALTER TABLE Nashville_Housing
ADD SplitAddress nvarchar(255);

UPDATE Nashville_Housing
SET SplitCity = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) 

UPDATE Nashville_Housing
SET SplitAddress = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, Len(PropertyAddress)) 

--Viewing if it has been updated

Select * 
From SQLtutorial3_Data_Cleaning..Nashville_Housing

--3b. Breaking OwnerAddress into Address, City , State

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM SQLtutorial3_Data_Cleaning..Nashville_Housing

ALTER TABLE Nashville_Housing 
ADD OwnerSplitAddress nvarchar(255)

ALTER TABLE Nashville_Housing 
ADD OwnerSplitCity nvarchar(255)

ALTER TABLE Nashville_Housing 
ADD OwnerSplitState nvarchar(255)

UPDATE Nashville_Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

UPDATE Nashville_Housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

UPDATE Nashville_Housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


-- Viewing the table to see if the table has been updated
SELECT *
FROM SQLtutorial3_Data_Cleaning..Nashville_Housing

-- 4. Change the Y and N to Yess and No in the SoldAsVacant column
SELECT SoldAsVacant, count(*)
FROM SQLtutorial3_Data_Cleaning..Nashville_Housing
group by SoldAsVacant
order by 2

-- Making a case Statement to convert the Y to Yes and N to No
SELECT 
CASE 
	When SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	Else  SoldAsVacant
	End
FROM SQLtutorial3_Data_Cleaning..Nashville_Housing

-- updating the table

UPDATE Nashville_Housing
SET SoldAsVacant = CASE 
	When SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	Else  SoldAsVacant
	End

