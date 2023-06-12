

samples = 52;
t= linspace(0, 1, samples);
s1 = zeros(1, samples);
s2 = zeros(1, samples);

s1(t<=1) = 1;
s2(t>0.75) = -1;
s2(t<=0.75) = 1;

figure(1);
stairs(t, s1, 'LineWidth', 2);
axis([0 1 -1.75 1.4]);
title('Signal s1');

figure(2);
stairs(t, s2, 'LineWidth', 2);
axis([0 1 -1.75 1.4]);
title('Signal s2');

A = [s1; s2];
[phi1, phi2] = GM_Bases(s1, s2);


time = linspace(0, 1, length(phi1));
figure(3);
% Make Line width 2
stairs(time, phi1*sqrt(samples), 'LineWidth', 2);
axis([0 1.2 -1.75 1.4]);
xlabel('Time');
ylabel('phi1');
title('Plot of phi1 against time');


figure(4);
stairs(time, phi2*sqrt(samples), 'LineWidth', 2);
axis([0 1.2 -1.75 1.4]);
xlabel('Time');
ylabel('phi2');
title('Plot of phi2 against time');

% test Signal spcae 
[s1_1, s1_2] = signal_space(s1, phi1, phi2);
disp("Projection of s1 over phi1: ");
disp(s1_1);
disp("Projection of s1 over phi2:: ");
disp(s1_2);
figure(5)
scatter(s1_1, s1_2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[s2_1, s2_2] = signal_space(s2, phi1, phi2);
disp("Projection of s2 over phi1: ");
disp(s2_1);
disp("Projection of s2 over phi2: ");
disp(s2_2);
figure(6)
scatter(s2_1, s2_2);


%%%%%%%%%%%%%%%%%%%% noise %%%%%%%%%%%%%%%%%%%%
% Generate samples of 𝑟1(𝑡) and 𝑟2(𝑡) using s1(t) & s2(t) in Figure 1.1 and random noise samples (for example 50 or 100 sample).
% Plot the received signals 𝑟1(𝑡) and 𝑟2(𝑡) in the same figure.

% Generate the received signals
r1_1 = noise(s1, -5);
r1_2 = noise(s1, 0);
r1_3 = noise(s1, 10);

r2_1 = noise(s2, -5);
r2_2 = noise(s2, 0);
r2_3 = noise(s2, 10);

% % Plot the received signals
% figure(5);
% % Scatter plot should have x and y
% scatter(r1_1, r2_1, 'filled', 'r');
% title('Received signal r1');

% figure(8);
% % scatter(r2_1);
% title('Received signal r2');


% Create scatter plot
% figure;
% hold on;
% plot(phi1, phi2, 'k')
% % Plot r1_1 with blue markers
% scatter(s1, r1_1, 'Marker', 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b');
% % Plot r2_1 with red markers
% scatter(s2, r2_1, 'Marker', 'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r');

% % Customize the plot
% xlabel('Phi1');
% ylabel('Phi2');
% title('Scatter Plot');
% legend('r1_1', 'r2_1');

% hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Gramm Schmitt %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs:
% s1, s2: two 1xN vectors that represent the input signals
% Outputs:
% phi1, phi2: two 1xN vectors that represent the two orthonormal bases functions (using Gram-Schmidt)
function [phi1, phi2] = GM_Bases(s1, s2)

% Energy of the input signals
E1 = sum(s1.^2);
E2 = sum(s2.^2);

% Check the size of the input signals
if length(s1) ~= length(s2)
    error('The length of the input signals must be the same.');
end

% Initialize phi1 and phi2 as zero vectors
phi1 = zeros(1, length(s1));
phi2 = zeros(1, length(s2));

% Calculate phi1
phi1 = s1 / norm(s1);

% Calculate s2_1
s2_1 = dot(s2, phi1); 
% Calculate phi2
% orthogonalize s2 with respect to phi1
g2 = s2 - s2_1 * phi1; 

% calculate the dot of g2
EG_2 = dot(g2,g2);


% normalize g2 to obtain phi2
phi2 = g2 / norm(g2); 


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% signal_space Representation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs:
% s: a 1xN vector that represents the input signal
% phi1, phi2: two 1xN vectors that represent the orthonormal bases functions
% Outputs:
% v1, v2: the projections (i.e. the correlations) of s over phi1 and phi2 respectively.
function [v1, v2] = signal_space(s, phi1, phi2)
% Calculate the projections of s onto phi1 and phi2
v1 = dot(s, phi1);
v2 = dot(s, phi2);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% noise %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs:
% s: a 1xN vector that represents the input signal
% sigma2: the variance of the additive white Gaussian noise
% Outputs:
% r: a 1xN vector that represents the received signal
function r = noise(s, Eb_over_N0)

Eb = 1; % Energy per bit  
% Calculate the noise variance  
N0=Eb/(10^(Eb_over_N0/10));
sigma2=N0/2;


% Generate the noise
w = sqrt(sigma2) * randn(1, length(s));

% Add the noise to the input signal
r = s + w;

end


%{
4. How does the noise affect the signal space? Does the noise effect increase or decrease with increasing 𝜎2 ?
The presence of additive white Gaussian noise (AWGN) affects the signal space by adding a random component to the signal 
that is uncorrelated with the original signal.
his results in a spreading of the signal in the signal space,
which can make it more difficult to distinguish between different signals.

The effect of noise on the signal space increases with increasing variance (𝜎^2) of the noise.
This is because a higher variance means that the noise has a greater effect on the signal,
making it more difficult to distinguish between different signals. As the noise variance increases,
the signal space expands and becomes more diffuse, making it more difficult to accurately represent and detect the original signal.

To better understand the effect of noise on the signal space,
consider the case of binary signaling, where a signal is represented by one of two possible values (+1 or -1).
If the signal is transmitted over an AWGN channel, the received signal will be corrupted by noise,
resulting in a noisy version of the original signal. The signal space for this case is a two-dimensional space spanned by
the two possible signal values.

As the noise variance increases,
the noise spreads out the received points in the signal space,
making it more difficult to distinguish between the original points.
This can result in errors in signal detection and decoding, and can reduce the overall performance of the communication system.

In summary, the AWGN affects the signal space by spreading out the signal points and making it more difficult to distinguish
between different signals. The effect of noise increases with increasing variance,
leading to a more diffuse and difficult-to-distinguish signal space.
%}