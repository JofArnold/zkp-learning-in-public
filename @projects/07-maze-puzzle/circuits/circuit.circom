pragma circom 2.0.0;

include "./functions/getNextIndexForMove.circom";
include "./functions/getTileCodeFromIndex.circom";
include "./functions/isTileOpenForSide.circom";

function invertDirection(direction) {
    if (direction == 0) {
        return 2;
    } else if (direction == 1) {
        return 3;
    } else if (direction == 2) {
        return 0;
    } else {
      return 1;
    }
}

template Game(N) {
  signal input moves[N];

  // result
  signal output out;

  var currentTileCode;
  var currentIndex = 0;
  var currentDirection;
  var movesOk = 1;

  var OUT_OF_RANGE = 100;

  for (var m = 0; m < N; m++) {
    currentDirection = moves[m];
    if (currentDirection != OUT_OF_RANGE) {
      // Get current tile type
      currentTileCode = getTileCodeFromIndex(currentIndex);

      // Check if exiting the tile in that direction is ok
      movesOk *= isTileOpenForSide(currentTileCode, currentDirection); // I.e. if success is zero, movesOk becomes zero

      // Get the next index
      currentIndex = getNextIndexForMove(currentIndex, currentDirection);
    }
  }

  var isComplete = currentIndex == 24 ? 1 : 0;

  var result = isComplete * movesOk == 1 ? 2 : movesOk;

  out <-- result;
}

component main = Game(20);
