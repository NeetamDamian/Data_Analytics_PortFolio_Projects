SELECT *
FROM PortfolioProject..CovidDeaths
order by 3,4

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--order by 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
order by 1,2

-- looking at Total cases vs Total deaths

SELECT location, date, total_cases, total_deaths,(total_deaths / total_cases) *100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
order by 1,2

-- Looking at the total cases vs the Population
SELECT location, date, population, total_cases, (total_cases / Population) *100 as CovidPopPercentage
FROM PortfolioProject..CovidDeaths
order by 1,2

--Looking at countries with highest infection rate compiled to the population
SELECT location,population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases / Population)) *100 as CovidPopPercentage
FROM PortfolioProject..CovidDeaths
Group by location, population
order by CovidPopPercentage desc

--Checking for the Countries with highest Death Coutn
SELECT location, MAX(CAST(total_deaths as int)) as HighestDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null   
Group by location
order by HighestDeathCount desc

SELECT continent, MAX(CAST(total_deaths as int)) as HighestDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null   
Group by continent
order by HighestDeathCount desc


--GLOBAL FIGURES
SELECT date, SUM(new_cases) as totalCases, SUM(CAST(new_deaths as int )) as TotalDeaths, SUM(CAST(New_deaths as int )) / SUM(New_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
Group by date
order by 1,2


--JOINING THE VACCINATION TABLE WITH THE DEATH TABLE 
SELECT *
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	AND dea.date = vac.date

-- COMPARING THE POPULATION TO VACCINATION
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (partition by dea.location Order by dea.location, dea.date) as PeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
order by 2,3






-- CTE
with PopvsVac(continent,location, date, population, new_vaccinations, PeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (partition by dea.location Order by dea.location, dea.date) as PeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3

)
Select *, (PeopleVaccinated / population) * 100
From PopvsVac

CREATE View PercentVaccinatedPopulation as 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (partition by dea.location Order by dea.location, dea.date) as PeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3

Select * 
FROM PercentVaccinatedPopulation