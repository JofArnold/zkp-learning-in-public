pragma circom 2.0.0;

include "./Maze.circom";

template TileCodeFromIndex() {
  signal input index;
  signal output tileCode;
  component m = Maze();
  var maze[25] = m.out;
  tileCode <-- maze[index];
}
