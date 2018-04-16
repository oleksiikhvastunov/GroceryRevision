data = csvread('FirmIDsMSANoClubs2006ForPaper.csv',1,0);
storeid=data(:,1);
firmid=data(:,2);

load('demandStructsOP2010MSANoClubForPaper.mat')
load('resultsMSANoClubDistForPaperHanafNestsPointsAllFar3_1_2006.mat')
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
% 581 - Whole Foods id
% 15 - Wild Oats id
% Whole Foods id is assigned to Wild Oats stores
firmid=data(:,2).*(data(:,2)~=581)+15*(data(:,2)==581);

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


sum(((b(:,1)>0.15).*(b(:,2)>0.01)+(b(:,1)>0.25).*(b(:,2)>0.005))>0)