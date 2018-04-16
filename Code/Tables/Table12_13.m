clear
cd ../MatlabMain
load('demandStructsOP2010MSAClubForPaper.mat')
cd ../Tables
load('resultsMSAClubDistForPaperHanafNestsPointsAllFar3ClubFminunc_1_2006')
calculations=0;
NUcommon=size(ts.utilVarCommon,2);
ts.utilVar=[ts.utilVarCommon,ts.utilVarDifferent{3}];
ts.utilVarCommon=[];
ts.utilVarDifferent=[];

load('ChainsForPaper.mat');

% NEST CREATION
% ts.chainIDC:
% 17, 29 and 31 are Meijer, Target and Walmart (Supercenter Format)
% 36, 37 and 38 are BJ's, Costco and Sams (Club Format)
% The rest are grocery format
ts.nests=(1+1*(ts.chainIDC>35)+2*(1*(ts.chainIDC==17)+1*(ts.chainIDC==29)+1*(ts.chainIDC==31)));

params=view(:,1);



storeChainMap=unique([ts.storeID,ts.chainIDC],'rows');

Map=storeChainMap;
Ratio(:,1)=Map(:,1);
if (calculations==1)
    for i=1:1:size(Map,1)
        i
        if (Map(i,2)==33)
            [ storeRevenue, DerRev, storeChainMap ] = getClubNestsStoreDiversion( params, ts, storeRevenue, NUcommon, Map(i,1),33 );
        end;
        if (Map(i,2)==34)
            [ storeRevenue, DerRev, storeChainMap ] = getClubNestsStoreDiversion( params, ts, storeRevenue, NUcommon, Map(i,1), 34 );
        end;


        if (Map(i,2)==33)
            own=DerRev(i,1);
            cross=accumarray(Map(:,2),DerRev);
            Ratio(i,2)=(cross(34,1))/own;
        end;
        if (Map(i,2)==34)

            own=DerRev(i,1);
            cross=accumarray(Map(:,2),DerRev);
            Ratio(i,2)=(cross(33,1))/own;
        end;
    end;
save('DRWholeWild','Ratio');
else
    load('DRWholeWild');
end;    




structure=getStructureOPNests(view(:,1),ts);
a=accumarray(ts.storeID,structure);
rev_hat=a;
w=structure./rev_hat(ts.storeID);
wf=full(w);
data=csvread('HerfdifClubMSA2006ForPaperWholeFoodsWildOats3Nests.csv',0,0);
hstruct=data(ts.tractID,2);
hstructdif=data(ts.tractID,4);
hstore=accumarray(ts.storeID,hstruct.*w);
hstoredif=accumarray(ts.storeID,hstructdif.*w);
a=hstore(Map(:,2)==33,1);
adif=hstoredif(Map(:,2)==33,1);
adiv=Ratio(Map(:,2)==33,2);
wh=full([a,adif,adiv]);
wh=[wh(:,1),max(wh(:,2),0),-wh(:,3),Ratio(Map(:,2)==33,1)];
csvwrite('WholeStoreeHHIDiversion.csv',wh);
d=hstore(Map(:,2)==34,1);
ddif=hstoredif(Map(:,2)==34,1);
ddiv=Ratio(Map(:,2)==34,2);
wi=full([d,ddif,ddiv]);
wi=[wi(:,1),max(wi(:,2),0),-wi(:,3),Ratio(Map(:,2)==34,1)];
csvwrite('WildStoreeHHIDiversion.csv',wi);
o=accumarray(ts.tractID,1*((ts.chainIDC==34)));
o2=o(ts.tractID);
o3=accumarray(ts.storeID,o2);
table2(1,1)=sum(o3(Map(:,2)==33)>0);
table2(1,2)=sum(storeRevenue(o3(Map(:,2)==33)>0,1));
table2(1,3)=sum(wh(o3(Map(:,2)==33)>0,3)>0.05);
table2(1,4)=sum(wh(o3(Map(:,2)==33)>0,3)>0.1);
table2(1,5)=sum(wh(o3(Map(:,2)==33)>0,3)>0.2);
table2(1,6)=sum(((wh(:,2)>0.01).*(wh(:,2)<0.02).*((wh(:,1)+wh(:,2))>0.25)+(wh(:,2)>0.01).*(wh(:,1)+wh(:,2)<0.25).*((wh(:,1)+wh(:,2))>0.15))>0);
table2(1,7)=sum(((wh(:,2)>0.02).*((wh(:,1)+wh(:,2))>0.25))>0);
h=accumarray(ts.tractID,1*((ts.chainIDC==33)));
h2=h(ts.tractID);
h3=accumarray(ts.storeID,h2);
table2(2,1)=sum(h3(Map(:,2)==34)>0);
table2(2,2)=sum(storeRevenue(h3(Map(:,2)==34)>0,1));
table2(2,3)=sum(wi(h3(Map(:,2)==34)>0,3)>0.05);
table2(2,4)=sum(wi(h3(Map(:,2)==34)>0,3)>0.1);
table2(2,5)=sum(wi(h3(Map(:,2)==34)>0,3)>0.2);
table2(2,6)=sum(((wi(:,2)>0.01).*(wi(:,2)<0.02).*((wi(:,1)+wi(:,2))>0.25)+(wi(:,2)>0.01).*(wi(:,1)+wi(:,2)<0.25).*((wi(:,1)+wi(:,2))>0.15))>0);
table2(2,7)=sum(((wi(:,2)>0.02).*((wi(:,1)+wi(:,2))>0.25))>0);
save('DR_WF2WO_and_WO2WF','table2')



