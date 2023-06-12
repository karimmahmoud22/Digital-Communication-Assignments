function [data , samples_generated] = samples_generation(A,number_of_samples , number_of_bits)
data_size = [1 , number_of_bits] ; 

% generate the required array 
data = randi([0,1] , data_size);
% mapping logic zero to -1 and logic 1 to 1 
data_mapped =(2*data-1)*A;
% ex (2*0-1)*1=-1 
% ex (2*1-1)*1=1
samples_generated=upsample(data_mapped ,number_of_samples );
end 