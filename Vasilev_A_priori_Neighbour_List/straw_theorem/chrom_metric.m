function metric=chrom_metric(sigma,lambda)

metric=0;


for i=1:size(sigma,1)-1 % last one is zero
%     lambda
%     i
%     graph.sigma(i,2)
    metric=metric+...
        log( lambda-i ) - log(  lambda-sigma(i,2)  ) ;
end



end