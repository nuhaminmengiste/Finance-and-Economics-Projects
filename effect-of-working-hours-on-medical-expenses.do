 * DATA EXPLORATION AND PREP
 kdensity a_uslhrs if 0 < = a_uslhrs < = 99 /// The code  kdensity moop if 0 < = a_uslhrs < = 99 gives me a weird graph b/c if we just want to see their r/ship, i can just use scatterplot 
 gen hours = log(a_uslhrs) /// logged the hours to make it a normal distribution  more than 101,000 values were missing here (check using codebook) 
 gen moop_log = log(moop) /// 29,093 missing values generated with the code above meaning they are missing values

 * REGRESSION 
 regress moop_log hours 
 egen mean_moop = mean(moop_log), by(hours) /// taking the mean of the categorical variable bins and then plotting them  see session 3.1 class notes
scatter mean_moop hours || lfit mean_moop hours

* controlling some variables and regressing it; class of worker is in the private sector and age
regress moop_log hours if a_clswkr ==1 & 20 <= a_age <= 60

*plotting residuals 
predict rs,resid
egen mean_rall = mean(rs), by(hours)
scatter mean_rall hours

* Checking for any differences between males and females
regress moop_log hours if a_clswkr ==1 & 20 <= a_age <= 60 & a_sex == 1 

 *knowing and plotting the residuals
predict r,resid
 egen mean_rmale = mean(r), by(hours)
scatter mean_rmale hours 

* same regression for females
regress moop_log hours if a_clswkr ==1 & 20 <= a_age <= 60 & a_sex == 2 
predict rf,resid

* then plotting the residuals
egen mean_residfemale = mean(rf), by(hours)
scatter mean_rfemale hours 

* HYPOTHESIS TEST
* step 1: define null and alternative hypothesis 
/// Our null is that B2 = 0 where there is no effect of hours worked on medical expenses for otc drugs and the alternative is that B2 > 0 , a one tailed positive test
* step 2: specify the test statistic and its distribution if the null hypothesis is true 
/// The t- distriubtion will have a mean of 0 and a standard error of 1. This is because the sample size is large enough for the distribution to be like the normal one.  If the null hypothesis is true, the t-value we get will be less than the critical value calculated below and the probability of getting that t-value must be more than the specified alpha below. 
/// Note: the regression gives us the t value if the true value of B2 is 0. I do not need to specify this because it calculates the t value on this assumption by default.
/// plotting the t-distribution source: https://www.psychstatistics.com/2010/11/24/stata-graphing-distributions/ 

twoway function y=normalden(x), range(-4 1.65) color(dknavy) || ///
function y=normalden(x), range(1.64 4) recast(area) color(dknavy) ///
xtitle("{it: x}") ///
ytitle("Density") title("Critical Value for T distribution with 55351 df") ///
subtitle("One-tailed test and {&alpha}=.05") ///
legend(off) xlabel(0 1.64) 

* step 3 P value approach: select alpha and determine the rejection region 
/// The alpha is 5% and the rejection region is if the p-value is under this alpha probability given the df and t value 
display ttail(55351,28.93)
/// the pvalue is 5.79e-183 which is less than alpha, so the result is signficant 

*step 3 Critical value approach: select alpha and determine the rejection region/// knowing the critical value given df and alpha
display invttail(55351,0.05) 
* critical value is 1.6448812 

* step 4; Calculate the sample value of the t statistic /// 
/// the t value from the regression is 28.93 which is greater than the critical value so it is significant 

* step 5: state your conclusion 
///the pvalue is 5.79e-183 which is less than alpha, so the result is signficant. Because the probability of getting the the t-value of 28.93 is too small to be a coincidence given that null hypothesis was true , we reject the null hypothesis.
///the t value of the sample is higher than the critical value meaning that the t distribution characteristics that would be true if the null hypothesis was true isn't true. Thus we reject, the null hypothesis. 
