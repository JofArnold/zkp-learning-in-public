#!/bin/bash
set -e

helpFunction() {
  echo ""
  echo "Usage: $0 -c my_circuit -m ptau"
  echo -e "\t-c Name of circuit - e.g. 'my_circuit'. Much also match the directory name"
  echo -e "\t-m Mode - 'compile' or 'ptau'"
  exit 1 # Exit script after printing help
}

while getopts "c:m:" opt; do
  case "$opt" in
    c) circuitName="$OPTARG" ;;
    m) mode="$OPTARG" ;;
    ?) helpFunction ;; # Print helpFunction in case parameter is non-existent
  esac
done

CIRCUIT_DIR=".zk/${circuitName}"
PTAU_DIR=./zk/ptau

if [ "$mode" != "compile" ] && [ "$mode" != "ptau" ]; then
  echo "❌ 'Mode' must be 'circuit' or 'ptau'"
  helpFunction
fi

if [ "$mode" == "compile" ] && [ ! "${circuitName}" ]; then
  echo "❌ Compile mode must have a circuit name set"
  helpFunction
fi

if [ "$mode" == "compile" ] && [ ! -d "${CIRCUIT_DIR}" ]; then
  echo "⚠️ Circuit directory '${CIRCUIT_DIR}' does not exist. Creating directory."
  mkdir "${CIRCUIT_DIR}"
fi

if [ "$mode" == "ptau" ] && [ ! -d "${PTAU_DIR}" ]; then
  echo "⚠️ Circuit directory '${PTAU_DIR}' does not exist. Creating directory."
  mkdir "${PTAU_DIR}"
fi

ptau0="${PTAU_DIR}/pot12_0000.ptau"
ptau1="${PTAU_DIR}/pot12_0001.ptau"
ptau2="${PTAU_DIR}/pot12_0002.ptau"
ptau3="${PTAU_DIR}/pot12_0003.ptau"
ptau_beacon="${PTAU_DIR}/pot12_final.ptau"
ptau_final="${PTAU_DIR}/pot12_final.ptau"

# --------------------------------------------------------------------------------
# Phase 1
# ... non-circuit-specific stuff
if [ "$mode" == "ptau" ]; then
  echo "Running powers of tau ceremony for circuit"
  # Starts Powers Of Tau ceremony, creating the file "${ptau0}"
  yarn snarkjs powersoftau new bn128 12 "${ptau0}" -v



  # Contribute to ceremony a few times...
  # As we want this to be non-interactive we'll just write something random-ish for entropy
  yarn snarkjs powersoftau contribute "${ptau0}" "${ptau1}" --name="First contribution" -v -e="$(head -n 4096 /dev/urandom | openssl sha1)"
  yarn snarkjs powersoftau contribute "${ptau1}" "${ptau2}" --name="Second contribution" -v -e="$(head -n 4096 /dev/urandom | openssl sha1)"
  yarn snarkjs powersoftau contribute "${ptau2}" "${ptau3}" --name="Third contribution" -v -e="$(head -n 4096 /dev/urandom | openssl sha1)"

  # Verify
  yarn snarkjs powersoftau verify "${ptau3}"

  # Apply random beacon to finalised this phase of the setup.
  yarn snarkjs powersoftau beacon "${ptau3}" "${ptau_beacon}" 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon"

  # Prepare phase 2...
  # Under the hood, the prepare phase2 command calculates the encrypted evaluation of the Lagrange polynomials at tau for
  # tau, alpha*tau and beta*tau. It takes the beacon ptau file we generated in the previous step, and outputs a final pta
  # file which will be used to generate the circuit proving and verification keys.
  yarn snarkjs powersoftau prepare phase2 "${ptau_beacon}" "${ptau_final}" -v

  # Verify the final ptau file. Creates the file "${ptau_final}"
  yarn snarkjs powersoftau verify "${ptau_final}"
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
  (cd && "${PTAU_DIR}/${circuitName}"./circom circuit.circom --r1cs --wasm  --sym)

  # Optional - view circuit state info
  # yarn snarkjs r1cs info circuit.r1cs

  # Optional - print the constraints
  # yarn snarkjs r1cs print circuit.r1cs zk/circuit.sym

  # Optional - export the r1cs
  # yarn snarkjs r1cs export json circuit.r1cs circuit.r1cs.json && cat circuit.r1cs.json
  # or...
  # yarn zk:export-r1cs

  # Generate witness
  node "${CIRCUIT_DIR}/${circuitName}_js/generate_witness.js" "${CIRCUIT_DIR}/${circuitName}_js/circuit.wasm" "${CIRCUIT_DIR}/${circuitName}/input.json" "${CIRCUIT_DIR}/${circuitName}/witness.wtns"


  # Setup (use plonk so we can skip ptau phase 2
  yarn snarkjs groth16 setup circuit.r1cs "${ptau_final}" "${ptau_final}"

  # Generate reference zkey
  yarn snarkjs zkey new circuit.r1cs "${ptau_final}" "${ptau0}"

  # Ceremony just like before but for zkey this time
  yarn snarkjs zkey contribute "${ptau0}" "${ptau1}" --name="First contribution" -v -e="$(head -n 4096 /dev/urandom | openssl sha1)"
  yarn snarkjs zkey contribute "${ptau1}" "${ptau2}" --name="Second contribution" -v -e="$(head -n 4096 /dev/urandom | openssl sha1)"
  yarn snarkjs zkey contribute "${ptau2}" "${ptau3}" --name="Third contribution" -v -e="$(head -n 4096 /dev/urandom | openssl sha1)"

  #  Verify zkey
   yarn snarkjs zkey verify circuit.r1cs "${ptau_final}" "${ptau3}"

  # Apply random beacon as before
  yarn snarkjs zkey beacon "${ptau3}" "${ptau_final}" 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon phase2"

  # Optional: verify final zkey
  yarn snarkjs zkey verify "${CIRCUIT_DIR}/${circuitName}.r1cs" "${ptau_final}" "${ptau_final}"

  # Export verification key
  yarn snarkjs zkey export verificationkey "${ptau_final}" "${CIRCUIT_DIR}/verification_key.json"

  # Create the proof
  yarn snarkjs groth16 prove "${ptau_final}" "${CIRCUIT_DIR}/witness.wtns" "${CIRCUIT_DIR}/proof.json" "${CIRCUIT_DIR}/public.json"

  # Verify the proof
  yarn snarkjs groth16 verify "${CIRCUIT_DIR}/verification_key.json" "${CIRCUIT_DIR}/public.json" "${CIRCUIT_DIR}/proof.json"

  # Export the verifier as a smart contract
  yarn snarkjs zkey export solidityverifier "${ptau_final}" "../contracts/${circuitName}/verifier.sol"

fi
