/Keyed /ki:d/ table - is a dictionary (type 99h) that map 2 tables: key table->value table

Inserting data into a keyed table works just like inserting data into a regular table,
with the additional requirement that the key must not already exist in the table.

kt:k!v
q)kt:([eid:1 2 3] c1:`a`b`c; c2: 10 20 30)
q)kt
eid| c1 c2
---| -----
1  | a  10
2  | b  20
3  | c  30

q)key kt
eid
---
1
2
3

q)value kt
c1 c2
-----
a  10
b  20
c  30

q)keys kt
,`eid
q)cols kt
`eid`c1`c2

//////////Getting data using key values

/get one row using key
q)kt[2]	or	kt[`eid!2]
c1| `b
c2| 20

//its possible to update kt (similarly we can update dictionary)
kt[`eid!2]:`c1`c2!(`b;200j)
`kt insert (4;`d;40)  //inserting new key works
`kt insert (4;`d;400)  //inserting to existing key fails

/get multiple rows using list of keys
q)kt[flip enlist 1 3]	or	kt[(enlist 1; enlist 3)]
c1 c2
-----
a  10
c  30

/Using simple lookup, this is more efficient than above flip (it's costly to transpose list)
q)kt[([]eid:1 2)]
c1 c2
-----
a  10
b  20

/Using take operator
q)([]eid: 1 3)#kt
eid| c1 c2
---| -----
1  | a  10
3  | c  30

q)kt[([]eid:1 2)][`c1`c2]
a  b
10 20

/Using simple lookup but result as nested list
q)kt[([]eid:1 2);`c1`c2]
`a 10
`b 20


///////////

/? - reverse lookup, to get a key value
q)kt?(`a;10)
eid| 1

/ xkey - convert non-keyed <-> keyed table
() xkey `kt    /convert to non-keyed table, same as 0! kt
`eid xkey `kt  /convert to keyed table

