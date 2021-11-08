pragma circom 2.0.0;

template IsTileOpenForDirection() {
  // tileCode: [1..16]
  signal input tileCode;

  // direction
  // 0 - north
  // 1 - east
  // 2 - south
  // 3 - west
  signal input direction;

  signal output success;


  var    topOpen[8] = [ 1, 2, 3, 5, 6,  9, 13, 15];
  var bottomOpen[8] = [ 1, 3, 4, 7, 8, 11, 13, 15];
  var   leftOpen[8] = [ 1, 2, 4, 5, 8, 14, 15,  0]; // 0 to keep the array size constant
  var  rightOpen[8] = [ 2, 3, 4, 6, 7, 10, 14, 15];
  var directions[4][8] = [
    topOpen,
    rightOpen,
    bottomOpen,
    leftOpen
  ];
  var allowed[8] = directions[direction];

  var s = 0;
  var i;
  for (i=0; i<8; i++) {
    var allowedFromType = allowed[i];
    if (allowedFromType == tileCode) {
      s = 1;
    }
  }
  success <-- s;
}
