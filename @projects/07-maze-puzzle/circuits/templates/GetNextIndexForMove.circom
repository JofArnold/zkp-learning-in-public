pragma circom 2.0.0;

include "./Maze.circom";

template GetNextIndexForMove() {
  // Index of current position in maze
  signal input from;

  // direction
  // 0 - north
  // 1 - east
  // 2 - south
  // 3 - west
  signal input direction;

  signal output out;

  var delta = 0;
  if (direction == 0) {
    delta = 5;
  } else if (direction == 1) {
    delta = 1;
  } else if (direction == 2) {
    delta = -5;
  } else if (direction == 3) {
    delta = -1;
  }
  out <-- from + delta;
}
