import {
  convertBinaryStringToInt,
  convertMovesArrayToBinaryString,
  convertMovesArrayToPaddedBinaryString,
} from "../src/utils";
import {
  circuit_checkIfIntSequenceIsValid,
  circuit_convertIntTo16BitIntArray,
  circuit_convertIntTo16BitSignedIntArray,
  circuit_convertIntTo16BitSparseArray,
  circuit_positionToMove,
  circuit_reverseArray,
  maze,
} from "../src/draftCircuits";

describe("Draft circuits test tests", () => {
  test("circuit_reverseArray", () => {
    const arr = [10, 14, 5, 4, 4];
    const reversed = circuit_reverseArray(arr);
    const nativeReversed = arr.reverse();
    expect(reversed).toEqual(nativeReversed);
  });

  test("circuit_convertIntTo16BitIntArray", () => {
    const moves = [1, 2, 3, 4, 5];
    const bin = convertMovesArrayToPaddedBinaryString(moves, 9);
    // Create the integer representation of the binary string
    // Add base here
    const int = convertBinaryStringToInt(bin, 4);
    // Send to circuit
    // 00010010001101000101000000000000
    // 00010010001101000101000000000000 0000
    const arr = circuit_convertIntTo16BitIntArray(int, 9);
    console.log(arr);
  });

  test("circuit_convertIntTo16BitIntArrayBytes", () => {
    const int = parseInt(
      // eslint-disable-next-line prettier/prettier
        "00001" +
        "00010" +
        "10001" +
        "00100" +
        "00101",
      2
    );
    const arr = circuit_convertIntTo16BitSignedIntArray(int, 5);
    expect(arr).toEqual([5, 4, -1, 2, 1]);
  });

  test("circuit_convertIntTo16BitSparseArray", () => {
    // Pre-generate
    const moves = [1, 2, 3, 4, 5];
    const bin = convertMovesArrayToBinaryString(moves);
    const int = convertBinaryStringToInt(bin, 4);
    // Send to circuit
    const arr = circuit_convertIntTo16BitSparseArray(int);
    expect(arr).toEqual([...moves, 1000, 1000, 1000, 1000, 1000]);
  });

  test("circuit_positionToMove", () => {
    const positions = Array(25)
      .fill(null)
      .map((_, i) => i);
    const flatMaze = [...maze].reverse().flat();

    positions.forEach((position) => {
      const move = circuit_positionToMove(position);
      const mazeMove = flatMaze[position];
      expect(move).toBe(mazeMove);
    });
  });

  test("convertMovesArrayToBinaryString", () => {
    const moves = [10, 14, 5, 4, 4];
    const bin = convertMovesArrayToBinaryString(moves);
    const int = convertBinaryStringToInt(bin, 4);
    const arr = circuit_convertIntTo16BitIntArray(int, moves.length);
    expect(arr).toEqual(moves);
  });

  test("convertMovesArrayToBinaryString", () => {
    {
      const moves = [10, 14, 5, 4, 4];
      const bin = convertMovesArrayToBinaryString(moves);
      const int = convertBinaryStringToInt(bin, 4);
      const audit = circuit_checkIfIntSequenceIsValid(int);
      expect(audit).toBe(true);
    }

    {
      const moves = [10, 14, 5, 14, 4];
      const bin = convertMovesArrayToBinaryString(moves);
      const int = convertBinaryStringToInt(bin, 4);
      const audit = circuit_checkIfIntSequenceIsValid(int);
      expect(audit).toBe(false);
    }

    {
      const moves = [10, 14, 5, 14, 10];
      const bin = convertMovesArrayToBinaryString(moves);
      const int = convertBinaryStringToInt(bin, 4);
      const audit = circuit_checkIfIntSequenceIsValid(int);
      expect(audit).toBe(true);
    }
  });
});
