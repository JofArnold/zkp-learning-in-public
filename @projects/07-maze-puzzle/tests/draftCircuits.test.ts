import {
  convertBinaryStringToInt,
  convertMovesArrayToBinaryString,
} from "../src/utils";
import {
  checkIfIntSequenceIsValid,
  convertIntTo16BitIntArray,
  reverseArray,
} from "../src/draftCircuits";

describe("Draft circuits test tests", () => {
  test("reverseArray", () => {
    const arr = [10, 14, 5, 4, 4];
    const reversed = reverseArray(arr);
    const nativeReversed = arr.reverse();
    expect(reversed).toEqual(nativeReversed);
  });

  test("convertMovesArrayToBinaryString", () => {
    const moves = [10, 14, 5, 4, 4];
    const bin = convertMovesArrayToBinaryString(moves);
    const int = convertBinaryStringToInt(bin);
    const arr = convertIntTo16BitIntArray(int, moves.length);
    expect(arr).toEqual(moves);
  });

  test("convertMovesArrayToBinaryString", () => {
    {
      const moves = [10, 14, 5, 4, 4];
      const bin = convertMovesArrayToBinaryString(moves);
      const int = convertBinaryStringToInt(bin);
      const audit = checkIfIntSequenceIsValid(int);
      expect(audit).toBe(true);
    }

    {
      const moves = [10, 14, 5, 14, 4];
      const bin = convertMovesArrayToBinaryString(moves);
      const int = convertBinaryStringToInt(bin);
      const audit = checkIfIntSequenceIsValid(int);
      expect(audit).toBe(false);
    }

    {
      const moves = [10, 14, 5, 14, 10];
      const bin = convertMovesArrayToBinaryString(moves);
      const int = convertBinaryStringToInt(bin);
      const audit = checkIfIntSequenceIsValid(int);
      expect(audit).toBe(true);
    }
  });
});
