function [obj_test,fval]=testerror(population,D_multitask,train_F,train_L,pop,Xtest_L,Xtest_F)
D = D_multitask;
parfor nn=1:size(population,1)
%  temp_x = PopDec(nn,:);
    temp_x = population(nn,:);
    inmodel=logical(temp_x);
  if sum(inmodel)==0
   inmodel( randperm(D_multitask,4))=1;  % 当选不中特征时，随机选 8 个
  end
      [~,ind]= find(inmodel==1);
feature_num=length(ind)/D;
k =5;
  Model     = fitcknn(train_F(:,inmodel),train_L,'NumNeighbors',k); 
pred      = predict(Model,Xtest_F (:,inmodel)); 
num_valid = length(Xtest_L); 
correct   = 0;
  for j = 1:num_valid
     if isequal(Xtest_L(j),pred(j))
    correct = correct + 1;
     end
  end
Acc_s   = correct / num_valid; % 分类正确率
f=1-Acc_s;
oobb=[feature_num,f];
  obj_test(nn,:)=oobb;
% [~,ind]= find(inmodel==1);
% feature_num = length(ind)/D_multitask; 
% [m,n] = size(train_F);
% % K 近邻个数
% k= 5;
% tr_F=train_F(:,inmodel);
% te_F=Xtest_F(:,inmodel);
% tr=[train_L,tr_F];
% te=[Xtest_L,te_F];
% % A        测试精度
% % knnlabel 测试样本实际分类标签
% data=[tr;te];
% n=size(data,2);
% label=data(:,1);
% L=unique(label);  % 合并A中相同数据
% ls=length(L(:));  %统计类别总数
% m1=size(tr,1);
% m2=size(te,1);
% trd=tr(:,2:n);
% trl=tr(:,1);
% ted=te(:,2:n);
% tel=te(:,1);
%    for j=1:m2
%     distance=zeros(m2,1);
%       for i=1:m1
%         distance(i)=norm(ted(j,:)-trd(i,:));
%       end
% %选择排序，只找出最小的前K个数据,对数据和标号都进行排序
% [distance1,index]=sort(distance); %以升序排序
% distance11=distance1(1:k);
% label=trl(index(1:k));
% %出现次数最多的类别标号即为该测试样本的类别标号
% knnlabel(j,1)=mode(label);
%   end
% % [~,bj]=find(knnlabel==tel);
% num_valid = length(tel); 
% correct   = 0;
%   for j = 1:num_valid
%      if isequal(knnlabel(j,1),tel(j,1))
%     correct = correct + 1;
%      end
%   end
% A=correct/m2; %输出识别正确率
% error=1-A; 
% oobb=[feature_num,error];
% obj_test(nn,:)=oobb;
 end
[~,~,Pareto] = QuickSortDD(obj_test);
inda=find(Pareto(:,1)==1);
fval(:,1)=Pareto(inda,3);
fval(:,2)=Pareto(inda,4);