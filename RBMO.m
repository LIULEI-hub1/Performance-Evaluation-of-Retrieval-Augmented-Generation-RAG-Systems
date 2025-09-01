function [BestValue, Xfood, Conv] = RBMO(N, T, Xmin, Xmax, D, fobj)
    % Initialize the relevant parameters
    Xfood = zeros(1, D);
    BestValue = inf;
    Conv = zeros(1, T);
    fitness = inf(N, 1);
    FES = 0;
    Epsilon = 0.5;
    
    X = initialization(N, D, Xmax, Xmin);
    
    X_old = X;
    for i = 1:N
        fitness_old(i, 1) = fobj(X_old(i, :)');
    end
  
    t = 1; % Start of the main loop
    
    while t < T+1
        % Search for food
        for i = 1:N
            % Randomly select 2 to 5 red-billed blue magpies
            p = randi([2, 5]);
            selected_index_p = randperm(N, p);
            Xp = X(selected_index_p, :);
            Xpmean = mean(Xp);

            % Randomly select 10 to N red-billed blue magpies
            q = randi([10, N]);
            selected_index_q = randperm(N, q);
            Xq = X(selected_index_q, :);
            Xqmean = mean(Xq);

            A = randperm(N);
            R1 = A(1);
            if rand < Epsilon
                X(i, :) = X(i, :) + (Xpmean - X(R1, :)) .* rand; % Eq. (3)
            else
                X(i, :) = X(i, :) + (Xqmean - X(R1, :)) .* rand; % Eq. (4)
            end
        end
        
        % Boundary handling
        X = boundaryCheck(X, Xmin, Xmax);
        
        for i = 1:N
            fitness(i, 1) = fobj(X(i, :)');
            if fitness(i, 1) < BestValue
                BestValue = fitness(i, 1);
                Xfood = X(i, :);
            end
            FES = FES + 1;
        end
        
        % Food storage
        [fitness, X, fitness_old, X_old] = Food_storage(fitness, X, fitness_old, X_old); % Eq. (7)
        
        CF = (1 - t / T)^(2 * t / T);
        
        % Exploitation
        for i = 1:N
            % Randomly select 2 to 5 red-billed blue magpies
            p = randi([2, 5]);
            selected_index_p = randperm(N, p);
            Xp = X(selected_index_p, :);
            Xpmean = mean(Xp);

            % Randomly select 10 to N red-billed blue magpies
            q = randi([10, N]);
            selected_index_q = randperm(N, q);
            Xq = X(selected_index_q, :);
            Xqmean = mean(Xq);

            if rand() < Epsilon
                X(i, :) = Xfood + CF * (Xpmean - X(i, :)) .* randn(1, D); % Eq. (5)
            else
                X(i, :) = Xfood + CF * (Xqmean - X(i, :)) .* randn(1, D); % Eq. (6)
            end
        end

        % Boundary handling
        X = boundaryCheck(X, Xmin, Xmax);

        for i = 1:N
            fitness(i, 1) = fobj(X(i, :)');
            if fitness(i, 1) < BestValue
                BestValue = fitness(i, 1);
                Xfood = X(i, :);
            end
            FES = FES + 1;
        end

        
        [fitness, X, fitness_old, X_old] = Food_storage(fitness, X, fitness_old, X_old); % Eq. (7)
        
        Conv(t) = BestValue;
        t = t + 1;
    end
end





