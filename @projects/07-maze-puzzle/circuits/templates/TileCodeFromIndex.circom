pragma circom 2.0.0;

include "./functions/getMaze.circom";

template TileCodeFromIndex() {
  signal input index;
  var maze[25] = getMaze();
  tileCode <-- maze[index];
}
