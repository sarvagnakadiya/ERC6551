// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/ERC6551Registry.sol";

contract deployRegistryScript is Script {
    function deployRegistry() public returns (address) {
        ERC6551Registry registry = new ERC6551Registry();
        return address(registry);
    }

    function run() external {
        vm.startBroadcast();
        address deployedContract = deployRegistry();
        vm.stopBroadcast();
        console.log(
            "registry contract of ERC6551 deployed to:",
            address(deployedContract)
        );
    }
}
