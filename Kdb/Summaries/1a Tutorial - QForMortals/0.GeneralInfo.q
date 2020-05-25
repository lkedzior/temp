/comments until end of line

/
comments line 1
comments line 2
\

/
if '/' or '\' is first and the only character in the line
then every following line is commented out until end of the file
\

/
multiline function:
table/function can have line breaks after the closing square brcket or after a (;)
f:{[a;b]
  e1;
  e2;
  e3
 } /note a spaces at the begining of each line and before closing bracket
\



/
""	 /empty char list
" "	 /null char

-1 "" /prints to stout, 1 "" does append new line
-2 /prints to st error
0N! x /prints and returns x
q)show
k){1 .Q.s x;}	 /.Q.s formats an object to plain text, as used by the q console.
−3!x /used by .Q.s, returns string representation of x

/extracting year/month/day as int number from date
q)d
2013.06.05
q)d.year or `year$d
2013i
q)d.mm or `mm$d
6i
q)d.dd or `dd$d
5i


/extracting hours mins secs as int number from time
q)t
08:34:27.421
q)t.hh
8i
q)t.mm
34i
q)t.ss
27i
q)

/to get number of miliseconds use modulo
q)`int$t mod 1000
421i


/you can also extract higher-order constituents (won't work inside a function, have to use casting to int in this case)
date: d.month
q)d.month
2013.06m

time: t.minute, t.second, t mod 1000 to get miliseconds
q)t.minute
08:34
q)type t.minute
-17h

datetime: dt.year, dt.month, dt.date, dt.time, dt.minute
q)dt.year
2013i
q)dt.month
2013.06m
q)dt.date
2013.06.05
q)dt.time
18:59:25.640
q)dt.minute
18:59

/The above does not work with function arguments. You MUST use casting with function arguments.
q)fmm:{[x] `mm$x}
q)fmm 2006.09.15
9i

/
datetime-stored as a signed float
time-stored as an int, number of milliseconds from the start of day

A date and a time can be added to give a datetime.

        2007.07.04+12:45:59.876
2007.07.04T12:45:59.876 

Note: A time is implicitly converted to a fractional day when it is added to a date to get a datetime.

Observe that a time does not wrap when it exceeds 24 hours. 
        23:59:59.999+2 
24:00:00.001 
\


/
//// INTERPROCESS COMMUNICATION    ////
.z.ps / asynch request(set), default {value x}
.z.pg / synch request(get), default {value x}
.z.w /client connection
.z.pc /client close handler

/(neg h)[] vs h[]

//flushing buffer after asynch call
(neg h)[]
async send, e.g. neg[h] data
merely queues the data for sending later. The actual writing into sockets begins at any of the following
1)when the current/pending queries/script complete
2)a sync request is issued on h
3)an async purge on h is performed, i.e. neg[h][]; / blocks until all pending msgs on h are sent

neg[h][] or neg[h](::)
doesn't mean that it has been processed by or even reached the server.
It means it has been written into it's local tcpip buffers.

//from client code
neg[h](::)		 //clears the outbound client queue
h""				 //this synch call ensures the server has processed all prior incoming asyn messages!
 
So if h"" follows your async calls, you can be sure that your async request has been process when h"" returns


/
using h[] in gateways code to listen on socket
gateways can be design to have async communication with HDBs/RDBs
1. client calls gw function using sync call
2 then gateway dispatches requests HDB and RDB using async call
3 then it listen on RDB socket
4 then it listen on HDB socket
5 when 3 and 4 returns it merges results and gw function can return
\


/
---------
Important: When local and global names collide,
the global variable is always obscured.
Even double colon assignment will NOT affects the global variable.

a:42
f:{a:6;a::98; x*a}	/global a is not changed by this f
---------

/
What makes the language dynamic
the key factor for a language to qualify as “dynamic” is the ability to define new code at runtime


        