clear
cd ../MatlabMain
load('demandStructsOP2010MSAClubForPaper.mat')
cd ../Tables
load('resultsMSAClubDistForPaperHanafNestsPointsAllFar3ClubFminunc_1_2006')
NUcommon=size(ts.utilVarCommon,2);
ts.utilVar=[ts.utilVarCommon,ts.utilVarDifferent{3}];
ts.utilVarCommon=[];
ts.utilVarDifferent=[];
calculations=0;

load('ChainsForPaper.mat');

% NEST CREATION
% ts.chainIDC:
% 17, 29 and 31 are Meijer, Target and Walmart (Supercenter Format)
% 36, 37 and 38 are BJ's, Costco and Sams (Club Format)
% The rest are grocery format
ts.nests=(1+1*(ts.chainIDC>35)+2*(1*(ts.chainIDC==17)+1*(ts.chainIDC==29)+1*(ts.chainIDC==31)));

params=view(:,1);
% Indexing is used to create order of chains which is used in the Table7,
% because we want Supercenters and Club Stores to be consecutive rows in
% the table

ind=zeros(size(chains));
ind(17,1)=1;
ind(29,1)=1;
ind(31,1)=1;
ind(36,1)=2;
ind(37,1)=2;
ind(38,1)=2;

storeChainMap=unique([ts.storeID,ts.chainIDC],'rows');

Map=storeChainMap;
Ratio(:,1)=Map(:,1);

if (calculations==1)
    for i=1:1:size(Map,1)
        i
        if (Map(i,2)==6)
            [ storeRevenue, DerRev, storeChainMap ] = getClubNestsStoreDiversion( params, ts, storeRevenue, NUcommon, Map(i,1), 6 );
        end;
        if (Map(i,2)==12)
            [ storeRevenue, DerRev, storeChainMap ] = getClubNestsStoreDiversion( params, ts, storeRevenue, NUcommon, Map(i,1), 12 );
        end;
        if (Map(i,2)==9)
            [ storeRevenue, DerRev, storeChainMap ] = getClubNestsStoreDiversion( params, ts, storeRevenue, NUcommon, Map(i,1), 9 );
        end;
        if (Map(i,2)==27)
            [ storeRevenue, DerRev, storeChainMap ] = getClubNestsStoreDiversion( params, ts, storeRevenue, NUcommon, Map(i,1), 27 );
        end;

        if (Map(i,2)==6) || (Map(i,2)==12)
            own=DerRev(i,1);
            cross=accumarray(Map(:,2),DerRev);
            Ratio(i,2)=(cross(9,1)+cross(27,1))/own;
        end;
        if (Map(i,2)==9) || (Map(i,2)==27)

            own=DerRev(i,1);
            cross=accumarray(Map(:,2),DerRev);
            Ratio(i,2)=(cross(6,1)+cross(12,1))/own;
        end;
    end;

    save('DRAholdDelhaize','Ratio')
    csvwrite('DRAholdDelhaize.csv',Ratio)

else
    load('DRAholdDelhaize');
