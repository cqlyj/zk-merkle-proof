pragma circom  2.0.0;

template MerkleProof(n) {

    // Declaration of signals.
    signal input leaf; // Precomputed hash of the transaction leaf
    signal input pathElements[n]; // Precomputed sibling hashes
    signal input pathIndices[n]; // 0 = left, 1 = right(Must be boolean)
    signal input root; // Precomputed hash of the Merkle root

    signal output isValid; // 1 if the proof is valid, 0 otherwise
    
    signal intermediateHashes[n + 1]; // Array to store intermediate hashes
    signal leftCombination[n]; // Array for left combination
    signal rightCombination[n]; // Array for right combination
    signal selectedLeft[n]; // Array for selected left branch
    signal selectedRight[n]; // Array for selected right branch 

    // Constraints.

    intermediateHashes[0] <== leaf; // Initialize with the leaf hash

    // Compute the root based on the path provided
    for(var i = 0; i < n; i++) {
        // Ensure pathIndices[i] is boolean
        pathIndices[i] * (1 - pathIndices[i]) === 0;

        // Compute both possible branches
        leftCombination[i] <== intermediateHashes[i] + pathElements[i]; // Left sibling
        rightCombination[i] <== intermediateHashes[i] + pathElements[i]; // Right sibling

        // Select the correct branch
        selectedLeft[i] <== leftCombination[i] * (1 - pathIndices[i]); // Use leftCombination if pathIndices[i] is 0
        selectedRight[i] <== rightCombination[i] * pathIndices[i]; // Use rightCombination if pathIndices[i] is 1

        // Update intermediate hash
        intermediateHashes[i + 1] <== selectedLeft[i] + selectedRight[i]; // Combine the selected branches
    }

    // Validate that the computed root matches the provided root
    signal difference;
    difference <== intermediateHashes[n] - root; // Difference between computed and provided root
    isValid <== 1 - difference * difference; // Set isValid to 1 if the difference is 0, otherwise 0
}

component main = MerkleProof(3);