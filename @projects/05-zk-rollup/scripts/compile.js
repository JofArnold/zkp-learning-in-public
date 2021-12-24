const { exec } = require("child_process");
const path = require("path");

const CIRCUIT_NAME = process.argv[2];

const CIRCUIT_PATH = path.resolve(
  __dirname,
  "../circuits",
  CIRCUIT_NAME,
  "circuit.circom"
);
const CONTRACT_DIR = path.resolve(__dirname, "../contracts");
const PTAU_DIR = path.resolve(
  __dirname,
  "../node_modules/@projects/utils/ptau"
);

const SCRIPT_PATH = path.resolve(
  __dirname,
  "../node_modules/@projects/utils/compile/circuit.sh"
);

exec(
  `sh ${SCRIPT_PATH} -z ${CIRCUIT_PATH} -p ${PTAU_DIR} -c ${CONTRACT_DIR}`,
  (error, stdout, stderr) => {
    if (error) {
      console.error("❌ Fail!", error.message);
      return;
    }
    if (stderr) {
      console.error("❌ Fail!", stderr);
      return;
    }
    console.log("🎉 Success!", stdout);
  }
);
