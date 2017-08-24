in the parsing tree

select from tbl where user=myUser
enlist (=;`user;`myUser)

select from tbl where user=`myUser
enlist (=;`user;enlist `myUser)

if `myUser is hardcoded literal then we have to enlist it
if myUser is a variable then we use `myUser symbol

#runninng moving average with variable number of ticks the average is calculated on
/n column defines number of ticks to be taken into account when calculating avg
.tmp.t:([] price:til 100000; n:2+100000?2)
\ts update px1:avg each price@i-til each n from .tmp.t
\ts update a:{[p;n;i] n:n[i]; f:(1+i-n); avg p[f+til n]}[price;n;] each i from .tmp.t   

#Return rows where column value/expression differs (i.e. value has changed with a new tick)
/1e-7 xbar (mycol) can put the same value to different buckets
    /e.g. (1e-7 xbar 0.66) can yield 0.66 or 0.6599999
    /1e-7 xbar 0.66 + 0.00000005) always ends up in the same bucket 0.66
    (((differ;  1e-7 xbar (mycol) + 0.5e-7) fby ([]date;sym))

table within join
table1 wtih st;et columns
table2 with time column
join table1 cross table2 and return only rows where time within (st;et)
e.g.
q)t:update et:st+10?10,a:10?10,b:10?1.0 from ([]st:10?00:10)
q)t1:`time xasc ([]time:5?00:20;z:5?1000)
q)res1:select from (t cross t1) where time within (st;et)
q)res2:ungroup wj1[t`st`et;`st;t;(update st:time from t1;(::;`time);(::;`z))]
or ungroup wj1[t`st`et;`st;t;enlist[update st:time from t1],(::),/:cols t1]


Creating links between splayed tables
e.g. trade and tradeCancel
update tradeCancelLink:`tradeCancel!tradeCancel.id?id from trade
//this will populate missing ids with the count of the tradeCancel which is okay
when we use dot notation tradeCancelLink.columnA we will get nulls for these rows

for splayed save downs
pathToTheColumn set `tradeCancel!indecies 
where indecies are calculated with ? as above


Kdb can stop with bus error if /dev/shm is too small.
As a rough guide, it should be large enough for a decompressed partition.
If a script is iterating over the files, we must be sure to not to keep references to them once they are finished with,
otherwise they will needlessly occupy the shm memory. 


http://code.kx.com/wiki/Cookbook/cpuaffinity 


kdb will swtich to debug on error only if we have got nested function call
q)f
{[x] if[x; '"Hdb not ready"]}
q)f 10
'Hdb not ready
q)g
{f 10}
q)g[]
{f 10}
'Hdb not ready
@
{[x] if[x; '"Hdb not ready"]}
10
q))


###################
partitioning by symbol
i.e. same date partition is saved in all par.txt locations
Will that help with 32bit limits?
-w specifies a limit for individual slaves
but can one process use more than 4GB if slaves stay below 4GB mark?



###################
byMinQuery:{[tbl;n]
  select ...
  by n xbar time.minute
  from tbl
 }

bySecondQuery:{[tbl;n]
  select ...
  by n xbar time.second
  from tbl
 } 
 
can be done with 
select ...
by n xbar time
from tbl

where n=0D00:01 or 0D00:02 or 0D00:05 for minute bins
or n=0D00:00:01 or 0D00:00:02 or 0D00:00:05 for second bins

////f1 in q instead of k
f1:{x@{(y>)x/x y}[x?1+x] each til count x} 

given list, e.g.


x:8 2 4 1 6 0 5 3 7 9


for each find the smallest number to the right that is >=, e.g.


f x
   9 3 5 3 7 3 7 7 9 0N




also:


x:-10000?10000
\t f x

###############################c.q storing n last bucket prices

most of the time we can use this construct
we update exisitng cache using apply and dyadic function which operates on existing cache and incoming data table
@[table;key incomingDataTable;dyadicfunc;value incomingDataTable]    

