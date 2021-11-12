# About

A ZKP for a simple 5x5 maze.

# How to play

You submit a series of moves in an attempt to solve the maze. The moves are an array with direction encoded:

```
0 - up
1 - right
2 - down
3 - left
```

The proof returns a value of 0,1 or 2 defined as follows:

```
0 - invalid moves
1 - valid moves but incomplete
2 - valid moves and complete
```

See circuits.test.ts

# The code

There are two versions of the code under the circuits directory.

- `./circuits/templates` which uses constraints throughout
- `./circuits/functions` which is a pure function version

An ideal implementation is likely somewhere between the two; I've not attempted to optimise as largely it was just an experiment.

# To run

Install circom globally as per their docs then

```bash
yarn test
```

You can compile the circuits using `yarn circuits:compile`

