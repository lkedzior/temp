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
