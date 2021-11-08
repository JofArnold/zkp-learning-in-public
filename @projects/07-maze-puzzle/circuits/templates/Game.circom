pragma circom 2.0.0;

include "./GetNextIndexForMove.circom";
include "./TileCodeFromIndex.circom";
include "./IsTileOpenForDirection.circom";

template Game(N) {
  signal input moves[N];

  // result
  // 0 - invalid moves
  // 1 - valid moves
  // 2 - valid and completed
  signal output result;

  // Various utils
  component gnis[N];
  component tcis[N];
  component exits[N];
  component entrances[N];

  // Build the components arrays
  for (var i = 0; i < N; i++) {
    gnis[i] = GetNextIndexForMove();
    tcis[i] = TileCodeFromIndex();
    exits[i] = IsTileOpenForDirection();
    entrances[i] = IsTileOpenForDirection();
  }

  var currentTileCode;
  var nextTileCode;
  var currentIndex = 0;
  var currentDirection;
  var movesOk = 1;
  var moveOk;


  for (var m = 0; m < N; m++) {
    currentDirection = moves[m];

    // Get current tile type
    currentIndex --> tcis[m].index;
    currentTileCode = tcis[m].tileCode;

    // Check if exiting the tile in that direction is ok
    currentTileCode --> exits[m].tileCode;
    currentDirection --> exits[m].direction;
    moveOk = exits[m].success;
    movesOk *= moveOk;

    // Get the next tile type
    // Check if the move from the current tile is ok
    // Check if the move to the next tile is ok
  }

  result <== currentIndex;
}
