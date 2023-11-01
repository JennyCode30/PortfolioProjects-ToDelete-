SELECT *
FROM CovidDeaths

--Looking at Total Cases vs Total Deaths
--Show likelihood of dying if you contract covid in your country

SELECT location, date, total_cases, total_deaths, 
CONCAT(
CONVERT(float,total_deaths)/NULLIF(CONVERT(float,total_cases),0)*100
,'%') AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location = 'United Kingdom'
ORDER BY 2 DESC


-- Looking at Total Cases vs Total Population
SELECT location, date, total_cases, population, 
CONCAT(
CONVERT(float,total_cases)/NULLIF(CONVERT(float,population),0)*100
,'%') AS CasesPercentage
FROM PortfolioProject..CovidDeaths
WHERE location = 'United Kingdom'
ORDER BY 2 DESC


-- Looking at countries with highest infection rate compare to population

SELECT location, population, MAX(total_cases) as HighestInfectionCount,
MAX(CONCAT(
CONVERT(float,total_cases)/NULLIF(CONVERT(float,population),0)*100
,'%')) AS PercentPopulatinInfected
FROM PortfolioProject..CovidDeaths
GROUP BY location, population  --------- GROUP BY often used with COUNT(),MAX(),MIN(),AVG(),SUM()
ORDER BY 4 DESC

----Showing countris with highest death count per population 

SELECT location, MAX(CAST(total_deaths as int)) as HighestDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL  ---Error from the excel as continent is NULL and location is ASIA
GROUP BY location
ORDER BY 2 DESC

---- LET'S BREAKING OUT BY CONTINENT
SELECT continent, MAX(CAST(total_deaths as int)) as HighestDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 2 DESC

------Showing continent with the highest death count per population 
SELECT continent, MAX(total_deaths) as HighestDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
  
----GLOBAL NUMBERS
SELECT date, SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths, 
	SUM(cast(new_deaths as int))/SUM(NULLIF(cast(new_cases as int),0))*100 as DeathPercentage

FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1 desc

-------GLOBAL NUMBERS
SELECT SUM(new_cases) as totalcases, SUM(cast(new_deaths as int)) as TotalDeaths,
SUM(new_deaths)/SUM(new_cases) AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 2 DESC


------LOOKING AT TOTAL POPULATION VS TOTAL VACCINATIONS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location,
	   dea.date) as RollingPeopleVaccinated -----类加
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 1,2

--------USE CTE


