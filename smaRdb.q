.log.inf"Entering ", string[.z.f];

.z.exit:{
  -1 (string .z.z), "\tEntering .z.exit";
  show .Q.w[];
 };

.z.po:{[x]
  .log.inf["Entering .z.po",
    ", handle=", string[x],
    ", user=", string[.z.u],
    ", hostname=", string[.Q.host .z.a]
  ];
 };

.z.pc:{[x]
  .log.inf"Entering .z.pc, handle=", string[x];
  if[x~.u.tp;
    .log.inf"Lost TP connection, exiting";
    exit 1;
  ];
 };

//We need to have current avgLast10 14 20 50 100 200 stats
//We probably need to do avgs on mid prices so consider if it make sense to change updOnTbl to be less generic and work with specific cols
/sample code do do avgOnLast 
/avgLast:{avg x#y}
/avgOnLast:{`avgLast10`avgLast14`avgLast20`avgLast50`avgLast100`avgLast200!(avgLast[-10];avgLast[-14];avgLast[-20];avgLast[-50];avgLast[-100];avgLast[-200])@\:x}
/exec avgOnLast 0.5*bid+ask by sym:sym from hour1

avgLast:{avg x#y};
smas:{`sma10`sma14`smat20`sma50`sma100`sma200!(avgLast[-10];avgLast[-14];avgLast[-20];avgLast[-50];avgLast[-100];avgLast[-200])@\:x};

updOnTbl:{[t;x]

  /if[x~"last";upd:{[t;x].[t;();,;r::select by sym from x]}]
  /.[`lastUpd;();,;select by sym from x];

  .[`second30;();,;select by sym,time:.u.d+30 xbar time.second from x];
  .[`min1;();,;select by sym,.u.d+1 xbar time.minute from x];
  .[`min2;();,;select by sym,.u.d+2 xbar time.minute from x];
  .[`min5;();,;select by sym,.u.d+5 xbar time.minute from x];
  .[`min10;();,;select by sym,.u.d+10 xbar time.minute from x];
  .[`min15;();,;select by sym,.u.d+15 xbar time.minute from x];
  .[`min20;();,;select by sym,.u.d+20 xbar time.minute from x];
  .[`min30;();,;select by sym,.u.d+30 xbar time.minute from x];
  .[`hour1;();,;select by sym,time:.u.d+60 xbar time.minute from x];
  .[`hour2;();,;select by sym,time:.u.d+120 xbar time.minute from x];
  .[`hour4;();,;select by sym,time:.u.d+240 xbar time.minute from x];
  .[`hour8;();,;select by sym,time:.u.d+480 xbar time.minute from x];
  .[`day1;();,;select by sym,time:.u.d from x];
  .[`week1;();,;select by sym,time:`week$.u.d from x];
  .[`month1;();,;select by sym,time:`month$.u.d from x];
  
  /This works okay when we get x as 1 row
  /For multiple rows updates it's possible that the last tick in bin is not taken into account for sma
  /e.g. x`sym is `GBP/USD`GBP/USD, x`time is 13:21:59 13:22
  /by sym, last time from min1 will return `GBP/USD | 13:22 
  /we would not recalculate/upsert  13:21 into smaMin1
  .[`smaSecond30;();,;exec smas 0.5*bid+ask by sym, last time from second30 where sym in x`sym];
  .[`smaMin1;();,;exec smas 0.5*bid+ask by sym, last time from min1 where sym in x`sym];
  .[`smaMin2;();,;exec smas 0.5*bid+ask by sym, last time from min2 where sym in x`sym];
  .[`smaMin5;();,;exec smas 0.5*bid+ask by sym, last time from min5 where sym in x`sym];
  .[`smaMin10;();,;exec smas 0.5*bid+ask by sym, last time from min10 where sym in x`sym];
  .[`smaMin15;();,;exec smas 0.5*bid+ask by sym, last time from min15 where sym in x`sym];
  .[`smaMin20;();,;exec smas 0.5*bid+ask by sym, last time from min20 where sym in x`sym];
  .[`smaMin30;();,;exec smas 0.5*bid+ask by sym, last time from min30 where sym in x`sym];
  .[`smaHour1;();,;exec smas 0.5*bid+ask by sym, last time from hour1 where sym in x`sym];
  .[`smaHour2;();,;exec smas 0.5*bid+ask by sym, last time from hour2 where sym in x`sym];
  .[`smaHour4;();,;exec smas 0.5*bid+ask by sym, last time from hour4 where sym in x`sym];
  .[`smaHour8;();,;exec smas 0.5*bid+ask by sym, last time from hour8 where sym in x`sym];
  .[`smaDay1; ();,;exec smas 0.5*bid+ask by sym, last time from day1  where sym in x`sym];
  .[`smaWeek1;();,;exec smas 0.5*bid+ask by sym, last time from week1 where sym in x`sym];
  .[`smaMonth1;();,;exec smas 0.5*bid+ask by sym, last time from month1 where sym in x`sym];
  
 };

updOnList:{[t;x]
  if[not t~p.table;:(::)];
  f:key flip value t;
  x:$[0>type first x;enlist f!x;flip f!x];
  updOnTbl[t;x];
 };

/.u.end:{@[`.;tables`.;0#];}
.u.end:{
  .log.inf "Entering .u.end, date=", string x;
  .u.d+:1;
  .log.inf ".u.end finished";
 };

.u.rep:{
  (.[;();:;].) x; /define p.table
  if[null first y;:()]; /return here if logCount is null
  -11!y; /replay the log
 };

/go to HDB and load 200points history for each tbl
/we could just load it directly from last HDB
/or if not available calculate from prices HDB
initHistory:{};

.log.inf "Reading cmd line input cfg";
.opt.config,:(`tpProcessHandle;`;"tp port");
.opt.config,:(`hdbProcessHandle;`;"hdb port");
.opt.config,:(`table;`prices;"tp table name for subscription");
p:.opt.getopt[.opt.config;`tpProcessHandle`hdbProcessHandle] .z.x;
if[`help in key p;-1 .opt.usage[1_c;.z.f];exit 1];

show p;

.u.d:.z.D;

initHistory[];

.log.inf "Opening the tp connection";
.u.tp:hopen p.tpProcessHandle;

.log.inf"Define upd as updOnList for .u.rep";
`upd set updOnList;

.log.inf "Subscribe and replay tp log";
.u.rep . (.u.tp)"(.u.sub[",(-3!p.table),";`];`.u `i`L)";

.log.inf"Define upd as updOnTbl";
`upd set updOnTbl;

.log.inf string[.z.f], " is running now";

/
This process will keep last row  for different time frames
It will have 1 table per time frame
It should be initialized to 200 history points for each bucket from HDB
On startup it should replay tp log file

we are going to use this data to calculate sma[10;] sma[20;] sma[50;] sma[100;] sma[200;] for each time frame


/for P-P3 charts
/minute: 1 2 5 15 30 
/hour: 1 2 4 8
/daily weekly monthly

P P1 P2 P3 S&R check
1m 2m 5m 15m (30m & 1day)
2m 5m 15m 30min (1h & 1day)
5m 15m 30m 1h (4h & 1day)
15m 30m 1h 2h (4h & 1day)
(30m 1h 2h 4h)
1h 2h 4h 8h (1day)
4h 8h 1d 1w (1month)
8h 1d 1w 1m (n/a)
