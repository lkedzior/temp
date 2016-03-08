http://code.kx.com/wiki/Releases/ChangesIn2.7
http://code.kx.com/wiki/DotQ/DotQDotgc
http://code.kx.com/wiki/Reference/peach
http://code.kx.com/wiki/Releases/ChangesIn2.4#multi-threadedinput


-w N
workspace MB limit (default: 2*RAM)
Workspace limits the VIRT memory size, not the RES memory size. Max RES memory size for kdb process
has to be controlled from outside, kdb itself has no means to limit it

-g option:
since 2.7 2011.02.04
allows switching of garbage collect to immediate(1) mode instead of deferred(0).
Immediate mode will return (certain types of) memory to the OS as soon as
no longer referenced and has an associated overhead.
Deferred mode will return memory to the OS when either .Q.gc[] is called or an allocation fails.
Deferred mode has a performance advantage, but can be more difficult to dimension/manage memory requirements.
Immediate mode is the 2.5/2.6 default, deferred is the 2.7 default.
e.g. to use immediate mode, invoke as q -g 1

/go to HDB.doc to read about mamory management in slave threads