const path = require("path");
const { F1Field, Scalar } = require("ffjavascript");
exports.p = Scalar.fromString(
  "21888242871839275222246405745257275088548364400416034343698204186575808495617"
);
const Fr = new F1Field(exports.p);

const wasmTester = require("circom_tester").wasm;

describe("test", () => {
  it("Should create a EqualsFive circuit", async () => {
    const file = path.resolve(
      __dirname,
      "../circuits/equals_five/circuit.circom"
    );
    const circuit = await wasmTester(file);

    {
      const witness = await circuit.calculateWitness({ a: 1, b: 4 }, true);
      expect(Fr.eq(Fr.e(witness[0]), Fr.e(1))).toBe(true);
    }

    {
      await expect(
        circuit.calculateWitness({ a: 2, b: 4 }, true)
      ).rejects.toThrow();
    }
  });
});
