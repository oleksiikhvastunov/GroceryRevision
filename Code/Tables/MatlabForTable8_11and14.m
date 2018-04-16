%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This subsection creates difference in Herfindahl index for census tracts 
% before and after merge of Ahold and Delhaize taking club stores into
% account
clear
data = csvread('FirmIDsMSAClubs2006ForPaper.csv',1,0);
storeid=data(:,1);
firmid=data(:,2);
cd ../MatlabMain
load('demandStructsOP2010MSAClubForPaper.mat')
cd ../Tables
load('resultsMSAClubDistForPaperHanafNestsPointsAllFar3ClubFminunc_1_2006')
ts.utilVar=[ts.utilVarCommon,ts.utilVarDifferent{3}];
ts.utilVarCommon=[];
ts.utilVarDifferent=[];

ts.nests=(1+1*(ts.chainIDC>35)+2*(1*(ts.chainIDC==17)+1*(ts.chainIDC==29)+1*(ts.chainIDC==31)));


structurefirmid=firmid(ts.storeID);

xx=view(:,1);

structure=getStructureOPNests(xx,ts);

rev_est = accumarray(ts.storeID,structure);
rev_tract=accumarray(ts.tractID,structure);
tract_rev=rev_tract(ts.tractID);

share_rev_tractstore=structure./tract_rev;

a=accumarray([ts.tractID,structurefirmid],full(share_rev_tractstore),[],[],[],(1==1));
herfindal=sum(a.^2,2);

% Firm id's are checked at Club Stores/FirmIDsClubMSAForPaper

% Correct assignment!!!
% First row is Ahold id - it is a bit more than just Giant Food and Super Shop &
% Store (other storname are there)
% Second row is Delhaize id - it is a bit more than Food Lion and Hannaford
% Ahold id is assigned to Delhaize stores
mergedids = csvread('ChainsIDSForHerfindahlWithClubs.csv',1,0);
firmid=data(:,2).*(data(:,2)~=mergedids(1,1))+mergedids(2,1)*(data(:,2)==mergedids(1,1));

structurefirmid=firmid(ts.storeID);

structure=getStructureOPNests(xx,ts);

rev_est = accumarray(ts.storeID,structure);
rev_tract=accumarray(ts.tractID,structure);
tract_rev=rev_tract(ts.tractID);

share_rev_tractstore=structure./tract_rev;

a=accumarray([ts.tractID,structurefirmid],full(share_rev_tractstore),[],[],[],(1==1));
herfindal2=sum(a.^2,2);
difherfinal=herfindal2-herfindal;

