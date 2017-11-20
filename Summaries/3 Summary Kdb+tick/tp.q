/
 .u.w - dictionary of tables->(handle;syms)
 .u.i - msg count
 .u.t - table names 
 .u.L - tp log filename, e.g. `:./sym2008.09.11
 .u.l - handle to tp log file
 .u.d - date
\

/load the schema file
system"l tick/",(src:first .z.x,enlist"sym"),".q"

/set port
if[not system"p";system"p 5010"]

/switch to .u context
\d .u

/.u.init - defines .u.w dict + .u.t list
init:{w::t!(count t::tables`.)#()}

/.u.w - contains connection handles and sym subsciption lists for each table in .u.t
/ quote| ((1824;`IBM`GOOG);(1804;`)
/ trade| ((1824;`IBM`GOOG);(1804;`MSFT`CSCO))

/.u.t - list of all tables in the tp

/.u.del - deletes a connection handle from the subscription list,
/is called from .z.pc when client disconnects. example .u.del[`trade;1824]
del:{w[x]_:w[x;;0]?y};

/handler called when client disconnects
.z.pc:{del[;x]each t};

/.u.sel - used to get the data for a specific sym list or for all symbols (`)
/example .u.sel[`trade;`] or .u.sel[`trade;`sym1`sym2]
sel:{
  $[`~y;x;
    select from x where sym in y]
 }

/.u.pub - calls from .u.upd or .z.ts(depending on initial \t configuration)
/it publishes the data to clients who have subscribed to given table updates
/example .u.pub[`trade; flipData]
pub:{[t;x]
  {[t;x;w]  /w here has a format like (1804;`MSFT`CSCO)
    if[count x:sel[x]w 1; (neg first w)(`upd;t;x)]
  }[t;x]each w t
 }

/.u.add - updates .u.w with client's handle + sym list (adds new handle or appends new sym list if handle exists)
/called from .u.sub
/example .u.add[`trade;`sym1`sym2]
add:{
  $[(count w x)>i:w[x;;0]?.z.w;  /.u.w[x;;0] -> gives list of registered clients, i-index of .z.w in the list or list count
    .[`.u.w;(x;i;1);union;y]; /existing client
    w[x],:enlist(.z.w;y) /new client
   ];
  /
  (x;$[99=type v:value x;sel[v]y;0#v])
 }

/.u.sub - called by the client when he subscribes
/example .u.sub[`trade;`sym1`sym2]
/function updates the .u.w subscription list using .u.add
/Subsequent to this the caller will be updated asynchronously via the .u.pub
/Note what is returned by sub/add functions to the client
/If it's a non key table that it is simply (`tbl;schema) pair or list of pairs if clients subscribe for all tables
/But if the table client subscribe to is keyed (e.g. client subscribes to c.q publisher tp->c.q->client) 
/then .u.sub will return all keyed table data (e.g. all aggregations for each symbol)
sub:{
  if[x~`;:sub[;y]each t];
  if[not x in t;'x];
  del[x].z.w;
  add[x;y]
 }

/.u.end - sends (`.u.end; date) to every client
end:{
  (neg union/[w[;;0]])@\:(`.u.end;x)
 }
/
q).u.w[;;0]		//first index elided means all keys, second elided means all values
quote| ,1804
trade| 1816 1792
\

/.u.ld - logging function, called with .u.d(new day) as argument
/it creates the log (schemaDATE, i.e. sym2010.01.04) if is not already there,
/it updates the .u.i log count. It then returns the new file handle 
ld:{
  if[not type key L::`$(-10_string L),string x;
    .[L;();:;()] /creates empty list new TP log file
  ];
  i::-11!(-2;L); /update log counter
  hopen L
 };

/.u.tick - code called to initialize the TP, u.tick[src;dst]
/src - used only in the tp log filename
/dst - used for tp log file location
/ defines .u.t, .u.w, .u.d, .u.L, .u.l, applies `g# on sym columns, creates log file
/.u.d - current date, the value will be inserted into the date column when the data is saved and will be used for the name of the new partition
/.u.L - e.g. `:./sym2011.01.28, used to create the logfile
/.u.l - this is the handle to the log file and is used to append messages to it)
tick:{
  init[];
  if[not min(`time`sym~2#key flip value@)each t;'`timesym];
  @[;`sym;`g#]each t;
  d::.z.D;
  //that's kx way to run tick without a tp log file (if y is "" then we don't use tp log file)
  if[l::count y;L::`$":",y,"/",x,10#".";l::ld d]
 };


/.u.endofday[] - called from .z.ts->.u.ts->.u.endofday
/it calls .u.end which sends `.u.end to every client
/it increases .u.d date by 1
/it updates .u.l log file handle
endofday:{
  end d;
  d+:1;
  if[l;hclose l;l::ld d]
 };

/.u.ts[date] - calls endofday[] if given date is > than .u.d 
ts:{
  if[d<x;
    if[d<x-1;system"t 0";'"more than one day?"];
    endofday[]
  ]
 };

/configuration 1: .u.pub called from .z.ts timer handler every heartbeat 
/define .z.ts and .u.upd 
if[system"t";

  .z.ts:{
    pub'[t;value each t];
/@[L;I;f] is equivalent to f@L[I]
/refference L by name `L in order to update it
/`.[`trade] -> gives trade table
/we actually re-assing trade with empty table here!
/@[;`sym;`g#]0# is function projection
    @[`.;t;@[;`sym;`g#]0#]; /re-assign table schemas + apply `g# attribute on sym columns
    ts .z.D
  };
 
  upd:{[t;x]
    if[not -19=type first first x;
      /if a new day call .z.ts
      if[d<"d"$a:.z.Z;.z.ts[]];
      /add time column
      a:"t"$a;
      x:$[0>type first x;a,x;(enlist(count first x)#a),x]
    ];
    t insert x;
    if[l;l enlist (`upd;t;x);i+:1];
  }
 ];

/configuration 2: zero-latency mode
/.u.pub called from .u.upd i.e. every time when FH calls .u.upd
/no data is stored in internal tables
if[not system"t";
  system"t 1000";
  
  /.z.ts handler definition
  .z.ts:{ts .z.D};
  
  /.u.upd function definition
  upd:{[t;x]
    ts"d"$a:.z.Z;
    if[not -19=type first first x;
      a:"t"$a;
      x:$[0>type first x;a,x;
        (enlist(count first x)#a),x]
    ];
    f:key flip value t; /e.g. f:`time`sym`price`size
    pub[t; $[0>type first x;enlist f!x;
      flip f!x]];
    if[l;
      l enlist (`upd;t;x);
      i+:1];
  }
 ];

/switch context to default, call .u.tick[src;dest]
\d .
.u.tick[src;.z.x 1];
