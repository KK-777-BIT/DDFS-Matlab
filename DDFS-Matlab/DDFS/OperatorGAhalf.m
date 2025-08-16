function Offspring = OperatorGAhalf(Parent,D)
%OperatorGAhalf - Crossover and mutation operators of genetic algorithm.

        [proC,disC,proM,disM] = deal(1,20,1,20);

    Parent1 = Parent(1:floor(end/2),:);
    Parent2 = Parent(floor(end/2)+1:floor(end/2)*2,:);
    [N,D]   = size(Parent1);

            %% Genetic operators for binary encoding
            % Uniform crossover
            k = rand(N,D) < 0.5;
            k(repmat(rand(N,1)>proC,1,D)) = false;
            Offspring    = Parent1;
            Offspring(k) = Parent2(k);
            % Bit-flip mutation
            Site = rand(N,D) < proM/D;
            Offspring(Site) = ~Offspring(Site);
     
end