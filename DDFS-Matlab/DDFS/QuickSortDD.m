function [FrontNo,MaxFront,Pareto]= QuickSortDD(PopObj)
% quick sort
% Some discussions about MOGAs: individual relations, non-dominated set,
% and application on automatic negotiation

% 输入：PopObj 每一行为一个个体，每一列为一个目标值
% 输出：Pareto 第一列为Pareto的Rank，第二列为对应的原索引，其它列为目标值

% Copyright：2016-2017 Ye Tian and 2021 Sebastian

%     tic
    [N,M]    = size(PopObj);
    FrontNo  = inf(1,N);
%     nCompare = 0;
    MaxFront = 0;
    while sum(FrontNo<inf) < N
        MaxFront = MaxFront + 1;
        Remain   = find(FrontNo==inf);
        t = length(Remain);
        i = 1;
        j = t;
        while i <= j
            ndsign = true;
            while i < j
                while i < j
                    domi = 0;
                    for m = 1 : M
                        if PopObj(Remain(i),m) < PopObj(Remain(j),m)
                            if domi == -1
                                domi = 0;
                                break;
                            else
                                domi = 1;
                            end
                        elseif PopObj(Remain(i),m) > PopObj(Remain(j),m)
                            if domi == 1
                                domi = 0;
                                break;
                            else
                                domi = -1;
                            end
                        end
                    end
%                     nCompare = nCompare + m;
                    if domi ~= 1
                        break;
                    else
                        j = j - 1;
                    end
                end
                p         = Remain(i);
                Remain(i) = Remain(j);
                Remain(j) = p;
                while i < j
                    domi = 0;
                    for m = 1 : M
                        if PopObj(Remain(j),m) < PopObj(Remain(i),m)
                            if domi == -1
                                domi = 0;
                                break;
                            else
                                domi = 1;
                            end
                        elseif PopObj(Remain(j),m) > PopObj(Remain(i),m)
                            if domi == 1
                                domi = 0;
                                break;
                            else
                                domi = -1;
                            end
                        end
                    end
%                     nCompare = nCompare + m;
                    if domi == -1
                        ndsign = false;
                    end
                    if domi == 1
                        break;
                    else
                        i = i + 1;
                    end
                end
                p         = Remain(i);
                Remain(i) = Remain(j);
                Remain(j) = p;
            end
            if ndsign
                FrontNo(Remain(i)) = MaxFront;
            end
            j = i - 1;
            i = 1;
        end
    end
    Pareto=sortrows([FrontNo',(1:N)',PopObj],1);
    a=Pareto(:,2);
    a(:,2)=Pareto(:,1);
    b = sortrows(a);
    FrontNo=b(:,2);
    %     time = toc;
end