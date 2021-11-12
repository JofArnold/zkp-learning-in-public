pragma circom 2.0.0;

include "./functions/isTileOpenForSide.circom";

// FOR TESTING THE FUNCTION
template IsTileOpenForSide() {
  // tileCode: [1..16]
  signal input tileCode;

  // side
  // 0 - top
  // 1 - right
  // 2 - bottom
  // 3 - left
  signal input side;

  signal output success;

  var s = isTileOpenForSide(tileCode, side);
  success <-- s;
}


component main {public [tileCode, side]} = IsTileOpenForSide();
