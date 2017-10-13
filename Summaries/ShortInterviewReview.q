		 ////	LISTS	////

/using null item :: to define general list
L:(1;2;3;`a;::)
L[3]:4	   /would change L type 0h->6h without :: at the end
L[3]:`a    /and here would fail without :: at the end

/creating typed empty lists
L:`int$()
L:0#ON    /use 0# with an value of the required type, 0N is int null

/transpose the rectangular list (matrix) with flip
flip L

//// DICT ////
//domain of values is set and cannot be change to the 'wider' type
q)d:`a`b!(10;10.5)
q)d
a| 10
b| 10.5
q)d[`b]:11
q)d[`b]:10.5
'type

//use :: to avoid this errors
q)d:``abc!(::;10)
q)d
   | ::
abc| 10
q)d[`a]:`aaa

			 /////	Operators, functions	////

			 //// ? - reverse lookup	 ////
L?x		 /returns the index of the first appearance or list count
q)L:0 1 1 2
q)L?1
1

d:`a`b`c!1 2 3
q)d?2	 /returns appropriate key or null
`b

			 /////	_ drop/cut	////

/drop for Lists
q)5_0 1 2 3 4 5 6 7 8      / drop the first 5 (leaving the last 4) 
5 6 7 8
q)-5_0 1 2 3 4 5 6 7 8     / drop the last 5 (leaving the first 4) 
0 1 2 3
q)0 1 2 3 4 5 6 7 8_5      / drop L[5] item (leaving everything else)
0 1 2 3 4 6 7 8

/cut - partitions a list into sublists at the specified indices
q)0 3 7_0 1 2 3 4 5 6 7 8	 / cut at indices 0, 3 and 7 
0 1 2
3 4 5 6
7 8

q)2 3_0 1 2 3 4 5 6 7 8    / cut at indices 2 and 3 (note: the result starts at index 2)
(,2;3 4 5 6 7 8)

/drop/cut can be used with tables

/and with dictionaries
d:`a`b`c!1 2 3
/remove 1 item
d _`a
/remove multiple items
`a`c _d
`a`c cut d

			 /////	# take, shape	////
q)5#0 1 2 3 4 5 6 7 8      / take the first 5 items
0 1 2 3 4 
q)-5#0 1 2 3 4 5 6 7 8     / take the last 5 elements
4 5 6 7 8

/If the number of elements to take is longer than the list specified,
/it acts as if the list was circular.
q)5#`Arthur`Steve`Dennis
`Arthur`Steve`Dennis`Arthur`Steve
q)-5#`Arthur`Steve`Dennis
`Steve`Dennis`Arthur`Steve`Dennis

/If the second argument is a scalar it will be converted into a list
/of the length given by the first argument:
q)3#9
9 9 9

/A list of length 2 specifies the "shape" of the resulting
/two dimensional matrix (KDB+ 2.3 and above).
q)2 3#til 20
0 1 2
3 4 5

q)2 3#til 2
0 1 0
1 0 1

/Using a null integer for either part of the "shape"
/will cause that dimension to be maximal:
q)0N 3#til 10
(0 1 2;3 4 5;6 7 8;,9)
q)3 0N # til 10
(0 1 2 3;4 5 6 7;8 9)

/take applies to tables as well
5#t
-5#t

/ i+=1 from c/c++
i+:1

/create views, .z.b shows all set dependencies
q)a::x+y
q)view `a
"x+y"
q).z.b
x| a
y| a
q)views[]
,`a
q)


			 ////    @ and .    ////


1a) dyadic @ . =>indexing at top level @[L;I] or at depth .[L;I]
1b) /daɪˈæd.ɪk/ @ . with function => apply @[fMonadic;a], .[fMultiValen;(a1;a2;...)]

2) /traɪ.ædɪk/ @ . => amend in place using monadic f, amend at top level (@) or at depth (.)
@[L;I;monadicFunc]

3a) 4 args with @ . => amend in place using dyadic f
@[L;I;dyadicFunc;x]	 /I, x same shape or x atom which will be expanded to the List

3b) 4 args with @ . with function => try catch
############# 1a)  dyadic @ .
/INDEXING LISTS, APPLY FOR FUNCTIONS 
@ /index at top level
. /indexing at depth
@[L;I]		 /@[L;0 2] or L[0 2]
.[L;I]		 /.[L;0 2] or L[0;2]

############# 1b)  dyadic @ .
@ /apply for mondadic
. /apply multi valent
@[f;1 2]		 /f[1 2]
.[f;(a1;a2)]	 /f[a1;a2]

/use any null or (::) with niladic f
f@ON /with niladic f
f. enlist ON /with niladic f

############# 2)  /traɪ.ædɪk/ @ . => amend in place using monadic f
/amend, @ top leve, . at depth
/to modify original list/dict/table refer by name e.g. `L
f - monadic
@[L;I;f]

