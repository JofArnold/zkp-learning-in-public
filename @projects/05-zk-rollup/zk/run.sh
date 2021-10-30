#!/bin/bash
set -e

helpFunction() {
  echo ""
  echo "Usage: $0 -c my_circuit -m=ptau"
  echo -e "\t-c Name of circuit - e.g. 'my_circuit'. Much also match the directory name"
  echo -e "\t-m Mode - 'compile' or 'ptau'"
  exit 1 # Exit script after printing help
}

while getopts "c:m:" opt; do
  case "$opt" in
  d) circuitName="$OPTARG" ;;
  m) mode="$OPTARG" ;;
  ?) helpFunction ;; # Print helpFunction in case parameter is non-existent
  esac
done

# Print helpFunction in case parameters are empty
if [ -z "$circuitName" ] || [ -z "$mode" ]; then
  echo "Some or all of the parameters are empty"
  helpFunction
fi

if [ "$mode" != "compile" ] && [ "$mode" != "ptau" ]; then
  echo "Mode is not 'compile' or 'ptau'"
  helpFunction
fi

CIRCUIT_DIR=$circuitName

cd "$CIRCUIT_DIR"

# --------------------------------------------------------------------------------
# Phase 1
# ... non-circuit-specific stuff
if [ "$mode" == "ptau" ]; then
  echo "Running powers of tau ceremony for circuit '${circuitName}'"
  # Starts Powers Of Tau ceremony, creating the file pot12_0000.ptau
  yarn snarkjs powersoftau new bn128 12 gpot12_0000.ptau -v

  # Contribute to ceremony a few times...
  # As we want this to be non-interactive we'll just write something random-ish for entropy
  yarn snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v -e="$(head -n 4096 /dev/urandom | openssl sha1)"
  yarn snarkjs powersoftau contribute pot12_0001.ptau pot12_0002.ptau --name="Second contribution" -v -e="$(head -n 4096 /dev/urandom | openssl sha1)"
  yarn snarkjs powersoftau contribute pot12_0002.ptau pot12_0003.ptau --name="Third contribution" -v -e="$(head -n 4096 /dev/urandom | openssl sha1)"

  # Verify
  yarn snarkjs powersoftau verify pot12_0003.ptau

  # Apply random beacon to finalised this phase of the setup.
  yarn snarkjs powersoftau beacon pot12_0003.ptau pot12_beacon.ptau 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon"

  # Prepare phase 2...
  # Under the hood, the prepare phase2 command calculates the encrypted evaluation of the Lagrange polynomials at tau for
  # tau, alpha*tau and beta*tau. It takes the beacon ptau file we generated in the previous step, and outputs a final pta
  # file which will be used to generate the circuit proving and verification keys.
  yarn snarkjs powersoftau prepare phase2 pot12_beacon.ptau pot12_final.ptau -v

  # Verify the final ptau file. Creates the file pot12_final.ptau
  yarn snarkjs powersoftau verify pot12_final.ptau
  exit 0
fi

# --------------------------------------------------------------------------------
# Phase 2
# ... circuit-specific stuff

if [ "$mode" == "compile" ]; then
  echo "Compiling circuit '${circuitName}', generating witness etc"

  # Compile the circuit. Creates the files:
  # - circuit.r1cs: the r1cs constraint system of the circuit in binary format
  # - "${circuitName}_js folder: wasm and witness tools
  # - circuit.sym: a symbols file required for debugging and printing the constraint system in an annotated mode
  ./circom circuit.circom --r1cs --wasm  --sym

  # Optional - view circuit state info
  # yarn snarkjs r1cs info circuit.r1cs

  # Optional - print the constraints
  # yarn snarkjs r1cs print circuit.r1cs zk/circuit.sym

  # Optional - export the r1cs
  # yarn snarkjs r1cs export json circuit.r1cs circuit.r1cs.json && cat circuit.r1cs.json
  # or...
  # yarn zk:export-r1cs

  # Generate witness
  node "./${circuitName}_js/generate_witness.js" "./${circuitName}_js/circuit.wasm" input.json witness.wtns


  # Setup (use plonk so we can skip ptau phase 2
  yarn snarkjs groth16 setup circuit.r1cs gpot12_final.ptau "${circuitName}_final.zkey"

  # Generate reference zkey
  yarn snarkjs zkey new circuit.r1cs gpot12_final.ptau "${circuitName}_0000.zkey"

  # Ceremony just like before but for zkey this time
  yarn snarkjs zkey contribute "${circuitName}_0000.zkey" "${circuitName}_0001.zkey" --name="First contribution" -v -e="$(head -n 4096 /dev/urandom | openssl sha1)"
  yarn snarkjs zkey contribute "${circuitName}_0001.zkey" "${circuitName}_0002.zkey" --name="Second contribution" -v -e="$(head -n 4096 /dev/urandom | openssl sha1)"
  yarn snarkjs zkey contribute "${circuitName}_0002.zkey" "${circuitName}_0003.zkey" --name="Third contribution" -v -e="$(head -n 4096 /dev/urandom | openssl sha1)"

  #  Verify zkey
   yarn snarkjs zkey verify circuit.r1cs gpot12_final.ptau "${circuitName}_0003.zkey"

  # Apply random beacon as before
  yarn snarkjs zkey beacon "${circuitName}_0003.zkey" "${circuitName}_final.zkey" 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon phase2"

  # Optional: verify final zkey
  yarn snarkjs zkey verify "${circuitName}.r1cs" gpot12_final.ptau "${circuitName}_final.zkey"

  # Export verification key
  yarn snarkjs zkey export verificationkey "${circuitName}_final.zkey" verification_key.json

  # Create the proof
  yarn snarkjs groth16 prove "${circuitName}_final.zkey" witness.wtns proof.json public.json

  # Verify the proof
  yarn snarkjs groth16 verify verification_key.json public.json proof.json

  # Export the verifier as a smart contract
  yarn snarkjs zkey export solidityverifier "${circuitName}_final.zkey" "../contracts/${circuitName}/verifier.sol"

fi
