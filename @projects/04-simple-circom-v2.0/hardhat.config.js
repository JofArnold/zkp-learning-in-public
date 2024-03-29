require("@nomiclabs/hardhat-waffle");
require("hardhat-circom");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.6.11",
  circom: {
    // (optional) Base path for input files, defaults to `./circuits/`
    inputBasePath: "./zk",
    // (required) The final ptau file, relative to inputBasePath, from a Phase 1 ceremony
    ptau: "pot15_final.ptau",
    // (required) Each object in this array refers to a separate circuit
    circuits: [{ name: "circom" }],
  },
};
