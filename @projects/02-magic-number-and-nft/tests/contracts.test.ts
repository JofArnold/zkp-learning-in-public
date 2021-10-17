const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('verifier tests', () => {
  it('should return true when given correct input', async () => {
    const proof = require('../zk/proof.json');
    const Verifier = await ethers.getContractFactory('Verifier');
    const verifier = await Verifier.deploy();
    await verifier.deployed();

    const result = await verifier.verifyTx(proof.proof, proof.inputs);
    expect(result).equals(true);
  });

  it('should return false when given incorrect input', async () => {
    const Verifier = await ethers.getContractFactory('Verifier');
    const verifier = await Verifier.deploy();
    await verifier.deployed();

    const proof = require('../zk/proof.json');
    // Break input
    proof.proof.a = [
      '0x0c6a0d84b75abf537af3686c38a9d0d73adaf3c555e7f44c4f3fa37c7b365b15',
      '0x1e08a93f36aa7228b80a4b56fa952bc47aed36beb02a9f28f3c3f0dccdc25270',
    ];
    const result = await verifier.verifyTx(proof.proof, proof.inputs);
    expect(result).equals(false);
  });
});
