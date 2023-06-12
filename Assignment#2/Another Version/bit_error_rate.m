function [BER_matched ,BER_rect ] = bit_error_rate( data , matched_after_descision , rect_after_descision , number_of_bits) 

   Error_num_matched=0;
   Error_num_rect=0; 
  for i=1:10000
       if(matched_after_descision(i)~=data(i))
       Error_num_matched=Error_num_matched+1;
       end
       if(rect_after_descision(i)~=data(i))
       Error_num_rect=Error_num_rect+1;
       end
   end
   BER_rect=Error_num_rect/number_of_bits;
   BER_matched=Error_num_matched/number_of_bits;


end 