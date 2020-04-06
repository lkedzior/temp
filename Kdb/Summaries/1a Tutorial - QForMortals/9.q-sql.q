////    insert    /////
t:([] c1:`a`b; c2:10 20)

`t insert (`a`b;10 20)

/tables are list of dictionaries
/we can insert/append a row using dictionary syntax
`t insert `c1`c2!(`c;30)

/insert table
/this one is used in rdb, tp .u.pub sends async (`upd;tableName;flipDataSubset)
`t insert anotherTable

////    select    /////
select <col list>	<by ...>	from t	<where ...>

The order of execution for select is:

    (1) from expression texp,
    (2) where phrase pw
    (3) by phrase pb
    (4) select phrase ps
/A virtual column i holding the position of each record is implicitly available in the select phrase
t:([]sym:`aaa`aaa`aaa`bbb`ccc`bbb; price:6?10.0; size:6?10)

q)select i, price, size by sym from t
sym| x     price                     size
---| -------------------------------------
aaa| 0 1 2 9.672398 2.306385 9.49975 6 1 8
bbb| 3 5   4.39081 5.919004          5 9
ccc| ,4    ,5.759051                 ,4

q)select count i by sym from t
sym| x
---| -
aaa| 3
bbb| 2
ccc| 1

/grouping without aggregation functions
q)t:([]c1:`a`b`c`a;c2:1 2 3 10)

q)select c2 by c1 from t
c1| c2
--| ----
a | 1 10
b | ,2
c | ,3

/if no columns are selected then the last value is returned
q)select by c1 from t		 /select last c2 by c1 from t
c1| c2
--| --
a | 10
b | 2
c | 3

////	exec    ////
/same as select but the results is list(single column query)
/or a dict (multiple columns query)

distinct /retruns distinct rows
distinct t
select distict c1,c2 from t
/with exec must be used with every column
exec distinct c1, distinct c2 ... /we can get different count of c1 and c2

////	fby (filter by)   ////
/e.g. show all entries with price greater than average
/fby is part of the where filter...it filters out rows which don't meet the condition, it does not group the result set

/use it if you need to group by + use an aggregate function in the where phrase
t:([]sym:`IBM`IBM`MSFT`IBM`MSFT; ex:`N`O`N`N`N; time:12:10:00.0 12:30:00.0 12:45:00.0 12:50:00.0 13:30:00.0; price:82.1 81.95 23.45 82.05 23.40)
q)t
sym  ex time         price
--------------------------
IBM  N  12:10:00.000 82.1
IBM  O  12:30:00.000 81.95
MSFT N  12:45:00.000 23.45
IBM  N  12:50:00.000 82.05
MSFT N  13:30:00.000 23.4

q)select from t where price>(avg;price) fby ([]sym)
q)select from t where price>(avg;price) fby sym	 /if by one column notaction could be '(avg;price) fby sym'
sym  ex time         price
--------------------------
IBM  N  12:10:00.000 82.1
MSFT N  12:45:00.000 23.45
IBM  N  12:50:00.000 82.05

q)select from t where price>(avg;price) fby ([]sym;ex)
sym  ex time         price
--------------------------
IBM  N  12:10:00.000 82.1
MSFT N  12:45:00.000 23.45

/another example, show duplicates - multiple occurances of marketTradeId
select from internalorderevent where 1<(count;i) fby ([]marketTradeId)


////	update    ////
/update can be used to change exisiting column data or to add new column
/same form as select, to update t table, refer by `t

/change column values
t:([] c1:`a`b; c2:10 20)
q)update c2:2*c2 from t  /no where phrase here
c1 c2
-----
a  20
b  40

/add new column
t:([] c1:`a`b; c2:10 20)
q)update c3:2*c2 from t
c1 c2 c3
--------
a  10 20
b  20 40

update-by
When the by phrase is present, update can be used to create new columns from the grouped values.
When an aggregate function is used,
it is applied to each group of values and the result is assigned to all records in the group.

        t:([] n:`a`b`a`c`c`b; p:10 15 12 20 25 14)
        t
n p
----
a 10
b 15
a 12
c 20
c 25
b 14

        update av:avg p by n from t
