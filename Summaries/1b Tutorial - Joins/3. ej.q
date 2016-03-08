////    equijoin ej[c;t1;t2]  /'ikwi, 'ɛkwi/  ////
/ej verb joins two tables on a given list of columns c
/ej is like keyed inner join (ij) but it works with non-keyed tables

q)s:([]sym:`IBM`MSFT`dummy;ex:`N`CME`dummy;MC:1000 250 777)
q)t:([]sym:`IBM`FDP`FDP`FDP`IBM`MSFT;price:0.7029677 0.08378167 0.06046216 0.658985 0.2608152 0.5433888)

q)s
sym   ex    MC
----------------
IBM   N     1000
MSFT  CME   250
dummy dummy 777		 /ej is inner join, `dummy does not exists in second table, hence this wont be included in results

q)t
sym  price
---------------
IBM  0.7029677
FDP  0.08378167
FDP  0.06046216
FDP  0.658985
IBM  0.2608152
MSFT 0.5433888

/what happens when second table has duplicates?
/All combinations will be included in the result table
q)ej[`sym;s;t]
sym  ex  MC   price
-----------------------
IBM  N   1000 0.7029677
IBM  N   1000 0.2608152
MSFT CME 250  0.5433888

