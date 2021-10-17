const { initialize } = require("zokrates-js/node");
const fs = require("fs");
const path = require("path");

const generateJSProof = async toCheck => {
  const values = [...toCheck]; //.map(s => parseInt(s, 10));
  // --------------------------------------------------------------------------------
  // Get the various bits of data we need

  const zokratesProvider = await initialize();
  const source = fs.readFileSync(
    path.resolve(__dirname, "../zk/magicNumber.zok"),
    "utf-8"
  );
  const artefacts = zokratesProvider.compile(source);
  const { witness } = zokratesProvider.computeWitness(artefacts, values);
  const provingKey = fs.readFileSync(
    path.resolve(__dirname, "../zk/proving.key")
  );

  // --------------------------------------------------------------------------------
  // Compute the proof (this will fail if the users gets it wrong)

  const proof = zokratesProvider.generateProof(
    artefacts.program,
    witness,
    provingKey
  );
  return proof;
};

module.exports = { generateJSProof };
