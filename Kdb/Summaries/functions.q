c/building file paths with sv
q)` sv `:/home/kdb/q`data`2010.03.22`trade
`:/home/kdb/q/data/2010.03.22/trade

q)` sv `mywork`dat
`mywork.dat

/opposite operations with vs
q)` vs `mywork.dat
`mywork`dat
q)` vs `:/home/kdb/data/mywork.dat
`:/home/kdb/data`mywork.dat

/# reshape, create nested lists
/nrRows nrCols # List
q)2 3 # til 10
0 1 2
3 4 5

q)2 3 # til 4
0 1 2
3 0 1

/e.g. lists with given number of elements
q)0N 3 #til 10
0 1 2
3 4 5
6 7 8
,9


/comparing strings(not symbols)
/same like, each right or each must be used when selecting from tables with where statemment on strings
q)L like "abc"
101010101010101010.....
q)\t L like "abc"
31
q)\t "abc"~/:L
140
q)\t ("abc"~) each L
343

Select[n]

        select[2] from tk	

        select[-1] from tk	/negative – returns the last records


////    .Q    ////

/performance improvement, when applying expensive func to a list 
.Q.fu[func;L]	 /applies func to distinct L and copy results to the whole list
instead of
func each L
.Q.fu[func] L
fu:{[f;x]
  d:distinct x;
  (d!f d)[x]
 };
f:{x*x}
fu[f] raze 2#enlist til 5

fu:{[f;x]
  ur:f u:distinct x;
  ur u?x
 };
fu[f] raze 2#enlist til 5

//calculate vwap per instrument
q)t:([] sym:`IBM`AAA`IBM; size:10 20 30; price:1.0 2.0 3.0)
q)t
sym size price
--------------
IBM 10   1
AAA 20   2
IBM 30   3

q)select vwap:size wavg price by sym from t
sym| vwap
---| ----
AAA| 2
IBM| 2.5
q)

size wavg price -> (sum size*price)%sum size


/find out the null value of integer type
q)first `int$()
0Ni


/adding vwap real time service
q tick/c.q vwap :5010 –p 6005

q)vwap
sym| price size
---| ----------

q)upd
{[t;x]vwap+:select size wsum price,sum size by sym from x}
q)vwap
sym| price size
---| ----------
q)