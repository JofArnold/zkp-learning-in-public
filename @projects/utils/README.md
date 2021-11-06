# About

Various scripts for working with ZKPs, Solidity and so on

# Utils

## Ptau

Ready-made artefacts phase 1 ptau of above script. Saves you running it for each project.

⚠️ DO NOT USE IN PRODUCTION!

## Compile

Shell script which compiles a circuit and runs phase 2 ptau. Requires `circom` binary to be installed globally and NOT from the package.json or yarn will hijack and use that one (which as of writing will be the legacy JS version)

Example usage from within node


```javascript
const { exec } = require("child_process");
const path = require("path");

const CIRCUIT_DIR = path.resolve(__dirname, "../circuits/circuit.circom");
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
  `sh ${SCRIPT_PATH} -z ${CIRCUIT_DIR} -p ${PTAU_DIR} -c ${CONTRACT_DIR}`,
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
```