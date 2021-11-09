pragma circom 2.0.0;

include "./functions/getNextIndexForMove.circom";

// FOR TESTING THE FUNCTION
template GetNextIndexForMove() {
  // Index of current position in maze
  signal input from;

  // direction
  // 0 - north
  // 1 - east
  // 2 - south
  // 3 - west
  signal input direction;

  signal output nextIndex;

  var next = getNextIndexForMove(from, direction);

  nextIndex <-- next;
}


component main {public [from, direction]} = GetNextIndexForMove();
