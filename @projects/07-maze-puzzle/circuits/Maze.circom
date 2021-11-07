pragma circom 2.0.0;

template Maze() {
  signal output out[25];
  var maze[25] = [
    10, 14, 5, 6, 12,
    6, 2, 4, 4, 5,
    11, 13, 6, 5, 13,
    6, 4, 8, 13, 11,
    7, 14, 12, 7, 12
  ];
  var i;
  for (i = 0; i < 25; i++) {
    out[i] <-- maze[i];
  }
}

component main = Maze();
