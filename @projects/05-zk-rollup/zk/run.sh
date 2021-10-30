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

CIRCUIT_DIR="./zk/${circuitName}"
PTAU_DIR="./zk/ptau"
CONTRACT_DIR="./contracts/${circuitName}"

if [ "$mode" != "compile" ] && [ "$mode" != "ptau" ]; then
  echo "❌ 'Mode' must be 'circuit' or 'ptau'"
  helpFunction
fi

if [ "$mode" == "compile" ] && [ ! "${circuitName}" ]; then
  echo "❌ Compile mode must have a circuit name set"
  helpFunction
fi

if [ "$mode" == "compile" ] && [ ! -d "${CIRCUIT_DIR}" ]; then
  echo "❌ Circuit directory '${CIRCUIT_DIR}' does not exist."
  exit 1;
fi

if [ "$mode" == "ptau" ] && [ ! -d "${PTAU_DIR}" ]; then
  echo "⚠️ Circuit directory '${PTAU_DIR}' does not exist. Creating directory."
  mkdir "${PTAU_DIR}"
fi

# Ptau artefacts
PTAU_FILE_0="${PTAU_DIR}/pot12_0000.ptau"
PTAU_FILE_1="${PTAU_DIR}/pot12_0001.ptau"
PTAU_FILE_2="${PTAU_DIR}/pot12_0002.ptau"
PTAU_FILE_3="${PTAU_DIR}/pot12_0003.ptau"
PTAU_BEACON_FILE="${PTAU_DIR}/pot12_beacon.ptau"
PTAU_FINAL_FILE="${PTAU_DIR}/pot12_final.ptau"

INPUT_FILE="${CIRCUIT_DIR}/input.json"
# Phase 2 artefacts
R1CS_FILE="${CIRCUIT_DIR}/circuit.r1cs"
wtns_file="${CIRCUIT_DIR}/witness.wtns"
VERIFICATION_KEY_FILE="${CIRCUIT_DIR}/verification_key.json"
PROOF_FILE="${CIRCUIT_DIR}/proof.json"
PUBLIC_FILE="${CIRCUIT_DIR}/public.json"

KEY_FILE_0="${CIRCUIT_DIR}/circuit_0000.key"
KEY_FILE_1="${CIRCUIT_DIR}/circuit_0001.key"
KEY_FILE_2="${CIRCUIT_DIR}/circuit_0002.key"
KEY_FILE_3="${CIRCUIT_DIR}/circuit_0003.key"
KEY_FINAL_FILE="${CIRCUIT_DIR}/circuit_final.key"

# JS artefacts
WASM_FILE="${CIRCUIT_DIR}/circuit_js/circuit.wasm"

# --------------------------------------------------------------------------------
# Phase 1
# ... non-circuit-specific stuff
if [ "$mode" == "ptau" ]; then
  echo "Running powers of tau ceremony for circuit"
  # Starts Powers Of Tau ceremony, creating the file "${PTAU_FILE_0}"
  yarn snarkjs powersoftau new bn128 12 "${PTAU_FILE_0}" -v



  # Contribute to ceremony a few times...
  # As we want this to be non-interactive we'll just write something random-ish for entropy
  yarn snarkjs powersoftau contribute "${PTAU_FILE_0}" "${PTAU_FILE_1}" --name="First contribution" -v -e="$(head -n 4096 /dev/urandom | openssl sha1)"
  yarn snarkjs powersoftau contribute "${PTAU_FILE_1}" "${PTAU_FILE_2}" --name="Second contribution" -v -e="$(head -n 4096 /dev/urandom | openssl sha1)"
  yarn snarkjs powersoftau contribute "${PTAU_FILE_2}" "${PTAU_FILE_3}" --name="Third contribution" -v -e="$(head -n 4096 /dev/urandom | openssl sha1)"

  # Verify
  yarn snarkjs powersoftau verify "${PTAU_FILE_3}"

  # Apply random beacon to finalised this phase of the setup.
  yarn snarkjs powersoftau beacon "${PTAU_FILE_3}" "${PTAU_BEACON_FILE}" 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon"

  # Prepare phase 2...
  # Under the hood, the prepare phase2 command calculates the encrypted evaluation of the Lagrange polynomials at tau for
  # tau, alpha*tau and beta*tau. It takes the beacon ptau file we generated in the previous step, and outputs a final pta
  # file which will be used to generate the circuit proving and verification keys.
  yarn snarkjs powersoftau prepare phase2 "${PTAU_BEACON_FILE}" "${PTAU_FINAL_FILE}" -v

  # Verify the final ptau file. Creates the file "${PTAU_FINAL_FILE}"
  yarn snarkjs powersoftau verify "${PTAU_FINAL_FILE}"
  exit 0
