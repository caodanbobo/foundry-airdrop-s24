// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import {Test, console} from "forge-std/Test.sol";
import {MerkleAirdrop} from "src/MerkleAirdrop.sol";
import {RiceToken} from "src/RiceToken.sol";
import {ZkSyncChainChecker} from "lib/foundry-devops/src/ZkSyncChainChecker.sol";
import {DeployeMerkleAirdrop} from "script/DeployMerkleAirdrop.s.sol";

contract MerkleAirdropTest is Test, ZkSyncChainChecker {
    MerkleAirdrop public airDrop;
    RiceToken public token;

    uint256 public constant AMOUNT = 25 ether;
    bytes32[] public PROOF;

    bytes32 public constant ROOT =
        0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    address user;
    address gasPayer;
    uint256 userPrivateKey;

    function setUp() external {
        if (!isZkSyncChain()) {
            DeployeMerkleAirdrop deployer = new DeployeMerkleAirdrop();
            (airDrop, token) = deployer.run();
        } else {
            token = new RiceToken();
            airDrop = new MerkleAirdrop(ROOT, token);
            token.mint(token.owner(), 4 * AMOUNT);
            token.transfer(address(airDrop), 4 * AMOUNT);
        }

        (user, userPrivateKey) = makeAddrAndKey("user");
        gasPayer = makeAddr("gaspayer");
        PROOF.push(
            0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a
        );
        PROOF.push(
            0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576
        );
    }

    function testUsersCanClaim() public {
        uint256 startingBalance = token.balanceOf(user);
        assertEq(startingBalance, 0);
        bytes32 digest = airDrop.getMessageHash(user, AMOUNT);
        //sign a message
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(userPrivateKey, digest);

        vm.prank(gasPayer);
        airDrop.claim(user, AMOUNT, PROOF, v, r, s);

        uint256 endingBalance = token.balanceOf(user);
        assertEq(endingBalance, AMOUNT);
    }
}
