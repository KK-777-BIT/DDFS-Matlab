       function [rnvec,obj] = initialize(pop,D,train_F,train_L)
           rnvec = zeros(pop, D);
            k = randi(D, [pop,1]);
            for i=1:pop
             h = randperm(D, k(i));  
             rnvec(i, h) = 1;
            end
            parfor i=1:pop
             obj(i,:) = knn(rnvec(i, :),train_F, train_L,D); 
            end
       end