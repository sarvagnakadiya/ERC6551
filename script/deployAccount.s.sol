// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/ERC6551Account.sol";

contract deployAccountScript is Script {
    function deployAccount() public returns (address) {
        ERC6551Account acc = new ERC6551Account();
        return address(acc);
    }

    function run() external {
        vm.startBroadcast();
        address deployedContract = deployAccount();
        vm.stopBroadcast();
        console.log(
            "Implementation contract of ERC6551 Account deployed to:",
            address(deployedContract)
        );
    }
}
