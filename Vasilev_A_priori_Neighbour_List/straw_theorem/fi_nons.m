function vert=fi_nons(graph)

% Find a non simplicial vertex
% that is not the central vertex graph.v_1
ver_set=zeros(graph.kd,1) ;
for i=1:graph.kd
% for all vertexes that are not yet deleted
% find their original degree
    if graph.vl(i,1)~=graph.v_1
    ver_set(i)=length(graph.nl.v ( graph.vld(i,1)  ) .v ) ;
    else
        ver_set(i)=graph.k+1; % make sure that the central vertex is not deleted
    end
end

% select the vertex with the lowest degree
[~,vert]=min(ver_set);

vert =graph.vld( vert ,1)  ;


end