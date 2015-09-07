t:([] minute:09:00 + 5*til 60; d1:5*til 60; d2:10*60?10; d3:7*60?5)

/for each minute we want to calculate aggregation
/so we would need aggregation on rows rather than columns
/one way would be to unpivot table but we don't have to do that
/we can transform rows into columns with flip on the fly

update val:sum each flip (d1;d2;d3) from t

/functional form if columns are not know in advance
parse "update val:sum each flip (d1;d2;d3) from t"
/(!;`t;();0b;enlist `val!enlist (k){x'y};sum;(+:;(plist;`d1;`d2;`d3))))
/ ![t;();0b;enlist[`val]!enlist (sum';(+:;(enlist;`d1;`d2;`d3)))]
f:`d1`d2`d3
![t;();0b;enlist[`val]!enlist (sum';(flip;(enlist,f)))] 
