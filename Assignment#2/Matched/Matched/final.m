clear all; clc; close all;

% need to mul by sqrt(3)
% 3 + 12 + 27 + 48 + 75
tri_filter= sqrt(3) * [1 2 3 4 5 ] / sqrt(165) ; 
matched_rect_filter = [1 1 1 1 1 ]/sqrt(5) ; 
not_exist_filter = [0 0 1 0 0 ];

figure(1);
subplot(2,1,1);
plot(matched_rect_filter);
subplot(2,1,2);
stem(matched_rect_filter , 'r' , '.') 

figure(2);
subplot(2,1,1);
plot(tri_filter);
subplot(2,1,2);
stem(tri_filter , 'r' , '.') 

figure(3);
subplot(2,1,1);
plot(not_exist_filter);
subplot(2,1,2);
stem(not_exist_filter , 'r' , '.') 



A=1 ;
number_of_bits1 = 10;

number_of_bits2 = 10000;

number_of_samples =5 ;
[data , data_sampled] = samples_generation(A ,number_of_samples , number_of_bits1);

y1 = conv (matched_rect_filter , data_sampled) ;

figure(4)
subplot(2,1,1);
plot(y1);
subplot(2,1,2);
stem(y1 , 'r' , '.') 

% filter use the two types of filters and plot the output 
[matched_filter_output ,tri_filter_output, not_exist_filter_output ] = filter_block( matched_rect_filter ,tri_filter ,not_exist_filter, y1) ;
figure(5);
subplot(3,1,1);
stem(matched_filter_output,'g','.');
title(' matched filter output')
subplot(3,1,2); 
stem(tri_filter_output,'r','.')
title(' rect filter output')
subplot(3,1,3); 
stem(not_exist_filter_output,'r','.')
title(' not exist filter output')

% Repeat a, b, and c from 1 above but generate 10000 bits instead of 10 bits
[data2 , data_sampled2] = samples_generation(A ,number_of_samples , number_of_bits2);
y2 = conv (matched_rect_filter , data_sampled2) ;
n = randn(1 , length(y2));
Eb = 1 ;

BER_matched_cases=ones(1,18);
BER_tri_cases=ones(1,18) ;
BER_not_exist_cases=ones(1,18) ;

BER_theoretical=ones(1,18);

counter=1;

for Eb_over_N0 =-10:7
    
    N0=Eb/(10^(Eb_over_N0/10));
    noise = n*sqrt(N0/2);
    V_n=noise+y2;
    
    [matched_filter_output ,tri_filter_output, not_exist_filter_output ] = filter_block(matched_rect_filter ,tri_filter ,not_exist_filter, V_n );
    
    [recived_bits_matched_after_sample,recived_bits_tri_after_sample, recived_bits_not_exist_after_sample ] = sampling_block (matched_filter_output ,tri_filter_output ,not_exist_filter_output, number_of_bits2 ,number_of_samples );
    
    [matched_after_descision ,tri_after_descision, not_exist_after_descision ]=descision_block(recived_bits_matched_after_sample ,recived_bits_tri_after_sample,recived_bits_not_exist_after_sample  );
    
    [BER_matched , BER_tri, BER_not_exist ]=bit_error_rate(data2 , matched_after_descision  ,tri_after_descision ,not_exist_after_descision, number_of_bits2 );
    
    BER_matched_cases(counter)=BER_matched;
    BER_tri_cases(counter)=BER_tri;
    BER_not_exist_cases(counter)=BER_not_exist;
    
    BER_theoretical(counter)=0.5 *erfc(sqrt(Eb/N0));
   
    counter=counter+1 ;
end

semi_log_plot_BER(BER_matched_cases ,BER_tri_cases,BER_not_exist_cases,BER_theoretical );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Bit Error Rate %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [BER_matched ,BER_tri, BER_not_exist ] = bit_error_rate( data , matched_after_descision , tri_after_descision ,not_exist_after_descision, number_of_bits) 

   Error_num_matched=0;
   Error_num_rect=0; 
   Error_num_not_exist=0; 
   
  for i=1:10000
       
      if(matched_after_descision(i)~=data(i))
        Error_num_matched=Error_num_matched+1;
      end
      
      if(tri_after_descision(i)~=data(i))
        Error_num_rect=Error_num_rect+1;
      end
       
      if(not_exist_after_descision(i)~=data(i))
        Error_num_not_exist=Error_num_not_exist+1;
      end
       
  end
   
   BER_tri=Error_num_rect/number_of_bits;
   BER_matched=Error_num_matched/number_of_bits;
   BER_not_exist=Error_num_not_exist/number_of_bits;

end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Descision Block %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [matched , tri, not_exist] = descision_block (matched , tri, not_exist )

   for i=1:10000

       if(matched(i)>0)
        matched(i)=1;
       else
        matched(i)=0;
       end
       
       if(tri(i)>0)
        tri(i)=1;
       else
        tri(i)=0;
       end
       
       if(not_exist(i)>0)
        not_exist(i)=1;
       else
        not_exist(i)=0;
       end
       
   end

end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Filter Block %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [matched_filter_output ,tri_filter_output, not_exist_filter_output ] = filter_block(pulseshape ,tri_filter ,not_exist_filter, y )

matchedfilter = fliplr(pulseshape);
matched_filter_output = conv(matchedfilter , y) ; 
tri_filter_output = conv(tri_filter , y);
not_exist_filter_output = conv(not_exist_filter , y);

end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Samples Generation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [data , samples_generated] = samples_generation(A,number_of_samples , number_of_bits)

data_size = [1 , number_of_bits] ; 
% generate the required array 
data = randi([0,1] , data_size);
% mapping logic zero to -1 and logic 1 to 1 
data_mapped =(2*data-1)*A;
samples_generated=upsample(data_mapped ,number_of_samples );

end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Sampling Block %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [recived_bits_matched_after_sample,recived_bits_tri_after_sample, recived_bits_not_exist_after_sample ] = sampling_block (matched_filter_output ,tri_filter_output ,not_exist_filter_output, number_of_bits , number_of_samples) 

    conter=1;
    recived_bits_matched_after_sample = ones (1 , number_of_bits);
    recived_bits_tri_after_sample = ones (1 , number_of_bits); 
    recived_bits_not_exist_after_sample = ones (1 , number_of_bits); 
    
    for i=5:number_of_samples:number_of_bits*number_of_samples
        recived_bits_matched_after_sample(conter)=matched_filter_output(i);
        recived_bits_tri_after_sample(conter)=tri_filter_output(i);
        recived_bits_not_exist_after_sample(conter)=not_exist_filter_output(i);
        
        conter=conter+1;
    end

end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Drawing in dB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = semi_log_plot_BER(BER_matched_cases ,BER_tri_cases,BER_not_exist_cases,BER_theoretical)
figure(6);
semilogy(-10:7,BER_matched_cases);
hold all
semilogy(-10:7,BER_theoretical,'r');
grid on
title('BER matched ')
ylabel('BER')
xlabel('E_b/N_0 in db')
legend(' BER for matched Filter',' BER for theoritical');

figure(7);
semilogy(-10:7,BER_tri_cases)
hold all
semilogy(-10:7,BER_theoretical)
grid on
ylabel('BER')
xlabel('E_b/N_0 in dB')
title('BER rec')
legend(' BER for Tri Filter',' BER for theoritical');

figure(8);
semilogy(-10:7,BER_not_exist_cases)
hold all
semilogy(-10:7,BER_theoretical)
grid on
ylabel('BER')
xlabel('E_b/N_0 in dB')
title('BER rec')
legend(' BER for Not Exist Filter',' BER for theoritical');

end 