n p  av
---------
a 10 11
b 15 14.5
a 12 11
c 20 22.5
c 25 22.5
b 14 14.5

If a uniform function is used, it is applied across the grouped values and the result is assigned in sequence to the records in the group. With t as above,
        update s:sums p by n from t
n p  s
-------
a 10 10
b 15 15
a 12 22
c 20 20
c 25 45
b 14 29

////    delete    ////

/delete can be used to delete column or rows
delete c1 from t /deletes column
delete from t where c2=`z /delete some rows
/you have to refer by `t to update table

////    aggregation, grouping    ////
/Aggregation - applying an aggregate function(produces an atom from a list) to a column

/Unlike SQL, any column can participate in the select result when grouping

/Grouping WITHOUT Aggregation - non simple lists in the results set

/xgroup (don't confuse with ungroup)
xgroup – another way to group the table results.
xgroup always shows all columns in the results
`byColumn xgroup table

ungroup t	 /normalize results to flat table
q)t		 /note c3 column is not simple list
c1 c2 c3
---------
a  10 1 2
b  20 3 4

q)ungroup t
c1 c2 c3
--------
a  10 1
a  10 2
b  20 3
b  20 4

/grouping with agregation
q)select av:avg qty by s from sp
s | av
--| --------
s1| 266.6667
s2| 350
s3| 200
s4| 200

Using each
If the column is not simple list, you must use the each modifier to apply an aggregate.
        o 
name | qty 
-----| --------------- 
bolt | 200 400 200 200 
cam  | 100 400
cog  | 100
nut  | 300 300
screw| 400 200 300 

We must use each to compute the average order size for each product in o.

       select name, avqty:avg qty from o 
'length 

       select name, avqty:avg each qty from o 


/xasc, xdesc - sorting
`c1`c2 xdesc t

/xcol - renaming columns
t:`a`b`c xcol t

/xcols - reordering the columns
t:`c3`c2`c1 xcols t


////    Simulate stored procedures with parametrized queries
getScByEidStoredProc:{[e] select form tdetails where eid in ((),e)}

/limitations
- you can NOT pass column names to the query (only values or table names)
Important: Parameterized queries have restrictions. First, a parameterized query cannot use implicit function parameters (x,y,z).
Second, columns cannot be passed as parameters.

The best/easiest way to have a query with columns as parameters (columns defined in the runtime) is to use functional version of select.
The other option would be to generate entire string with the query in the runtime and pass it to ‘value’ function for execution.


/views - q implement them as aliases
v:: select c1 from t where c2=2

/////    Functional forms of select/exec/update/delete    ////
/better than prametrized queries because column can be dynamic

?[t;c;b;a]	 /select, exec
![t;c;b;a]	 /update
![t;c;0b;a]	 /delete

t- table
c- list of contraints
b- dictionary of group bys
a- dictionary of aggregates

parse selectQuery - produces parse tree

SELECT		 /the only functional form you can apply on HDB 
?[t;c;b;a]
c:() /to skip
b:0b /to skip
a:() /to skip

EXEC
b is a list not a dictionary as in select
b:() /to skip

UPDATE
![t;c;b;a]

DELETE
![t;c;0b;a]		 /a is a list, not dict so both 'c' and 'a' are lists

/EXAMPLE
t:([]n:`x`y`x`z`z`y;p:0 15 12 20 25 14)

select m:max p, s:sum p		 /a:`m`s!((max;`p);(sum;`p))
  by name : n				 /b:(enlist `name)!enlist `n
  from t
  where p>0, n in `x`y	 	 /c: ((>;`p;0);(in;`n;enlist `x`y))  //note symbol literals are enlisted, column names are not

q)parse"select m:max p, s:sum p by name:n from t where p>0, n in `x`y"
?
`t
,((>;`p;0);(in;`n;,`x`y))
(,`name)!,`n
`m`s!((max;`p);(sum;`p))


?[`t;
  ((>;`p;0);(in;`n;enlist`x`y));
  (enlist`name)!enlist`n;
  `m`s!((max;`p);(sum;`p))]
