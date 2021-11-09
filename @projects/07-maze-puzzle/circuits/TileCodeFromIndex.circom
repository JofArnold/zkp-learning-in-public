pragma circom 2.0.0;

include "./functions/getTileCodeFromIndex.circom";

// FOR TESTING THE FUNCTION
template TileCodeFromIndex() {
  signal input index;
  signal output tileCode;
  var code = getTileCodeFromIndex(index);
  tileCode <-- code;
}


component main {public [index]} = TileCodeFromIndex();
