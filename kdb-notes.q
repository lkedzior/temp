in the parsing tree

nested list `aaa`bbb would indicate list of names/columns
doubly nested list e.g. enlist ("aaa";"bbb") indicates list of constants

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
