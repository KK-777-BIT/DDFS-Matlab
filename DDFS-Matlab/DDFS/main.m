clear
clc
% % 这里开始
pop=200; %  总数200个
M=2;   %  问题维度
Gen=100;  % 最大迭代次数 
%% Load dataset
load DLBCL.mat;
label=lab;
data=ins;
 [train_F,train_L,Xtest_F,Xtest_L,D]= dividset(data,label);
 [rnvec,obj] = initialize(pop,D,train_F,train_L);  % 随机生成种群
Ninitpop = rnvec(1:pop/2,:); Minitpop = rnvec(1+pop/2:pop,:);
Ninitobj = obj(1:pop/2,:); Minitobj = obj(1+pop/2:pop,:);
eval(['save initpop',num2str(0)]);
for hui = 1: 30
 tic;
 rand('seed',hui);
load initpop0.mat;
[population,obj] = NDSMOD(Ninitpop,Minitpop,Ninitobj,Minitobj,pop,M,Gen,train_F, train_L,D);
[obj_test,fval]=testerror(population,D,train_F,train_L,pop,Xtest_L,Xtest_F);
figure(1)
scatter(fval(:,1),fval(:,2),'r');
% 计算的HV指标
repoint=[1,1];
pf=fval;
HV=Hypervolume_calculation(pf,repoint);
toc;
time=toc;
eval(['save test',num2str(hui)]);
clear;
end