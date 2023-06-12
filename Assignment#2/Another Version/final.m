clear all; clc; close all;

p=[5 4 3 2 1 ] / sqrt(55) ; 
rectfilter = [1 1 1 1 1 ]/sqrt(5) ; 

A=1 ;
number_of_bits1 = 10;

number_of_bits2 = 10000;

number_of_samples =5 ;
[data , data_sampled] = samples_generation(A ,number_of_samples , number_of_bits1);

%pulse_shape
%[p , rectfilter] = shapes_generation();

% y is the transmitted signal 
y1 = conv (p , data_sampled) ;
figure
subplot(2,1,1);
plot(y1);
subplot(2,1,2);
stem(y1 , 'r' , '.') 

% filter use the two types of filters and plot the output 
[matched_filter_output ,rect_filter_output ] = filter_block( p ,rectfilter , y1) ;
figure();
subplot(2,1,1);
stem(matched_filter_output,'g','.');
title(' matched filter output')
subplot(2,1,2); 
stem(rect_filter_output,'r','.')
title(' rect filter output')

corr_out = correlator(p , y1 ,number_of_bits1 ,number_of_samples) ;


% Repeat a, b, and c from 1 above but generate 10000 bits instead of 10 bits
[data2 , data_sampled2] = samples_generation(A ,number_of_samples , number_of_bits2);
y2 = conv (p , data_sampled2) ;
%
n = randn(1 , length(y2));
Eb = 1 ;
%noise = n*sqrt(N0/2);
%v= y2 + noise ; 
%n = randn(1 , length(y2));
%


BER_matched_cases=ones(1,8);
BER_theoretical=ones(1,8);
BER_rect_cases=ones(1,8) ;
counter=1;

for Eb_over_N0 =-2:5
    
    N0=Eb/(10^(Eb_over_N0/10));
    noise = n*sqrt(N0/2);
    V_n=noise+y2;
    [matched_filter_output ,rect_filter_output ] = filter_block(p ,rectfilter ,V_n );
    [recived_bits_matched_after_sample,recived_bits_rect_after_sample ] = sampling_block (matched_filter_output ,rect_filter_output ,number_of_bits2 ,number_of_samples );
    [matched_after_descision ,rect_after_descision ]=descision_block(recived_bits_matched_after_sample ,recived_bits_rect_after_sample );
    [BER_matched , BER_rect]=bit_error_rate(data2 , matched_after_descision  ,rect_after_descision , number_of_bits2 );
    BER_matched_cases(counter)=BER_matched;
    BER_rect_cases(counter)=BER_rect;
    BER_theoretical(counter)=0.5 *erfc(sqrt(Eb/N0));
   counter=counter+1 ;
end

semi_log_plot_BER(BER_matched_cases ,BER_rect_cases,BER_theoretical );
number_of_bits3 = 100 ;
[data3 , samples_generated3] = samples_generation(A , number_of_samples,number_of_bits3);
eye_diagram(samples_generated3 ,number_of_samples )




