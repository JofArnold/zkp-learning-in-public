pragma circom 2.0.0;

include "./GetNextIndexForMove.circom";
include "./TileCodeFromIndex.circom";
include "./IsTileOpenForSide.circom";

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
  signal output movesValid;

  // Various utils
  component gnis[N];
  component currentTCFI[N];
  component nextTCFI[N];
  component exits[N];
  component entrances[N];

  // Build the components arrays
  for (var i = 0; i < N; i++) {
    gnis[i] = GetNextIndexForMove();
    currentTCFI[i] = TileCodeFromIndex();
    nextTCFI[i] = TileCodeFromIndex();
    exits[i] = IsTileOpenForSide();
    entrances[i] = IsTileOpenForSide();
  }

  var currentTileCode;
  var nextTileCode;
  var currentIndex = 0;
  var nextIndex;
  var currentDirection;
  var nextDirection;
  var movesOk = 1;
  var moveOk;
  var movesEnded = 0;

  for (var m = 0; m < N; m++) {
    currentDirection = moves[m];

    // Get current tile type
    currentIndex --> currentTCFI[m].index;
    currentTileCode = currentTCFI[m].tileCode;

    // Check if exiting the tile in that direction is ok
    currentTileCode --> exits[m].tileCode;
    currentDirection --> exits[m].side;
    moveOk = exits[m].success;
    movesOk *= moveOk; // I.e. if success is zero, movesOk becomes zero

    // Get the next index
    currentIndex --> gnis[m].from;
    currentDirection --> gnis[m].direction;
    nextIndex = gnis[m].nextIndex;

    // Get the type of tile for next index
    nextIndex --> nextTCFI[m].index;
    nextTileCode = nextTCFI[m].tileCode;

    // Check if entering in that direction is ok
    nextDirection = invertDirection(currentDirection);
    nextTileCode --> entrances[m].tileCode;
    nextDirection --> entrances[m].side;
    moveOk = exits[m].success;
    movesOk *= moveOk; // I.e. if success is zero, movesOk becomes zero

    currentIndex = nextIndex;
  }

  movesValid <-- movesOk;
}
