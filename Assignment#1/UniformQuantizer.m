function q_ind = UniformQuantizer(in_val, n_bits, xmax, m)
    L = 2^n_bits; % number of quantization intervals
    delta = (2*xmax) /L; % width of each quantization interval
    %disp(['delta : ', num2str(delta)]);
    %q_levels = linspace((delta/2 - xmax) , (-delta/2 + xmax), L) + m*delta/2;
    q_levels = (m*delta/2 - xmax): delta : (m*delta/2 + xmax);
    %disp(['Levels : ', num2str(q_levels)]);
    q_ind = zeros(size(in_val), 'int32'); % initialize quantized indices
    for i = 1:length(in_val)
    % find the closest reconstruction level to the input sample
        [~, q_ind(i)] = min(abs(in_val(i) - q_levels));
    end
end