q)@[0 1 2 3 4; 1 2; neg]
0 -1 -2 3 4

q)L
0 1 2 3 4 5
q)@[`.; `L; 2#]		 /amend in place
`.
q)L
0 1

############# 3a) 4 args with @ . => amend in place using dyadic f
f - dyadic
@[L;I;f;x]	 /I, x same shape
/ e.g.
q)@[1 1 1 1;0 1;+;10]
11 11 1 1
q)@[1 1 1 1;0 1;+;10 10]
11 11 1 1
q)@[1 1 1 1;0 1;+;10 10 10]
'length

.[L;I;f;x]
q).[((1 2);(3 4));0 1;+;10]
1 12
3 4

############# 3b)
/protected evaluation
@[f; arg; expr_fail]
.[f; L; expr_fail]


			 ////    ADVERBS    ////

/add something about peach adverb

/each for monadic f
f each L
each[f]

/each left for dyadic f
L f\: a

/each right for dyadic f
a f/: L

/each both for dyadic f
f'[L1;L2] or L1 f' L2   
q)+'[1 2;3 4]
4 6

/each previous for dyadic f
/applies f on consecutive items in a List
-':[0; 2 5 9 10]	 /deltas -':
(2-0;5-2;9-5;10-9)
2 3 4 1

f':[arg;L] /result is a list, arg is optional
f[L0;arg]; f[L1;L0]; f[L2;L1]; ...

f':[L] /no arg
L0 ; f[L1;L0]; f[L2;L1]; ...

////    OVER (f/)    ////
f/    /over - returns same shave as f[] call

f-monadic
/f is called n times
f/[n;arg]	 f[...f[f[arg]]] /recursive calls

f-dyadic
f/[arg;L]	or	f/[L]	 /arg is optional
f[Ln; ... f[L1; f[arg;L0]] /shape of the results is same as shape of single f[x;y] call

q)(+/) 1 2 3 4
10


////    SCAN f\    ////
f\    /scan - returns list of f[] calls

f-monadic
f\[arg]	 /results as a list
arg; f[arg]; f[f[arg]]; ...    /until the result is = arg

f\[n;arg]  /results as a list
arg; f[arg]; f[f[arg]]; ...    /count n+1

f\[condition;arg]  /results as a list
arg; f[arg]; f[f[arg]]; ...    /until condition is true

f-dyadic
f\[arg;L] /arg is optional, results as list
arg; f[arg;L0]; f[pr;L1]; f[pr;L2]; ... /pr - previous result

q)sums
+\
q)(+\) 1 2 3 4
1 3 6 10
q)(-\) 1 2 3 4
1 -1 -4 -8

////    PARSING STRINGS    ////
/use upper case type char
"I"$"4267"


////    ENUMERATIONS    ////

/to create enumeration cast to a given domain
v:`c`b`a`c`c`b`a`b`a`a`a`c
domain:`c`b`a
en:`domain$v    /type en is 20h+, different domains get different type
en1:`domain?v	 /? returns enumeration and will create/updates domain variable if needed 

q)en?`a     /locate first occurance
2
/locate all occurances
q)en=`a
001000101110b
q)where en=`a
2 6 8 9 10


////	EXECUTION CONTROL	////
/if(cond) {...}, statement does not have an explicit result
if[cond;e1;e2;e3;...]

/conditional evaluation cond ?: valueIfTrue : valueIfFalse
$[cond; exprIfTrue; exprIfFalse]

/ if-else block
$[cond; [et1;et2;...]; [ef1;ef2;...]]

/if elseif else block
$[ cond1;[...]; cond2;[...]; ... ; condn;[...]; [elseBlock] ]

/vector conditional evaluation
q)L
101 102 103 104
q)?[0011b; L; L-100]
1 2 103 104

/do
do[numberOfIterations; e1;e2;e3;...]

/while
while[cond; e1; e2; e3;...]


////	IO	////
/write text, one string per line
`:/f.txt 0: ("line1"; "line2"; "line3")
q)read0 `:/f.txt
"line1"
"line2"
"line3"

/PARSING csv files
("IFC"; ",") 0: `:/f.csv    /returns list of lists
("IFC"; enlist ",") 0: `:/f.csv    /uses first row as columns, returns table


//// INTERPROCESS COMMUNICATION    ////
.z.ps / asynch request(set), default {value x}
.z.pg / synch request(get), default {value x}
.z.w /client handler
.z.pc /client close handler


////	TABLES	////

/schemas - emtpy tables
t:([] c1:(); c2:())    /type of the columns is determinded by the first entry
t:([] c1:`symbol$(); c2:`int$())    /pre-defined types
t:([] c1:0#`; c2:0#0N)    /0# returns empty list, the type is determined be the argument

