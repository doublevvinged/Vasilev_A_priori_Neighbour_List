function mat=markov_transition(p)

%Markov Chain Monte Carlo approach
       N=1000;
        states=10^-4;% step parameter
        sigma=1;%variance of the sample distribution
        accuracy=10^-4;%of the result
        chain_convergence=0;%statinary distribution of the chain achieved?
         X=repmat(p,length(p),1) ;
%         X=ones(length(p),length(p))/length(p);
        p=p';
        f=(X*p-p)'*(X*p-p)+(sum(X,2)-1)'*(sum(X,2)-1)+...
           chain_convergence*sum(sum(X^2-X));
       k=1;
        while f>accuracy && k<N
            v=sigma*randn(size(X));
            f1=((X-states*v)*p-p)'*((X-states*v)*p-p)...
                +(sum((X-states*v),2)-1)'*(sum((X-states*v),2)-1)+...
                chain_convergence*sum(sum((X-states*v)^2-(X-states*v)));
                 X=abs(X);
            if f1<f
                X=X-states*v;
                f=f1;
            end
          k=k+1;  
        end
                X=abs(X);
                    for i=1:size(X,1)
                         X(i,:)=X(i,:)./sum(X(i,:));
                    end 
      
        mat=X;


end