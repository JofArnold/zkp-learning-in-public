pragma circom 2.0.0;

template PositionToMove() {
  signal input pos;
  signal output out;
  var size = 25;
  var maze[size] = [
    10, 14, 5, 6, 12,
    6, 2, 4, 4, 5,
    11, 13, 6, 5, 13,
    6, 4, 8, 13, 11,
    7, 14, 12, 7, 12
  ];
  out <-- maze[pos];
}

component main {public [pos]} = PositionToMove();
