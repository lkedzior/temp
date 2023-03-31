/if returns null (::)
if[cond;e1;e2;e3;...]

/conditional evaluation cond ?: valueIfTrue : valueIfFalse
/returns explicit results
$[cond; exprIfTrue; exprIfFalse]  //evaluates only one expression y or z

/execute whole block like if-else
/returns last expression from the block that was executed
$[cond; [et1;et2;...]; [ef1;ef2;...]]

/if elseif else block
$[ cond1;[...]; cond2;[...]; ... ; condn;[...]; [elseBlock] ]
q)$[0b;[2+2;`if]; 0b;[`elseif];[`else]]
`else

/vector conditional evaluation - evaluates both y & z params (both are normally needed given x boolean vector)
q)?[1100b;1 2 3 4;10 20 30 40]
1 2 30 40

/update list items at indexes defined by boolean list
q)L
1 2 3 4
q)?[1100b; L+100; L]	 /same as @[L;0 1;+;100]
101 102 3 4

/do - returns null item
do[numberOfIterations; e1;e2;e3;...]

/while
while[cond; e1; e2; e3;...]

/example - scanning hdb partitions until data was found
/api should ask for start end times so that we don't scan entire HDB

res:select by sym, streamId from dealabilityupdate where date = `date$dt, sym=s,
msgTimestamp<=`timespan$dt, streamId=stream;

d:(`date$dt)-1;
firstHdbDate:first date;
while[(d>=firstHdbDate) and 0=count res;
  res:select by sym, streamd from dealabilityupdate where date=d, sym=s, streamId=stream
  d:d-1;
 ];

res:delete date from update time:date+time from res;
return res

/e.g. while for fibonnaci numbers
q)res:1 1
q)n:10
q)while[n:n-1; res:res,sum -2#res]
q)res
1 1 2 3 5 8 13 21 34 55 89
q)
