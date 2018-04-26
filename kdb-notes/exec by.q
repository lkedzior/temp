ohlc:{`high`low`close!(max;min;last)@\:x};

ohlcQuery:{[n;dt]
  exec ohlc 0.5*bid+ask
  by date, sym, time:n xbar time
  from (select from prices where date=dt)
 };
