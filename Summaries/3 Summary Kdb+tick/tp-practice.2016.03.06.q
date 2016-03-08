//this tp needs the following config
//schema file
//tp log file location
/q tp-practice.2016.03.06.q -schemaFile D:\temp\schema.q -tpLogDir temp

.cfg.schemaFile:first .Q.opt[.z.x]`schemaFile
.cfg.tpLogDir:first .Q.opt[.z.x]`tpLogDir

system"l ",.cfg.schemaFile;

//this tp defines the following globals
/.u `t`d`w`L`l`i

.u.t:tables[];
@[;`sym;`g#] each .u.t;

.u.d:.z.D;
.u.w:.u.t!(count .u.t)#();

.u.L:`$":",.cfg.tpLogDir,"/tpLogyyyy.mm.dd";

/.u.l .u.i in .u.ld

\d .u

/.u.ld is called on process startup and during endofday routine
/dt - takes current date parameter
/updates the .u.L to append new yyyy.mm.dd
/create the file if does not exists
/updates .u.i to the current log count
/returns a handle to .u.L
ld:{[dt]
  L::`$-10_string[L],string[d];
  if[()~key L;
    .[L;();:;()];
  ];
  i::-11!(-2;L);
  hopen L  
 };

/update .u.L, u.i, u.l 
l:ld[d];

.z.pc:{[h]
  .u.del[;h] each t;
 };

del:{[tbl;h]
  /i:w[tbl;;0]?h;
  /w[tbl]:w[t]_i;
  w[tbl]_:w[tbl;;0]?h
 };

sub:{[tbl;syms]
  if[`~tbl;:(sub[;syms] each t)];
  if[not tbl in t;'tbl];
  del[tbl;.z.w];
  w[tbl],:enlist (.z.w;syms);
  :(tbl;0#value tbl)
 };

/.u.ts checks if endofday should be called, it is used in .z.ts and .u.upd
/dt - takes current date
ts:{[dt]
  if[d<dt;endofday[]];
 };
.z.ts:{
  ts[`date$x];
  /ts[.z.D]
 };
/end of day procedure
endofday:{
  end[d];
  hclose l;
  d+:1;
  l::ld[d];
 };

end:{[dt]
  (neg union/[w[;;0]]) @\: (`.u.end;d);
 };

upd:{[tbl;cdata]
  ts"d"$p:.z.P;
  
  if[-16h<>type first first cdata;
    n:"n"$p;
    cdata:$[0<type first cdata; enlist[count[first cdata]#n],cdata; n,cdata];
  ];
  
  c:key flip value tbl;
  /fdata:$[0<type first cdata;flip c!cdata;enlist c!cdata];
  pub[tbl;$[0<type first cdata;flip c!cdata;enlist c!cdata]];
  l enlist (`upd;tbl;cdata);
  i+:1;
 };

pub:{[tbl;fdata]
  {[tbl;fdata;hs]
    tdata:sel[fdata;hs 1];
    if[count tdata; (neg hs 0)(`upd;tbl;tdata)];
  }[tbl;fdata;] each w[tbl]
 };

sel:{[tdata;s]
  $[`~s;tdata;select from tdata where sym in s]
 };
 