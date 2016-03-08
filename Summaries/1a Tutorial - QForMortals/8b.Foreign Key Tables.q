////	Foreign Key    ////

When inserting data into a table that has a foreign key, everything works as for a regular table,
except that a value destined for a foreign key column must already exist
as a key in the corresponding primary key table.

/use enumeration to create FK column when defining a table
fkcolumn:`keyedTable$val1 val2 val3    /column is an enumeration, keyedTable is an domain

q)kt:([eid:1001 1002 1003] name:`Dent`Beeblebrox`Prefect; iq:98 42 126)
q)kt
eid | name       iq
----| --------------
1001| Dent       98
1002| Beeblebrox 42
1003| Prefect    126

q)tdetails:([] eid:`kt$1003 1001 1002 1001 1002 1001; sc:126 36 92 39 98 42)
q)tdetails
eid  sc
--------
1003 126
1001 36
1002 92
1001 39
1002 98
1001 42

/we can use . notation for inner joins with FK columns
q)select eid.name, eid.iq, sc from tdetails
name       iq  sc
------------------
Prefect    126 126
Dent       98  36
Beeblebrox 42  92
Dent       98  39
Beeblebrox 42  98
Dent       98  42

meta tdetails 
c  | t f  a
---| ------ 
eid| i kt 
sc | i

q)fkeys tdetails
eid| kt

/FK to compund PK table
q)ktc
lname      fname | iq
-----------------| ---
Dent       Arthur| 98
Beeblebrox Zaphod| 42
Prefect    Ford  | 126

/foreign key on compound PK
tdetails:([] name:`ktc$(`Beeblebrox`Zaphod;`Prefect`Ford;`Beeblebrox`Zaphod); sc:36 126 42)
