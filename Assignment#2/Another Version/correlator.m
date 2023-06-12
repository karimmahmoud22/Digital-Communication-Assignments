function [after_sample] = correlator (p  , y , number_of_bits , number_of_samples )

for i = 1:number_of_samples:number_of_samples*number_of_bits
    x(i : i+4 )= y(i:i+4).*p;
end
    % discard any value out of number_of_samples*number_of_bits 
    x=x(1:number_of_samples*number_of_bits) ;
    after_sample = intdump(x , number_of_samples);
    figure;
    stem(after_sample); 
    title ("correlator_output");
end 