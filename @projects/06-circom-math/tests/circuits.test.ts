const path = require("path");
const { F1Field, Scalar } = require("ffjavascript");
exports.p = Scalar.fromString(
  "21888242871839275222246405745257275088548364400416034343698204186575808495617"
);
const Fr = new F1Field(exports.p);

const wasmTester = require("circom_tester").wasm;

describe("test", () => {
  it("Should create a isZero circuit", async () => {
    const file = path.resolve(__dirname, "../circuits/IsZero.circom");
    const circuit = await wasmTester(file);

    {
      const witness = await circuit.calculateWitness({ in: 111 }, true);
      expect(Fr.eq(Fr.e(witness[0]), Fr.e(1))).toBe(true);
      expect(Fr.eq(Fr.e(witness[1]), Fr.e(0))).toBe(true);
    }

    {
      const witness = await circuit.calculateWitness({ in: 0 }, true);
      expect(Fr.eq(Fr.e(witness[0]), Fr.e(1))).toBe(true);
      expect(Fr.eq(Fr.e(witness[1]), Fr.e(1))).toBe(true);
    }
  });

  it("Should create a Add circuit", async () => {
    const file = path.resolve(__dirname, "../circuits/Add.circom");
    const circuit = await wasmTester(file);

    {
      const witness = await circuit.calculateWitness(
        { in1: 111, in2: 222 },
        true
      );
      const output = witness[1];
      expect(Fr.eq(Fr.e(output), Fr.e(333))).toBe(true);
    }
  });

  it("Should create a Multiply circuit", async () => {
    const file = path.resolve(__dirname, "../circuits/Multiply.circom");
    const circuit = await wasmTester(file);

    {
      const witness = await circuit.calculateWitness({ in1: 0, in2: 10 }, true);
      const output = witness[1];
      expect(Fr.eq(Fr.e(output), Fr.e(0))).toBe(true);
    }
    {
      const witness = await circuit.calculateWitness({ in1: 5, in2: 6 }, true);
      const output = witness[1];
      expect(Fr.eq(Fr.e(output), Fr.e(30))).toBe(true);
    }
  });

  it("Should create a Multiply circuit", async () => {
    const file = path.resolve(__dirname, "../circuits/Multiply.circom");
    const circuit = await wasmTester(file);

    {
      const witness = await circuit.calculateWitness({ in1: 0, in2: 10 }, true);
      const output = witness[1];
      expect(Fr.eq(Fr.e(output), Fr.e(0))).toBe(true);
    }
    {
      const witness = await circuit.calculateWitness({ in1: 5, in2: 6 }, true);
      const output = witness[1];
      expect(Fr.eq(Fr.e(output), Fr.e(30))).toBe(true);
    }
  });

  it("Should create a InverseModulo circuit", async () => {
    const file = path.resolve(__dirname, "../circuits/InverseModulo.circom");
    const circuit = await wasmTester(file);

    {
      const witness = await circuit.calculateWitness(
        { in1: 1, in2: 2, in3: 3 },
        true
      );
      const inv = Scalar.fromString(
        "10944121435919637611123202872628637544274182200208017171849102093287904247810"
      );
      const output = witness[1];
      expect(Fr.eq(Fr.e(output), inv)).toBe(true);
    }
    {
      const witness = await circuit.calculateWitness(
        { in1: 1, in2: 2, in3: 0 },
        true
      );
      const output = witness[1];
      expect(Fr.eq(Fr.e(output), Fr.e(0))).toBe(true);
    }
  });

  it("Should create a Quotient circuit", async () => {
    const file = path.resolve(__dirname, "../circuits/Quotient.circom");
    const circuit = await wasmTester(file);

    {
      const witness = await circuit.calculateWitness(
        { in1: 29, in2: 3, in3: 1 },
        true
      );
      const output = witness[1];
      // 3 goes into 29 nine times, remainder 2
      expect(Fr.eq(Fr.e(output), Fr.e(9))).toBe(true);
    }
  });

  it("Should create a Remainder circuit", async () => {
    const file = path.resolve(__dirname, "../circuits/Remainder.circom");
    const circuit = await wasmTester(file);

    {
      const witness = await circuit.calculateWitness(
        { in1: 29, in2: 3, in3: 1 },
        true
      );
      const output = witness[1];
      // 3 goes into 29 nine times, remainder 2
      expect(Fr.eq(Fr.e(output), Fr.e(2))).toBe(true);
    }
  });

  it("Should create a BitwiseAnd circuit", async () => {
    const file = path.resolve(__dirname, "../circuits/BitwiseAnd.circom");
    const circuit = await wasmTester(file);

    {
      const witness = await circuit.calculateWitness(
        { in1: 2999, in2: 15 },
        true
      );
      const output = witness[1];
      // 101110110111
      //         1111
      //          111
      // = 7
      expect(Fr.eq(Fr.e(output), Fr.e(7))).toBe(true);
    }
  });

  it("Should create a AssertAssign circuit", async () => {
    const file = path.resolve(__dirname, "../circuits/AssertAssign.circom");
    const circuit = await wasmTester(file);

    {
      const witness = await circuit.calculateWitness({ in: 29 }, true);
      // Check outputs are 1,29,29
      [1, 29, 29].forEach((v, i) => {
        const output = witness[i];
        expect(Fr.eq(Fr.e(output), Fr.e(v))).toBe(true);
      });
    }
  });

  it("Should create a AssertAssignPrivate circuit", async () => {
    const file = path.resolve(
      __dirname,
      "../circuits/AssertAssignPrivate.circom"
    );
    const circuit = await wasmTester(file);

    {
      const witness = await circuit.calculateWitness({ in: 29 }, true);
      // Check outputs are 1,29,29
      [1, 29].forEach((v, i) => {
        const output = witness[i];
        expect(Fr.eq(Fr.e(output), Fr.e(v))).toBe(true);
      });
    }
  });

  it("Should create a Assert circuit", async () => {
    const file = path.resolve(__dirname, "../circuits/Assert.circom");
    const circuit = await wasmTester(file);

    {
      const witness = await circuit.calculateWitness({ in: 29 }, true);
      [1].forEach((v, i) => {
        const output = witness[i];
        expect(Fr.eq(Fr.e(output), Fr.e(v))).toBe(true);
      });
    }
    {
      // Check that it throws an error if the input is not 29
      try {
        await circuit.calculateWitness({ in: 28 }, true);
      } catch (e: any) {
        expect(e.message).toMatch("Assert Failed");
      }
    }
  });
});
