function [Allpop,Allobj] = NDSMOD(Npop,Mpop,Nobj,Mobj,pop,M,Gen,train_F, train_L,D)
            N=pop/2;
            [~,FrontNo,CrowdDis,~] = EnvironmentalSelection(Npop,Nobj,N);


            %% Generate the weight vectors
            [W,N] = UniformPoint(N,M);
            T = ceil(N/10);

            %% Detect the neighbours of each solution
            B = pdist2(W,W);
            [~,B] = sort(B,2);
            B = B(:,1:T);
            Z = min(Mobj,[],1);

            %% Optimization
for g=1:Gen
                %% 基于支配的EA
                MatingPool = TournamentSelection(2,N,FrontNo,-CrowdDis);
                NOffspring  = OperatorGA(Npop(MatingPool,:),D);
            parfor i=1:N
             NOffobj(i,:) = knn(NOffspring(i, :),train_F, train_L,D); 
            end
                [Npop,FrontNo,CrowdDis,Nobj] = EnvironmentalSelection([Npop;NOffspring],[Nobj;NOffobj],N);

                %% 基于分解的EA
  % 重新排列个体，根据目标值
  % 父代obj排序
    objfit(:,1)=Mobj(1:N,2)-Mobj(1:N,1);  % 值越小，权重向量的首位越小
    [~,xu]=sortrows(objfit,1);
    Mpop = Mpop(xu,:);
    Mobj = Mobj(xu,:);
    Z=min(Z,min([Mobj;Nobj])); % 更新参考点
                % For each solution
                parfor i = 1 : N
                    % Choose the parents
                    P = B(i,randperm(size(B,2)));
                    % Generate an offspring
                    MOffspring(i,:) = OperatorGAhalf(Mpop(P(1:2),:),D);
                    MOffobj(i,:) = knn(MOffspring(i,:),train_F, train_L,D); 
                end
 % 子代obj排序       
    zzfit(:,1)=MOffobj(:,2)-MOffobj(:,1);  % 值越小，权重向量的首位越小
    [~,xu]=sortrows(zzfit,1);
    MOffspring = MOffspring(xu,:);
    MOffobj = MOffobj(xu,:);
    Z = min(Z,min(MOffobj));
                parfor i=1:N
                    roadN=max(MOffobj(i,:))-Z;  % 计算子代最大值与理想点的差距
                    roadO=max(Mobj(i,:))-Z;  % 计算父代最大值与理想点的差距
                    % Update the neighbours
                            % Tchebycheff approach with normalization
            [newobj,oldobj]=updates(W(i,:),Mobj(i,:),MOffobj(i,:),Z,roadN,roadO);
            % 更新领域解，注意传的参数（原）
           if newobj<oldobj 
              Mpop(i,:)=MOffspring(i,:);
               Mobj(i,:)=MOffobj(i,:);
           end
                end
                %% 知识迁移，分配两种进化的个体    
                Allpop=[Npop;Mpop];
                Allobj=[Nobj;Mobj];
           [~,~,Pareto]=QuickSortDD(Allobj);
           Mpop = Allpop(Pareto(1:N,2),:);
           Mobj = Allobj(Pareto(1:N,2),:);
           Npop = Allpop(setxor((1:pop),Pareto(5:N+4,2)),:);
           Nobj = Allobj(setxor((1:pop),Pareto(5:N+4,2)),:);
            %% 画每一代种群目标空间分布图
            disp(['iteration = ', num2str(g), ' best classfication error = ', num2str(Z(1,2))]);
% figure(2)
% % scatter(Nobj(:,1),Nobj(:,2),'r');
% % hold on
% scatter(Mobj(:,1),Mobj(:,2),'b');
end
          Allpop=[Npop;Mpop];
          Allobj=[Nobj;Mobj];