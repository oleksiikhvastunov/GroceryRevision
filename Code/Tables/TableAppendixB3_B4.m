clear

% Main specification (with nests and club stores)
load('resultsMSAClubDistForPaperHanafNestsPointsAllFar3ClubFminunc_1_2006');
v{1,1}=view;


% Multinomial logit (no nests)
load('resultsMSAClubDistForPaperHanaf_2_2006.mat')
v{1,2}=view;


% Specification without club stores (with nests)
load('resultsMSANoClubDistForPaperHanafNestsPointsAllFar3_5_2006')
v{1,3}=view;


% Specification with nests and club stores, but without fte and checkouts
% for supermarkets and supercenters
load('resultsMSAClubDistForPaperHanafNestsPointsAllFar3ClubSame_29_2006')
v{1,4}=view;
load('ChainsForPaper.mat');
nchains=size(chains,1);
ind=zeros(nchains,1);
ind(17,1)=1;
ind(29,1)=1;
ind(31,1)=1;
ind(36,1)=2;
ind(37,1)=2;
ind(38,1)=2;
vv{1,1}=v{1,1}(15:15+nchains-1,:);
vv{1,2}=v{1,2}(15:15+nchains-1,:);
vv{1,3}=[v{1,3}(11:11+nchains-4,:);zeros(3,3)];
vv{1,4}=v{1,4}(11:11+nchains-1,:);

vvv{1,1}=v{1,1}(15+nchains:15+2*nchains-1,:);
vvv{1,2}=v{1,2}(15+nchains:15+2*nchains-1,:);
vvv{1,3}=[v{1,3}(11+nchains-3:11+2*nchains-7,:);zeros(3,3)];
vvv{1,4}=v{1,4}(11+nchains:11+2*nchains-1,:);

vv2{1,1}=[vv{1,1}(ind==0,:);vv{1,1}(ind==1,:);vv{1,1}(ind==2,:)];
vv2{1,2}=[vv{1,2}(ind==0,:);vv{1,2}(ind==1,:);vv{1,2}(ind==2,:)];
vv2{1,3}=[vv{1,3}(ind==0,:);vv{1,3}(ind==1,:);vv{1,3}(ind==2,:)];
vv2{1,4}=[vv{1,4}(ind==0,:);vv{1,4}(ind==1,:);vv{1,4}(ind==2,:)];

vvv2{1,1}=[vvv{1,1}(ind==0,:);vvv{1,1}(ind==1,:);vvv{1,1}(ind==2,:)];
vvv2{1,2}=[vvv{1,2}(ind==0,:);vvv{1,2}(ind==1,:);vvv{1,2}(ind==2,:)];
vvv2{1,3}=[vvv{1,3}(ind==0,:);vvv{1,3}(ind==1,:);vvv{1,3}(ind==2,:)];
vvv2{1,4}=[vvv{1,4}(ind==0,:);vvv{1,4}(ind==1,:);vvv{1,4}(ind==2,:)];

% Create table with chain intercepts 
mymatlabtolatex( vv2, 'TableAppendixB3.tex', 'TableAppendixB3', {'','(1) Intercepts','(2) Intercepts','(3) Intercepts','(4) Intercepts'} ,chains  )
% Create table with chain slopes
mymatlabtolatex( vvv2, 'TableAppendixB4.tex', 'TableAppendixB4', {'','(1) Slopes','(2) Slopes','(3) Slopes','(4) Slopes'} ,chains  )

