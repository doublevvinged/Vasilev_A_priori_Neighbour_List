% ## Copyright (C) 2014 - doublevvinged
% ##
% ## This progrm is free software; you can redistribute it and/or modify
% ## it under the terms of the GNU General Public License as published by
% ## the Free Software Foundation; either version 3 of the License, or
% ## (at your option) any later version.
% ##
% ## This program is distributed in the hope that it will be useful,
% ## but WITHOUT ANY WARRANTY; without even the implied warranty of
% ## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% ## GNU General Public License for more details.
% ##
% ## You should have received a copy of the GNU General Public License
% ## along with this program. If not, see <http://www.gnu.org/licenses/>.
% 
% ## -*- texinfo -*-
% ## @deftypefn {Function File} {@var{y} =} randsample (@var{v}, @var{n}, @var{replacement}, @var{weights}  )
% ## This function returns a vector @var{y}[n x 1] of size @var{n} by 1 elements
% ## of random elements sampled from a vector @var{v}.
% ## If @var{replacement}='true', replacement is enabled and
% ## multiple occurances of the same element are allowed 
% ## If in addition to that the non negative weights @var{weights}[n x 1] >0 are given,
% ## then each sampel is taken with probability proportional to its weight
% ## The weights are not necessary normalised.
% ## The default @var{replacement} method is without replacement.
% ##
% ## Example:
% ##
% ##p=[0.1 0.2 0.6];
% ##
% ##for i=1:1000
% ##
% ## res(1:2,i)=randsample([2,4,7],2,'true', p );
% ##
% ##end
% ##
% ##res=res(:);
% ##
% ##hist(res)
% ##
% ## @seealso{randperm}
% ## @end deftypefn
% ## Author: doublevvinged




function samp=randsample_vv(x,n,repl,p)
%# by doublevvinged
%# x is the sample vector
%# n is the number of requested samples
%# repl if sampling is with replacement
%
%# build in function closest_match
%# this is a binary search that returns the closest lower match of a in sorted increasing x
function yes=closest_match(a,x)
yes=0;
lo=1;
up=length(x);
i=ceil( (up+lo)/2 );
k=up-lo;
while k>1
    if x(i)==a
        yes=i;
        break;
    else 
        if x(i)>=a
            up=i;
        else            
            lo=i;           
        end
    end
i=ceil( (up+lo)/2 );
k=up-lo;

end

if up==length(x)
   if(x(up)<a) 
   yes=up;
   else
   yes=lo;
   end
else
  yes=lo;
end
   
 
end %function



if exist('repl')
  if strcmp(repl,'true')
      if exist('p')
%          # generate the look up table for the specified distribution p
          %look_up(k,:)=[ lower interval of k-th element of x, upper interval of k-th element of x]
          look_up=zeros(length(p),2);
          look_up(1,:)=[0,p(1)];
          for j=2:length(p)
          look_up(j,1)=look_up(j-1,2);
          look_up(j,2)=look_up(j,1)+p(j);
          end

          for j=1:n
%          # a random index sample of elements of x from a distribution p
          %ind= closest_match( unifrnd(0,look_up(size(look_up,1),2 )  ), look_up(:,1)  ) 
          % Note that the probability distribution does not need to be normalised
          samp(j)= x(  closest_match( unifrnd(0,look_up(size(look_up,1),2 )  ), look_up(:,1)  )  );
          end
      else %# exist('p') no sample distribution specified sample from uniform
          look_up=zeros(length(x),2);
          look_up(1,:)=[0,1/length(x)];

            for j=2:length(x)
            look_up(j,1)=look_up(j-1,2);
            look_up(j,2)=look_up(j,1)+1/length(x);
            end

            for j=1:n
            %ind= closest_match( unifrnd(0,look_up(size(look_up,1),2 )  ), look_up(:,1)  ) 
            % Note that the probability distribution does not need to be normalised
            samp(j)= x(  closest_match( unifrnd(0,look_up(size(look_up,1),2 )  ), look_up(:,1)  )  );
            end            
      end  % exist('p')

   else % strcmp(repl,'true')
        % NOTE THAT IF SAMPLING IS repl IS NOT 'true' SAMPLING IS WITHOUT REPLACEMENT
        % sample WITHOUT replacement
          if n>=length(x)
          samp=0;
          display('Requested sample size without replacement is greater than the size of the input')
%           break
          end  
%          # this is reduced to a random permutation
          sampl=randperm(length(x),n);
%          # map the indexes to the input vector
          for j=1:n
          samp(j)= x(  sampl(j)  );
          end
%          samp=transpose(samp);
  end % strcmp(repl,'true')
    
else % exist('repl') 
        % Default is WITHOUT replacement
        if n>=length(x)
        samp=0;
        display('Requested sample size without replacement is greater than the size of the input')
%         break
        end  
%        # this is reduced to a random permutation
        sampl=randperm(length(x),n);
%        # map the indexes to the input vector
        for j=1:n
        samp(j)= x(  sampl(j)  );
        end
%        samp=transpose(samp);
end %# exist('repl')




end %# function samp=randsamp_doublevvinged(x,n,repl,p)


%% Testing

%p=[0.1 0.1 0.2 0.6]
%randsample(1:4,2, 'true',p )
% randsample('abcd',2, 'true',p )

%p=[0.1 0.1 0.2 0.6]
%k=1000
%res=zeros(2,k);
%for i=1:k
%res(1:2,i)=randsample(1:4,2, 'true',p );
%end
%res=res(:);
%hist(res)
%
%
%p=[0.1 0.2 0.6]
%k=1000
%res=zeros(2,k);
%for i=1:k
%res(1:2,i)=randsample([2,4,7],2,'true', p );
%end
%res=res(:);
%hist(res)
%
%
%k=1000
%res=zeros(2,k);
%for i=1:k
%res(1:2,i)=randsample([2,4,7],2,'true');
%end
%res=res(:);
%hist(res)
%
%
%
%k=1000
%res=zeros(2,k);
%for i=1:k
%res(1:2,i)=randsample([2,4,7],2,'false');
%end
%res=res(:);
%hist(res)
%
%
%
%
%p=[0.1 0.2 0.6 0.3]
%k=1000
%res=zeros(3,k);
%for i=1:k
%res(:,i)=randsample([2,4,6,7],3,'false',p);
%end
%res=res(:);
%hist(res)
%
%
%
%p=[0.1 0.2 0.6 0.3]
%k=1000
%res=zeros(3,k);
%for i=1:k
%res(:,i)=randsample([2,4,6,7],3,'false',p);
%end
%res=res(:);
%hist(res)


