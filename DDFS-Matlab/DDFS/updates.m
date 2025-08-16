 function [newobj,oldobj]=updates(weight,obj,zz,z,roadN,roadO)
weight(weight==0)=0.00001; 
part=abs(zz-z)./roadN;  % 计算得到的新解在当前权重下的聚合后函数值
newobj = max(weight.*part); 
part=abs(obj-z)./roadO; % 计算当前个体的聚合后函数值
oldobj=max(weight.*part); 
end