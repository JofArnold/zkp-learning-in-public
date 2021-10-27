# About

Projects uses Circom 2.0, PLONKs, circomlib, snarkjs, ethers.


You will need to install Circom somehow and modify the scripts accordingly. Have the binary in ./bin/circom as I don't install circom globally.

## Commands

- `yarn zk:ptau` - run the first part of the Powers of Tau ceremony. Only has to be ran once
- `yarn zk:compile` - compiles the circuit and generates a solidity validator
- `yarn contracts:test` - tests the contracts (subset of tests used in Project 02)
