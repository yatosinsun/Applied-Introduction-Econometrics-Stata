/* BASIC ECONOMETRIC ANALYSIS */

/* Yasin Tosun / Siegen University */
/* Genç Ekonomistler Kulübü - 2023 */
/* ECONMATIC - Stage : 1 - Introduction to Econometrics */
 
/* For data, transfer the "Workshop - 1.xlsx" file to the Data Editor. */
 
/* 
time = 1988-2020
gdp = Gross Domestic Product (%)
c = Consumption (%)
fdi = Foreign Direct Investment, Net Inflow (%)
e = Government Expenditure (%)
ex = Export (%)
im = Import (%)
*/

/* Define Time and Series */

/* Yearly */
tsset time id

/* Monthly */
generate time = tm(2000m1) + _n-1 
list time in 1 
format %tm time 
list time in 1 
tsset time

/* Naming Variables */
rename gdp GDP
rename c C
rename fdi FDI 
rename e GOV
rename ex EX
rename im IM

/* Series Graphs of Variables */
twoway (tsline GDP)
twoway (tsline C)
twoway (tsline FDI)
twoway (tsline GOV)
twoway (tsline EX)
twoway (tsline IM)
/* To save the graphics, click on the "Save" button at the top left of the screen and save it to the location where you want to save it; Select and save in PNG format.
These are the level values of your series. */

/* Calculation of Correlation and Covariance Values */
 correlate GDP C FDI GOV EX IM, noformat /* Correlation */
 
 correlate GDP C FDI GOV EX IM, covariance /* Covariance */
 
 /* Data Graphs: Histogram and Box Plot */ 
histogram GDP
histogram C
histogram FDI
histogram GOV
histogram EX
histogram IM

graph box GDP C FDI GOV EX IM
 
/* Summary Statistics */
summarize GDP C FDI GOV EX IM, detail
sktest GDP C FDI GOV EX IM
summarize GDP C FDI GOV EX IM, detail
/* Two components of the test are required. Pr(Skewness) and Pr(Kurtosis) values should be added to the summary statistics above in the table. */

/* Creating a New Variable - ln Operation */
gen lnGDP=ln(GDP)
gen lnC=ln(C)
gen lnFDI=ln(FDI)
gen lnGOV=ln(GOV)
gen lnEX=ln(EX)
gen lnIM=ln(IM)


/* Series Graphs of Variables */
twoway (tsline lnGDP)
twoway (tsline lnC)
twoway (tsline lnFDI)
twoway (tsline lnGOV)
twoway (tsline lnEX)
twoway (tsline lnIM)
/* To save the graphics, click on the "Save" button at the top left of the screen and save it to the location where you want to save it; Select and save in PNG format.
These are the level values of your series. */ 

/* Creating a New Variable - Difference Operation */
gen dGDP=d.GDP
gen dC=d.C
gen dFDI=d.FDI
gen dGOV=d.GOV
gen dEX=d.EX
gen dIM=d.IM


/* Creating a New Variable - 2nd Difference Operation */
gen ddGDP=d.dGDP
gen ddC=d.dC
gen ddFDI=d.dFDI
gen ddGOV=d.dGOV
gen ddEX=d.dEX
gen ddIM=d.dIM

/* Creating a New Variable - Process of creating the 1st lag of the Ln series */
gen GDPL=L.lnGDP
gen CL=L.lnC
gen FDIL=L.lnFDI
gen GOVL=L.lnGOV
gen EXL=L.lnEX
gen IML=L.lnIM

/* Creating a New Variable - Process of creating the 2nd lag of the Ln series */
gen GDPLL=L.GDPL
gen CLL=L.CL
gen FDILL=L.FDIL
gen GOVLL=L.GOVL
gen EXLL=L.EXL
gen IMLL=L.IML


/* Creating a New Variable - Taking the lag of the Differentiated Series */
gen dGDPL=L.dGDP
gen dCL=L.dC
gen dFDIL=L.dFDI
gen dGOVL=L.dGOV
gen dEXL=L.dEX
gen dIML=L.dIM

/* Creating a New Variable - Taking the lag of the 2nd Differentiated Series */
gen ddGDPL=L.ddGDP
gen ddCL=L.ddC
gen ddFDIL=L.ddFDI
gen ddGOVL=L.ddGOV
gen ddEXL=L.ddEX
gen ddIML=L.ddIM

