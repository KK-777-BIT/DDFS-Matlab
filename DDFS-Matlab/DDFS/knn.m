function oobb= knn (temp_x,train_F, train_L,D)
% % % 十折交叉验证分类测试、训练集
% tr 训练数据 第一列是类别标签 2：end列是训练样本数据
% te 训练数据 第一列是类别标签 2：end列是测试样本数据

inmodel=logical(temp_x);
if sum(inmodel)==0
   inmodel( randperm(D,4))=1;  % 当选不中特征时，随机选 8 个
end
% object.feature_num = sum(inmodel(1,:)); % 所选特征数量
[~,ind]= find(inmodel==1);
feature_num = length(ind)/D; 

data_normal=train_F;
%交叉验证
kz =5;    %预将数据分成wu份
% sum_accuracy_svm = 0;
[m,n] = size(data_normal);
%交叉验证,使用十折交叉验证 Kfold
%indices为 m 行一列数据，表示每个训练样本属于k份数据的哪一份
indices = crossvalind('Kfold',m,kz);
for d = 1:kz
test_indic = (indices == d);
train_indic = ~test_indic;
train_data = data_normal(train_indic,:);%找出训练数据与标签
train_label = train_L(train_indic,:);
test_data = data_normal(test_indic,:);%找出测试数据与标签
test_label = train_L(test_indic,:);

% K 近邻个数
k= 5;
tr_F=train_data(:,inmodel);
te_F=test_data(:,inmodel);
tr=[train_label,tr_F];
te=[test_label,te_F];

% A        测试精度
% knnlabel 测试样本实际分类标签
data=[tr;te];
n=size(data,2);
label=data(:,1);
L=unique(label);  % 合并A中相同数据
ls=length(L(:));  %统计类别总数
m1=size(tr,1);
m2=size(te,1);

trd=tr(:,2:n);
trl=tr(:,1);
ted=te(:,2:n);
tel=te(:,1);

 for j=1:m2
    distance=zeros(m2,1);
    for i=1:m1
        distance(i)=norm(ted(j,:)-trd(i,:));
    end

%选择排序，只找出最小的前K个数据,对数据和标号都进行排序
[distance1,index]=sort(distance); %以升序排序
distance11=distance1(1:k);
label=trl(index(1:k));

%出现次数最多的类别标号即为该测试样本的类别标号
knnlabel(j,1)=mode(label);
 end
% [~,bj]=find(knnlabel==tel);
num_valid = length(tel); 
correct   = 0;
  for j = 1:num_valid
     if isequal(knnlabel(j,1),tel(j,1))
    correct = correct + 1;
     end
  end
A=correct/m2; %输出识别正确率
error(d)=1-A;
end
f=sum(error)/kz;
% object.factorial_costs=f;
oobb=[feature_num,f];
end