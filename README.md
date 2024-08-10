## Decription

This is a solidity contract project using foundry, and it is based on cyfrin updraft foundry tutorial.

## Concepts

### Airdrop

Users can claim 'Rice Token' if their accounts is a part of the merkle tree.
In other words, users can register on airdrop project, and once the airdorp is ready, the registed users can claim tokens.

### Merkle Tree

Merkle Tree is a data structure allows efficient and secure verification of the contents of a large data structure.

it is a tree structure, and each leaf is a data block, and every non-leaf node is the hash of its child nodes.

- construct a merkle tree: We'll iteratively hash pairs of nodes to construct the tree.

```
          Root
        /       \
   Node 0      Node 1
   /    \      /    \
N0.0  N0.1  N1.0  N1.1
/ \   / \   / \   / \
L0 L1 L2 L3 L4 L5 L6 L7

//N0.0 = hash(hash(l0)+hash(l1))
```

- Merkle Proof for L0
  1. Hash of L1 (the sibling of L0)
  2. Hash of N0.1 (the sibling of the parent of L0, which is N0.0)
  3. Hash of Node 1 (the sibling of the parent of N0.0, which is Node 0)
- Verifying the Proof
  1. Start with the leaf node (L0) and its sibling (L1).
  2. Compute the hash of the pair to get N0.0: Hash(Hash(L0) + Hash(L1)).
  3. Combine with the sibling hash (N0.1) to get Node 0: Hash(Hash(N0.0) + Hash(N0.1)).
  4. Finally, combine with the sibling hash (Node 1) to get the root: Hash(Hash(Node 0) + Hash(Node 1)).

### Digital Signature

    A digital signature is a mathematical scheme for verifying the authenticity of digital messages or documents.

- how to create a signature
  1. Get the hash of the message
  2. sign the hash with private key
- how to very a signature (in solidity)
  1. get the digest(hash) of the messgae
  2. recover the digest with sender's public key to get the sender's address
  3. compare the result with sender's address
- what is 'r,s,v'?
  'r,s,v' is equivilent to signature. Signature is a bytes array which length is 65, the first 32 bytes are bytes32 'r', and next 32 bytes are bytes32 's', and the last is uint8 'v'.

### EIP-191, EIP-712

[EIP712 and EIP191 | Understanding Ethereum Signature Standards](https://www.cyfrin.io/blog/understanding-ethereum-signature-standards-eip-191-eip-712)
