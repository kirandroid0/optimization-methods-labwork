function hh = constraint(X)
%CONSTRAINT Keep points that satisfy the LP inequalities.
%   X is an N-by-2 matrix with columns [x1, x2].
%   hh contains only feasible rows.

x1 = X(:,1);
x2 = X(:,2);

% Constraints are of the form A*x <= b.
cons1 = x1 + 2.*x2 - 2000;
cons2 = x1 + x2 - 1500;
cons3 = x2 - 600;

viol1 = find(cons1 > 1e-5);
viol2 = find(cons2 > 1e-5);
viol3 = find(cons3 > 1e-5);
viol_neg1 = find(x1 < -1e-5);
viol_neg2 = find(x2 < -1e-5);

invalid_rows = unique([viol1; viol2; viol3; viol_neg1; viol_neg2]);

X(invalid_rows, :) = [];
hh = X;
end
