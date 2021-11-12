pragma circom 2.0.0;

function getNextIndexForMove(from, direction) {
  // From: index of current position in maze
  // direction:
  // 0 - north
  // 1 - east
  // 2 - south
  // 3 - west

  var delta = 0;
  if (direction == 0) {
    delta = 5;
  } else if (direction == 1) {
    delta = 1;
  } else if (direction == 2) {
    delta = -5;
  } else if (direction == 3) {
    delta = -1;
  }
  var result = from + delta;
  return result;
}
