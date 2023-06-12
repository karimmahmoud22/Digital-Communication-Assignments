function deq_val = UniformDequantizer(q_ind, n_bits, xmax, m)
    L = 2^n_bits; % number of quantization intervals
    delta = (2*xmax)/L; % width of each quantization interval
    %disp(['delta : ', num2str(delta)]);
    %q_levels = linspace((delta/2 - xmax) , (-delta/2 + xmax), L) + m*delta/2;
    q_levels = (-xmax + m*delta/2): delta : (xmax + m*delta/2);
    %disp(['Levels : ', num2str(q_levels)]);
    deq_val = zeros(size(q_ind), 'double');
    for i = 1:length(q_ind) 
     deq_val(i) = q_levels(q_ind(i));
    end
end