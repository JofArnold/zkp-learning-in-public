pragma circom 2.0.0;

include "./getMaze.circom";

function getTileCodeFromIndex(index) {
  var maze[25] = getMaze();
  var tileCode = maze[index];
  return tileCode;
}
