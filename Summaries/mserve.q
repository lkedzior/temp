/ http://code.kx.com/wiki/Cookbook/LoadBalancing
/ e.g.  q mserve.q -p 5001 2 tq


/ start slaves
/{value"\\q ",.z.x[1]," -p ",string x}each p:(value"\\p")+1+til"I"$.z.x 0;
port:5001
system"p ",string port
p:5002 5003
startupScript:""
{value"\\q ",startupScript," -p ",string x}each p;

/ unix (comment out for windows)
/sleep 1

/ connect to slaves
h:neg hopen each p;
h@\:".z.pc:{exit 0}";    /for each slave handle @[handle;"..."]
h!:()
/
q)h
-1924|
-1928|
\

/ fields queries. assign query to least busy slave
.z.ps:{
	$[(w:neg .z.w)in key h;
	    /response
		[
			h[w;0]x;    /h[w;0] use client handle i.e. the first handle from the queue for this slave and send the msg x
			 /given slave processes all requests in order they are sent - hence we remove first item from the queue 1_h w 
			h[w]:1_h w  /remove client handle from the queue
		];
        /request
		[
			h[a?:min a:count each h],:w;    /append client hadle to a queue for the slave handle with the shortest queue
			 / a is now neg slave handle added
			a("{(neg .z.w)@[value;x;`error]}";x)    /request passed to run on slave
		]    
	]
  }


\

client(h:hopen 5001):  (neg h)x;h[]

l64: 50us overhead(20us base)

