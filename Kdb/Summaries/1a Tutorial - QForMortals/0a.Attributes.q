/

##### note from the Qtips
8.2 Attributes
- By default, q uses a linear search algorithm to find values within lists
- Other options we have are: binary search for sorted data, or hashing algorithm for unique, grouped or partitioned data

- `u `g and `p attributes need extra memory and use a hashing algorithm
`u maps the value to a single index
`g maps the value to a list of indices
`p maps the value to an index and count
####

Attributes - metadata applied to lists of special form,
they can be applied to a dictionary domain or a table column
Q treats those lists differently to speed up operations and reduce storage

`s#4 5 9 9 10		//sorted
Applying the sorted attribute to a table implies binary search on the table
and also that the first column is sorted.

`u#4 5 9 10			//unique, overhead 16*u
Useful for large dictionaries, changes retrival from linier time to constant (hashtable/map)
To define this we apply `u# to the keys
q)d:(`u#keys)!values

`p#8 8 8 3 4 4 4 4 9 9 2 2		//parted, requires a 'partitioned' list
Creates an index dictionary that maps each unique output value to the position of its first occurrence
Search is just hashtable lookup

E.g. sym column in HDB has `p# attribute, index dictionary is stored at the end of the file
When reading sym file to get `GBPCHF indices Kdb knows that it must read data from index 2 to 10
`GBPCHF | 2
`GBPUSD | 10

`g#8 9 7 3 7 9 3 7 8			//grouped
Can be applied to any list. Creates an index,
the index is a dictionary that maps each unique output value to the a list of the positions of all its occurrences.
Applying the grouped attribute to a table column roughly corresponds to placing a SQL index on a column.

`g# (TP/RDB sym columns)
With the grouped index and below query Kdb knows which records should be read from the table
select from trade where sym=`VOD.L
\

/
/apply an atrribute on a table column
@[`t;`sym;`g#]

/tickerplant code
@[;`sym;`g#] each tables `.




Attributes

•	Metadata added to dictionaries, list or tables
•	Indicates to q interpreter to use specific routines for data retrieval
•	All but `s# require extra space

•	`s# (sorted)
o	Indicates sorted ascending order
o	Searches are speeded up with binary search instead of default linear seach
o	min/max/med are faster
o	applying asc (ascending sort function) to a list or table column will automatically set `s#
o	Appending out of order data loses `s#

•	`u# (unique)
o	Indicates unique list
o	Speeds up searches/lookups
o	Appending non-unique data loses `u#
o	Size overhead 16*u (u-number of uniques), hash table is built behind

•	`p# (parted)
o	Indicates partitioned list into sublists of the same element
o	Applying `p# creates an index which maps each unique element of the list to the index of its first occurrence and the occurrence count
o	Searches are speed up, linear search is replaced with hashtable lookup
o	All appends lose `p#

•	`g# (grouped)
o	The only attribute that can be applied to any list (no requirements to list elements)
o	Applying `g# creates an index mapping each unique element to a list of its occurrences
o	Index mapping is maintained through appends
o	Speeds up lookups
