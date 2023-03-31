/get all namespaces
key`

system"f"	 /functions
system"v"	 /variables
system"a"	 /tables
system"l ."	 /reload

select from marketdata where sym=`EURUSD, ((market like "REU*") or market like "EBS*")
/this condition can be written this way
((market like "REU*") or market like "EBS*")
any market like/: ("REU*"; "EBS*")


/downloading http results as csv
http://hostaname:port/.csv?select ...

/5 mins bars with time and timespan

1000*60*5 xbar time		 /as time type
`time$5 xbar time.minute	 /as time type
`timespan$5 xbar time.minute	 /as timespan type

q)select last price, sum size by 10 xbar time.minute from trade where sym=`IBM
minute| price size
------| -----------
09:30 | 55.32 90094
09:40 | 54.99 48726
09:50 | 54.93 36511
10:00 | 55.23 35768

/if time column is of timespan type then
0D:00:05 xbar time
0D1 is one hour

/killing remote session
@[h;"exit 0";{}]	 /protected evaluation


/custom functions within select
/qty with mio suffix if it is more than 1m
select qty:{$[count x; x,"mio";x]} each (string quantity%1000000), quantity from internalorderevent

/design functions so that they work with vectors
/not vectorized version takes 171 ms
select {$[x<y; `int$`time$`datetime$(y-x);neg `int$`itme$`datetime$(x-y)]}'[transactTime; consumeTime] from fixmarketdata
/vectorized version takes 13ms
select time, sym, transactTime, consumeTime, {?[x<y; `int$`time$`datetime$(y-x); neg `int$`time$`datetime$(x-y)]}[transactTime;consumeTime] from fixmarketdata
/better version with over takes 9ms
select {`int$`time$(-/)`timestamp$(y;x)}[consumeTime;transactTime] from fixmarketdata

/################timestamp and timespan format

q).z.p
2013.06.13D07:05:42.375000000	 /timestamp stored as long, number of ns from start time
q)`timestamp$1		 /start time
2000.01.01D00:00:00.000000001
q)

q).z.n		 /timespan stored as long, number of ns from start time
0D07:06:26.937500000
q)`timespan$1
0D00:00:00.000000001
q)

/#####################reading files with path[`file]
 q)get `:/temp/test
1 2 3 4

q)`:/temp[`test]
1 2 3 4

q)`:/temp `test
1 2 3 4

/###########################replaying the log file with value
q)\l /kdb/bin/KdbConfig/current/instances/5520/schema/logevents.q
q)upd:insert

q)m:get `:logevents2013.05.17
q)m
`upd `logevents (,0D00:00:00.064867000;,`AP_AIT_ARCH_A_PRI; ...
`upd `logevents (,0D00:00:00.964867000;,`AP_AIT_ARCH_A_PRI; ...

q)value each m	 /this will call upd[`logevents; ...] for each entry in the log


/#############################getting meta data from first partition
/by default kdb will look at last partition to load meta data
/this can be overriden by adding this line to hdb code
k).Q.d0:{.Q.dd[*.Q.pd;*.Q.pv]}

/the first partition is always the same, the last might not be if there are some issues when saving to disk








