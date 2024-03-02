function [optimal_point, num_calls] = quasiNewtonOptimization()

    % Initial guess
    x_old = [4; 2];
    
    % Relaxation factor
    relaxation_factor = 0.2; % You can adjust this value
    
    % Precisions for gradient vector
    precisions = [1e-4, 1e-8, 1e-12];
    
    % Initialize output variables
    optimal_point = zeros(length(precisions), 2);
    num_calls = zeros(length(precisions), 1);
    
    for i = 1:length(precisions)
        % Reset parameters
        x = x_old;
        precision = precisions(i);
        num_iter = 0;
        
        % Initialize Hessian matrix (identity matrix)
        Hessian = eye(length(x));
        
        % Quasi-Newton method
        while true
            % Call the objective function
            f = ObjFunc(x); % Replace objfunc with your actual objective function
            
            % Calculate gradient analytically
            grad = calculateGradient(x);
            
            % Check convergence
            if norm(grad) < precision
                break;
            end
            
            % Update the guess using quasi-Newton method
            delta_x = -Hessian * grad;
            x_new = x + relaxation_factor * delta_x;
            
            % Call the objective function for the new point
            f_new = ObjFunc(x_new); % Replace objfunc with your actual objective function
            
            % Update Hessian matrix using BFGS formula
            q = x_new - x;
            s = relaxation_factor * delta_x;
            Hessian = Hessian + (q*q') / (q'*s) - (Hessian*s*s'*Hessian) / (s'*Hessian*s);
            
            % Update variables
            x = x_new;

            % Increment iteration count
            num_iter = num_iter + 1;
        end
        
        % Store the optimal point
        optimal_point(i, :) = x;
        
        % Store the number of function calls
        num_calls(i) = num_iter;
        
        % Determine decimal places based on the precision
        decimal_places = getDecimalPlaces(precision);
        
        % Print the final solution with the specified decimal places
        fprintf(['Optimal Point (precision %g): %.', num2str(decimal_places), 'f, %.', num2str(decimal_places), 'f\n'], precision, x(1), x(2));
    end

end

function grad = calculateGradient(x)
    % Calculate gradient analytically
    grad = [exp(x(1)) + 4*x(1) + 2*x(2); exp(x(2)) + 2*x(1) + 2*x(2)];
end

function decimal_places = getDecimalPlaces(precision)
    % Determine decimal places based on the tolerance
    if precision == 1e-4
        decimal_places = 4;
    elseif precision == 1e-8
        decimal_places = 8;
    elseif precision == 1e-12
        decimal_places = 12;
    else
        decimal_places = 4; % Default to 4 decimal places
    end
end
