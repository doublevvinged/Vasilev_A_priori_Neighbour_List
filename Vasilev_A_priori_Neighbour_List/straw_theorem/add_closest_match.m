function x_set=add_closest_match(an_elem,posit,x_set,opt)

% Add an_element, that was not privously in x_set to x_set,
% where posit specifies the position in x_set
%         yes=bin_inc_ss(a , x) ;
%         if yes==0
%         posit=closest_match_miss( a , x) ;
%         end

% protptype for adding
% x_set=add_closest_match(an_elem, ...
% closest_match_miss( an_elem , x_set) , x_set , opt)

if opt==1
% NOTE an_element[1 x n] might be a vector that goes in x_set[m x n]
if size(x_set,2)==length(an_elem)
    if posit==0
        %  an_elem must be the FIRST element of x_set
        x_set=[ an_elem ; x_set] ;
    else
        if posit==size(x_set,1)+1
            %  an_elem must be the  LAST element of x_set
            x_set=[ x_set ; an_elem ] ;
        else
            %  an_elem must be the  POSIT element of x_set
             x_set=[ x_set(1:posit,:) ; an_elem ; ...
                 x_set(posit+1:size(x_set,1),:) ] ;
        end
    end
end

else % opt~=1
% NOTE an_element[n x 1] might be a vector that goes in x_set[n x m]
if size(x_set,1)==length(an_elem)
    if posit==0
        %  an_elem must be the FIRST element of x_set
        x_set=[ an_elem , x_set] ;
    else
        if posit==size(x_set,2)+1
            %  an_elem must be the  LAST element of x_set
            x_set=[ x_set , an_elem ] ;
        else
            %  an_elem must be the  POSIT element of x_set
             x_set=[ x_set(:,1:posit) , an_elem , ...
                 x_set(:,posit+1:size(x_set,2)) ] ;
        end
    end
end

end % if opt==1

% % test add_closest_match
% % test sigle vector
% a= 1:2:11
%  x= transpose(a(2:length(a))-1 )
% 
% for k=1:length(a)
%     a(k)
%   posit=closest_match_miss(a(k),x)
%     yes=add_closest_match(a(k),posit,x)
% pause
% end


% % test matrix
% a= [(1:2:11)' ,(1:2:11)' ]
%  x= [ a(2:length(a),1)-1 , a(2:length(a),1)-1 ]
% 
% for k=1:length(a)
%     a(k)
%   posit=closest_match_miss(a(k,1),x(:,1))
%     yes=add_closest_match(a(k,:),posit,x)
% pause
% end


% % test transposed matrix
% a= [(1:2:11)' ,(1:2:11)' ]'
%  x= [ a(1,2:length(a))-1 ; a(1,2:length(a))-1 ]
% 
% for k=1:length(a)
%     a(k)
%   posit=closest_match_miss(a(1,k),x(1,:))
%     yes=add_closest_match(a(:,k),posit,x)
% pause
% end


end