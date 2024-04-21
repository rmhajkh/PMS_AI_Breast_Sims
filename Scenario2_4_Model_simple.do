* do file for simulation
* Jude Holmes 18_04_24
* Version 18.0 MP

* set up workspace, clear and drop all existing graphs
clear
graph drop _all

* set inputs
set seed 1234										// Starting seed
set obs 200											// Observations (patient #)

* generate paired data for time and outcome

// Generate a variable indicating the first, second, and third thirds
gen third = _n <= _N / 3

// Generate outcome2 with different probabilities for each third
gen outcome_encoded = runiform()
replace outcome_encoded = runiform() < 0.25 if third <= 1/3
replace outcome_encoded = runiform() < 0.35 if third > 1/3 & third <= 2/3
replace outcome_encoded = runiform() < 0.45 if third > 2/3

// Drop the intermediate variable
drop third
	
	
gen time = runiform() 							   	// this is the "time" data
sort time										   	// sort into time order

* generate plots 
set autotabgraphs on								// sets up tabs for graphs
plot outcome_encoded time 									// shows "raw" distribution of the data


*graph combine Whole_time Window_1_time

// Whole Time Graph 
cusum outcome_encoded time, generate(cs) title("Whole time") graph // generate CUSUM for the whole time "Local"
//dis `r(N)' // local variable from cs 
graph save  "C:/Users/rmhajkh/OneDrive - University College London/Documents/PhD/2023_Breast_AI/STATA_modelling/Plots/Scenario_2/Whole_time.gph", replace

//Windows

// Generate CUSUM for the specified window
cusum outcome_encoded time if time > 0.5, title("Window 0.5-1") graph 
graph save  "C:\Users\rmhajkh\OneDrive - University College London\Documents\PhD\2023_Breast_AI\STATA_modelling\Plots\Scenario_2\Window_0.5-1.gph", replace
// Generate CUSUM for the specified window
cusum outcome_encoded time if time < 0.5, title("Window 0-0.5") graph 
graph save  "C:\Users\rmhajkh\OneDrive - University College London\Documents\PhD\2023_Breast_AI\STATA_modelling\Plots\Scenario_2\Window_0-0.5.gph", replace
// Generate CUSUM for the specified window
cusum outcome_encoded time if time >=0.3 & time <= 0.7, title("Window 0.3-0.7") graph 
graph save  "C:\Users\rmhajkh\OneDrive - University College London\Documents\PhD\2023_Breast_AI\STATA_modelling\Plots\Scenario_2\Window0.3-0.7.gph", replace

// Combine graphs
cd "C:\Users\rmhajkh\OneDrive - University College London\Documents\PhD\2023_Breast_AI\STATA_modelling\Plots\Scenario_2"
graph combine Whole_time.gph Window_0.5-1.gph Window_0-0.5.gph Window0.3-0.7.gph

graph save "C:\Users\rmhajkh\OneDrive - University College London\Documents\PhD\2023_Breast_AI\STATA_modelling\Plots\Scenario_2\scenario2_4.jpg"

// 


/* Graph combine

* need to save as graph .gph format
	graph save  "$path_data/Fig_1C.gph", replace
	graph save  "$path_data/Fig_1X.gph", replace


* combine three graphs using "graph combine"
cd "$path_data/"
graph combine Fig_1C.gph Fig_1X.gph


sysuse auto, clear
gr tw (scatter mpg weight if foreign==0, name(g1, replace) nodraw)
gr tw (scatter mpg weight if foreign==1, name(g2, replace) nodraw)
graph combine g1 g2, ycommon name(combined, replace)
graph display combined, xsize(10)


#delimit ;
 twoway (scatter hpvvalue hpvvalue2 if visit_no==0 & highgrade==1, mcolor(red) msymbol(triangle)) 
(scatter hpvvalue hpvvalue2 if visit_no==0 & highgrade==0, mcolor(green))
( connected hpvvalue2 hpvvalue2 ,s(i)), 
ytitle(Self HPV (pg/ml)) yscale(log) yline(1) ysize(2) ylabel(1 10 100 1000 5000, nogrid)
xtitle(Conventional HPV (pg/ml)) xscale(log) xline(1) xsize(2) xlabel(1 10 100 1000 5000, nogrid)
legend(label(2 "women without" "high grade disease")) legend (label(1 "women with" "high grade disease"))
legend(label(3 "equal HPV values"));

global path_data "N:\_\_\ "
*/

