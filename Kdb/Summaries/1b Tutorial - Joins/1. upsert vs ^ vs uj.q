/////////////////////////////////    upsert , ^ uj    /////////////////////////////

/t1 upsert t2 or t1,t2	- upsert or insert if t1 is non keyed
/t1 uj t2 is like upsert but works for different table shapes
/kt1 ^ kt2 is special version of upsert for keyed tables, which does not override with nulls

/upsert works only if both tables have got the same columns
/if first table is keyed table then upsert is performed
/otherwise insert is performed
/you can update first table by passing reference
/t1,t2 does same thing as upsert
t1 upsert t2
kt1 upsert kt2
kt1 upsert t2
/t1 upsert kt2 - does not work 

q)kt1:([s:`a`b`c]size:1 2 3)
q)kt1
s| size
-| ----
a| 1
b| 2
c| 3

q)kt2:([s:`c`d]size:300 400)
q)kt2
s| size
-| ----
c| 300
d| 400

q)kt1 upsert kt2	 /upsert is performed
s| size
-| ----
a| 1
b| 2
c| 300
d| 400

q)kt1 upsert (0!kt2)	 /upsert is performed
s| size
-| ----
a| 1
b| 2
c| 300
d| 400

/t1 upsert t2 (insert is performed)
q)(0!kt1) upsert (0!kt2)	 
s size
------
a 1
b 2
c 3
c 300
d 400

/t1 upsert kt2 	- is not possible
q)(0!kt1) upsert kt2
'mismatch

/^ - special version of upsert that does not overwrite with nulls, both tables must be keyed
kt1^kt3

^ replaces null values
q)0^1 2 3 0N	/replaces null values
1 2 3 0

q)kt1:([k:1 2 3] c1:10 20 30;c2:`a`b`c)
q)kt3:([k:2 3] c1:0N 3000;c2:`bbb`)

q)kt1
k| c1 c2
-| -----
1| 10 a
2| 20 b
3| 30 c

q)kt3
k| c1   c2
-| --------
2|      bbb
3| 3000

q)kt1,kt3
k| c1   c2
-| --------
1| 10   a
2|      bbb
3| 3000

q)kt1^kt3
k| c1   c2
-| --------
1| 10   a
2| 20   bbb
3| 3000 c
q)

/////////////////////////////////    uj union join    /////////////////////////////

t1 uj t2	or 		kt1 uj	kt2

/similar to upsert but columns don't have to match exactly
/1)when used with unkeyed tables - the second table is inserted
/2)when used with keyed tables (both must be keyed) the upsert is performed

q)t1:([]sym:`a`b;i:1 2)
q)t1
sym i
-----
a   1
b   2


q)t2:([]sym:`b`c; i:200 300; newCol:"AB")
q)t2
sym i   newCol
--------------
b   200 A
c   300 B


q)t1 uj t2		 /insert for non-keyed tables
sym i   newCol
--------------
a   1
b   2
b   200 A
c   300 B

q)(1!t1) uj (1!t2)	 /upsert for keyed table
sym| i   newCol
---| ----------
a  | 1
b  | 200 A
c  | 300 B