/#unpivoting table
ungroup:(`sym`id #testData1),'{`statname`test1!(key x; value x)}each `sym`id _ testdata

/t - table data for the unpivot operation
/keyCols - columns which are not unpivoted
/columnName1 - column for names
/columnName2 - column for values

unpivot:{[t; keyCols; colName1; colName2]
  ungroup(keyCols #t),'{[colName1;colName2;row] (colName1,colName2)!(key row;value row)}[colName1;colName2] each keyCols _ t
 };

unenum:{
  @[x;where (type each flip x) within 20 77h; {@[value;x;x]}]
 };
