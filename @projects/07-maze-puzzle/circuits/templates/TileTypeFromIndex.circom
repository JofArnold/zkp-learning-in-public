pragma circom 2.0.0;

include "./Maze.circom";

template TileTypeFromIndex() {
  signal input index;
  signal output out;
  component m = Maze();
  var maze[25] = m.out;
  out <-- maze[index];
}
