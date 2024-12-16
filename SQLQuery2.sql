create view percentagePopulationvaccinated 
 as select d.continent, d.location, d.date, d.population, v.new_vaccinations,
sum(convert(int, v.new_vaccinations )) over (partition by d.location, d.date) as RolllingPeopleVaccinated
from PortfolioProject_1..CovidDeaths d  join PortfolioProject_1..CovidVaccinations v on d.location = v.location and d.date = v.date 
where d.continent is not null
--order by 2,3 

select *
from percentagePopulationvaccinated