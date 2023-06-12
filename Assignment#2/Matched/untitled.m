% define the filter length
L = 10;

% define the matched filter
h = fliplr(1:L)/L;

% normalize the filter to have unit energy
h1 = h/sqrt(sum(h.^2));

% plot the filter
figure();
plot(h1);
xlabel('Filter tap');
ylabel('Amplitude');
title('Matched Filter with Unit Energy');