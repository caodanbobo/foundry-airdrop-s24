// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import {Script} from "forge-std/Script.sol";
import {MerkleAirdrop} from "src/MerkleAirdrop.sol";
import {RiceToken} from "src/RiceToken.sol";

contract DeployeMerkleAirdrop is Script {
    bytes32 public immutable i_merkleRoot =
        0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    uint256 private constant i_amountToTransfer = 4 * 25 ether;

    function run() external returns (MerkleAirdrop, RiceToken) {
        vm.startBroadcast();
        RiceToken token = new RiceToken();
        MerkleAirdrop airdrop = new MerkleAirdrop(i_merkleRoot, token);
        token.mint(token.owner(), i_amountToTransfer);
        token.transfer(address(airdrop), i_amountToTransfer);
        vm.stopBroadcast();
        return (airdrop, token);
    }
}
