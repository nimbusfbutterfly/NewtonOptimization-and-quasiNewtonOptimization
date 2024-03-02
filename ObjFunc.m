function [y] = ObjFunc(X)
y = exp(X(1)) + exp(X(2)) + 2*X(1)^2 + 2 * X(1) * X(2) + X(2)^2;