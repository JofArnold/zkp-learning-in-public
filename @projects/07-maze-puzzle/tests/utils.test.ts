import {
  convertBinaryStringToInt,
  convertMovesArrayToBinaryString,
} from "../src/utils";

describe("Utils tests", () => {
  test("convertMovesArrayToBinaryString", () => {
    const moves = [10, 14, 5, 4, 4];
    expect(convertMovesArrayToBinaryString(moves)).toBe("10101110010101000100");
  });

  test("convertBinaryStringToInt", () => {
    expect(convertBinaryStringToInt("10101110010101000100")).toBe(714052);
  });

  // test("convertIntTo16BitIntArray", () => {
  //   const moves = [10, 14, 5, 4, 4];
  //   expect(convertMovesArrayToBinaryString(moves)).toEqual([]);
  //   expect(convertIntTo16BitIntArray[)
  // });
  it("Should create a Puzzle circuit", async () => {
    // const movesBin = moves.map((m) => m.toString(2).padStart(4, "0")).join("");
    // const movesInt = parseInt(movesBin, 2);
    //
    // const validMoves = [
    //   [10, 14],
    //   [14, 5],
    //   [5, 4],
    //   [4, 4],
    // ];
    //
    // const out = convertTo16BitArray(movesInt);
    //
    // const audit = [];
    // for (let i = 0; i < moves.length - 1; i++) {
    //   const curr = out[3 - i];
    //   const next = out[3 - i - 1];
    //   if (curr === next) {
    //     audit[i] = true;
    //     continue;
    //   }
    //   let valid = false;
    //   for (let j = 0; j < 3; j++) {
    //     const seq = validMoves[j];
    //     if (!seq) {
    //       continue;
    //     }
    //     const validCurr = seq[0];
    //     const validNext = seq[1];
    //     if (curr === validCurr && next === validNext) {
    //       valid = true;
    //       break;
    //     }
    //   }
    //   audit[i] = valid;
    // }
    //
    // console.log(audit);
    // const circuit = await wasmTester(file);
    //
    // {
    //   const witness = await circuit.calculateWitness({ in: 123456 }, true);
    //   [7716, 482, 30].forEach((w, i) => {
    //     expect(Fr.eq(Fr.e(w), Fr.e(witness[i + 1]))).toBe(true);
    //   });
    // }
  });
});
