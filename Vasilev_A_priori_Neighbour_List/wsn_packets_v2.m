function  q=wsn_packets_v2(graph,q,packet_option,simulation_time)


% ## This function propagates traffic in the wireless sensor network
% ## specified by the graph.
% ## queue.options needs to be specified for example:
% ##
% ## q.opt.traffic=2 % is the traffic a vertex generates to other vertexes
% ## q.opt.initilised_packets=4 % is the maximum number of packets a vertex can initialise
% ## q.opt.resourses=2 % is the maximum amount of memory resourses a vertex can have
% ## q.opt.num_packet=10 % is the maximum number of all packet that are in the network
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


    

switch packet_option
case 'initialise_queue',
% Initialise the global packet queue
% q.pack= [ q.opt.num_packet ,5]=
%[1 source, 2 destination, 3 start_t, 4 end_t, 5 packet_status ]
% packet_status=[0-active, 1-recieved, 2-failed]
q.pack= zeros( q.opt.num_packet , 5) ;          
% q.k is the position of the first  empty element of q.pack
q.k=1;
q.br=0; % wheather q.pack is full

for i=1:graph.k % for all vertexes
% Initialise a routing packet queue
% this queue hold all packet that are to be routed by vertex i
% q.v(i).rout= [ q.opt.resourses ,6]=
%[1 source, 2 destination, 3 start_t, 4 end_t,...
% 5 points to the packet's position in q.pack,...
% 6 current vertex ]
q.v(i).rout=zeros(q.opt.resourses,6);
q.v(i).r=1; % the position of the first  empty element of q.v(i).rout

