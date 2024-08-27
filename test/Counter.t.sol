// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../script/deployNFT.s.sol";
import "../script/deployAccount.s.sol";
import "../script/deployRegistry.s.sol";
import "../src/interfaces/IERC6551Account.sol";
import "../src/interfaces/IERC6551Registry.sol";

contract ERC6551Test is Test {
    MyToken public myToken_;
    deployNftScript public deployNftScript_;
    deployAccountScript public deployAccountScript_;
    deployRegistryScript public deployRegistryScript_;
    address payable implementation;
    address registry;
    IERC6551Account public accountInstance;
    IERC6551Registry public registryInstance;

    address public user = vm.envAddress("USER");

    function setUp() public {
        testNFTDeployment();
        testAccountDeployment();
        testRegistryDeployment();

        // Create instances of the contracts
        accountInstance = IERC6551Account(implementation);
        registryInstance = IERC6551Registry(registry);
    }

    function testNFTDeployment() public {
        vm.startPrank(user);
        deployNftScript_ = new deployNftScript();

        address deployedAddress = deployNftScript_.deployNftContract();

        myToken_ = MyToken(deployedAddress);
        assertEq(myToken_.owner(), user, "Owner should be the user address");

        assertTrue(
            address(myToken_) != address(0),
            "Deployed contract address should not be zero"
        );
        console.log("NFT contract deployed to: ", deployedAddress);
        vm.stopPrank();
    }

    function testAccountDeployment() public {
        vm.startPrank(user);
        deployAccountScript_ = new deployAccountScript();

        implementation = payable(deployAccountScript_.deployAccount());
        assertNotEq(
            implementation,
            address(0),
            "COntract not deployed, and implementation address not set"
        );
        console.log(
            "ERC6551 implementation contract deployed to: ",
            implementation
        );
        vm.stopPrank();
    }

    function testRegistryDeployment() public {
        vm.startPrank(user);
        deployRegistryScript_ = new deployRegistryScript();

        address deployedAddress = deployRegistryScript_.deployRegistry();
        registry = deployedAddress;
        assertNotEq(
            registry,
            address(0),
            "COntract not deployed, and registry address not set"
        );
        console.log("ERC6551 registry contract deployed to: ", registry);
        vm.stopPrank();
    }

    address public createdAccount;
    uint256 public constant TOKEN_ID = 0;

    function testCreateAccount() public {
        vm.startPrank(user);

        myToken_.safeMint(user);

        // Parameters for createAccount
        uint256 chainId = block.chainid;
        address tokenContract = address(myToken_);
        uint256 salt = 0;
        bytes memory initData = "";

        createdAccount = registryInstance.createAccount(
            implementation,
            chainId,
            tokenContract,
            TOKEN_ID,
            salt,
            initData
        );

        assertNotEq(createdAccount, address(0), "Account creation failed");
        console.log("New account created at: ", createdAccount);

        vm.stopPrank();
    }

    function testAccountFunctions() public {
        testCreateAccount();

        vm.startPrank(user);

        IERC6551Account newAccountInstance = IERC6551Account(
            payable(createdAccount)
        );

        // Test token function
        (
            uint256 chainId,
            address tokenContract,
            uint256 tokenId
        ) = newAccountInstance.token();
        assertEq(chainId, block.chainid, "Chain ID mismatch");
        assertEq(tokenContract, address(myToken_), "Token contract mismatch");
        assertEq(tokenId, TOKEN_ID, "Token ID mismatch");

        address owner = newAccountInstance.owner();
        console.log("the owner", owner);
        assertEq(owner, user, "Owner mismatch");

        vm.stopPrank();
    }

    function testAccountCreationAndFunctions() public {
        testCreateAccount();
        testAccountFunctions();
    }
}
