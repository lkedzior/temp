//this tp needs the following config
//schema file
//tp log file location
/q tp-practice.q -schemaFile D:\temp\schema.q -tpLogDir temp

\d .u

/dt - new date
/update .u.L, create file if does not exists, update .u.i, return handle
ld:{[dt]
  L::`$(-10_string .u.L),string[dt];
  if[()~key L; .[L;();:;()]];
  i::-11!(-2;L);
  hopen L
 };

.z.pc:{[h]
  .u.del[;h] each t;
 };

del:{[tbl;h]
  /idx:w[tbl;;0]?h;
  /w[tbl]:w[tbl]_idx;
  w[tbl]_:w[tbl;;0]?h;
 };
 
/u.sub[`;`]
sub:{[tbl;syms]
  if[`~tbl; :(sub[;syms] each t)];
  if[not tbl in t; 'tbl];
  del[tbl;.z.w];
  w[tbl],:enlist (.z.w;syms);
  :(tbl;0#value tbl)
 };

/dt - current date
ts:{[dt]
  if[d<dt;endofday[]];
 };

.z.ts:{
  /ts[`date$x];
  ts .z.D
 };
 
endofday:{
  end[d];
  hclose l;
  d+:1;
  l::ld[d];
 };

end:{[dt]
  (neg union/[w[;;0]]) @\: (`.u.end;dt); 
 };

upd:{[tbl;cdata]
  dt:"d"$p:.z.P;
  ts[dt];
  if[-16h<>first first cdata;
    p:"n"$p;
    cdata:$[0h<type first cdata;enlist[(count first cdata)#p],cdata; p,cdata];
  ];
  c:key flip value tbl;
  fdata:$[0h<type first cdata; flip c!cdata; enlist c!cdata];
  pub[tbl;fdata];
  l (`upd;tbl;cdata);
  i+:1;
 };

pub:{[tbl;fdata]
  {[tbl;fdata;hs]
    fdata:sel[fdata;hs 1];
    if[count fdata;
      (neg hs 0)(`upd;tbl;fdata)
    ];
  }[tbl;fdata;] each w[tbl]
 };

sel:{[tdata;syms]
  select from tdata where sym in syms
 };

\d .

.cfg.schemaFile:first .Q.opt[.z.x]`schemaFile;
.cfg.tpLogDir:first .Q.opt[.z.x]`tpLogDir;

/Defining .u variables `t`d` `w `L`l`i
.u.d:.z.D;

system"l ",.cfg.schemaFile;
.u.t:tables[];
@[;`sym;`g#] each .u.t;

.u.w:.u.t!(count .u.t)#();

.u.L:`$":",.cfg.tpLogDir,"/tpLogyyyy.mm.dd";
.u.l:.u.ld[.u.d]; /this will update .u.L & .u.i