end;

structure=getStructureOPNests(view(:,1),ts);
a=accumarray(ts.storeID,structure);
rev_hat=a;
w=structure./rev_hat(ts.storeID);
wf=full(w);
data=csvread('HerfdifClubMSA2006ForPaper3Nests.csv',0,0);
hstruct=data(ts.tractID,2);
hstructdif=data(ts.tractID,4);
hstore=accumarray(ts.storeID,hstruct.*w);
hstoredif=accumarray(ts.storeID,hstructdif.*w);
a=hstore(Map(:,2)==6 | Map(:,2)==12,1);
adif=hstoredif(Map(:,2)==6 | Map(:,2)==12,1);
adiv=Ratio(Map(:,2)==6 | Map(:,2)==12,2);
aa=full([a,adif,adiv]);
aa=[aa(:,1),max(aa(:,2),0),-aa(:,3),Ratio(Map(:,2)==6 | Map(:,2)==12,1)];
csvwrite('DelhaizeAholdStoreHHIDiversion.csv',aa);

d=hstore(Map(:,2)==9 | Map(:,2)==27,1);
ddif=hstoredif(Map(:,2)==9 | Map(:,2)==27,1);
ddiv=Ratio(Map(:,2)==9 | Map(:,2)==27,2);
dd=full([d,ddif,ddiv]);
dd=[dd(:,1),max(dd(:,2),0),-dd(:,3),Ratio(Map(:,2)==9 | Map(:,2)==27,1)];
csvwrite('AholdStoreeHHIDiversion.csv',dd);

d=accumarray(ts.tractID,1*((ts.chainIDC==6)+(ts.chainIDC==12)));
d2=d(ts.tractID);
d3=accumarray(ts.storeID,d2);
a=accumarray(ts.tractID,1*((ts.chainIDC==9)+(ts.chainIDC==27)));
a2=a(ts.tractID);
a3=accumarray(ts.storeID,a2);
table(1,1)=sum(a3(Map(:,2)==6|Map(:,2)==12)>0);
table(1,2)=sum(storeRevenue(a3(Map(:,2)==6|Map(:,2)==12)>0,1));
ind=a3(Map(:,2)==6|Map(:,2)==12)>0;
table(1,3)=sum(aa(a3(Map(:,2)==6|Map(:,2)==12)>0,3)>0.05);
table(1,4)=sum(aa(a3(Map(:,2)==6|Map(:,2)==12)>0,3)>0.1);
table(1,5)=sum(aa(a3(Map(:,2)==6|Map(:,2)==12)>0,3)>0.2);
table(2,1)=sum(d3(Map(:,2)==9|Map(:,2)==27)>0);

table(2,2)=sum(storeRevenue(d3(Map(:,2)==9|Map(:,2)==27)>0,1));
table(2,3)=sum(dd(d3(Map(:,2)==9|Map(:,2)==27)>0,3)>0.05);
table(2,4)=sum(dd(d3(Map(:,2)==9|Map(:,2)==27)>0,3)>0.1);
table(2,5)=sum(dd(d3(Map(:,2)==9|Map(:,2)==27)>0,3)>0.2);
table(1,6)=sum(((aa(:,2)>0.01).*(aa(:,2)<0.02).*((aa(:,1)+aa(:,2))>0.25)+(aa(:,2)>0.01).*(aa(:,1)+aa(:,2)<0.25).*((aa(:,1)+aa(:,2))>0.15))>0);
table(1,7)=sum(((aa(:,2)>0.02).*((aa(:,1)+aa(:,2))>0.25))>0);
table(2,6)=sum(((dd(:,2)>0.01).*(dd(:,2)<0.02).*((dd(:,1)+dd(:,2))>0.25)+(dd(:,2)>0.01).*(dd(:,1)+dd(:,2)<0.25).*((dd(:,1)+dd(:,2))>0.15))>0);
table(2,7)=sum(((dd(:,2)>0.02).*((dd(:,1)+dd(:,2))>0.25))>0);
table=table([2,1],:);
save('DR_A2D_and_D2A','table')

