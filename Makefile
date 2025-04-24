compile:
	@circom circuits/merkleProof.circom --r1cs --wasm --sym -o outputs/

setup-key:
	@wget https://storage.googleapis.com/zkevm/ptau/powersOfTau28_hez_final_10.ptau -O outputs/pot10.ptau

generate-key:
	@snarkjs groth16 setup outputs/merkleProof.r1cs outputs/pot10.ptau outputs/merkleProof.zkey && \
	snarkjs zkey export verificationkey outputs/merkleProof.zkey outputs/verification_key.json
