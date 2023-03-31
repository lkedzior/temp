////Pivoting Pivot a table 
t:([]k:1 2 3 2 3;p:`xx`yy`zz`xx`yy;v:10 20 30 40 50);
P:asc exec distinct p from t;
exec P#p!v by k:k from t

t:2!([]k:1 2 3 2 3;p:`xx`yy`zz`xx`yy;v:10 20 30 40 50);
// keyed-(t)able implementation of pivot
// last column of key table is the pivot column
// remaing columns in front of the key table are group by columns
// last column of table is data
pivot:{[t]
 u:`$string asc distinct last f:flip key t;
 pf:{x#(`$string y)!z};
 //parse"exec P#(p!v) by k:k from t"  (?;`t;();(enlist `k)!enlist `k;enlist (#;`P;(!;`p;`v)))
 p:?[t;();g!g:-1_ k;(pf;`u;last k:key f;last key flip value t)];
 p}



parse "select from t"
(?;`t;();0b;())

parse "select [5] from t"
(?;`t;();0b;();5j)

parse "select [5 5] from t"
(?;`t;();0b;();5j, 5j)

parse "select [< abs price] from t"
(?;`t;();0b;();0Wj;enlist (<:;(abs;`price)))

parse "select [5 5;< abs price] from t"
(?;`t;();0b;();5j, 5j;enlist (<:;(abs;`price)))