fi

# --------------------------------------------------------------------------------
# Phase 2
# ... circuit-specific stuff

if [ "$mode" == "compile" ]; then
  echo "Compiling circuit '${circuitName}', generating witness etc"

  # Compile the circuit. Creates the files:
  # - circuit.r1cs: the r1cs constraint system of the circuit in binary format
  # - "${circuitName}_js folder: wasm_file and witness tools
  # - circuit.sym: a symbols file required for debugging and printing the constraint system in an annotated mode
  (cd "${CIRCUIT_DIR}" && ./circom --r1cs --wasm  --sym)

  # Optional - view circuit state info
  # yarn snarkjs r1cs info circuit.r1cs

  # Optional - print the constraints
  # yarn snarkjs r1cs print circuit.r1cs zk/circuit.sym

  # Optional - export the r1cs
  # yarn snarkjs r1cs export json circuit.r1cs circuit.r1cs.json && cat circuit.r1cs.json
  # or...
  # yarn zk:export-r1cs

  # Generate witness
  node "${CIRCUIT_DIR}/circuit_js/generate_witness.js" "${WASM_FILE}" "${INPUT_FILE}" "${wtns_file}"


  # Setup (use plonk so we can skip ptau phase 2
  yarn snarkjs groth16 setup "${R1CS_FILE}" "${PTAU_FINAL_FILE}" "${KEY_FINAL_FILE}"

  # Generate reference zkey
  yarn snarkjs zkey new "${R1CS_FILE}" "${PTAU_FINAL_FILE}" "${KEY_FILE_0}"

  # Ceremony just like before but for zkey this time
  yarn snarkjs zkey contribute "${KEY_FILE_0}" "${KEY_FILE_1}" --name="First contribution" -v -e="$(head -n 4096 /dev/urandom | openssl sha1)"
  yarn snarkjs zkey contribute "${KEY_FILE_1}" "${KEY_FILE_2}" --name="Second contribution" -v -e="$(head -n 4096 /dev/urandom | openssl sha1)"
  yarn snarkjs zkey contribute "${KEY_FILE_2}" "${KEY_FILE_3}" --name="Third contribution" -v -e="$(head -n 4096 /dev/urandom | openssl sha1)"

  #  Verify zkey
   yarn snarkjs zkey verify "${R1CS_FILE}" "${PTAU_FINAL_FILE}" "${KEY_FILE_3}"

  # Apply random beacon as before
  yarn snarkjs zkey beacon "${KEY_FILE_3}" "${KEY_FINAL_FILE}" 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon phase2"

  # Optional: verify final zkey
  yarn snarkjs zkey verify "${R1CS_FILE}" "${PTAU_FINAL_FILE}" "${KEY_FINAL_FILE}"

  # Export verification key
  yarn snarkjs zkey export verificationkey "${KEY_FINAL_FILE}" "${VERIFICATION_KEY_FILE}"

  # Create the proof
  yarn snarkjs groth16 prove "${KEY_FINAL_FILE}" "${wtns_file}" "${PROOF_FILE}" "${PUBLIC_FILE}"

  # Verify the proof
  yarn snarkjs groth16 verify "${VERIFICATION_KEY_FILE}" "${PUBLIC_FILE}" "${PROOF_FILE}"

  # Export the verifier as a smart contract
  yarn snarkjs zkey export solidityverifier "${KEY_FINAL_FILE}" "${CONTRACT_DIR}/verifier.sol"

fi
