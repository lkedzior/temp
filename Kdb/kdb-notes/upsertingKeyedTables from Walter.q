
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