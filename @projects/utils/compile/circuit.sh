#!/bin/bash
set -e

echoerr() {
  echo "$@" 1>&2
  exit 1
}

helpFunction() {
  echo ""
  echo "Usage: $0 -z path/to/circuit.circom -p path/to/ptau/dir -c path/to/contract/dir"
  exit 1 # Exit script after printing help
}

while getopts "z:p:c:" opt; do
  case "$opt" in
  z) CIRCUIT_FILE="$OPTARG" ;;
  p) PTAU_DIR="$OPTARG" ;;
  c) CONTRACT_DIR="$OPTARG" ;;
  ?) helpFunction ;; # Print helpFunction in case parameter is non-existent
  esac
done

#ROOT_DIR=$(pwd)
#CIRCUIT_DIR="${ROOT_DIR}/circuits/${circuitName}"
#PTAU_DIR="${ROOT_DIR}/circuits/ptau"
#CONTRACT_DIR="${ROOT_DIR}/contracts/${circuitName}"

#echo $mode
#echo $circuitName
if [ ! "${CIRCUIT_FILE}" ] || [ ! "${PTAU_DIR}" ] || [ ! "${CONTRACT_DIR}" ]; then
  echoerr "❌  All args must be set"
fi

if [ ! -f "${CIRCUIT_FILE}" ]; then
  echoerr "❌  Circuit file '${CIRCUIT_FILE}' does not exist"
fi

if [ ! -d "${PTAU_DIR}" ]; then
  echoerr "❌  Ptau directory '${PTAU_DIR}' does not exist"
fi

if [ ! -d "${CONTRACT_DIR}" ]; then
  echoerr "❌  Contract directory '${CONTRACT_DIR}' does not exist"
fi

CIRCUIT_DIR=$(dirname "${CIRCUIT_FILE}")

# Ptau artefacts
PTAU_FINAL_FILE="${PTAU_DIR}/pot12_final.ptau"

# Input for witness
INPUT_FILE="${CIRCUIT_DIR}/input.json"

## Phase 2 artefacts
R1CS_FILE="${CIRCUIT_DIR}/circuit.r1cs"
WTNS_FILE="${CIRCUIT_DIR}/witness.wtns"
VERIFICATION_KEY_FILE="${CIRCUIT_DIR}/verification_key.json"
PROOF_FILE="${CIRCUIT_DIR}/proof.json"
PUBLIC_FILE="${CIRCUIT_DIR}/public.json"
#
KEY_FILE_0="${CIRCUIT_DIR}/circuit_0000.key"
KEY_FILE_1="${CIRCUIT_DIR}/circuit_0001.key"
KEY_FILE_2="${CIRCUIT_DIR}/circuit_0002.key"
KEY_FILE_3="${CIRCUIT_DIR}/circuit_0003.key"
KEY_FINAL_FILE="${CIRCUIT_DIR}/circuit_final.key"
#
## JS artefacts
WASM_FILE="${CIRCUIT_DIR}/circuit_js/circuit.wasm"

# Compile the circuit. Creates the files:
# - circuit.r1cs: the r1cs constraint system of the circuit in binary format
# - "${circuitName}_js folder: wasm_file and witness tools
# - circuit.sym: a symbols file required for debugging and printing the constraint system in an annotated mode
circom --r1cs --wasm --sym --output "${CIRCUIT_DIR}" "${CIRCUIT_FILE}"

# Optional - view circuit state info
# yarn snarkjs r1cs info circuit.r1cs

# Optional - print the constraints
# yarn snarkjs r1cs print circuit.r1cs zk/circuit.sym

# Optional - export the r1cs
# yarn snarkjs r1cs export json circuit.r1cs circuit.r1cs.json && cat circuit.r1cs.json
# or...
# yarn zk:export-r1cs

# Generate witness
node "${CIRCUIT_DIR}/circuit_js/generate_witness.js" "${WASM_FILE}" "${INPUT_FILE}" "${WTNS_FILE}"

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
yarn snarkjs groth16 prove "${KEY_FINAL_FILE}" "${WTNS_FILE}" "${PROOF_FILE}" "${PUBLIC_FILE}"

# Verify the proof
yarn snarkjs groth16 verify "${VERIFICATION_KEY_FILE}" "${PUBLIC_FILE}" "${PROOF_FILE}"

# Export the verifier as a smart contract
yarn snarkjs zkey export solidityverifier "${KEY_FINAL_FILE}" "${CONTRACT_DIR}/verifier.sol"
