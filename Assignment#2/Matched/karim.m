number_of_bits = 1000;
number_of_samples = 10;
A = 1;
Eb = 1;
N0 = 20;

data_size = [1, number_of_bits]; 

% generate the required array 
data = randi([0, 1], data_size);

% mapping logic zero to -1 and logic 1 to 1 
data_mapped = (2 * data - 1) * A;
disp(data_mapped)

% create an array of 10x the length of the data mapped array
% fill it with the data mapped array but with 10x the number of samples (10 samples per bit)
% reshape the array to be 10x the length of the data mapped array
upsampling_factor = 10;
data_upsampled = reshape(repmat(data_mapped, upsampling_factor, 1), 1, []);
%disp(data_upsampled)
%figure(1);
%plot(data_upsampled);

%Just a declaaration of the noise array
data_noise = awgn(data_upsampled, N0 / 2);

% Generate noise sequence
noise_rand = randn(size(data_upsampled));

% Filters

% first:
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

%h1 = ones(1, upsampling_factor);
%figure();
%plot(h1)

% second:
h2 = zeros(1, upsampling_factor);
h2(upsampling_factor/2) = 1;
figure();
plot(h2)

% third:
base = 1;
height = sqrt(3);
t = 0:1:base;
% Create a right-angled triangle with the height at x = 1
h3 = height * t;
figure();
plot(h3)



%% DECLARATIONS
matched_filter_output1 = zeros(1, 8);
matched_filter_output2 = zeros(1, 8);
matched_filter_output3 = zeros(1, 8);

sampled_bits1 = ones (1 , number_of_bits);
sampled_bits2 = ones (1 , number_of_bits);
sampled_bits3 = ones (1 , number_of_bits);


decoded_bits1 = ones (1 , number_of_bits);
decoded_bits2 = ones (1 , number_of_bits);
decoded_bits3 = ones (1 , number_of_bits);

BER_matched_cases1 = zeros(1, 8);
BER_matched_cases2 = zeros(1, 8);
BER_matched_cases3 = zeros(1, 8);
BER_theoretical = zeros(1, 8);
% BER_theoretical2 = zeros(1, 31);
% BER_theoretical3 = zeros(1, 31);

counter = 1;
Error_num_matched = 0;
Error_num_matched2 = 0;
Error_num_matched3 = 0;


for Eb_over_N0 =-2:5
    
    N0=Eb/(10^(Eb_over_N0/10));
    noise = noise_rand*sqrt(N0/2);
    data_noise = data_upsampled + noise;
    %data_noise = awgn(data_upsampled, Eb_over_N0);
    % Convolution
    % matched_filter_output1(counter) = conv(data_noise, h1);
    out1 = conv(data_noise, h1);
    out2 = conv(data_noise, h2);
    out3 = conv(data_noise, h3);

    %figure(5);
    %plot(out2);
    disp('out2');
    disp(out2);
    counter2 =1;
    %Sampling
    for i=10:upsampling_factor:number_of_bits*upsampling_factor
        sampled_bits1(counter2)=out1(i);
        sampled_bits2(counter2)=out2(i);
        sampled_bits3(counter2)=out3(i);
        counter2=counter2+1;
    end
    disp('sampled bits');
    disp(sampled_bits2);

    %Decoding
    for i=1:number_of_bits
        if sampled_bits1(i)>0
            decoded_bits1(i)=1;
        else
            decoded_bits1(i)=0;
        end
        if sampled_bits2(i)>0
            decoded_bits2(i)=1;
        else
            decoded_bits2(i)=0;
        end
        if sampled_bits3(i)>0
            decoded_bits3(i)=1;
        else
            decoded_bits3(i)=0;
        end
    end
    disp('decoded bits');
    disp(decoded_bits2);

    disp('data');
    disp(data);
    
    for j=1:number_of_bits
        if(decoded_bits1(j)~=data(j))
        Error_num_matched=Error_num_matched+1;
        end
        if(decoded_bits2(j)~=data(j))
        Error_num_matched2=Error_num_matched2+1;
        end
        if(decoded_bits3(j)~=data(j))
        Error_num_matched3=Error_num_matched3+1;
        end

    end
    BER_matched_cases1(counter)=Error_num_matched/number_of_bits;
    BER_matched_cases2(counter)=Error_num_matched2/number_of_bits;
    BER_matched_cases3(counter)=Error_num_matched3/number_of_bits;
    Error_num_matched=0;
    Error_num_matched2=0;
    Error_num_matched3=0;

    %BER
    % BER_matched_cases1(counter)=(sum(abs(decoded_bits1-data))/number_of_bits);
    % BER_matched_cases2(counter)=sum(abs(decoded_bits2-data))/number_of_bits;
    % BER_matched_cases3(counter)=sum(abs(decoded_bits3-data))/number_of_bits;

    %BER theoretical
    BER_theoretical(counter) = 0.5*erfc(sqrt(Eb/N0));

    counter=counter+1;
end

disp('BER matched1');
disp(BER_matched_cases2);

disp('BER THEORITICAL');
disp(BER_theoretical);

figure();
semilogy(-2:5,BER_matched_cases1,'g');
hold all
semilogy(-2:5,BER_matched_cases2,'b');
hold all
semilogy(-2:5,BER_matched_cases3,'r');
%hold all
%semilogy(-2:5,BER_theoretical,'y');
grid on
title('BER matched Filters ')
ylabel('BER')
xlabel('E_b/N_0')
legend(' BER for matched Filter1',' BER for matched Filter2', 'BER for matched Filter3');

figure();
semilogy(-2:5,BER_theoretical,'r');
grid on
title('BER Theoritical ')
ylabel('BER')
xlabel('E_b/N_0')
legend(' BER for theoritical');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data_noise = awgn(data_upsampled, N0 / 2);
