const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('NFT tests', () => {
  it('should return true and assign NFT when given correct input', async () => {
    // const proof = require('../zk/proof.json');
    const NFT = await ethers.getContractFactory('NFTPrize');
    const nft = await NFT.deploy();
    await nft.deployed();
  });
});
