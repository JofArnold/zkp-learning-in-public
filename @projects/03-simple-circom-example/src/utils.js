const bigInt = require("big-integer");

const p = bigInt(
  "21888242871839275222246405745257275088548364400416034343698204186575808495617"
);

// FROM https://github.com/darkforest-eth/packages/blob/05c85915ad664563e17085eb23817ea9a0f83bb2/snarks/index.ts#L205-L218
function buildContractCallArgs(snarkProof, publicSignals) {
  // the object returned by genZKSnarkProof needs to be massaged into a set of parameters the verifying contract
  // will accept
  return [
    snarkProof.pi_a.slice(0, 2), // pi_a
    // genZKSnarkProof reverses values in the inner arrays of pi_b
    [
      snarkProof.pi_b[0].slice(0).reverse(),
      snarkProof.pi_b[1].slice(0).reverse(),
    ], // pi_b
    snarkProof.pi_c.slice(0, 2), // pi_c
    publicSignals, // input
  ];
}

function modPBigInt(x) {
  let ret = bigInt(x).mod(p);
  if (ret.lesser(bigInt(0))) {
    ret = ret.add(p);
  }
  return ret;
}

module.exports = {
  buildContractCallArgs,
  modPBigInt,
};

// await expect(world.user1Scoring.claim(...makeRevealArgs(LVL3_SPACETIME_2, x, y)))
//         const callArgs = await this.snarkHelper.getInitArgs(
//             await this.contractsAPI.initializePlayer(callArgs, txIntent);

/*




const callArgs = await this.snarkHelper.getInitArgs(
  planet.location.coords.x,
  planet.location.coords.y,
  Math.floor(Math.sqrt(planet.location.coords.x ** 2 + planet.location.coords.y ** 2)) + 1 // floor(sqrt(x^2 + y^2)) + 1
);


  async getInitArgs(x: number, y: number, r: number): Promise<InitSnarkContractCallArgs> {
    try {
      const start = Date.now();
      this.terminal.current?.println('INIT: calculating witness and proof', TerminalTextStyle.Sub);
      const input: InitSnarkInput = {
        x: modPBigInt(x).toString(),
        y: modPBigInt(y).toString(),
        r: r.toString(),
        PLANETHASH_KEY: this.hashConfig.planetHashKey.toString(),
        SPACETYPE_KEY: this.hashConfig.spaceTypeKey.toString(),
        SCALE: this.hashConfig.perlinLengthScale.toString(),
        xMirror: this.hashConfig.perlinMirrorX ? '1' : '0',
        yMirror: this.hashConfig.perlinMirrorY ? '1' : '0',
      };

      const { proof, publicSignals }: SnarkJSProofAndSignals = this.useMockHash
        ? this.fakeInitProof(x, y, r)
        : await this.snarkProverQueue.doProof(input, initCircuitPath, initZkeyPath);
      const ret = buildContractCallArgs(proof, publicSignals) as InitSnarkContractCallArgs;
      const end = Date.now();
      this.terminal.current?.println(
        `INIT: calculated witness and proof in ${end - start}ms`,
        TerminalTextStyle.Sub
      );


      //doProof
      const res = await window.snarkjs.groth16.fullProve(task.input, task.circuit, task.zkey);



 */

// async
// initializePlayer(
//   args
// :
// InitSnarkContractCallArgs,
//   action
// :
// UnconfirmedInit
// ):
// Promise < void | providers.TransactionReceipt > {
//   if(
// !this.txExecutor
// )
// {
//   throw new Error('no signer, cannot execute tx');
// }
// const tx = this.txExecutor.queueTransaction(
//   action.actionId,
//   this.coreContract,
//   ContractMethodName.INIT,
//   args
// );

//
// planetLoc: TestLocation,
//   x: number,
//   y: number
// ): [
//   [BigNumberish, BigNumberish],
//   [[BigNumberish, BigNumberish], [BigNumberish, BigNumberish]],
//   [BigNumberish, BigNumberish],
//   [
//     BigNumberish,
//     BigNumberish,
//     BigNumberish,
//     BigNumberish,
//     BigNumberish,
//     BigNumberish,
//     BigNumberish,
//     BigNumberish,
//     BigNumberish
//   ]
// ] {
//   return [
//     [BN_ZERO, BN_ZERO],
//     [
//       [BN_ZERO, BN_ZERO],
//       [BN_ZERO, BN_ZERO],
//     ],
//     [BN_ZERO, BN_ZERO],
//     [
//       planetLoc.id,
//       planetLoc.perlin,
//       modPBigInt(x).toString(),
//       modPBigInt(y).toString(),
//       PLANETHASH_KEY,
//       SPACETYPE_KEY,
//       PERLIN_LENGTH_SCALE,
//       PERLIN_MIRROR_X ? '1' : '0',
//       PERLIN_MIRROR_Y ? '1' : '0',
//     ],
//   ];
// }
