*class one:  in-class demonstration do-file

/*  THIS IS A DO-FILE! 
Do-files are text files that contain your commands
*/

*There are 3 ways to make comments in your do-files (comments are green)

*start of a line
// at the start or in the middle of a line
/* more than one line */

/*Comments are critical for reminded you about decisions you have made 
and what you have done; 
They are also useful for organizing your do-file and making them easy to read */


*Use comments as dividers:
*------------------------*
****************
*~~~~~~~~*


*~~~~~~~~*
***Example of components that belong in a Do-file:
*~~~~~~~~*

//Close any log that is open:
capture log close

//Set working directory (note: this can easily cause errors if you change machinges):
cd "F:\EHS data analysis" //for a PC
cd "/Volumes/Padlock--in use/Julie_from 0-drive/Classes/EHS data analysis 2014/Class Sessions/Class 1_0123_Overview" //for a MAC

//Open your log file :  
log using logname, replace text

//Comments about what the do-file does:  
// Homework 1
* Homework 1

//Controlling how STATA runs:
version 13 
clear all
set linesize 80

//Your commands (and comments throughout)

//Close log:
log close

//End the file (if you don’t [return] after close log, it won’t close):
exit 
*Note:  final command could be anything



*~~~~~~~~*
***Example of some commands you might find useful for lab #1:
*~~~~~~~~*
*open data file:  "NYCHanes_subset.dta"
use "NYCHANES_subset for HW#1_2016.dta"

*put your variables in alphabetical order
aorder   

*sets the order of your variables as you specify
order SP_ID race_eth riaageyr riagendr TCQ015 SMQ040 DIQ010 IMQ040
 
*count the number of observations:
tab race_eth
tab race_eth, missing



*~~~~~~~~*
***Start the HW!***
***Note:  you don't have this. . .but your homework will be to recreate it!
***Make sure to save your do-file and please include your name in the filename!
*~~~~~~~~*

use "NYCHANES_subset for HW#1_2016.dta", clear
//Before you begin:  look at the data
describe

//Rename (if necessary) and label all your variables in your dataset
label variable SP_ID "id"

rename OCQ280 hlthins
label variable hlthins "Health insurance offered at main job"

rename WHQ070 losewt
label variable losewt "Tried to lose wt in past year"

rename TCQ015 cellph
label variable cellph "Have a cell phone"

rename SMQ040 sm_curr
label variable sm_curr "Do you now smoke cigarettes"

rename DIQ010 diabetes
label variable diabetes "Ever told you have diabetes"

rename IMQ040 flusht
label variable flusht "Had flu shot past 12 months"

rename race_eth race
label variable race "Race/Ethnicity"

rename riaageyr age
label variable age "Age (yrs)"

rename riagendr gender
label variable gender "Gender"

describe

//In this dataset, there are only a few variables; to find them easily:
aorder //will put all the variables in alphabetical order (easier to search:  look at varlist and data browser)


//Questions to Answer:
*Q1. What proportion of the sample is Hispanic?
codebook race
*need to know what 1 means, 2 means, etc. . .look in data codebook!  
label define labrace 1 "NH White" 2 "NH Black" 3 "NH Asian" 4 "Hispanic" 5 "NH Other" //define labels
codebook race  // 1, 2, 3, etc. still not labeled
label values race labrace //assign labels called 'labrace' to variable called 'race_eth'
codebook race
tab race, missing //note:  4 people with missing race

*(Note:  if you make a mistake labeling a variable:  label drop labrace)

*ANSWER:  

*~~~~~~~~~*

*Q2.  What is the average age of the Non-Hispanic Asians?
*commands:  sum or means will give you averages
sum age if race==3
means age if race==3
//or
sort race //look at data browser for effects of sort
by race:  sum age  //summarize by strata

*ANSWER: 

****************
*******Additional info (FYI):
//If "race_eth" is a categorical variable, you might wonder why we use numbers
codebook race
tostring race, generate (race_str)

codebook race_str
label variable race_str "race, as a string"
replace race_str = "NH White" if race_str=="1"
replace race_str = "NH Black" if race_str=="2"
replace race_str = "NH Asian" if race_str=="3"
replace race_str = "Hispanic" if race_str=="4"
replace race_str = "NH Other" if race_str=="5"
codebook race_str

**revisit Q2.  What is the average age of the Non-Hispanic Asians?
sort race_str
by race_str:  summ age
//or
summ age if race_str=="NH Asian" //watch for typos, spaces, etc.

*more of a problem if you want to create categories:
*Example: What proportion of participants are NOT hispanic?

*using the numeric:
gen race_NH = . 
label variable race_NH "Non-Hispanic"
replace race_NH = 0 if race==4
replace race_NH = 1 if race < 4 | race > 4 & race~=.
label define labracenh 0 "Hispanic" 1 "Non-Hispanic"
label values race_NH labracenh
tab race_NH, missing

*using the string:
gen race_NHs = .
label variable race_NHs "Non-Hispanic, string"
replace race_NHs = 0 if race_str=="Hispanic"
replace race_NHs = 1 if race_str=="NH White" 
replace race_NHs = 1 if race_str=="NH Black" 
replace race_NHs = 1 if race_str== "NH Asian" 
replace race_NHs = 1 if race_str== "NH Other" 
label values race_NHs labracenh
tab race_NHs, missing
****************
*~~~~~~~~~*

*Q3. What proportion of participants are 55 or younger?
tab age
//or
gen age55 = .
replace age55 = 0 if age <=55 
replace age55 = 1 if age >55
label define lab55 0 "less than 55" 1 "older than 55"
label values age55 lab55
tab age55

*ANSWER: 

*~~~~~~~~~*

*Q4. What proportion (%) of participants older than 55 have cell phones?
label define labyn 1 "yes" 2 "no"
label values cellph labyn

/*We have the variable for age55 from Q3:
gen age55 = .
replace age55 = 0 if riaageyr <=55 
replace age55 = 1 if riaageyr >55
label define lab55 0 "less than 55" 1 "older than 55"
label values age55 lab55 
*/

tab age55 cellph, row missing 
*ANSWER: 

//note: you will get the wrong answer if you don't include ", missing"
tab age55 cellph, row  //wrong answer because only those who have data for cellph are included

*~~~~~~~~~*

*Q5.  What proportion (%) of men currently smoke cigarettes every day?
label define labsm 1 "every day" 2 "some days" 3 "not at all"
label values sm_curr labsm

label define labsex 1 "Male" 2 "Female"
label values gender labsex 

tab sm_curr gender, missing row col

*ANSWER: 

*~~~~~~~~~*

