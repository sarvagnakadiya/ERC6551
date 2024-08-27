// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/egNFT.sol";

contract deployNftScript is Script {
    address public USER = vm.envAddress("USER");

    function deployNftContract() public returns (address) {
        address initialOwner = USER;
        MyToken myToken = new MyToken(initialOwner);
        return address(myToken);
    }

    function run() external {
        vm.startBroadcast();
        address deployedContract = deployNftContract();
        vm.stopBroadcast();
        console.log(
            "example NFT contract deployed to:",
            address(deployedContract)
        );
    }
}
