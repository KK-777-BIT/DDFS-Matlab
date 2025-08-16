clear;clc;
Time=[];
load obj_test11.mat;
Time=[Time,HV];
load obj_test12.mat;
Time=[Time,HV];
load obj_test13.mat;
Time=[Time,HV];
load obj_test14.mat;
Time=[Time,HV];
load obj_test15.mat;
Time=[Time,HV];
load obj_test16.mat;
Time=[Time,HV];
load obj_test17.mat;
Time=[Time,HV];
load obj_test18.mat;
Time=[Time,HV];
load obj_test19.mat;
Time=[Time,HV];
load obj_test20.mat;
Time=[Time,HV];
a=mean(Time);
b=std(Time);
        mean_value = a;
        std_value = b;
fid = fopen('TCHV.txt','w');
for j = 1:size(Time,1)
            fprintf(fid ,'%8.2e', mean_value(j));
            fprintf(fid ,'%s', '±');
            fprintf(fid ,'%8.2e', std_value(j));
            fprintf(fid ,'\r\n');
end
fclose(fid);

MFFS=Time;
load result.mat;
MT = HVZ;
% load('MT.mat');
xx =MT;
for i= 1:1
    clear x
    if i ==1
        x= MFFS;
        mean_value = mean(x,2);
        std_value = std(x,[],2);
        y = x;
            end

    if  i ==1
        fid = fopen('DUIBI_HV.txt','w');
    end
    better = 0;
    bad = 0;
    equal =0;
    for j= 1:size(xx,1)
        if sum(isnan(xx(j,:)))==0 && sum(isnan(y(j,:)))>0
            h(j) = 1;
            re(j,1) = '-';
            bad= bad+1;
        elseif sum(isnan(xx(j,:)))>0 && sum(isnan(y(j,:)))==0
            h(j) = 1;
            re(j,1) = '+';
            better = better +1;
        elseif sum(isnan(xx(j,:)))>0 && sum(isnan(y(j,:)))>0
            h(j) = 0;
            re(j,1)='=';
            equal=equal+1;
        else
            [p(j),h(j)] = ranksum(xx(j,:),y(j,:),0.05);
            if h(j) ==1
                if mean(xx(j,:)) < mean(y(j,:))
                    re(j,1)  = '-';
                    bad= bad+1;
                else
                    re(j,1)  = '+';
                    better= better+1;
                end
            else
                re(j,1)  = '=';
                equal=equal+1;
            end
        end
    end
    
    
    if i ~= 7

        for j = 1:size(xx,1)
            fprintf(fid ,'%8.2e', mean_value(j,1));
            fprintf(fid ,'%s', '±');
            fprintf(fid ,'%8.2e', std_value(j,1));
            fprintf(fid ,'(');
            fprintf(fid ,'%s',re(j));
            fprintf(fid ,')\r\n');
        end
    else
        for j = 1:17
            fprintf(fid ,'%8.2e', mean_value(j,1));
            fprintf(fid ,'%s', '±');
            fprintf(fid ,'%8.2e', std_value(j,1));
            %             fprintf(fid ,'(');
            %             fprintf(fid ,'%s',re(j));
            fprintf(fid ,'\r\n');
        end
    end
    fprintf(fid ,'%d/%d/%d',better,equal,bad);
    fclose(fid);
    
end

        x= MT;
        mean_value = mean(x,2);
        std_value = std(x,[],2);
        y = x;
fid = fopen('HV_MT.txt','w');
for j = 1:size(x,1)
            fprintf(fid ,'%8.2e', mean_value(j));
            fprintf(fid ,'%s', '±');
            fprintf(fid ,'%8.2e', std_value(j));
            fprintf(fid ,'\r\n');
end
fclose(fid);