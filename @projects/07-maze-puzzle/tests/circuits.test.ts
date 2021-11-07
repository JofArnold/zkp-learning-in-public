const path = require("path");
const { F1Field, Scalar } = require("ffjavascript");
exports.p = Scalar.fromString(
  "21888242871839275222246405745257275088548364400416034343698204186575808495617"
);
const Fr = new F1Field(exports.p);

const wasmTester = require("circom_tester").wasm;

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
});