% Initialise an initialised packet queue
% this queue holds all packet that were initilised by vertex i
% q.v(i).init=[ q.opt.initilised_packets, 5 ]=
%[1 source, 2 destination, 3 start_t, 4 end_t,...
% 5 points to the packet's position in q.pack  ]
q.v(i).init= zeros(q.opt.initilised_packets,5);
q.v(i).i=1;  % the position of the first  empty element of q.v(i).init

end

   
case 'generate_packets',
% One needs to generate packets with a random permutation 
% of the vertexes otherwise there will bi priority for 
% the packets with respect to the vertex label
% generate a random permutation
v_p=randperm(graph.k) ; 
for i=1:graph.k % for all vertexes
% at this point on the label of a vertex becomes v_p(i)    
  if q.br==0 % is there any space in the global packet queue
  %then select a random number of packets
  num_p=poissrnd(q.opt.traffic); % the number of packets
     if num_p==0
      % cannot initialise 0 packets
     else
       for j=1 : num_p % for each  packet
       %I. Is it possible to add any more packets to the global queue?
          if q.k<=q.opt.num_packet
          % try to initialise global packet
% for v_p(i)          
% the possible available destination vertexes are 
av_vert=...
graph.vl(graph.vl(:,1)~=v_p(i),1);
if length(av_vert)>1
q.pack(  q.k   ,1:5 )=[...
v_p(i) ,...1 source vertex
randsample_vv( av_vert   ,1,'false') , ...% 2 a random destination vertex
simulation_time ,...3 start time
Inf ,... 4 end time
0 ]; % 5 global packet status
else
q.pack(  q.k   ,1:5 )=[...
v_p(i) ,...1 source vertex
av_vert , ...% 2 there is only 1 available destination vertex
simulation_time ,...3 start time
Inf ,... 4 end time
0 ]; % 5 global packet status   
end
% count the new global packets
q.k=q.k+1;
% q.pack(  q.k -1  ,1:5 )
% q.k


% II. Try to assign the new packet to the
% init packet queue
% and the rout packet queue
% to this end both queues must have avaiable resourses
% the source vertex's first zero vector position in init queue  
% q.v( v_p(i) ).i
% the source vertex's first zero vector position in rout queue  
% q.v( v_p(i) ).r

if and(   q.v( v_p(i) ).i<= q.opt.initilised_packets ,...
q.v( v_p(i) ).r <=q.opt.resourses   )
%vertex CAN accept the new packet
% assign it to the init queue
q.v( v_p(i) ).init(  q.v( v_p(i) ).i  ,1:4 )=...
q.pack(  q.k -1  , 1:4  );
% add the position of the global packet count 
q.v( v_p(i) ).init(  q.v( v_p(i) ).i  , 5 )= q.k -1;
% cout the new packet
q.v( v_p(i) ).i=q.v( v_p(i) ).i+1;

%assign it to the rout queue
q.v( v_p(i) ).rout( q.v( v_p(i) ).r ,1:4  )=...
q.pack(  q.k -1  , 1:4  );
% add the position of the global packet count 
q.v( v_p(i) ).rout( q.v( v_p(i) ).r , 5  )=q.k -1;
% set the current vertex to the source vertex
q.v( v_p(i) ).rout( q.v( v_p(i) ).r , 6  )= v_p(i) ;
% cout the new packet
q.v( v_p(i) ).r =q.v( v_p(i) ).r +1;
else
% the vertex CANNOT accept the new packet
% cout a failed packet
q.pack(  q.k -1  , 5  )=2;
end

% q.pack
% 
% % q.v( v_p(i) ).init( q.v( v_p(i) ).i -1 , :)
% q.v( v_p(i) ).init
% q.v( v_p(i) ).i
% 
% % q.v( v_p(i) ).rout( q.v( v_p(i) ).r -1 , :  )
% q.v( v_p(i) ).rout
% q.v( v_p(i) ).r



          else
           % there is no more space in the global packet queue
           q.br=1;
           break
          end
       end  %j=1 : num_p % for each  packet
     end %  num_p==0     
  else
    display('There is no more space in the global packet queue...break')
    break
  end %if queue.br==0 % is there any space in the global packet queue
end  % for all vertexes

case 'propagate_packets',

 % One needs to generate packets with a random permutation 
% of the vertexes otherwise there will bi priority for 
% the packets with respect to the vertex label
% generate a random permutation
v_p=randperm(graph.k) ; 
for i=1  :graph.k % for all vertexes   
% at this point on the label of a vertex becomes v_p(i)
% Build the cover tree rooted at v_p(i)
graph_bfs=bfs_nl(graph, v_p(i) ,graph.k+1,'cover_tree');
    for j=1  : q.opt.resourses 
    % for all packetr that need to be routed at v_p(i)
        if q.v( v_p(i) ).rout(j,1)>0
        % rout the packet q.v( v_p(i) ).rout(j, : )
        % find the next vertex at v_p(i) for the packet
next_vertex=cover_tree2next_vertex(graph_bfs ,...
v_p(i),...% current vertex, alternatively q.v( v_p(i) ).rout(j,6) 
q.v( v_p(i) ).rout(j,2) ); % destination vertex 

% One of a number of things that can happen from here on
switch next_vertex
    case 0, % 1. There is NO next vertex
        % mark a FAILED packet in the global queue
        % a pointer to the global queue
        %        q.v( v_p(i) ).rout(j,5) 
        q.pack(  q.v( v_p(i) ).rout(j,5)  ,5)=2;
 
        % remove the packet from both queues
        q=remove_from_q( q,v_p(i) , j  ,'rout_init');
        
    otherwise, % 2. There IS a next vertex

     if q.v( next_vertex ).r <=  q.opt.resourses    
     % 2.1 The next vertex CAN accept the packet
            if next_vertex==q.v( v_p(i) ).rout(j,2)
            % 2.1.1 The next vertex IS the destination
                % mark a  RECIEVED packet in the global queue
                % a pointer to the global queue
                %        q.v( v_p(i) ).rout(j,5) 
                q.pack(  q.v( v_p(i) ).rout(j,5)  ,5)= 1 ; 
                % mart time 
                q.pack(  q.v( v_p(i) ).rout(j,5)  ,4)= simulation_time ; 
                
                % remove the packet from both queues
                q=remove_from_q( q,v_p(i) , j  ,'rout_init');                
            else
            % 2.1.2 The next vertex IS NOT the destination
                % assign the packet to the next vertex
                % the packet
                % q.v( v_p(i) ).rout(j,:) 
                % next vertex empty vector
                %q.v( next_vertex ).rout( q.v( next_vertex ).r ,:)
                q.v( next_vertex ).rout( q.v( next_vertex ).r ,1:6)=...
                q.v( v_p(i) ).rout(j,1:6) ;
                
                % fix the position of the first empty vector
                % at the next vertex
                q.v( next_vertex ).r=1+...
                    q.v( next_vertex ).r;
                
                % remove the packet from old vertex rout queue
                q=remove_from_q( q,v_p(i) , j  ,'rout');                 
            end
     else
     % 2.2 The next vertex CANNOT accept the packet
                % mark a  FAILED packet in the global queue
                % a pointer to the global queue
                %        q.v( v_p(i) ).rout(j,5) 
                q.pack(  q.v( v_p(i) ).rout(j,5)  ,5)= 2 ;               
               
                % remove the packet from both queues
                q=remove_from_q( q,v_p(i) , j  ,'rout_init');     
     end        
        
end % switch next_vertex


        else % q.v( v_p(i) ).rout(j,1)>0
        % no more packets for routing
        break
        end % q.v( v_p(i) ).rout(j,1)>0
    end % j=1: q.opt.resourses % all packets for routing
end  % for all vertexes
    
       
otherwise
    display('uknown option for wsn_traffic')         
end %switch packet_option

    
    
    

end