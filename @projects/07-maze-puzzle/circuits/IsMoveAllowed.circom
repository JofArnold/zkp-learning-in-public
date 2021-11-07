pragma circom 2.0.0;

template IsMoveAllowed() {
  signal input move[2];
  signal output success;
  var allowed[4][2] = [
    [10,14],
    [14,5],
    [5,4],
    [4,6]
  ];
  var i;
  var from = move[0];
  var to = move[1];
  var s = 0;
  for (i=0; i<4; i++) {
    var first = allowed[i][0];
    var second = allowed[i][1];
    if (first == from && second == to || second == from && first == to) {
      s = 1;
    }
  }
  success <-- s;
}

component main {public [move]} = IsMoveAllowed();
