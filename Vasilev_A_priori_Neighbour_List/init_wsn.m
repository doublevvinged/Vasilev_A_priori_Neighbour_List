function graph=init_wsn(graph,area_size,states,inter_range)

% ## graph = [prototype]
% ## 
% ##            v_1: [scalar]       the central vertex
% ##              k: [scalar]       the global number of vertexes
% ##             vl: [k x 4]        the vertex list 
% ##            vld: [{kd<=k} x 2 ] the vertex list dynamics
% ##             kd: 7              the number of vertexes in vld
% ##nl.v(i \in k).v: [vect]         neighbours of vertex i from vl NOT vld
% ##nld.v(i \in k).v: [vect] = nl    neighbours of vertex i from vl dynamic NOT vld



% This function initilises the wireless sensor network
% wireless range
graph.area_size=area_size;
% Generate positions of the vertexes
graph.coordinates_edge=graph.area_size*rand(graph.k,2);
graph.states=states; % possible state of each edge

% inter_range [min, interwal]
graph.wireless_range=inter_range(1):inter_range(2):...
    (inter_range(1)+inter_range(2)*graph.states );

p=1:(graph.states);
poisson_intensity=2;
p=(poisson_intensity.^p).*exp(-p)./factorial(p);
p=(p/sum(p)); % initial transition
% figure(2)
% plot(1:(graph.states),p)
% title('range distribution')
graph.transition_pr=markov_transition(p);
graph.p=p;
display('chain error')
sum(abs(p*graph.transition_pr^100-p))

% Transform the state of the range to the actual range
function z=state2range(x,y)
% z=state2range(graph.state_vertex,graph.wireless_range)
for i=1:length(x)
    z(i)=y(x(i));
end
end %function


%initial range states
%graph.state_vertex=randsample(1:(graph.states),graph.k,REPLACEMENT=true,graph.p);
graph.state_vertex=randsample_vv(1:(graph.states),graph.k,'true',graph.p);
graph.range_vertex=state2range(graph.state_vertex,graph.wireless_range);
% graph.range_vertex=randsample(graph.wireless_range,graph.k,true,graph.p);




end