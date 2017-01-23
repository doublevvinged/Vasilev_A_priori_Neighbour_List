function plot_wsn_nl(graph,fig_title)

% ## graph = [prototype]
% ## 
% ##            v_1: [scalar]       the central vertex
% ##              k: [scalar]       the global number of vertexes
% ##             vl: [k x 4]        the vertex list 
% ##            vld: [{kd<=k} x 2 ] the vertex list dynamics
% ##             kd: 7              the number of vertexes in vld
% ##nl.v(i \in k).v: [vect]         neighbours of vertex i from vl NOT vld
% ##nld.v(i \in k).v: [vect] = nl    neighbours of vertex i from vl dynamic NOT vld
% ##
% ## AFTER initialise_wsn
% ##       area_size: [scalar]  size of the sqauare areas
% ##coordinates_edge: [k x 2 ]   2D coordinates of each vertex
% ##          states: [scalar] h number of possible covarage states
% ##  wireless_range: [1 x h]    the actual coverate states
% ##   transition_pr: [h x h] transisiton probabilities between  between covarage states
% ##               p: [1 x h] steady state of the % coverage states
% ##    state_vertex: [1 x k] current coverage state of each vertex
% ##    range_vertex: [1 x k] actual current range of each vertex
% ## Author: doubblevvinged

close all
figure(1)
% Plot sensor posiutions
plot(graph.coordinates_edge(:,1),graph.coordinates_edge(:,2),'x')
% axis([XMIN XMAX YMIN YMAX])
title('Sensor position')
xlabel('X position [m]')
ylabel('Y position [m]')
axis([0 graph.area_size 0 graph.area_size])
hold on

% Plot the range of the vertexes
for i=1:graph.k
[X,Y] = pol2cart(0:0.1:2*pi,graph.range_vertex(i));
plot(graph.coordinates_edge(i,1)+X,...
    Y+graph.coordinates_edge(i,2))
    hold on
end

% i=graph.v_1;
% Plot the range of the central vertex
[X,Y] = pol2cart(0:0.1:2*pi,graph.range_vertex(graph.v_1));
plot(graph.coordinates_edge(graph.v_1,1)+X,...
    Y+graph.coordinates_edge(graph.v_1,2),'og','MarkerSize',10)
    hold on
%str = strcat('\leftarrow', 'Initial Node');
str = strcat(' <-', 'Initial Node');
text(graph.coordinates_edge(graph.v_1,1),...
  graph.coordinates_edge(graph.v_1,2)  ,str,'HorizontalAlignment','left');
  hold on  
% plot(graph.coordinates_edge(graph.v_1,1),...
%     graph.coordinates_edge(graph.v_1,2),'ok','MarkerSize',25)


% Plot the neihour relationships
for i=1:graph.k
    for j=1:graph.k
%    graph.vertex_list(j)
    if ~isempty(graph.nl.v(i).v)
        if bin_inc_s(graph.vl(j),...
        graph.nl.v(i).v )>0
plot([graph.coordinates_edge(i,1),graph.coordinates_edge(j,1) ],...
    [graph.coordinates_edge(i,2),graph.coordinates_edge(j,2) ],'r')   
hold on    
        end
    end
    end
end


% PLot the cover_tree with respect to the v_1 vertex
 path=bfs_nl(graph,graph.v_1,graph.k+1,'cover_tree');
% path.cover_tree
if    and(size( path.cover_tree,1 )>0 , path.cover_tree(1,1)>0 )
for i=1:size( path.cover_tree,1 ) 
%path.cover_tree(i,1)
%path.cover_tree(i,2)
    plot([graph.coordinates_edge( path.cover_tree(i,1) ,1),...
    graph.coordinates_edge( path.cover_tree(i,2)  ,1) ],...
        [graph.coordinates_edge( path.cover_tree(i,1)  ,2),...
        graph.coordinates_edge(  path.cover_tree(i,2) ,2) ],'k','LineWidth',4)            
hold on
end
end
%legend('nodes','range')

% print('-f1',fig_title,'-dpdf')

% pause
% close all

end