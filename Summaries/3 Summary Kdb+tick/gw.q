Gateway and RDB and HDB setup
clients send sync requests to gateways
gateways dispatch asyn requests to HDB and RDB and then blocking using rdb and hdb handles in this order
res1:rdb[];
res2:hdb[];

when the rdb and hdb are done with the queries they send results back to gateway e.g.
(neg gwHandle) result;
(neg .z.w) result;

Then gw merges res1 and res2 and returns

With this setup each client should get its own gateway

gateway code
q)neg[rdbhandle](`f;::);neg[hdbHandle](`f;::);res1:rdbHandle[];res2:hdbHandle[]
q)res1
123
q)res2
124

rdb and hdb code
q)f:{do[10000000;1.1*2.2];(neg .z.w)123}

gw main select checks all opened sockets for incoming data