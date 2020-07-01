## The project from CS240h

The project as described at [here](http://www.scs.stanford.edu/16wi-cs240h/slides/basics.html)


### Instructions.

1) install the dependencies with `cabal build` or which ever may you prefer

2) load the basic.hs file in ghci

3) run the code 

`> withClient "127.0.0.1" "9001" (computerVsUser Rock)`


4) open a terminal and hit the server you just started with:-

`$ nc localhost 9001`

```
nc is short for the netcat unix utility
```
