
function sub_set=is_subset_exc_e(x,y,e)
% Is ordered x a subset of ordered y excluding e
% , where e is a member of both x and y?
sub_set=1;

% ?
% x
% y
% e

% uses binary increas search
if and(length(x)==1, x==e) % 
% x is not a subset of y
sub_set=1; % takes care of tree pendant vertexes
% otherwise put the empty set is a subset of both sets
else
    for k=1:length(x) % for all elements of x
      % excluding e   
      if x(k) ~=  e % in graph.nld all vertexes ARE NOT neighbours to themselves
        % look up x(k) in y           
        yes= bin_inc_ss(x(k) , y )  ;
          if yes~=0
          % a match is found increase the size of the intersection    
          else
          % an element of x(k) is missing from y
          % x is not a subset of y
          sub_set=0;
          break
          end
      end % x(k) ~=  e 
    end %k=1:length(x) % for all elements of x
end % and(length(x)==1, x==e) %


% % test 
% % sub_set=1
% x=unique(randi(10,[10,1]))
% y=unique( [ x; randi(40,[10,1]) ]  )
% sub_set=is_subset_exc_e(x,y,x(1))

% % sub_set=0
% x=unique(randi(10,[10,1]))
% y=unique( randi(40,[10,1])  )
% sub_set=is_subset_exc_e(x,y,x(1))

end