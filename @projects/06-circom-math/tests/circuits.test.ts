const path = require("path");
const { F1Field, Scalar } = require("ffjavascript");
exports.p = Scalar.fromString(
  "21888242871839275222246405745257275088548364400416034343698204186575808495617"
);
const Fr = new F1Field(exports.p);

const wasmTester = require("circom_tester").wasm;

describe("test", () => {
  it("Should create a isZero circuit", async () => {
    const file = path.resolve(__dirname, "../circuits/isZero.circom");
    const circuit = await wasmTester(file);

    let witness;
    witness = await circuit.calculateWitness({ in: 111 }, true);
    expect(Fr.eq(Fr.e(witness[0]), Fr.e(1))).toBe(true);
    expect(Fr.eq(Fr.e(witness[1]), Fr.e(0))).toBe(true);

    witness = await circuit.calculateWitness({ in: 0 }, true);
    expect(Fr.eq(Fr.e(witness[0]), Fr.e(1))).toBe(true);
    expect(Fr.eq(Fr.e(witness[1]), Fr.e(1))).toBe(true);
  });
});
