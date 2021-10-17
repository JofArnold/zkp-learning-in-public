# About

This folder pretty much exactly mirrors Elena's repo [here](https://github.com/leanthebean/puzzle-hunt). However, it brings some of the tooling up to date by using Hardhat, newer versions of node etc.

Just like Elena's, the puzzle to solve is _"what x and y add up to x * y + 4 == 10"_.

For this we will be using Zokrates for its high level language for writing zkSNARKs. It means we can write the inputs/outputs/assertions in a way that's a bit more familiar!

# Installation

## Setting up the JavaScript

Run `yarn` in the terminal in root. You can use npm if you wish.

## Setting up ZoKrates

If you have ZoKrates already installed globally you can skip this setp, but I prefer using Docker to avoid polluting my global OS. The following pulls down the latest Zokrates image (which is currently at 0.7.7 at time of writing), maps this directory to the `code` directory in the container and opens up a terminal.

```bash
yarn zokrates:run
```

# What are all these files?

## zk stuff

- `addToTen.zok` is the program that represents the ZKP using the ZoKrates DSL (`x * y + 4 = 10`)
- `abi.json` is the Application Binary Interface for the program (created by `zokrates compile`)
- `out` is the program (created by `zokrates compile`)
- `out.ztf` is the human-readable version program (created by `zokrates compile`)
- `witness` is the witness (created by `zokrates compute-witness`)
- `proof.json` is the proof based on our witness (`zokrates generate-proof`)
- `verifier.sol` is smart contract (`zokrates export-verifier`)


# Working on the project

## Compiling the program and contract

To compile the ZoKrates program (the `--ztf` option adds a human readable output too)

```bash
zokrates compile --ztf -i addToTen.zok
```

To compute the witness (e.g. with x=2 and y=3)

```bash
zokrates compute-witness -a 2 3
```

To create the proving and verification keys:

```bash
zokrates setup
```

To export the verifier

```bash
zokrates export-verifier -o ../contracts/verifier.sol 
```

## Generating a proof for our answer

E.g. for a correct answer

```bash
zokrates compute-witness -a 2 3
```


To run tests

```bash
yarn contracts:test
```
