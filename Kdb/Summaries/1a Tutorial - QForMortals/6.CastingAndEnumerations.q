////    CASTING    /////

/cast with $
/e.g. cast to int
`int$4.2
6h$4.2
"i"$4.2

/cast to symbol
`$"ab cd"

/creating typed empty lists
L:`int$()
L:0#ON    /use 0# with any value of the required type, typically null of the required type is used


////    PARSING STRINGS    ////

/use upper case type char
"I"$"4267"
"J" long
"F" float
"D"  date
"Z" datetime


////    ENUMERATIONS for symbol lists    ////
/inernally enumeration is stored as list of integers

q)symList:`c`b`a`c`c`b`a`b`a`a`a`c
q)domain:`c`b`a			 /domain:distinct symList
q)en:`domain$symList	 /to create enumeration cast to a given domain
q)en					 /type en is 20h+, different domains get different type
`domain$`c`b`a`c`c`b`a`b`a`a`a`c

q)value en
`c`b`a`c`c`b`a`b`a`a`a`c
q)en?`a     /locate first occurance
2
/locate all occurances
q)en=`a
001000101110b
q)where en=`a
2 6 8 9 10

/Normally we don't create domain upfront, we use ? operator to create enumeration and create/update domain on the fly
/conditional enumeration
/create an enumeration using (?) - creates enumeration and does conditional append to the domain (it can also be used with a file path)
/new symbols will be added to the domain
q)sym
'sym
q)`sym?`c`b`a`c`c`b`a`b`a`a`a`c	 /returns an enumeration and defines sym variable
`sym$`c`b`a`c`c`b`a`b`a`a`a`c
q)sym
`c`b`a
q)`sym ? `a`z		 //? use as conditional append
`sym$`a`z
q)sym
`c`b`a`z

/special case of conditional enumeration when used with filepath
q)`:/db/sym?`a`b`a /will create a file with symbol list if it does not already exists
`sym$`a`b`a
/the above command overrides in momory sym variable with symbol list from the file
q)sym	`a`b
q)get `:/db/sym
`a`b
q)`:/db/sym?`z	 /updates sym list on the disk and overrides in memory sym variable
`sym$`z
q)sym
`a`b`z
q)get `:/db/sym
`a`b`z

////    ENUMERATIONS using key table as a domain    ////
columnData:`kt$value1 value2 value3
see 8a.Key Tables.q
q)kt:([eid:1001 1002 1003] name:`Dent`Beeblebrox`Prefect; iq:98 42 126)
q)tdetails:([] eid:`kt$1003 1001 1002 1001 1002 1001; sc:126 36 92 39 98 42)


////    ENUMERATIONS using ! operator to create a link column to a simple table (not key table)    ////
`tbl!listOfIndicies
columnData:`table1!(1 0 2 1)



