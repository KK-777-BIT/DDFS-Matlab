function Offspring = OperatorGA(Parent,D)
%OperatorGA - Crossover and mutation operators of genetic algorithm.

        [proC,disC,proM,disM] = deal(1,20,1,20);

    Parent1 = Parent(1:floor(end/2),:);
    Parent2 = Parent(floor(end/2)+1:floor(end/2)*2,:);
    [N,D]   = size(Parent1);

            %% Genetic operators for binary encoding
            % Uniform crossover
            k = rand(N,D) < 0.5;
            k(repmat(rand(N,1)>proC,1,D)) = false;
            Offspring1    = Parent1;
            Offspring2    = Parent2;
            Offspring1(k) = Parent2(k);
            Offspring2(k) = Parent1(k);
            Offspring     = [Offspring1;Offspring2];
            % Bit-flip mutation
            Site = rand(2*N,D) < proM/D;
            Offspring(Site) = ~Offspring(Site);
end