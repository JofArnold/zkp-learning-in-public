export const circuit_convertIntTo16BitIntArray = (
  movesInt: number,
  totalMoves: number
): (number | undefined)[] => {
  const out = [];
  for (let i = 0; i < totalMoves; i++) {
    let integer = 0;
    for (let j = 0; j < 4; j++) {
      const bit = (movesInt >> (i * 4 + j)) & 1;
      const digit = bit * 2 ** j;
      integer += digit;
    }
    out[i] = integer;
  }
  const reversed = circuit_reverseArray(out);
  return reversed;
};

export const circuit_reverseArray = (arr: number[]): (number | undefined)[] => {
  const out = [];
  for (let i = arr.length - 1; i >= 0; i--) {
    out[arr.length - 1 - i] = arr[i];
  }
  return out;
};

const validMoves = [
  [10, 14],
  [14, 5],
  [5, 4],
  [4, 4],
];

const maze = [[7, 14, 12, 7, 12]];

export const circuit_checkIfIntSequenceIsValid = (seq: number): boolean => {
  const length = 5;
  const moves = circuit_convertIntTo16BitIntArray(seq, 5);
  const audit = [];
  for (let i = 0; i < length - 1; i++) {
    const curr = moves[i];
    const next = moves[i + 1];
    if (curr === next) {
      audit[i] = true;
      continue;
    }
    let valid = false;
    for (let j = 0; j < 4; j++) {
      const seq = validMoves[j];
      if (!seq) {
        continue;
      }
      {
        const validCurr = seq[0];
        const validNext = seq[1];
        if (curr === validCurr && next === validNext) {
          valid = true;
          break;
        }
      }
      {
        const validCurr = seq[1];
        const validNext = seq[0];
        if (curr === validCurr && next === validNext) {
          valid = true;
          break;
        }
      }
    }
    audit[i] = valid;
  }
  let ok = true;
  for (let i = 0; i < length - 1; i++) {
    if (audit[i] === false) {
      ok = false;
    }
  }
  return ok;
};
