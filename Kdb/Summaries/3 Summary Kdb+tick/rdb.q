
if[not "w"=first string .z.o;system "sleep 1"];

/Define upd function
upd:insert;

/Define .u.x to store TP and HDB connection details
/e.g. .u.x:("localhost:5010";"localhost:5012") 
.u.x:.z.x,(count .z.x)_(":5010";":5012");

/ end of day: save, clear, hdb reload
.u.end:{
  t:tables`.; /e.g. t:`s#`quote`trade
  t@:where `g=attr each t@\:`sym; /override t, use only tables with `g# on sym columns, e.g. t:`quote`trade
  
  /.Q.hdpf[hdbPort;directory;partition;`p#field]
  /.Q.hdpf creates partition with all tables from `. context
  /The partition is saved in the given directory
  /Re-assigns all tables with empty schemas
  /Reloads HDB 
  .Q.hdpf[`$":",.u.x 1;`:.;x;`sym];
  @[;`sym;`g#] each t; /apply `g# attribute on `sym columns
 };

/init schema and sync up from log file;cd to hdb(so client save can run)
/.u.rep[tpSchemas;(logCount;logFile)]
/e.g. tpSchemas:((`quote;quoteSchema); (`trade;tradeSchema))
/e.g. logFile:(156; `:/tickDb/sym2011.06.12)
.u.rep:{
  (.[;();:;].)each x; /.[`table;();:;tableData] is like `table set tableData
  if[null first y;:()]; /.u.rep returns here with () if count is null
  -11!y; /-11!(n;`:logfile) - executes the first n chunks of logfile
  system "cd ",1_-10_string first reverse y /change current dir, e.g. "cd /tickDb/sym" or "cd ./sym"
  /current dir is going to be used from .u.end when data is saved
  /above call defaults to tpLogDir/schemaName
 };
/ HARDCODE \cd if other than logdir/db (db is the schema file name)

/opens a connection to TP
/send synch message "(.u.sub[`;`];`.u `i`L)"
/TP should return 2 item list (tpSchemas; (logCount; logFile))
/tpSchemas format (((`quote;quoteDataOrSchemaIfEmpty) ;(`trade;tradeDataOrSchemaIfEmpty))
/call .u.rep[ tpSchemas; (logCount; logFile) ]
/e.g. .u.rep[ tpSchemas; (0;`:/tickDb/sym2011.06.12)
.u.rep .(hopen `$":",.u.x 0)"(.u.sub[`;`];`.u `i`L)";

/ f . 10 20 calls f[10;20]
/ f @ 10 20 would create projection f[10 20; ]
