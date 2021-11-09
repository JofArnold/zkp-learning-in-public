pragma circom 2.0.0;

include "./functions/getMaze.circom";

template Maze() {
  signal output out[25];
  var maze[25] = getMaze();
  for (var i = 0; i < 24; i++) {
    out[i] <-- maze[i];
  }
}

component main = Maze();