a=1:1:size(herfindal,1);
b=[full([herfindal2,difherfinal])];
csvwrite('HerfdifClubMSA2006ForPaper3Nests.csv',full([a',herfindal,herfindal2,difherfinal,((b(:,1)>0.15).*(b(:,2)>0.01)+(b(:,1)>0.25).*(b(:,2)>0.005))>0]));



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This subsection creates difference in Herfindahl index for census tracts 
% before and after merge of Ahold and Delhaize without taking club stores
% into account
clear
data = csvread('FirmIDsMSANoClubs2006ForPaper.csv',1,0);
storeid=data(:,1);
firmid=data(:,2);

cd ../MatlabMain
load('demandStructsOP2010MSANoClubForPaper.mat')
cd ../Tables
load('resultsMSANoClubDistForPaperHanafNestsPointsAllFar3_5_2006.mat')
ts.utilVar=[ts.utilVarCommon,ts.utilVarDifferent{3}];
ts.utilVarCommon=[];
ts.utilVarDifferent=[];

ts.nests=(1+1*(1*(ts.chainIDC==17)+1*(ts.chainIDC==29)+1*(ts.chainIDC==31)));


structurefirmid=firmid(ts.storeID);

xx=view(:,1);

structure=getStructureOPNests(xx,ts);

rev_est = accumarray(ts.storeID,structure);
rev_tract=accumarray(ts.tractID,structure);
tract_rev=rev_tract(ts.tractID);

share_rev_tractstore=structure./tract_rev;

a=accumarray([ts.tractID,structurefirmid],full(share_rev_tractstore),[],[],[],(1==1));
herfindal=sum(a.^2,2);

% Correct assignment!!!
% First row is Ahold id - it is a bit more than just Giant Food and Super Shop &
% Store (other storname are there)
% Second row is Delhaize id - it is a bit more than Food Lion and Hannaford
% Ahold id is assigned to Delhaize stores
mergedids = csvread('ChainsIDSForHerfindahlNoClubs.csv',1,0);
firmid=data(:,2).*(data(:,2)~=mergedids(1,1))+mergedids(2,1)*(data(:,2)==mergedids(1,1));

structurefirmid=firmid(ts.storeID);

structure=getStructureOPNests(xx,ts);

rev_est = accumarray(ts.storeID,structure);
rev_tract=accumarray(ts.tractID,structure);
tract_rev=rev_tract(ts.tractID);

share_rev_tractstore=structure./tract_rev;

a=accumarray([ts.tractID,structurefirmid],full(share_rev_tractstore),[],[],[],(1==1));
herfindal2=sum(a.^2,2);
difherfinal=herfindal2-herfindal;

a=1:1:size(herfindal,1);
b=[full([herfindal2,difherfinal])];
csvwrite('HerfdifNoClubMSA2006ForPaper3Nests.csv',full([a',herfindal,herfindal2,difherfinal,((b(:,1)>0.15).*(b(:,2)>0.01)+(b(:,1)>0.25).*(b(:,2)>0.005))>0]));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This subsection creates difference in Herfindahl index for census tracts 
% before and after merge of Whole foods and WildOats taking club stores into
% account
clear
data = csvread('FirmIDsMSAClubs2006ForPaper.csv',1,0);
storeid=data(:,1);
firmid=data(:,2);

cd ../MatlabMain
load('demandStructsOP2010MSAClubForPaper.mat')
cd ../Tables
load('resultsMSAClubDistForPaperHanafNestsPointsAllFar3ClubFminunc_1_2006')
ts.utilVar=[ts.utilVarCommon,ts.utilVarDifferent{3}];
ts.utilVarCommon=[];
ts.utilVarDifferent=[];

ts.nests=(1+1*(ts.chainIDC>35)+2*(1*(ts.chainIDC==17)+1*(ts.chainIDC==29)+1*(ts.chainIDC==31)));


structurefirmid=firmid(ts.storeID);

xx=view(:,1);

structure=getStructureOPNests(xx,ts);

rev_est = accumarray(ts.storeID,structure);
rev_tract=accumarray(ts.tractID,structure);
tract_rev=rev_tract(ts.tractID);

share_rev_tractstore=structure./tract_rev;

a=accumarray([ts.tractID,structurefirmid],full(share_rev_tractstore),[],[],[],(1==1));
herfindal=sum(a.^2,2);

% Firm id's are checked at Club Stores/FirmIDsClubMSAForPaper

% Correct assignment!!!
% Third row - Whole Foods id
% Forth row - Wild Oats id
mergedids = csvread('ChainsIDSForHerfindahlWithClubs.csv',1,0);
firmid=data(:,2).*(data(:,2)~=mergedids(3,1))+mergedids(4,1)*(data(:,2)==mergedids(3,1));

structurefirmid=firmid(ts.storeID);

structure=getStructureOPNests(xx,ts);

rev_est = accumarray(ts.storeID,structure);
rev_tract=accumarray(ts.tractID,structure);
tract_rev=rev_tract(ts.tractID);

share_rev_tractstore=structure./tract_rev;

a=accumarray([ts.tractID,structurefirmid],full(share_rev_tractstore),[],[],[],(1==1));
herfindal2=sum(a.^2,2);
difherfinal=herfindal2-herfindal;

a=1:1:size(herfindal,1);
b=[full([herfindal2,difherfinal])];
csvwrite('HerfdifClubMSA2006ForPaperWholeFoodsWildOats3Nests.csv',full([a',herfindal,herfindal2,difherfinal,((b(:,1)>0.15).*(b(:,2)>0.01)+(b(:,1)>0.25).*(b(:,2)>0.005))>0]));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This subsection creates difference in Herfindahl index for census tracts 
% before and after merge of Whole foods and WildOats without taking club stores into
% account
clear
data = csvread('FirmIDsMSANoClubs2006ForPaper.csv',1,0);
storeid=data(:,1);
firmid=data(:,2);
cd ../MatlabMain
load('demandStructsOP2010MSANoClubForPaper.mat')
cd ../Tables
load('resultsMSANoClubDistForPaperHanafNestsPointsAllFar3_5_2006.mat')
ts.utilVar=[ts.utilVarCommon,ts.utilVarDifferent{3}];
ts.utilVarCommon=[];
ts.utilVarDifferent=[];

ts.nests=(1+1*(1*(ts.chainIDC==17)+1*(ts.chainIDC==29)+1*(ts.chainIDC==31)));

structurefirmid=firmid(ts.storeID);

xx=view(:,1);

structure=getStructureOPNests(xx,ts);

rev_est = accumarray(ts.storeID,structure);
rev_tract=accumarray(ts.tractID,structure);
tract_rev=rev_tract(ts.tractID);

share_rev_tractstore=structure./tract_rev;

a=accumarray([ts.tractID,structurefirmid],full(share_rev_tractstore),[],[],[],(1==1));
herfindal=sum(a.^2,2);


% Correct assignment!!!
% Third row - Whole Foods id
% Forth row - Wild Oats id
mergedids = csvread('ChainsIDSForHerfindahlWithClubs.csv',1,0);
firmid=data(:,2).*(data(:,2)~=mergedids(3,1))+mergedids(4,1)*(data(:,2)==mergedids(3,1));

structurefirmid=firmid(ts.storeID);

structure=getStructureOPNests(xx,ts);

rev_est = accumarray(ts.storeID,structure);
rev_tract=accumarray(ts.tractID,structure);
tract_rev=rev_tract(ts.tractID);

share_rev_tractstore=structure./tract_rev;

a=accumarray([ts.tractID,structurefirmid],full(share_rev_tractstore),[],[],[],(1==1));
herfindal2=sum(a.^2,2);
difherfinal=herfindal2-herfindal;

a=1:1:size(herfindal,1);
b=[full([herfindal2,difherfinal])];
csvwrite('HerfdifNoClubMSA2006ForPaperWholeFoodsWildOats3Nests.csv',full([a',herfindal,herfindal2,difherfinal,((b(:,1)>0.15).*(b(:,2)>0.01)+(b(:,1)>0.25).*(b(:,2)>0.005))>0]));

