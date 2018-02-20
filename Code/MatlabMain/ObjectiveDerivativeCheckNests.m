function Pass=ObjectiveDerivativeCheckNests(Params,ts,storeRevenue)
% This function checks if the analytical and numerical derivatives are close enough 
NumParams=size(Params,1);
eps=1e-6;
eps2=10;
tic
[FuncVal0,FuncDer0]=demandObjectiveNests( Params, ts, storeRevenue );
toc
NumDerivative=zeros(NumParams,1);
tic
for i=1:1:NumParams
    IncPoint=Params;
    IncPoint(i,1)=IncPoint(i,1)+eps;
    NumDerivative(i,1)=( demandObjectiveNests( IncPoint, ts, storeRevenue )-FuncVal0)/(eps);
    
end;
toc
Pass=(max((NumDerivative-FuncDer0)./NumDerivative)<eps2);

if (Pass==0)
    disp(sprintf('Error: Derivative Check did not pass'));
end;