see this debug output
q)kt:([a:`a`b`c] v:(10 10 10;20 20 20; 30 30 30));
q)kt
a| v
-| --------
a| 10 10 10
b| 20 20 20
c| 30 30 30
q)updKt:([a:`a`b] v:(100 100; 200 200));
q)updKt
a| v
-| -------
a| 100 100
b| 200 200

//here we do dictx,dicty which is upsert 
q)@[kt;key updKt; {[x;y] -1"func running ";0N!x;0N!y;x,y}; value updKt]
func running
(,`v)!,10 10 10
(,`v)!,100 100
func running
(,`v)!,20 20 20
(,`v)!,200 200
a| v
-| --------
a| 100 100
b| 200 200
c| 30 30 30

//here we do dictx,'dicty which is append at the value level
q)@[kt;key updKt; {[x;y] -1"func running ";0N!x;0N!y;x,'y}; value updKt]
func running
(,`v)!,10 10 10
(,`v)!,100 100
func running
(,`v)!,20 20 20
(,`v)!,200 200
a| v
-| ----------------
a| 10 10 10 100 100
b| 20 20 20 200 200
c| 30 30 30

//here we trim above result to keep last 3 values with -3#'
q)@[kt;key updKt; {[x;y] -1"func running ";0N!x;0N!y;-3#'x,'y}; value updKt]
func running
(,`v)!,10 10 10
(,`v)!,100 100
func running
(,`v)!,20 20 20
(,`v)!,200 200
a| v
-| ----------
a| 10 100 100
b| 20 200 200
c| 30 30  30
q)


t:([sym:`a`b]time:(10:00 10:01 10:02;10:00 10:01 10:02);price:(1.1 1.11 1.2;1.1 1.09 1.1));
d:([]sym:`a`b`a`b`b`a;time:10:01:01.10 10:01:01.20 10:02:02.20 10:02:02.20 10:02:02.30 10:02:02.40;price:1.1 1.1 1.2 1.3 1.3 1.2);
t1:select first[time]!first price by sym from t ;
{[t;data] d:select price:time!price by sym from select last price by sym, time:time.minute from data;
  @[t;key d;{-3 sublist/: x,'y};value d];
 }[`t1;d]
t1

another aproach
{[t;data]
  d:`sym xgroup 0!select last price by sym, time:time.minute from data;
  @[t;key d;{(key;value)@\:-3 sublist (exec time!price from x),exec time!price from y};value d]
}[t;d] 

#####################pulling large table
assuming large table t is on remote process
h:hopen remote process
t:();  //create a table the remote will be insert into

//run async so that remote can insert (deadlock otherwise)
neg[h]({[tbl]
  //we can cut by sym or just each over different i ranges where i within ...
  syms:exec distinct sym from ...
  //is it safer to do .z.w instead neg[.z.w] because the remote
  //does not multiple chunks if the local was busy processing something else?
  {[tbl;s] .z.w(insert[tbl]; select from tbl where ...,sym=s);}[tbl] each syms;
}[`t]);


#############loading text file as a string
read1 `$:file.txt //returns byte list
`char$read1 `$:file.txt //`char$ turns byte list into a string/char list


################generating file paths
q)key[`:.]
`s#`a`b`c
q)`:myPath,/:key[`:.]
:myPath a
:myPath b
:myPath c
q)` sv/: `:myPath,/:key[`:.]
`:myPath/a`:myPath/b`:myPath/c

q)hFilePaths:{` sv/: x,/:key x}
q)hFilePaths `:.
`:./a`:./b`:./c


#################checking types in table columns
distinct type''[tbl]

#################adding multiple columns to a table
//use `t if you need in-place update
q)f:{(100 200 300; 1000 2000 3000)}
q)t:([]a:10 20 30)
q)![t;();0b;(`c`d)!f[]]
a  c   d
-----------
10 100 1000
20 200 2000
30 300 3000
q)@[t;`aa`bb;:;f[]]
a  aa  bb
-----------
10 100 1000
20 200 2000
30 300 3000
q)

#######################################.Q.dpft vs in memory sym
Saving with .Q.dpft and poining to new location will override in-memory sym variable with new values
So if we were to use HDB process to .Q.dpft to new location we would need to re-load the initial HDB location
to be able to read its data again

E.g. 
q)t:([] time:.z.t+til 2; sym:`a`b; v:til 2)
q)t
time         sym v
------------------
12:59:22.109 a   0
12:59:22.110 b   1
q).Q.dpft[`:hdb1;.z.d;`sym;`t]
`t
q)sym
`a`b
q)t:([] time:.z.t+til 2; sym:`b`c; v:til 2)
q).Q.dpft[`:hdb2;.z.d;`sym;`t]
`t
q)sym
`b`c

