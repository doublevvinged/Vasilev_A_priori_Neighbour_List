function s=rep_all_bin_mat(a,b,s)

% Replace a with b in incr sorted s
% , where b is such that s is still sorted in icreasing.

% Using binary search find one position in s that matches a
yes=bin_inc_ss( a, s );
if yes~=0            
% if there is a match  
s(yes)= b ;
% shift upwards while s(k)==a
up=1;                
while yes-up>=1
    if s(yes-up)~= a
        break
    else
        % set the elements to b
        s(yes-up) =  b ;
    end
up=up+1;
end
 % also shift downwards while s(k)==a                   
lo=1;                    
while yes+lo <= length(s)
    if s(yes+lo)~= a
        break
    else
        s(yes+lo) =  b ;
    end
lo=lo+1;
end                       

end   % if yes~=0 

%         s = [1 1 1 2 2 2 3 3 3 3 3 4 4 4 4 4 4]

%         a=4
%         b=4.5;

%         x=rep_all_bin_mat(a,b,s)

end % function s=all_bin_matches(a,s)