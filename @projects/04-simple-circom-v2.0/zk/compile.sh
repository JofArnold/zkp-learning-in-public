#!/bin/zsh
set -e

# Check if input.json exists to define the inputs for your witness. If not, exist

if [[ ! -f input.json ]] ; then
    echo "You must have an input.json file for generating a witness"
    exit 1
fi

# --------------------------------------------------------------------------------
# Phase 2
# ... circuit-specific stuff

# Compile the circuit. Creates the files:
# - circuit.r1cs: the r1cs constraint system of the circuit in binary format
# - circuit_js folder: wasm and witness tools
# - circuit.sym: a symbols file required for debugging and printing the constraint system in an annotated mode
./circom circuit.circom --r1cs --wasm  --sym

# Optional - view circuit state info
# yarn snarkjs r1cs info ./zk/circuit.r1cs

# Optional - print the constraints
# yarn snarkjs r1cs print ./zk/circuit.r1cs zk/circuit.sym

# Optional - export the r1cs
# yarn snarkjs r1cs export json ./zk/circuit.r1cs ./zk/circuit.r1cs.json && cat circuit.r1cs.json

# Generate the witness
node ./circuit_js/generate_witness.js ./circuit_js/circuit.wasm input.json witness.wtns

# Setup (use plonk so we can skip ptau phase 2
yarn snarkjs plonk setup ./zk/circuit.r1cs ./zk/pot12_final.ptau ./zk/circuit_final.zkey

# Optional: verify final zkey
#yarn snarkjs plonk zkey verify ./zk/circuit.r1cs ./zk/pot12_final.ptau ./zk/circuit_final.zkey

# Export verification key
yarn snarkjs zkey export verificationkey ./zk/circuit_final.zkey ./zk/verification_key.json

# Create the proof
yarn snarkjs plonk prove ./zk/circuit_final.zkey ./zk/witness.wtns ./zk/proof.json ./zk/public.json

# Verify the proof
yarn snarkjs plonk verify ./zk/verification_key.json ./zk/public.json ./zk/proof.json

# Export the verifier as a smart contract
yarn snarkjs zkey export solidityverifier ./zk/circuit_final.zkey ./contracts/verifier.sol
