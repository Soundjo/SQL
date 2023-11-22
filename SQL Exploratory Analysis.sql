Select *
From PortfolioProject..CovidDeaths
order by date, location asc


Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1,2;

--Death rate Cote d'Ivoire
Select location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float)*100) as DeathPercent
From PortfolioProject..CovidDeaths
Where location like '%ivoi%'
Order by 2;

--Infection rate
Select location, date, total_cases, population, ((cast(total_cases as float)/population))*100 as InfectedRate
From PortfolioProject..CovidDeaths
Where location like '%ivoi%'
Order by 2;



--countries with highest infection rate
Select location, population, Max(cast(total_cases as float)) as InfectionCount,
				Max((cast(total_cases as float)/population))*100 as InfectedRate
From PortfolioProject..CovidDeaths
Group by location, population
Order by 4 desc;

-- countries with highest death rate per population
Select location, population, Max(cast(total_deaths as float)) as TotalDeaths,
				Max((cast(total_deaths as float)/population))*100 as DeathRate
From PortfolioProject..CovidDeaths
Group by location, population
Order by 4 desc;

--countries with highest deaths count

Select location, population, Max(cast(total_deaths as float)) as TotalDeaths
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location, population
Order by TotalDeaths desc;

--continent 
Select location, Max(cast(total_deaths as float)) as TotalDeaths
From PortfolioProject..CovidDeaths
Where continent is null
Group by location
Order by TotalDeaths desc;

Select location, Max(cast(total_deaths as float)) as TotalDeaths,
				Max((cast(total_deaths as float)/population))*100 as DeathRate
From PortfolioProject..CovidDeaths
where continent is null
	and location not like '%income'
Group by location
Order by DeathRate desc;


--global numbers
Select date, SUM(new_cases) as NewCases, SUM(new_deaths) as NewDeaths
				,SUM(new_deaths)/SUM(new_cases)*100 as DeathRate
From PortfolioProject..CovidDeaths
Where continent is not null 
Group by date
Having SUM(new_cases) <> 0
Order by 1 asc;

Select SUM(new_cases) as NewCases, SUM(new_deaths) as NewDeaths
				,SUM(new_deaths)/SUM(new_cases)*100 as DeathRate
From PortfolioProject..CovidDeaths
Where continent is not null 
Having SUM(new_cases) <> 0
Order by 1 asc;

--total population vs vaccinations
Select d.continent, d.location, d.date, d.population, v.new_vaccinations
		, SUM(cast(v.new_vaccinations as bigint)) 
				OVER (Partition by d.location order by d.location, d.date) as RollingVaccCount
		, (RollingVaccCount/population)*100
From PortfolioProject..CovidDeaths d
	Join PortfolioProject..CovidVacc v 
		on d.location=v.location
			and d.date=v.date
Where d.continent is not null
Order by 2,3;

With PopvsVacc (continent, location, date, population, New_vaccinations, RollingVaccCount)
as (
Select d.continent, d.location, d.date, d.population, v.new_vaccinations
		, SUM(cast(v.new_vaccinations as bigint)) 
				OVER (Partition by d.location order by d.location, d.date) as RollingVaccCount
		--, (RollingVaccCount/population)*100
From PortfolioProject..CovidDeaths d
	Join PortfolioProject..CovidVacc v 
		on d.location=v.location
			and d.date=v.date
Where d.continent is not null
)
select *, (RollingVaccCount/population)*100
From PopvsVacc
Order by 2,3



--temp table
Drop table if exists PercentPopVax
Create table PercentPopVax
(
continent nvarchar(255),
location nvarchar(255),
Date datetime, 
population numeric,
new_vacc numeric,
RollingVaccCount numeric
)

insert into PercentPopVax
Select d.continent, d.location, d.date, d.population, v.new_vaccinations
		, SUM(cast(v.new_vaccinations as bigint)) 
				OVER (Partition by d.location order by d.location, d.date) as RollingVaccCount
		--, (RollingVaccCount/population)*100
From PortfolioProject..CovidDeaths d
	Join PortfolioProject..CovidVacc v 
		on d.location=v.location
			and d.date=v.date
Where d.continent is not null

select *, (RollingVaccCount/population)*100
From PercentPopVax


--creating view 

Use PortfolioProject
Go
Create View PercentPopVax as
Select d.continent, d.location, d.date, d.population, v.new_vaccinations
		, SUM(cast(v.new_vaccinations as bigint)) 
				OVER (Partition by d.location order by d.location, d.date) as RollingVaccCount
		--, (RollingVaccCount/population)*100
From PortfolioProject..CovidDeaths d
	Join PortfolioProject..CovidVacc v 
		on d.location=v.location
			and d.date=v.date
Where d.continent is not null


