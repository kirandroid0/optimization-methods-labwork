format short;
clear;
clc;

C = [3 5];

a = [1 2;
     1 1;
     0 1];

b = [2000;
     1500;
     600];

y1 = 0:1:max(b);  % x1-axis values

%% Calculate x2 for each constraint boundary
x21 = (b(1) - a(1,1).*y1) ./ a(1,2);
x22 = (b(2) - a(2,1).*y1) ./ a(2,2);
x23 = (b(3) - a(3,1).*y1) ./ a(3,2);

%% Plot constraint boundaries
figure;
plot(y1, x21, "r", y1, x22, "b", y1, x23, "k");
xlabel('x1');
ylabel('x2');
title('Constraint boundaries');
legend("x1 + 2x2 = 2000", "x1 + x2 = 1500", "x2 = 600", ...
       "Location", "best");
grid on;
hold on;

%% Axis intercepts
cx1 = find(y1 == 0, 1);
c1 = find(x21 == 0, 1);
c2 = find(x22 == 0, 1);
c3 = find(x23 == 0, 1);

Line1 = [y1([c1 cx1]); x21([c1 cx1])]';
Line2 = [y1([c2 cx1]); x22([c2 cx1])]';
Line3 = [y1([c3 cx1]); x23([c3 cx1])]';

corpt = unique([Line1; Line2; Line3], 'rows');

%% Pairwise intersections of constraint boundaries
hg = [0; 0];

for i = 1:size(a, 1)
    hg1 = a(i,:);
    b1 = b(i);

    for j = i+1:size(a, 1)
        hg2 = a(j,:);
        b2 = b(j);

        Aa = [hg1; hg2];
        Bb = [b1; b2];

        if abs(det(Aa)) > 1e-10
            Xx = Aa \ Bb;
            hg = [hg, Xx]; %#ok<AGROW>
        end
    end
end

pt = hg';
allpt = [pt; corpt];
points = unique(allpt, 'rows');

%% Filter candidate points for feasibility
PT = constraint(points);
PT = unique(PT, 'rows');

if isempty(PT)
    error('No feasible corner points were found.');
end

%% Evaluate objective function
Fx = zeros(size(PT, 1), 1);
for i = 1:size(PT, 1)
    Fx(i) = sum(PT(i,:) .* C);
end

Vert_Fxn = [PT Fx];

%% Find and display optimum
[fxval, indfx] = max(Fx);
optval = Vert_Fxn(indfx, :);

optimal_bfs = array2table(optval, ...
    'VariableNames', {'x1', 'x2', 'Max_Z'});

disp('--- OPTIMAL SOLUTION ---');
disp(optimal_bfs);

%% Mark feasible points and optimum
plot(PT(:,1), PT(:,2), 'ko', ...
    'MarkerSize', 8, 'MarkerFaceColor', 'g');
plot(optval(1), optval(2), 'rp', ...
    'MarkerSize', 12, 'MarkerFaceColor', 'r');
