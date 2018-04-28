/Tables - flipped column dictionaries
/The tables are implemented as dictionary like in k3 but marked as "flipped"
/Table - conceptually /kən'sɛptjʊəlɪ/ it is a list of dicts (list of rows) but not physically.

/Is a table a flipped column dictionary or a list of records?
/Logically it is both, but physically it is stored as a column dictionary with a flipped indicator.

/creating a table
d:`c1`c2!(`a`b`c;10 20 30)
t:flip d	 

/or enlist d if 1 row dictionary
q)enlist (`a`b!10 20)
a  b
-----
10 20

t:([] c1:`a`b`c; c2:10 20 30)

/alternatively
q)c1:`a`b`c
q)c2:10 20 30
q)t:([] c1;c2)
q)t
c1 c2
-----
a  10
b  20
c  30

t.c2 or t[;`c2]  /get column data
t[2] or t[2;]    /get a row as a dictionary

cols t    /get column list
meta t    /get meta deta in keyed table
q)meta t
c | t f a
--| -----
c1| s
c2| i


/schemas - emtpy tables
t:([] c1:(); c2:())    /type of the columns is determinded by the first insert
t:([] c1:`symbol$(); c2:`int$())    /pre-defined types
t:([] c1:0#`; c2:0#0N)    /0# returns empty list, the type is determined be the argument

////    table operators    ////
first, last, n#table, -n#table, columnList#table

/? - reverse lookup
t?(rowAsList)
kt?(values row as list)

q)t
c1 c2
-----
a  10
b  20
c  30

q)t?(`b;20)
1

q)(`c1 xkey t)?20	 /xkey creates keyed table here
c1| b
