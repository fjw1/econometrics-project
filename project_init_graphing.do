// Preamble

clear
use /Users/l-wild/FJW/project/data/penn_na.dta, clear

egen countryid = group(countrycode), label lname(country) // for declaring panel data
tsset countryid year

keep if countrycode == "GBR"

// Plotting Data - demeaning

// Real GDP at 2011 prices (rgdpna), real consumption at 2011 prices (rconna), investment = rgdpna-rconna

gen t = _n


// GDP Deviation
gen ln_gdp = log(q_gdp)
gen ln_gdp_fd = ln_gdp - l.ln_gdp
reg ln_gdp_fd t
gen gdp_time = _b[_cons] + t*_b[t]
gen ln_gdp_dev = ln_gdp_fd - gdp_time


// Consumption Deviation
gen ln_consump = log(q_c)
gen ln_consump_fd = ln_consump - l.ln_consump
reg ln_consump_fd t
gen consump_time = _b[_cons] + t*_b[t]
gen ln_consump_dev = ln_consump_fd - consump_time



// Investment Deviation
gen ln_invest = log(q_i)
gen ln_invest_fd = ln_invest - l.ln_invest
reg ln_invest_fd t
gen invest_time = _b[_cons] + t*_b[t]
gen ln_invest_dev = ln_invest_fd - invest_time


// Deviation Plots
tsline ln_gdp_dev ln_consump_dev ln_invest_dev, ///
	graphregion(fcolor(white)) bgcolor(white)  ///
	ytitle("Log Deviation from Trend") ///
	xtitle("Time (Years)") ///
	legend(label(1 "GDP Deviations") ///
			label(2 "Consumption Deviations") ///
			label(3 "Investment Deviations"))

graph export /Users/l-wild/FJW/project/graphics/dev_time_na.pdf, replace
			

// GDP Trend
reg q_gdp t
gen gdp_bigt = _b[_cons] + t*_b[t] 
gen gdp_fd = q_gdp - l.q_gdp + gdp_bigt

// Consumption Trend
reg q_c t
gen consump_bigt = _b[_cons] + t*_b[t] 
gen consump_fd = q_c - l.q_c + consump_bigt

// Investment Trend
reg q_i t
gen invest_bigt = _b[_cons] + t*_b[t] 
gen invest_fd = q_i - l.q_i + invest_bigt


// Trend and Deviation Plots

// GDP
tsline gdp_fd gdp_bigt, ///
	graphregion(fcolor(white)) bgcolor(white)  ///
	ytitle("GDP (Millions, 2011 Dollars)") ///
	xtitle("Time (Years)") ///
	legend(label(1 "GDP Deviations") ///
			label(2 "GDP Trend")) /// 
	name(panela, replace)
	
	
// Consumption		
tsline consump_fd consump_bigt, ///
	graphregion(fcolor(white)) bgcolor(white)  ///
	ytitle("Consumption (Millions, 2011 Dollars)") ///
	xtitle("Time (Years)") ///
	legend(label(1 "Consumption Deviations") ///
			label(2 "Consumption Trend")) /// 
	name(panelb, replace)
	
	
// Investment		
tsline invest_fd invest_bigt, ///
	graphregion(fcolor(white)) bgcolor(white)  ///
	ytitle("Investment (Millions, 2011 Dollars)") ///
	xtitle("Time (Years)") ///
	legend(label(1 "Investment Deviations") ///
			label(2 "Investment Trend")) /// 
	name(panelc, replace)
			
graph combine panela panelb panelc, cols(3) altshrink commonscheme iscale(*.8) ///
	graphregion(fcolor(white) lcolor(white))

graph export /Users/l-wild/FJW/project/graphics/trend_time_na.pdf, replace
