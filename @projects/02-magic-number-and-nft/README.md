# About

This is a slightly more elaborate example than Project 01 and has tests replicating a typical browser environment and "
winning" an NFT for a correct proof:

1) Happy path: user submits a valid proof to the contract and receives an NFT for doing so.
2) User messes around with a raw proof by modifying stuff and submitting to the contract... but contract rejects and
   they get nothing.
3) User correctly creates proof in the "browser" (the generateJSProof function) and submits to the contract to
   successfully get their NFT.
4) User attempts to create a proof with an invalid answer in the browser (here Zokrates flat out errors and the contract
   isn't even called.
