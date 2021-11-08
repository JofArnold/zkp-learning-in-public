pragma circom 2.0.0;

include "./Maze.circom";

template IndexToTileType() {
  signal input pos;
  signal output out;
  component m = Maze();
  var maze[25] = m.out;
  out <-- maze[pos];
}

component main {public [pos]} = IndexToTileType();
