function [optimal_point, num_calls] = NewtonOptimization()

    % Initial guess
    x_old = [2; 4];
    
    % Relaxation factor
    relaxation_factor =0.2;
    
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
        
        % Newton's optimization method
        while true
            % Calculate gradient and Hessian analytically
            grad = [exp(x(1)) + 4*x(1) + 2*x(2); exp(x(2)) + 2*x(1) + 2*x(2)];
            hessian = [exp(x(1)) + 4, 2; 2, exp(x(2)) + 2];
            
            % Check convergence
            delta_x = -inv(hessian) * grad;
            if norm(delta_x) < precision
                break;
            end
            
            % Update the guess using Newton's method
            x = x + relaxation_factor * delta_x;
            
            % Increment iteration count
            num_iter = num_iter + 1;
        end
        
        % Round the optimal point to the specified number of decimal places
        decimal_places = getDecimalPlaces(precision);
        optimal_point(i, :) = round(x, decimal_places);
        
        % Store the number of function calls
        num_calls(i) = num_iter;
        
        % Print the final solution
        fprintf('Optimal Point (precision %g): %.*f, %.*f\n', precision, decimal_places, optimal_point(i, 1), decimal_places, optimal_point(i, 2));
    end

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
