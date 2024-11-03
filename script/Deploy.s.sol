// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/GovernanceToken.sol";
import "../src/MyDao.sol";
import "../src/Treasury.sol";

contract DeployScript is Script {
    function run() external {
        // Start broadcasting transactions to the blockchain
        vm.startBroadcast();

        // Step 1: Deploy the Governance Token
        GovernanceToken governanceToken = new GovernanceToken();
        console.log("GovernanceToken deployed at:", address(governanceToken));

        // Step 2: Deploy the DAO contract, passing in the GovernanceToken address
        MyDao dao = new MyDao(address(governanceToken));
        console.log("DAO deployed at:", address(dao));

        // Step 3: Deploy the Treasury contract, passing in the DAO address for fund management
        Treasury treasury = new Treasury(address(dao));
        console.log("Treasury deployed at:", address(treasury));

        // Stop broadcasting transactions
        vm.stopBroadcast();
    }
}
