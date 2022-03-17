SELECT * 
From CovidDeaths
order by 3,4;


-- SELECT * 
-- From CovidVaccinations
-- order by 3,4; 

SELECT Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
order by 1,2;


-- Total cases vs Total deaths
-- Showing the likelihood of dying if you contract covid in your country 

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathsPercentage
From CovidDeaths
Where location like '%states%'
order by 1,2;

-- Total cases vs Population
-- Shows what percentage of the population were infected with covid 
SELECT Location, date, population, total_cases, (total_cases/population)*100 as InfectedPercentage
From CovidDeaths
Where location like '%states%'
order by 1,2;

-- Looking at countries with highest infection rate compared to population
SELECT Location,population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
-- Where location like '%states%'
Group by Location, Population
order by HighestInfectionCount desc;

-- Showing countries with highest deat count per population
SELECT Location, MAX(cast(total_deaths AS SIGNED)) as TotalDeathCount
From CovidDeaths
-- Where location like '%states%'
WHERE continent is not null AND location !='High income' 
AND location !='Europe' AND Location!='North America' AND Location!='South America' 
AND Location!='European Union' AND Location!='Low income'
GROUP BY Location
order by TotalDeathCount desc;

-- Highest death count by continent

SELECT continent, MAX(cast(total_deaths AS SIGNED)) as TotalDeathCount
From CovidDeaths
-- Where location like '%states%'
WHERE continent is not null
Group by continent
order by TotalDeathCount desc;

-- GLOBAL NUMBERS

SELECT date, SUM(new_cases), SUM(new_deaths), SUM(new_deaths)/SUM(new_cases)*100 AS DeathPErcentage -- total_deaths, (total_deaths/total_cases)*100 as DeathsPercentage
From CovidDeaths
Where continent is not null
Group by date
Order by 1,2;


-- Total population vs Vaccination 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(vac.new_vaccinations) OVER (Partition by  dea.location Order by dea.location, dea.date) 
AS RollingPeopleVaccinated-- , (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
    and dea.date = vac.date
Where dea.continent is not null AND dea.location !='High income' 
AND dea.location !='Europe' AND dea.location!='North America' AND dea.location!='South America' 
AND dea.location!='European Union' AND dea.location!='Oceania'
AND dea.location!='Low income' AND dea.location!='Africa' AND dea.location!='International'
Order by 2,3;


-- CTE
With PopvsVac (Continent, Location, Date, Population, NEw_Vaccinations,RollingPeopleVaccinated)
As
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(vac.new_vaccinations) OVER (Partition by  dea.location Order by dea.location, dea.date) 
AS RollingPeopleVaccinated-- , (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
    and dea.date = vac.date
Where dea.continent is not null AND dea.location !='High income' 
AND dea.location !='Europe' AND dea.location!='North America' AND dea.location!='South America' 
AND dea.location!='European Union' AND dea.location!='Oceania'
AND dea.location!='Low income' AND dea.location!='Africa' AND dea.location!='International'
Order by 2,3)
Select *,(RollingPeopleVaccinated/population)*100
From PopvsVac;



-- TEMP TABLE
CREATE TABLE PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPoepleVaccinated numeric
);

Insert into PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(vac.new_vaccinations) OVER (Partition by  dea.location Order by dea.location, dea.date) 
AS RollingPeopleVaccinated-- , (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
    and dea.date = vac.date
Where dea.continent is not null AND dea.location !='High income' 
AND dea.location !='Europe' AND dea.location!='North America' AND dea.location!='South America' 
AND dea.location!='European Union' AND dea.location!='Oceania'
AND dea.location!='Low income' AND dea.location!='Africa' AND dea.location!='International';
 

Select *,(RollingPeopleVaccinated/Population)*100
From PopvsVac PercentPopulationVaccinated;


-- Creating view for visualizations

Create View PercentPopulationVaccinated as  
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(vac.new_vaccinations) OVER (Partition by  dea.location Order by dea.location, dea.date) 
AS RollingPeopleVaccinated-- , (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
    and dea.date = vac.date
Where dea.continent is not null AND dea.location !='High income' 
AND dea.location !='Europe' AND dea.location!='North America' AND dea.location!='South America' 
AND dea.location!='European Union' AND dea.location!='Oceania'
AND dea.location!='Low income' AND dea.location!='Africa' AND dea.location!='International'
 


