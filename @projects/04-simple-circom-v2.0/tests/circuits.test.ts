const assert = require("assert");
const path = require("path");
const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
exports.p = Scalar.fromString(
  "21888242871839275222246405745257275088548364400416034343698204186575808495617"
);
const Fr = new F1Field(exports.p);

const wasmTester = require("circom_tester").wasm;

describe("Test circuits", () => {
  it("return correct values", async () => {
    const circuit = await wasmTester(
      path.resolve(__dirname, "../zk/circuit.circom")
    );
    console.log(11111111111);

    {
      const witness = await circuit.calculateWitness({ in: 111 }, true);
      assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
      assert(Fr.eq(Fr.e(witness[1]), Fr.e(0)));
    }

    {
      const witness = await circuit.calculateWitness({ in: 0 }, true);
      assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
      assert(Fr.eq(Fr.e(witness[1]), Fr.e(1)));
    }
  });
});
