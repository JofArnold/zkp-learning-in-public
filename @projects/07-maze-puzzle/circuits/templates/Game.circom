pragma circom 2.0.0;

template Game() {
  signal input moves[20];

  // result
  // 0 - invalid moves
  // 1 - valid moves
  // 2 - valid and completed
  signal output result;

  result <-- 0;

  var i;
  for (var m = 0; m < 20; m++) {
    i = 24;
  }
}
