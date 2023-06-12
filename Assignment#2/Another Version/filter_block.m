function [matched_filter_output ,rect_filter_output ] = filter_block(pulseshape ,rectfilter , y )

matchedfilter = fliplr(pulseshape);
matched_filter_output = conv(matchedfilter , y) ; 
rect_filter_output = conv(rectfilter , y);
%figure ;
%plot(matched_filter_output) ;
%figure ;
%plot(rect_filter_output) ;
end 