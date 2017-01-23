function yes=closest_match_miss(a,x)
% Find the closest match of a in x,
% where a is missing in x
% DONT USE IT IF THERE MIGHT BE EXACT MATCHES
% FIRST MAKE SURE THERE IS NO MATCH AT ALL. FOR EXAMPLE:
%         yes=bin_inc_s(a , x) ;
%         if yes==0
%         yes=closest_match_miss( a , x) ;
%         end
%This is a binary search that returns the closest
% lower match of a in sorted increasing x

% MAKE SURE THAT X HAS AT LEAST 2 ELEMENTS
if length(x)<=2 
    if length(x)==1
        if a < x
            yes=0;
        else
            yes=1;
        end
    else
        % length(x)== 2
        if a<x(1)
            yes=0;
        else
            % a>x(1)
            if a > x(2)
                yes=2;
            else
                yes=1;
            end
        end
    end
else % length(x)> 2
yes=0;
lo=1;
up=length(x);
i=ceil( (up+lo)/2 );
k=up-lo;
while k>1
        if x(i)>a
            up=i;
        else            
            lo=i;           
        end
i=ceil( (up+lo)/2 );
k=up-lo;

end


if up==length(x)
   if a < x(up)
   yes=lo;
   else
   yes=up;
   end
else 
    if lo==1
        if x(lo)<a
            yes=lo ;
        else
            yes= lo-1;
        end
    end
end
   


if and( lo>1 , up<length(x) )
    yes=lo;
end


end % length(x)<=2


% test
% a= 1:2:11
%  x= a(2:length(a))-1 
% 
% for k=1:length(a)
%     yes=closest_match_miss(a(k),x)
% end

%   closest_match_miss(6,[2,9])

 
end %function  yes=closest_match(a,x)