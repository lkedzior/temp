/Some joins are asof, where a time column in the first table specifies corresponding intervals
/in a time column of the second table. Such joins are not keyed. 



////	asof	////
/asof is a simpler aj where all columns (or dictionary keys) of the second argument are used in the join.

/
The verb asof takes a table as the left arg and a dictionary or a table as a right arg.
The last key of the dictionary, or the last column of the table on the right must be of time/timespan/timestamp type (datetime won't work)

If there are more rows with matching time, the last one (prevailing value) will be included in the result 
\

q)trade:([]time:09:30:00.0 09:31:00.0 09:31:00.0 09:32:00.0;sym:`aaa`aaa`bbb`aaa;price:10.0 20.0 30.0 40.0 ;size:100)

q)trade
time         sym price size
---------------------------
09:30:00.000 aaa 10    100
09:31:00.000 aaa 20    100
09:31:00.000 bbb 30    100
09:32:00.000 aaa 40    100

/show the price as of 09:31:00.0 i.e. the last entry in the table where the time is 09:31:00.0 or before
q)trade asof ([]time:09:31:00.0 09:40:00.0)	 /note no time column in the results
sym price size
--------------
bbb 30    100
aaa 40    100

/you can use dictionary as the second argument
q)trade asof (enlist `time)!enlist 09:31:00.0
sym  | `bbb
price| 30f
size | 100

/another example this time specifying symbol, note the last column should be time
q)trade asof ([]sym:enlist `aaa; time:09:31:00.0)
price size
----------
20    100




////	aj aj0 (asof join function)	////
aj[c1...cn;t1;t2]	 /join on c1...cn columns
/The result is a table with records from the left join of t1 and t2.
/NOTE that matching on time column will accept times before if there is no exact matching
/For each record in t1, the result has one record with the items in t1, and
/if there are matching records in t2, the items of the last matching record are appended to those of t1
/if there is no matching record in t2, the remaining columns are null

t:([]time:10:01:01 10:01:03 10:01:04;sym:`msft`ibm`ge;qty:100 200 150)
time       sym  qty
-----------------
10:01:01 msft 100
10:01:03 ibm  200
10:01:04 ge   150

q:([]time:10:01:00 10:01:01 10:01:01 10:01:03;sym:`ibm`msft`msft`ibm; px:100 99 101 98)
time       sym  px 
-----------------
10:01:00 ibm  100	 /this price won't be taken into account
10:01:01 msft 99 	 /note, 2 prices for msft with same time 10:01:01
10:01:01 msft 101	 /only this price, the last(most recent time) will be present in results
10:01:03 ibm  98

q)aj[`sym`time;t;q]		 /last join column must be common time
time       sym  qty px
---------------------
10:01:01 msft 100 101	 /note in SQL left join would give 2 records not 1
10:01:03 ibm  200 98
10:01:04 ge   150

/If the resulting time value is to be from the quote (actual time)
/instead of the (boundary time) from trade, use aj0 instead of aj.


- What format the data should be in for the most performant aj?
- Lucian: The first column in the column list should have an index on it in the table on the right
e.g. aj[`sym`time;t1;t2] then you need a `g# on sym in t2


////	window join function	////

###########wj join (notes from qtips book)
There are two assumptions about the data that must be true.
Firstly, in addition to the time column, there can only be a single column which uniquely identifies a record.
And secondly, the table must be sorted first by the identifier and then by time with the partition attribute `p on the identifier column.

Other joins allow the data to be un-partitioned as long as a `g attribute is placed on the identifier column.
THE wj OPERATOR, HOWEVER, DOES NOT ALLOW THIS.
The query will execute, but the reults will be meaningless.

For this reason it is not possible to use the wj operator across multiple ids on a real-time database.
It is meant to be used on an historical database where data has been sorted within partitioned sections.

wj[t.time+/: -0D00:00:01 0D;`id`time;t](q;(avg;`bp);(avg;`ap)

wj considers prevailing quote
wj1 does not consider events outside the window

Due to its implementation, the wj operator can only work with integer temporal values.
This means that the datetime and any other float value can not be used with wj or wj1
###########wj join (end of notes from qtips book)

/window join aggregates values of specified columns within intervals.
/e.g.  wj[w;`sym`time;t;(q;(max;`ask);(min;`bid))]
/t and q are the tables to be joined.
/q MUST be sorted `sym`time with `p# on sym
Note that wj requires only one join column ( so you can't have `sym`market`time)
Note that wj requires `p attribute, you get underfined results with other att alike `g

q)t:([]sym:3#`ibm;time:10:01:01 10:01:04 10:01:08;price:100 101 105)
q)t
sym time     price
------------------
ibm 10:01:01 100
ibm 10:01:04 101
ibm 10:01:08 105

q)q:([]sym:10#`ibm;time:10:00:58,10:01.00+til 9;ask:106 105 105 103 104 104 107 108 107 108;bid:97 98 99 102 103 103 104 106 106 107)
q)q
sym time     ask bid
--------------------
ibm 10:00:58 106 97
ibm 10:01:00 105 98
ibm 10:01:01 105 99
ibm 10:01:02 103 102
ibm 10:01:03 104 103
ibm 10:01:04 104 103
ibm 10:01:05 107 104
ibm 10:01:06 108 106
ibm 10:01:07 107 106
ibm 10:01:08 108 107

/For each time in t table we can build a 'time window' intervals
/e.g. here we build a window that starts 2 secs before t.time and ends 1 sec after t.time

q)t.time
10:01:01 10:01:04 10:01:08
q)w:(-2 1)+\:t.time
q)w
10:00:59 10:01:02 10:01:06
10:01:02 10:01:05 10:01:09

/Now we can join t table with q table so that for each record in t, the result table has additional columns
/which are the results of the aggregation functions applied to q columns over matching 'time windows' intervals  

q)wj[w;`sym`time;t;(q;(max;`ask);(min;`bid))]
sym time     price ask bid
--------------------------
ibm 10:01:01 100   106 97
ibm 10:01:04 101   107 102
ibm 10:01:08 105   108 106

/interval values may be seen using ::
q)wj[w;`sym`time;t;(q;(::;`ask);(::;`bid))]
sym time     price ask             bid
--------------------------------------------------
ibm 10:01:01 100   106 105 105 103 97 98 99 102
ibm 10:01:04 101   103 104 104 107 102 103 103 104
ibm 10:01:08 105   108 107 108     106 106 107

/the difference between wj and wj1 is that wj1 does not take into account the prevailing quote
q)wj1[w;`sym`time;t;(q;(::;`ask);(::;`bid))]
sym time     price ask             bid
--------------------------------------------------
ibm 10:01:01 100   105 105 103     98 99 102
ibm 10:01:04 101   103 104 104 107 102 103 103 104
ibm 10:01:08 105   108 107 108     106 106 107

/aj,aj0 are simpler window joins where only the last value in each interval is used.
q)aj[`sym`time;t;q]
sym time     price ask bid
--------------------------
ibm 10:01:01 100   105 99
ibm 10:01:04 101   104 103
ibm 10:01:08 105   108 107

/Since v3.0, wj and wj1 are both [] interval, i.e. they consider quotes>=beginning and <=end of the interval.

