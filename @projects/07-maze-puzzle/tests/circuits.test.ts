const path = require("path");
const fs = require("fs");
const { F1Field, Scalar } = require("ffjavascript");
exports.p = Scalar.fromString(
  "21888242871839275222246405745257275088548364400416034343698204186575808495617"
);
const Fr = new F1Field(exports.p);

const wasmTester = require("circom_tester").wasm;

const MAZE = [
  // eslint-disable-next-line prettier/prettier
  10, 14, 5, 6, 12,
  6, 2, 4, 4, 5,
  11, 13, 6, 5, 13,
  6, 4, 8, 13, 11,
  7, 14, 12, 7, 12,
];

describe("Circuit tests", () => {
  test("Basic array circuit works", async () => {
    const file = path.resolve(__dirname, "../circuits/Array.circom");
    const circuit = await wasmTester(file);

    const array = [10, 20, 30, 40, 50];
    const witness = await circuit.calculateWitness({ in: array }, true);
    const outputs: number[] = witness.slice(1, 6);
    outputs.forEach((output, i) => {
      expect(Fr.eq(Fr.e((array[i] as number) + 3), output)).toBe(true);
    });
  });

  test("Maze array circuit works", async () => {
    const file = path.resolve(__dirname, "../circuits/Maze.circom");
    const circuit = await wasmTester(file);

    const witness = await circuit.calculateWitness({}, true);
    const outputs: number[] = witness.slice(1, 25);
    outputs.forEach((output, i) => {
      expect(Fr.eq(Fr.e(MAZE[i]), output)).toBe(true);
    });
  });

  test("TileCodeFromIndex circuit works", async () => {
    const file = path.resolve(
      __dirname,
      "../circuits/TileCodeFromIndex.circom"
    );
    const circuit = await wasmTester(file);

    const promises = MAZE.map((_, i) => async () => {
      const witness = await circuit.calculateWitness({ index: i }, true);
      const output = witness[1];
      expect(Fr.eq(Fr.e(MAZE[i]), output)).toBe(true);
    });
    await Promise.all(promises);
  });

  test("GetNextIndexForMove circuit works", async () => {
    const file = path.resolve(
      __dirname,
      "../circuits/GetNextIndexForMove.circom"
    );
    const circuit = await wasmTester(file);

    const MOVES = [
      {
        input: [0, 3],
        expected: 1,
      },
      {
        input: [1, 3],
        expected: 2,
      },
      {
        input: [1, 0],
        expected: 7,
      },
      {
        input: [0, 0],
        expected: 6,
      },
    ];

    const promises = MOVES.map((test) => async () => {
      const witness = await circuit.calculateWitness(
        { from: test.input[0], direction: test.input[1] },
        true
      );
      const output = witness[1];
      expect(Fr.eq(Fr.e(test.expected), output)).toBe(true);
    });
    await Promise.all(promises);
  });

  test("IsTileOpenForSide circuit works", async () => {
    const file = path.resolve(
      __dirname,
      "../circuits/IsTileOpenForSide.circom"
    );
    const circuit = await wasmTester(file);

    {
      const witness = await circuit.calculateWitness(
        { tileCode: 10, direction: 1 }, // User enters or exits tile 10 from top
        true
      );
      expect(Fr.eq(Fr.e(1), witness[1])).toBe(true);
    }
    {
      const witness = await circuit.calculateWitness(
        { tileCode: 10, direction: 3 },
        true
      );
      expect(Fr.eq(Fr.e(0), witness[1])).toBe(true);
    }
    {
      const witness = await circuit.calculateWitness(
        { tileCode: 6, direction: 3 },
        true
      );
      expect(Fr.eq(Fr.e(0), witness[1])).toBe(true);
    }
    {
      const witness = await circuit.calculateWitness(
        { tileCode: 7, direction: 2 },
        true
      );
      expect(Fr.eq(Fr.e(1), witness[1])).toBe(true);
    }
  });

  test("IsMoveAllowed circuit works", async () => {
    const file = path.resolve(__dirname, "../circuits/IsMoveAllowed.circom");
    const circuit = await wasmTester(file);

    {
      const witness = await circuit.calculateWitness({ move: [10, 14] }, true);
      expect(Fr.eq(Fr.e(1), witness[1])).toBe(true);
    }
    {
      const witness = await circuit.calculateWitness({ move: [14, 10] }, true);
      expect(Fr.eq(Fr.e(1), witness[1])).toBe(true);
    }
    {
      const witness = await circuit.calculateWitness({ move: [1, 14] }, true);
      expect(Fr.eq(Fr.e(1), witness[1])).toBe(false);
    }
  });

  test("Game circuit works", async () => {
    const file = path.resolve(__dirname, "../circuits/Game.circom");
    const circuit = await wasmTester(file);

    const INVALID = 0;
    const VALID = 1;
    const COMPLETE = 2;
    // Invalid
    // {
    //   const moves = Array(20).fill(-1); // Sparse array of moves
    //   [1, 0].forEach((move, index) => {
    //     moves[index] = move;
    //   });
    //   const witness = await circuit.calculateWitness({ moves }, true);
    //   expect(Fr.eq(Fr.e(INVALID), witness[1])).toBe(true);
    // }
    // // Valid but incomplete
    // {
    //   const moves = Array(20).fill(-1); // Sparse array of moves
    //   [1, 1, 0, 3].forEach((move, index) => {
    //     moves[index] = move;
    //   });
    //   const witness = await circuit.calculateWitness({ moves }, true);
    //   expect(Fr.eq(Fr.e(VALID), witness[1])).toBe(true);
    // }
    // Valid and complete
    {
      const moves = Array(12).fill(-1); // Sparse array of moves
      [1, 1, 0, 3, 0, 0, 1, 2, 1, 0, 0, 1].forEach((move, index) => {
        moves[index] = move;
      });
      const witness = await circuit.calculateWitness({ moves }, true);
      const str = JSON.stringify(
        witness.map((v: number) => v.toString()),
        null,
        2
      );
      // fs.writeFileSync(path.resolve(__dirname, "result"), str);
      const output = witness[1];
      console.log(output);
      expect(Fr.eq(Fr.e(VALID), witness[1])).toBe(true);
    }
  });
});
