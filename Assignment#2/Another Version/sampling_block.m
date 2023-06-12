function [recived_bits_matched_after_sample,recived_bits_rect_after_sample ] = sampling_block (matched_filter_output ,rect_filter_output ,number_of_bits , number_of_samples) 

    conter=1;
    recived_bits_matched_after_sample = ones (1 , number_of_bits);
    recived_bits_rect_after_sample = ones (1 , number_of_bits); 
    
    for i=5:number_of_samples:number_of_bits*number_of_samples
        recived_bits_matched_after_sample(conter)=matched_filter_output(i);
        recived_bits_rect_after_sample(conter)=rect_filter_output(i);
        conter=conter+1;
    end

end 
