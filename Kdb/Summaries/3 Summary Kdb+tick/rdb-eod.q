/hdb_dir `:/hdbdirpath
/dt - date
/f - parted column (`sym)
/tab - table e.g. `trade
/version1 of the function, compress everything
util.saveTable:{phdb_dir;dt;f;comp_params;tab]
  path:.Q.par[hdb_dir;dt;tab];
  columns:cols[value tab]except `date;
  i:iasc enlist[f]#value tab;	 /i - indices, order of stored data
  {[h;p;t;f;c;i]
    p:` sv p,c;
    (p,(17;2;6)) set first flip .Q.en[h] $[f~c;@[;f;`p#];::] (enlist[c]#value t)@i
  }[hdb_dir;path;tab;f;;i] each columns;
  @[path;`.d;:;f,columns except f];
 };
 
/version2 of the function, `time`sym not compressed
util.saveTable:{phdb_dir;dt;f;comp_params;tab]
  path:.Q.par[hdb_dir;dt;tab];
  columns:cols[value tab]except `date;
  i:iasc enlist[f]#value tab;	 /i - indices, order of stored data
  
  {[h;p;t;f;c;i]
    p:` sv p,c;
    (p,(17;2;6)) set first flip .Q.en[h] $[f~c;@[;f;`p#];::] (enlist[c]#value t)@i
  }[hdb_dir;path;tab;f;;i] each columns except `time`sym;
  
  {[h;p;t;f;x;i]
    p:` sv p,c;
    p set first flip .Q.en[h] $[fć; @[;f;`p#];::] (enlist[c]#value t)@i
  }[hdb_dir;path;tab;f;;i]each `time`sym;
  
  @[path;`.d;:;f,columns except f];
 };
 
sync_and_reload_hdb:{[dt]
  /Execute in subshell to not to hold up .u.end
  cmd:"$SCRIPTS_DR/kdbpm.sh sync_hdb $tpPort ", (string dt), ";$SCRIPTS_DIR/kdbpm.sh reload_both_env $tpPort)&";
  system[cmd];
 };