import {
  convertBinaryStringToInt,
  convertMovesArrayToBinaryString,
} from "../src/utils";
import {
  circuit_checkIfIntSequenceIsValid,
  circuit_convertIntTo16BitIntArray,
  circuit_reverseArray,
} from "../src/draftCircuits";

describe("Draft circuits test tests", () => {
  test("circuit_reverseArray", () => {
    const arr = [10, 14, 5, 4, 4];
    const reversed = circuit_reverseArray(arr);
    const nativeReversed = arr.reverse();
    expect(reversed).toEqual(nativeReversed);
  });

  test("circuit_convertIntTo16BitIntArray", () => {
    const moves = [10, 14, 5, 4, 4];
    const bin = convertMovesArrayToBinaryString(moves);
    const int = convertBinaryStringToInt(bin);
    const arr = circuit_convertIntTo16BitIntArray(int, moves.length);
    expect(arr).toEqual(moves);
  });

  test("convertMovesArrayToBinaryString", () => {
    const moves = [10, 14, 5, 4, 4];
    const bin = convertMovesArrayToBinaryString(moves);
    const int = convertBinaryStringToInt(bin);
    const arr = circuit_convertIntTo16BitIntArray(int, moves.length);
    expect(arr).toEqual(moves);
  });

  test("convertMovesArrayToBinaryString", () => {
    {
      const moves = [10, 14, 5, 4, 4];
      const bin = convertMovesArrayToBinaryString(moves);
      const int = convertBinaryStringToInt(bin);
      const audit = circuit_checkIfIntSequenceIsValid(int);
      expect(audit).toBe(true);
    }

    {
      const moves = [10, 14, 5, 14, 4];
      const bin = convertMovesArrayToBinaryString(moves);
      const int = convertBinaryStringToInt(bin);
      const audit = circuit_checkIfIntSequenceIsValid(int);
      expect(audit).toBe(false);
    }

    {
      const moves = [10, 14, 5, 14, 10];
      const bin = convertMovesArrayToBinaryString(moves);
      const int = convertBinaryStringToInt(bin);
      const audit = circuit_checkIfIntSequenceIsValid(int);
      expect(audit).toBe(true);
    }
  });
});