/* If you are using data that contains seasonal effects, you need to create a new series with a logic such as delay and eliminate seasonal effects. */
gen SGDP=S.GDP
gen SC=S.C
gen SFDI=S.FDI
gen SGOV=S.GOV
gen SEX=S.EX
gen SIM=S.IM
/* seasonal difference y(t)-y(t-s), where s is the seasonal frequency (e.g., s=4 for quarterly) */


/* OLS Model */
regress GDP C FDI GOV EX IM  

/* dEC= 0.5955709 + 0.0124384*dCRD + 0.0124384*dSM + 0.0124384*dINT + 0.234589*dMRKT + u */
/* u=0.77757 */

/* Example of Two Side Hypothesis */
/* Ho:B1=0 V Ha: B1#0 */ 
/* Ho:B2=0 V Ha: B2#0  */ 

/* OLS Description */

/* Forecast results can be considered in 3 parts. 
In the first part, the results of the change in regression and the results of total change are included. 
The sum of the squares (SS) and the squares averages (SS / df) is 1,796. 

 In the second part, the number of observations used in the estimation is 83 and the calculated value of the F statistic is 0,33. 
Rejection of the hypothesis tested in the F test is 0.5611 
The standard error of the regression is  2.3281 

In the third part, inflation dependent variable, while interest rates are independent. 
There is a positive relationship between inflation and interest rates. 
If the interest rates increase by 1%, the inflation rate will increase by 0.07%. 
Interest rates; in this regression, it is possible to explain the increase in inflation rates by about %0.004. 
However, the interest rate and the constant value of the fixed variable t is higher than the table value is meaningless. 
It is also meaningless because the p value is greater than the alpha value. 
Therefore, hypotheses are unrejected.  */

/*  Calculation of errors in summary */
 
/*  => reg y x1 x2 */
quietly reg GDP C FDI GOV EX IM

/* xb => predict yhat, xb */
predict GDPhat, xb

/* predict resid, residual => predict resid, residual */
predict resid, residual

/*  => gen kalıntı=y-yhat */
gen kalıntı=GDP-GDPhat

/*  => twoway (scatter yhat y) */
twoway (scatter GDPhat GDP)

/*  => twoway (tsline yhat y) */
twoway (tsline GDPhat GDP)

/* COEFFICIENTS VARIANCE-COVARIANCE MATRIX ESTIMATION */
 estat vce

 
/* GRAPH ON THE DISTRIBUTION OF ERROR TERMS */
histogram resid, normal

kdensity resid, normal


/* GRAPH FOR CONSTANT VARIANCE ASSUMPTION */
  rvfplot, recast(scatter) yline(0)

 
/* TEST PACKAGES - IN SUMMARY */
quietly reg GDP C FDI GOV EX IM

/* Autocorrelation / Heteroscedasticity / Ramsey and VIF Test */

estat bgodfrey
/* Breusch-Godfrey LM test for autocorrelation */

quietly reg GDP C FDI GOV EX IM
estat durbinalt
/* Durbin's alternative test */
/* Ho: no serial correlation V ha: serial correlation */

quietly reg GDP C FDI GOV EX IM
estat dwatson
/* Durbin-Watson d-statistic */
/* Ho: no serial correlation V ha: serial correlation */

/* Heteroscedasticity */

estat hettest
/* Breusch-Pagan / Cook-Weisberg test for heteroskedasticity */
/* Ho: Constant variance  H1: No Constant Variance */

estat imtest, white
/* White's test for Ho: homoskedasticity */


/* Ramsey RESET Test | Defining Functional Form */

estat ovtest
/* Ramsey RESET test using powers of the independent variables */
/* Ho: model has no omitted variables   H1: model has omitted variables  */

/* Multiple Linear Connection | VIF Test */

estat vif
/* Variance Inflation Factors Test */


/* Test Considering Autocorrelation and Heteroscedasticity | Newey West */

newey GDP C FDI GOV EX IM, lag(lagnumbers)
/* Regression with Newey-West std.errors. */

/* Depending on the test results, you can re-analyze it by using appropriate variable forms or excluding it from the analysis. */

/* If you want to extract variables, you can use the code examples below. */
drop GDPhat
drop resid

/* Now start again. */
