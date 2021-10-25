const snarkjs = require("snarkjs");
const fs = require("fs");
const path = require("path");

async function run() {
  const { proof, publicSignals } = await snarkjs.groth16.fullProve(
    { a: 10, b: 21 },
    path.resolve(__dirname, "../zk/circuit.wasm"),
    path.resolve(__dirname, "../zk/circuit_final.zkey")
  );

  console.log("Proof: ");
  console.log(JSON.stringify(proof, null, 1));

  const vKey = JSON.parse(
    fs.readFileSync(path.resolve(__dirname, "../zk/verification_key.json"))
  );

  const res = await snarkjs.groth16.verify(vKey, publicSignals, proof);

  if (res === true) {
    console.log("Verification OK");
  } else {
    console.log("Invalid proof");
  }
}

run().then(() => {
  process.exit(0);
});