/Keyed table - is a dictionary (type 99h)
/that map 2 tables: key table->value table
kt:k!v

/ xkey - convert non-keyed <-> keyed table
() xkey `kt    /convert to non-keyed table, same as 0! kt
`eid xkey `kt  /convert to keyed table

/converting simple<->keyed tables with n!table

/With a positive integer on the left hand side converts a simple table to a keyed table
/with the given number of key columns:
q)t:([]a:1 2 3;b:10 20 30;c:`x`y`z)
q)2!t
a b | c
----| -
1 10| x
2 20| y
3 30| z

/With a 0 on the left hand side, converts a keyed table to a simple one
q)t:([a:1 2 3]b:10 20 30;c:`x`y`z)
q)0!t
a b  c
------
1 10 x
2 20 y
3 30 z

////	Foreign Key    ////

/to create FK column when defining a table with FK column:
fkcolumn:`keyedTable$val1 val2 val3    /column is an enumeration, keyedTable is an domain

kt:([eid:1001 1002 1003] name:`Dent`Beeblebrox`Prefect; iq:98 42 126)
tdetails:([] eid:`kt$1003 1001 1002 1001 1002 1001; sc:126 36 92 39 98 42)

q)fkeys tdetails
eid| kt

/inner joins - we can use . notation for inner joins with FK columns
select eid.name, sc from tdetails


////    SELECT    /////
select <col list>	<by ...>	from t	<where ...>

/grouping without aggregation functions
select sc by eid from tdetals	 /sc column vector will not be simple list

/ungroup normalize results to flat table
q)t
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

////    delete    ////

/delete can be used to delete column or rows
delete c1 from t /deletes column
delete from t where c2=`z /delete rows
/you have to refer by `t to update table

////    aggregation, grouping    ////
/Aggregation - applying an aggregate function(produces an atom from a list) to a column
/Grouping WITHOUT Aggregation - non simple lists in the results set

/xgroup (don't confuse with ungroup)
`p xgroup sp	~	select s,qty by p from sp

/grouping with agregation
select av:avg qty by s from sp
q)select av:avg qty by s from sp
s | av
--| --------
s1| 266.6667
s2| 350
s3| 200
s4| 200

/xasc, xdesc - sorting
`c1`c2 xdesc t

/xcol - renaming columns
t:`a`b`c xcol t

/xcols - reordering the columns
t:`c3`c2`c1 xcols t


