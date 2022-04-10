
************************************************************
Program name: MIS480 Capstone Analysis.sas
Purpose: Import capstone analysis data and perform analysis.\
Written by: Maximilian Herlim
Class: MIS 480 - Capstone
Instructor: Dr. Justin Bateh
************************************************************;

** Import Spreadsheet **;
%web_drop_table(WORK.IMPORT);


FILENAME REFFILE '/home/u48042460/HerlimMaximilian_Mod5_Capstone_Data.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;


%web_open_table(WORK.IMPORT);

data capstone;
  set import;
  
/*   leadXP_yrs = leadxp_yrs; */
  OB_Overall_hrs = sum(OB_DBbuild_hrs,OB_reports_hrs);
  
label
Project = 'Project name'
OB_DBBuild_hrs = 'Overburns in Database Build (in hrs)'
OB_reports_hrs = 'Overburns in Reports Build (in hrs)'
OB_Overall_hrs = 'Overall overburns (in hrs)'
JRprog_pct = 'Percentage of Junior level programmers in the project'
LeadXP_yrs = 'Project Lead number of experience'
NonUSprog_pct = 'Percentage of US Based programmers in the project'
NewTools_pct = 'Percentage of Using new Tools'
Trial_type = '1-Oncology, 2-Hematology, 3-Vaccine, 4-General DX'

;
run; 

** Descriptive Analysis **;
proc univariate data=capstone;
histogram OB_Overall_hrs ob_dbbuild_hrs ob_reports_hrs jrprog_pct leadxp_yrs nonusprog_pct newtools_pct;
quit;

** Regression analysis **;
proc glm data=capstone;
title "Database Build Overburns Regression";
  model ob_dbbuild_hrs = jrprog_pct leadxp_yrs Nonusprog_pct newtools_pct;
run;

proc glm data=capstone;
title "Reports Build Overburns Regression";
  model ob_reports_hrs = jrprog_pct leadxp_yrs nonusprog_pct newtools_pct;
run;

proc glm data=capstone;
title "Overall Overburns Regression";
  model ob_overall_hrs = jrprog_pct leadxp_yrs Nonusprog_pct newtools_pct;
run;