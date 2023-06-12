% Req - 1
disp("Req - 1");
in_val = [0.5, 1.2, -0.3, 2.1];
n_bits = 3;
xmax = 2;
m = 0;
q_ind = UniformQuantizer(in_val, n_bits, xmax, m) ;
disp(q_ind);



% Req - 2

disp("Req - 2");
deq_val = UniformDequantizer(q_ind , n_bits, xmax, m);
%disp(deq_val);



disp("Req - 3");
x = -6:0.01:6;
y = x;

n_bits = 3;
xmax = 6;
m = 0;
q_ind_0 = UniformQuantizer(x, n_bits, xmax, 0) ;  %midrise
%disp(q_ind_0);

q_ind_1 = UniformQuantizer(x, n_bits, xmax, 1) ;  %midrate
%disp(q_ind_1);


deq_val_0 = UniformDequantizer(q_ind_0 , n_bits, xmax, 0);
%disp(deq_val_0);

deq_val_1 = UniformDequantizer(q_ind_1 , n_bits, xmax, 1);
%disp(deq_val_1);


plot(x, y)
hold on
plot(x, deq_val_0)
xlabel('')
ylabel('')
title('Original && Midrise')

figure

plot(x, y)
hold on
plot(x, deq_val_1)
xlabel('')
ylabel('')
title('Original && Midrate')
figure


% Req - 4


a = -5;   % lower bound of the uniform distribution
b = 5;    % upper bound of the uniform distribution
n = 10000;  % number of random variables to generate

% generate n i.i.d. uniform random variables between a and b
x = (b-a).*rand(n,1) + a;
y = x;

n_bits = 2:1:8;
xmax = 5;
m = 0;

simulated_snr = n_bits;    % intial value for the two arrays
theo_snr = zeros(size(n_bits));


L = 2 .^ n_bits;

P = mean(x .^ 2);

for i = 1:length(n_bits)
    q_ind_0 = UniformQuantizer(x, n_bits(i), xmax, m) ;  %midrise
    deq_val_0 = UniformDequantizer(q_ind_0 , n_bits(i), xmax, m);

    q_error = x - deq_val_0;

    simulated_snr(i) = 10*log10(mean(x .^ 2) / mean(q_error .^ 2));
    
    theo_snr(i) = 10 * log10(P / (((xmax) .^ 2) / (3 * ((L(i) .^ 2)))));

end

%disp(simulated_snr);
%disp(theo_snr);

plot(n_bits, theo_snr, 'r-', n_bits, simulated_snr, 'bo');
xlabel('n-bits')
ylabel('SNR')
title('Req-4 : simulated & actual SNR')
figure

    

% Req - 5

rng('default');
n = 10000;
sign = 2 * randi([0 1], 1, n) - 1; % +/- with probability 0.5
magnitude = exprnd(1, 1, n); % Exponential distribution
x = sign .* magnitude;
n_bits = 2:1:8;
xmax = max(abs(x));
m = 0;

simulated_snr = n_bits;    % intial value for the two arrays
theo_snr = zeros(size(n_bits));
L = 2 .^ n_bits;
P = mean(x .^ 2);

for i = 1:length(n_bits)
    q_ind_0 = UniformQuantizer(x, n_bits(i), xmax, m) ;  %midrise
    deq_val_0 = UniformDequantizer(q_ind_0 , n_bits(i), xmax, m);
    
    
    q_error = x - deq_val_0;
    simulated_snr(i) = 10*log10(mean(x .^ 2) / mean(q_error .^ 2));
    theo_snr(i) = 10 * log10(P / (((xmax) .^ 2) / (3 * ((L(i) .^ 2)))));
end
plot(n_bits, theo_snr, 'r-', n_bits, simulated_snr, 'bo');
xlabel('n-bits')
ylabel('SNR')
title('Req-5 : simulated & actual SNR')
figure
hold on

% Req - 6
mue = [0 ,5, 100, 200];

color = ['r' , 'b' ,   'g' ,  'k'];
arr_plot = [0 , 0 , 0 , 0 , 0 , 0 , 0 , 0];


for j = 1:length(mue)
    
    simulated_snr = n_bits;    % intial value for the two arrays
    theo_snr = zeros(size(n_bits));
   
    for i = 1:length(n_bits)
        
        xmax = max(abs(x));
        x_norm=x/xmax;
        
        if (mue(j) > 0)
        y = sign .* (log(1+mue(j)*abs(x_norm))/log(1+mue(j)));
        else
            disp("Entered - 1");
            y = x_norm;
        end
        
        ymax = max(abs(y));
        
        q_ind_0 = UniformQuantizer(y, n_bits(i), ymax, m) ;  %midrise
        deq_val_0 = UniformDequantizer(q_ind_0 , n_bits(i), ymax, m);

        if (mue(j) > 0)
        z = sign .*(((1+mue(j)).^abs(deq_val_0)-1)/mue(j));
        else
            disp("Entered - 2");
        z =  deq_val_0;
        end
        de_comp = z * xmax;
        
        q_error = abs(x - de_comp);
        simulated_snr(i) = 10*log10(mean(x .^ 2) / mean(q_error .^ 2));
        
        if (mue(j) > 0)
        theo_snr(i) = 10 * log10 ((3*(L(i) .^ 2))/((log(1 + mue(j))) .^ 2));
        else
            theo_snr(i) = 10 * log10(P / (((xmax) .^ 2) / (3 * ((L(i) .^ 2)))));
        end
    end
    arr_plot(j) = plot(n_bits, theo_snr,  sprintf('%s-' , color(j))  , 'LineWidth', 1); % Plot theoretical SNR versus number of bits
    arr_plot(j + 1) = plot(n_bits, simulated_snr, sprintf('%s--' , color(j)) , 'LineWidth', 1); % Plot simulated SNR versus number of bits
    
   
 
end    

disp(length(arr_plot));


legend('theo & mue = 0', 'sim & mue = 0', 'theo & mue = 5', 'sim & mue = 5', 'theo & mue = 100', 'sim & mue = 100', 'theo & mue = 200', 'sim & mue = 200');



