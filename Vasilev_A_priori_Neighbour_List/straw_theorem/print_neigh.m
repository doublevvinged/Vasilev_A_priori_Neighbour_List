function print_neigh(graph)

% size of the neighbour matrix
m=1;
for i=1: size(graph.vld ,1)
    if length( graph.nld.v( graph.vld(i,1) ) .v) >m
        m=length( graph.nld.v( graph.vld(i,1) ) .v);
    end
end


neigh_label_matrix=zeros( graph.kd, m+1) ;

for i=1: size(graph.vld ,1)
%     graph.vld(i,1)
    vector= graph.nld.v( graph.vld(i,1) ) .v    ;
neigh_label_matrix (i, 1:length(vector))=vector ;
end

% neigh_label_matrix

% display('All dynamic vertexes in original labels')
% graph.vld(:,1)

display('All dynamic vertexes in original labels')

[ graph.vld(:,1), -1*ones( graph.kd,1)  neigh_label_matrix ]






end