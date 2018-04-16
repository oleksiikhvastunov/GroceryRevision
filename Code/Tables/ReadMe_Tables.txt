Tables folder contains code that produces tables 1-14 in the paper. Some of the tables are produced by matlab code, others by stata code. Some tables requires running both matlab and stata code.

The files that needs to be run in the following order:
	Table1_4.do
	Table5_7.m
	MatlabForTable8_11and14.m
	Table8_11and14.do
	Table12_13.m
	TableAppendixB1_B2.do
	TableAppendixB3_B4.m

The output (Tables 1-14 of the paper and B1-B4 of the appendix) is saved in the 
	TablesOutput
folder.

The file 
	Table1_4.do
is run in Stata and produces Tables 1-4 for paper which are written in the following files
(files for table 1):
	tabledata11.tex
	tabledata12.tex
	tabledata13.tex
	tabledata135.tex	 
	tabledata14.tex
(files for table 2):
	tabledata2.tex
	tabledata21.tex
	tabledata22.tex
	tabledata225.tex
	tabledata23.tex
(files for table 3):
	Produced inside stata and can be copied from stata results log
(files for table 4):
	tabledata4.tex

The file
	Table5_7.m
is run from matlab and produces Tables 5-7 for paper which are written in the following files:
(files for table 5):
	Table5.tex
(files for table 6):
	Table6.tex
(files for table 7):
	Table7.tex

The file 
	MatlabForTable8_11and14.m
is run from Matlab and produces Herfindahl index before and after merge for the Ahold/Delhaize and Whole Foods/Whild Oats cases. 
After this code has been run
	Table8_11and14.do
can produce Tables 8, 9, 10, 11 and 14 for the paper which are written in the following files:
(files for table 8):
	Table8Data5miles.tex
	Table8Data10miles.tex
(files for table 9):
	Table9.tex
	Table9Total.tex
(files for table 10):
	Table10Data.tex
	Table10Total.tex
(files for table 11):
	Table11.tex
(files for table 14):
	Table14.tex

The file
	Table12_13.m
is run from Matlab and produces Tables 12 and 13 for the paper which are written in the following files:
(files for table 12):
	Table12.tex
(files for table 13):
	Table13.tex

The file 
	TableAppendixB1_B2.do
is run from Stata and produces Tables B1 and B2 for appendix of the paper which are written in the following files:
(files for table B1):
	TableAppendixB1.tex
(files for table B2):
	Produced inside stata and can be copied from stata results log

The file 
	TableAppendixB3_B4.m
is run from Matlab and produces Tables B3 and B4 for appendix of the paper which are written in the following files:
(files for table B3):
	TableAppendixB3.tex
(files for table B4):
	TableAppendixB4.tex


	
