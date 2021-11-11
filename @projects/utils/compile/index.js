const { exec } = require("child_process");
const { program } = require("commander");
program
  .option(
    "-c, --circuit <type>",
    " Name of circuit - e.g. 'my_circuit'. Much also match the directory name"
  )
  .option("-m, --mode <type>", "Mode - 'compile' or 'ptau'");
program.parse();

const circuit = program.getOptionValue("circuit");
const mode = program.getOptionValue("mode");
console.log(circuit, mode);

exec(`pwd`, (error, stdout, stderr) => {
  if (error) {
    console.log(error);
    console.log(`error: ${error.message}`);
    return;
  }
  if (stderr) {
    console.log(`stderr: ${stderr}`);
    return;
  }
  console.log(`stdout: ${stdout}`);
});

exec(
  `sh ./compile/circuit.sh -z asdasd -p asdasdasd -c asdasdsad`,
  (error, stdout, stderr) => {
    if (error) {
      console.log(`error: ${error.message}`);
      return;
    }
    if (stderr) {
      console.log(`stderr: ${stderr}`);
      return;
    }
    console.log(`stdout: ${stdout}`);
  }
);
//
// exec(
//   `sh ./compile/circuit.sh -m ${mode} -c ${circuit}`,
//   (error, stdout, stderr) => {
//     if (error) {
//       console.log(error);
//       console.log(`error: ${error.message}`);
//       return;
//     }
//     if (stderr) {
//       console.log(`stderr: ${stderr}`);
//       return;
//     }
//     console.log(`stdout: ${stdout}`);
//   }
// );
