function oobb= knn (temp_x,train_F, train_L,D)
% % % ʮ�۽�����֤������ԡ�ѵ����
% tr ѵ������ ��һ��������ǩ 2��end����ѵ����������
% te ѵ������ ��һ��������ǩ 2��end���ǲ�����������

inmodel=logical(temp_x);
if sum(inmodel)==0
   inmodel( randperm(D,4))=1;  % ��ѡ��������ʱ�����ѡ 8 ��
end
% object.feature_num = sum(inmodel(1,:)); % ��ѡ��������
[~,ind]= find(inmodel==1);
feature_num = length(ind)/D; 

data_normal=train_F;
%������֤
kz =5;    %Ԥ�����ݷֳ�wu��
% sum_accuracy_svm = 0;
[m,n] = size(data_normal);
%������֤,ʹ��ʮ�۽�����֤ Kfold
%indicesΪ m ��һ�����ݣ���ʾÿ��ѵ����������k�����ݵ���һ��
indices = crossvalind('Kfold',m,kz);
for d = 1:kz
test_indic = (indices == d);
train_indic = ~test_indic;
train_data = data_normal(train_indic,:);%�ҳ�ѵ���������ǩ
train_label = train_L(train_indic,:);
test_data = data_normal(test_indic,:);%�ҳ������������ǩ
test_label = train_L(test_indic,:);

% K ���ڸ���
k= 5;
tr_F=train_data(:,inmodel);
te_F=test_data(:,inmodel);
tr=[train_label,tr_F];
te=[test_label,te_F];

% A        ���Ծ���
% knnlabel ��������ʵ�ʷ����ǩ
data=[tr;te];
n=size(data,2);
label=data(:,1);
L=unique(label);  % �ϲ�A����ͬ����
ls=length(L(:));  %ͳ���������
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

%ѡ������ֻ�ҳ���С��ǰK������,�����ݺͱ�Ŷ���������
[distance1,index]=sort(distance); %����������
distance11=distance1(1:k);
label=trl(index(1:k));

%���ִ�����������ż�Ϊ�ò��������������
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
A=correct/m2; %���ʶ����ȷ��
error(d)=1-A;
end
f=sum(error)/kz;
% object.factorial_costs=f;
oobb=[feature_num,f];
end