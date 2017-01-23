function [graph,q,data_set]=graph_nl

% ## This function generates a graph
% ## and stores its structure by means of 
% ## its neighbour list.
% ## This code is designes to handle both sparce and dense graphs and multiple VERTEX DELETIONS
% ## Because of the multiple sordet structures binary search is used.
% ##
% ## graph = [prototype]
% ## 
% ##            v_1: [scalar]       the central vertex
% ##              k: [scalar]       the global number of vertexes
% ##             vl: [k x 4]        the vertex list 
% ##            vld: [{kd<=k} x 2 ] the vertex list dynamics
% ##             kd: 7              the number of vertexes in vld
% ##nl.v(i \in k).v: [vect]         neighbours of vertex i from vl NOT vld
% ##nld.v(i \in k).v: [vect] = nl    neighbours of vertex i from vl dynamic NOT vld

% addpath(genpath('C:\Octave\Vasilev_Octave_Scripts\Neighbour_List'))


% addpath('straw_theorem')
% rmpath('straw_theorem')
%  close all
%  clear all
%  clc

%% Initialize the random graph 
k=14; % number of vertexes of the graph
v_1=1; % a central vertex of the graph
edge_prob=0.9 *log(k)/k  ; % the edge probability of a Erdos Renyi random graph
graph=random_graph(k,v_1,edge_prob) ;
%%

% Initialize the wireless sensor network
area_size=18; % size of the network
states=2; % numnber of states of the coverage of each vertex
inter_range=[7, 1]; % Interval in which the coverage changes
graph=init_wsn(graph,area_size,states,inter_range);


% This function propagates the state of the range of each vertex
graph=prop_states(graph);

% Plots the graph
% plot_wsn_nl(graph,strcat('results','\','network'))
% Plots the dynamic graph
% plot_wsn_nld(graph,strcat('results','\','Network'))

%% Initialise the queue
clear ('q')
q.opt.traffic=2 ;% is the traffic a vertex generates to other vertexes
q.opt.initilised_packets=3 ;% is the maximum number of packets a vertex can initialise
q.opt.resourses=7 ;% is the maximum amount of memory resourses a vertex can have
q.opt.num_packet=1400 ;% is the maximum number of all packet that are in the network
simulation_time=1  ;
q=wsn_packets_v2(graph,q,'initialise_queue',simulation_time);
%%


%% Time Simulation
T=100; % Duration of the simulation

% Initialise a vector to monitor the metric 
%graph.metric=zeros(T,1); 

data_set.time=0 ;
for simulation_time=1:T
    % Propagate each vertex's range and
    % change neighbour relationships.
    graph=prop_states(graph);
        % plot the network if  needed
%          plot_wsn_nl(graph,strcat('results','\','network',int2str(simulation_time)))
    % Each vertex, then generates packets. 
    q=wsn_packets_v2(graph,q,'generate_packets',simulation_time );
    % Rout all of vertex's packets and all neighbour packets.
    q=wsn_packets_v2(graph,q,'propagate_packets',simulation_time ) ;


    % Save the current network
    data_set.time=1+ data_set.time ;
    data_set.s(data_set.time)=graph  ;      
 
    if q.br==1 
    % there is no moore space in the packet queue
    break % the simulation
    end
end



% Pre proccessing step. Sort the packet queue with respect to the sender
q=pack_stat(q , 'preprocess') ;

%          plot_wsn_nl(graph,strcat('results','\','network',int2str(simulation_time)))
%          pause


% addpath(genpath('C:\Octave\Vasilev_Octave_Scripts\Neighbour_List'))


save('C:\Octave\Vasilev_Octave_Scripts\Neighbour_List\results\data_set.mat','data_set','q','-mat')




end