 function [newobj,oldobj]=updates(weight,obj,zz,z,roadN,roadO)
weight(weight==0)=0.00001; 
part=abs(zz-z)./roadN;  % ����õ����½��ڵ�ǰȨ���µľۺϺ���ֵ
newobj = max(weight.*part); 
part=abs(obj-z)./roadO; % ���㵱ǰ����ľۺϺ���ֵ
oldobj=max(weight.*part); 
end