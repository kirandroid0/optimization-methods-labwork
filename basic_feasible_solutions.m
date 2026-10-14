format short;
clear;
clc;

%% Parameters
C = [3 5];
a = [1 2; 1 1; 0 1];
b = [2000; 1500; 600];

%% Convert to standard form
[m, n_dec] = size(a);       % m = 3 constraints, n_dec = 2 decision variables
A = [a eye(m)];             % Augmented constraint matrix (3x5)
c_ext = [C zeros(1, m)];    % Augmented cost vector (1x5)

n = size(A, 2);             % Total variables = 5

%% Generate basic solutions
if n >= m
    nv = nchoosek(n, m);
    t = nchoosek(1:n, m);   % Variable index combinations
    sol = [];

    for i = 1:nv
        basic_cols = t(i, :);
        B_mat = A(:, basic_cols);

        if abs(det(B_mat)) > 1e-10
            x_basic = B_mat \ b;

            % Non-negativity condition
            if all(x_basic >= -1e-5)
                y = zeros(n, 1);
                y(basic_cols) = x_basic;
                sol = [sol, y]; %#ok<AGROW>
            end
        end
    end
else
    error("Number of constraints cannot exceed total variables.");
end

%% Compute objective values
objFunc = c_ext * sol;

%% Find optimal solution
[maxValue, idx] = max(objFunc);
optimalSolution = sol(:, idx);

%% Display results
fprintf('Feasible Basic Solutions Matrix (Rows: x1, x2, s1, s2, s3):\n');
disp(sol);

fprintf('Optimal Solution:\n');
fprintf('x1 = %.2f\n', optimalSolution(1));
fprintf('x2 = %.2f\n', optimalSolution(2));
fprintf('s1 = %.2f\n', optimalSolution(3));
fprintf('s2 = %.2f\n', optimalSolution(4));
fprintf('s3 = %.2f\n', optimalSolution(5));

fprintf('\nMaximum Objective Function Value: %.2f\n', maxValue);
