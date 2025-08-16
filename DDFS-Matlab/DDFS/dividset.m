function [train_F,train_L,Xtest_F,Xtest_L,D]= dividset(data,label)
S_ple=size(data,1);  % 计算数据集特征数和类别数
Lei=unique(label);
ind={};
for i=1:length(Lei)
    in=find(label==Lei(i));
    ind{i}=in;
    tr_ind{i}=ind{i}(1:floor(length(ind{i})*0.8));
    train_ind(1:length(tr_ind{1,i}),i)=tr_ind{1,i};
    te_ind{i}=setxor(tr_ind{i},ind{i});
    test_ind(1:length(te_ind{1,i}),i)=te_ind{1,i};
end
TT=train_ind(train_ind~=0); % 划分训练集
train_F=data(TT,:);
Xtest_F=data(setdiff(1:S_ple,TT),:); % 测试集（密封）
Xtest_L=label(setdiff(1:S_ple,TT),:); 
train_L=label(TT,:);
D=size(data,2);    % 特征维度 
end