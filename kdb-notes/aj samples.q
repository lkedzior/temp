trade:([]time:0D09:30:01 0D09:30:02 0D09:30:05; sym:`AA`AA`AA; price:10.1 10.2 10.5)

quote:([]time:0D09:30:00 0D09:30:01 0D09:30:02 0D09:30:03 0D09:30:04 0D09:30:05 0D09:30:06; sym:`AA`AA`AA`AA`AA`AA`AA; qprice:10 10.1 10.2 10.3 10.4 10.5 10.6)

//get quote at t-1 sec, t0 and t+1 sec
aj[`sym`time;trade;quote]
,'
(select n1time:qprice from aj[`sym`time;update time:time-0D00:00:01 from trade;quote])

,'
(select p1time:qprice from aj[`sym`time;update time:time+0D00:00:01 from trade;quote])


trade
,'(select t0quote:qprice from quote asof (select sym, time from trade))
,' (select n1000quote:qprice from quote asof (select sym, time:time-0D00:00:01 from trade))
,' (select p1000quote:qprice from quote asof (select sym, time:time+0D00:00:01 from trade))
