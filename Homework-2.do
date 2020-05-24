* HOMEWORK 2 
* QUESTION 1 
* i first created an ajusted version of the dataset containing only the first observations of the fifteen individuals
clear
import excel "/Users/macbookpro/Desktop/STATA LEARNING EXPERIENCES. /homework 2/KT adjusted .xlsx", sheet("Sheet1") firstrow 



*creating the list of variables x 1 is individual traits and x2 is family traits, only x1 must include a constant
global x1 EDUC POTEXPER ABILITY
global x2 MOTHERED FATHERED SIBLINGS
global y LOGWAGE

* question 1a
regress $y $x1

*question 1b
regress $y $x2
regress $y $x1 $x2

*question 1c, finding the r-squared manually 
global x22 MOTHERED FATHERED SIBLINGS
regress $y $x1 $x2

*question 1d
global x1 EDUC POTEXPER ABILITY
global x2 MOTHERED FATHERED SIBLINGS
global y LOGWAGE
regress $y $x1 $x2

*question 1e
*checking for the mr1 assumption, the linearity of the relatonship b/n the explanatory and response variables
* for part a, checking the outcome variable against the estimated outcome 
global x1 EDUC POTEXPER ABILITY
global x2 MOTHERED FATHERED SIBLINGS, noconstant
global y LOGWAGE
regress $y $x1
predict yhat, xb
graph twoway (scatter yhat LOGWAGE) (lfit yhat LOGWAGE)
* for part b
global x1 EDUC POTEXPER ABILITY
global x2 MOTHERED FATHERED SIBLINGS, noconstant
global y LOGWAGE
regress $y $x1 $x2
predict y_hat,xb
graph twoway (scatter y_hat LOGWAGE) (lfit yhat LOGWAGE)

* checking for the mr2 assumtion violation, where average error is not 0 (aka heteroskedasicity or the errors do not have constant variance)
* for part a 
global x1 EDUC POTEXPER ABILITY
global x2 MOTHERED FATHERED SIBLINGS, noconstant
global y LOGWAGE
regress $y $x1
predict r,resid
scatter r EDUC

* for part b
global x1 EDUC POTEXPER ABILITY
global x2 MOTHERED FATHERED SIBLINGS, noconstant
global y LOGWAGE
regress $y $x1 $x2
predict r1,resid
scatter r1 FATHERED

* checking for the mr5 assumption violation, where the regressors are not linear functions of eachother (aka multicollinearity)
*for part a
global x1 EDUC POTEXPER ABILITY
global x2 MOTHERED FATHERED SIBLINGS, noconstant
global y LOGWAGE
regress $y $x1
vif 

* for part b 
global x1 EDUC POTEXPER ABILITY
global x2 MOTHERED FATHERED SIBLINGS
global y LOGWAGE
regress $y $x1 $x2
vif

* checking for the mr6 (the normal distribution of error assumption)
* for part a 
kdensity r

* for part b 
kdensity r1


*QUESTION 2 
clear 
 import delimited "/Users/macbookpro/Desktop/STATA LEARNING EXPERIENCES. /homework 2/TableF2-2.csv", 


* 2a 
gen per_capita = gasexp/(gasp*pop)
regress per_capita income gasp pnc puc ppt pd pn ps year
vif

*2b, testing the hypothesis that the changes in the prices of used and new cars do not affect people’s decisions to purchase gas.
regress per_capita income gasp pnc puc ppt pd pn ps year
test pnc == puc

*2c
* price elasticity of demand without using log apparently , just using the margins, eyex
* price elasticity of demand
regress per_capita gasp 
margins if year == 2004,  eyex (gasp)

* price elasticity of income 
regress per_capita income
margins if year == 2004, eyex (income)

* cross price elasticity with the cross-price elasticity with respect to changes in the price of public transportation (aka the gasp with the ppt)
regress gasp ppt 
margins if year == 2004, eyex (ppt)

* 2d elasticity of the entire regression using log
gen log_percapita = log(per_capita)
gen log_gasp = log(gasp)
gen log_ppt = log(ppt)
gen log_income = log(income)
gen log_pnc = log(pnc)
gen log_puc = log(puc)
gen log_pd = log(pd)
gen log_pn = log(pn)
gen log_ps = log(ps)

regress log_percapita log_gasp log_income log_ppt log_pnc log_puc log_pd log_pn log_ps year
vif 
* additional work 
* price elasticity of demand using logarithms 
gen log_percapita = log(per_capita)
gen log_gasp = log(gasp)
regress log_percapita log_gasp 


* price elasticity of income
gen log_income = log(income)
regress log_percapita log_income 


* cross price elasticity of ...
gen log_ppt = log(ppt)
regress log_gasp log_ppt


* 2e, simple correlation of the price variables to check for multicollinearity 
pwcorr( gasp pnc puc ppt pd pn ps)

*2f, changed all the price index value of 2004 to 100 (aka renormalized the price indexes to that year), and then rerun the regressions a and d 
regress per_capita income gasp pnc puc ppt pd pn ps year
regress log_percapita log_gasp log_income log_ppt log_pnc log_puc log_pd log_pn log_ps year
