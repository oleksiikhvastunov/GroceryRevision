
function data=CsvToMat(FileNameStructuresStata,FileNameStructuresMatlab)
% Function that reads Stata structures from csv file FileNameStructuresStata
% and saves them into matrix data which is saved in mat file FileNameStructuresMatlab

CurrentFolder=pwd;
FullPathStructuresStata=strcat(CurrentFolder,'/',FileNameStructuresStata);



data=csvread(FullPathStructuresStata,1,0);

FullPathStructuresMatlab=strcat(CurrentFolder,'/',FileNameStructuresMatlab);

 
save(FullPathStructuresMatlab,'data','-v7.3');
