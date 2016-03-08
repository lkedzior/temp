/handling files

hcount `:c:/f.txt    /size in bytes
hdel `:c:/f.txt    /delete the file

/save - you can save table data to different format (binary,csv,txt,xls,xml)
t:([]x:2 3 5;y:`ibm`amd`intel;z:"npn")
save `t.xls

/save q entity with ‘set’, read it with ‘get’ or ‘value’
q)`:file set 1 2 3
`:file
q)get `:file
1 2 3
q)value `:file
1 2 3

/overwriting/appending with .
q).[`:file; (); :; 1 2 3 4]	 /creates new file
`:file
q).[`:file; (); ,; 5]		 /appends to the file
`:file
q)get `:file
1 2 3 4 5

///////////		Saving/Reading text files	///////////////
/saving text into file with 0:, one string per line
q)`:/f.txt 0: ("line1"; "line2"; "line3")
`:/f.txt
q)read0 `:/f.txt
"line1"
"line2"
"line3"

//append to file with negative handle
q)(neg h:hopen `:/f.txt)("line4")
-1844i
q)hclose h
q)read0 `:/f.txt
"line1"
"line2"
"line3"
"line4"

/write and read for binary data
1: /writes byte list to a file(creates), use positive file handle to append byte data
read1 /reads a binary file and return byte list

///////////		Reading CSV files	///////////////
//nested list is returned by 0:
flip `id`sym`px!("ISF"; ",") 0: `:/data/Px.csv

//delimited text file with columns as first line
//here 0: returns a table
("ISF";enlist ",") 0: `:/data/pxtitles.csv
Seq  Sym         Px
-----------------------
1001 DBT12345678 98.6
1002 EQT98765432 24.75
1004 CCR00000001 121.23

///////////		Reading Fixed length records	///////////////
0: /read text data
1: /read binary data
    
/e.g parse text record to int, float, string fields
("IFC"; 4 8 10) 0: `:/fixed.txt		 /nested list is returned
/you can read only part of the fiele
("IFC"; 4 8 10) 0: (`:/fixed.txt; 10; 20)

