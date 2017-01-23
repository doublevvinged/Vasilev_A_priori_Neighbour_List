function yes=bin_inc_s(a,x)
% Binary Increase Search
%search a in increasing ordered x, 
yes=0;% Suppose no match is found
lo=1; % set the LOWER index of the search interval
up=length(x); % set the UPPER index of the search interval

i=ceil( (up+lo)/2 ); % find the middle of the search interval
k=up-lo;% find the lengh of the search interval
while k>1 % if the length of the interval is >1
    if x(i)==a % a match is found
        yes=i;
        break;
    else 
        if x(i)>=a % if the middle of the search interval is >  the value
            up=i; % then set the UPPER index to the middle of the search interval
        else           
            lo=i; % then set the LOWER index to the middle of the search interval            
        end
    end
% update
i=ceil( (up+lo)/2 );% the middle of the NEW interval
k=up-lo; % the length of the NEW interval

end
%Check if either values are the search value
if x(up)==a
     yes=up;
  
end

if x(lo)==a
     yes=lo;
    
end

end