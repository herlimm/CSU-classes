
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
  
  leadXP_yrs = leadxp_yrs*-1;
  
label
Project = 'Project name'
OB_DBBuild_hrs = 'Overburns in Database Build (in hrs)'
OB_reports_hrs = 'Overburns in Reports Build (in hrs)'
JRprog_pct = 'Percentage of Junior level programmers in the project'
LeadXP_yrs = 'Project Lead number of experience'
NonUSprog_pct = 'Percentage of US Based programmers in the project'
NewTools_pct = 'Percentage of Using new Tools'
Trial_type = '1-Oncology, 2-Hematology, 3-Vaccine, 4-General DX'
/* Oncology_YN = 'Oncology Project' */
/* Hematology_YN = 'Hematology Project' */
/* Vaccine_YN = 'Vaccine Project' */
/* GeneralDX_YN = 'General Disease Project' */
;
run; 

proc univariate data=capstone;
histogram ob_dbbuild_hrs ob_reports_hrs jrprog_pct leadxp_yrs usprog_pct newtools_pct;
quit;

proc sgplot data=capstone;
vbar Trial_type;
quit;

proc glm data=capstone;

  model ob_dbbuild_hrs = jrprog_pct leadxp_yrs Nonusprog_pct newtools_pct;
run;

proc glm data=capstone;
  model ob_reports_hrs = jrprog_pct leadxp_yrs nonusprog_pct newtools_pct;
run;