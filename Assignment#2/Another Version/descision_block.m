function [matched , rect] = descision_block (matched , rect )

   for i=1:10000
       if(matched(i)>0)
        matched(i)=1;
       else
          matched(i)=0;
       end
       if(rect(i)>0)
        rect(i)=1;
       else
          rect(i)=0;
       end
   end

end 