dtab1=[aa(:,3)<0.05,(aa(:,3)<0.1).*(aa(:,3)>0.05),(aa(:,3)<0.2).*(aa(:,3)>0.1),(aa(:,3)>0.2)];
dtab2=[aa(ind,2)<0.01,(aa(ind,2)<0.02).*(aa(ind,2)>0.01),aa(ind,2)>0.02];
dtab2=[dtab2,(((aa(ind,2)>0.01).*(aa(ind,2)<0.02).*((aa(ind,1)+aa(ind,2))>0.25)+(aa(ind,2)>0.01).*(aa(ind,1)+aa(ind,2)<0.25).*((aa(ind,1)+aa(ind,2))>0.15))>0)];
dtab2=[dtab2,(aa(ind,2)>0.02).*(aa(ind,1)+aa(ind,2)>0.25)];
dtab2=[dtab2(:,[1,2,3]),ones(size(dtab2,1),1)-dtab2(:,4)-dtab2(:,5),dtab2(:,[4,5])];
table3=dtab2'*dtab1(ind,:);
atab1=[dd(:,3)<0.05,(dd(:,3)<0.1).*(dd(:,3)>0.05),(dd(:,3)<0.2).*(dd(:,3)>0.1),(dd(:,3)>0.2)];
ind2=d3(Map(:,2)==9|Map(:,2)==27)>0;
atab2=[dd(ind2,2)<0.01,(dd(ind2,2)<0.02).*(dd(ind2,2)>0.01),dd(ind2,2)>0.02];
atab2=[atab2,(((dd(ind2,2)>0.01).*(dd(ind2,2)<0.02).*((dd(ind2,1)+dd(ind2,2))>0.25)+(dd(ind2,2)>0.01).*(dd(ind2,1)+dd(ind2,2)<0.25).*((dd(ind2,1)+dd(ind2,2))>0.15))>0)];
atab2=[atab2,(dd(ind2,2)>0.02).*(dd(ind2,1)+dd(ind2,2)>0.25)];
atab2=[atab2(:,[1,2,3]),ones(size(atab2,1),1)-atab2(:,4)-atab2(:,5),atab2(:,[4,5])];
table4=atab2'*atab1(ind2,:);
table5=[table4;table3];
save('AholdDelhaizeHHIDRCrossTab','table5')
load('DR_WF2WO_and_WO2WF.mat')
t=[table;table2];

if (calculations==1)
    hh=zeros(38,38);
    cc=zeros(38,38);
    for i=1:1:size(Map,1)
        if ((Map(i,2)==6) | (Map(i,2)==9) | (Map(i,2)==12) | (Map(i,2)==27) | (Map(i,2)==33) | (Map(i,2)==34))
        i
        a=(ts.storeID==i);
        b=accumarray(ts.tractID,a);
        c=b(ts.tractID);
        d=accumarray(ts.storeID,c);
        e=accumarray(Map(:,2),d>0);

        hh(Map(i,2),:)=hh(Map(i,2),:)+e';
        cc(Map(i,2),:)=cc(Map(i,2),:)+1*(e'>0);
        end;
    end;
    save('Competitors','cc','hh');
else 
    load('Competitors');
end;

t(1,2)=(hh(9,6)+hh(9,12)+hh(27,6)+hh(27,12))/(cc(9,6)+cc(9,12)+cc(27,6)+cc(27,12));
t(2,2)=(hh(6,9)+hh(6,27)+hh(12,9)+hh(12,27))/(cc(6,9)+cc(6,27)+cc(12,9)+cc(12,27));
t(3,2)=(hh(33,34))/(cc(33,34));
t(4,2)=(hh(34,33))/(cc(34,33));

mymatlabtolatexRegular(t,'Table12.tex','Diversion Ratio for Merged Stores',{'','Competing Stores','Stores Revenue','Div>.05','Div>0.1','Div>0.2','Warrants Scrutiny','Raise Concerns'},{'From Delhaize to Ahold';'From Ahold to Delhaize';'From Whole Foods to Wild Oats';'From Wild Oats to Whole Foods'});
mymatlabtolatexRegular(table5,'Table13.tex','Comparison of Store Level dHHI and Diversion Ratios',{'','Div<.05','.05<Div<0.1','.1<Div<0.2','.2<Div'},{'dHHI<.1';'.1<dHHI<.2';'.2<dHHI';'No Concern';'Warrants Scrutiny';'Raise Concerns';'dHHI<.1';'.1<dHHI<.2';'.2<dHHI';'No Concern';'Warrants Scrutiny';'Raise Concerns'});
