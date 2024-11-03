// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Treasury {
    address public dao; // Reference to the DAO for permissions

    constructor(address _dao) {
        dao = _dao;
    }

    // Function for the DAO to fund projects
    function fundProject(address payable project, uint256 amount) external {
        require(msg.sender == dao, "Only DAO can fund projects");
        (bool success, ) = project.call{value: amount}("");
        require(success, "Funding failed");
    }

    // Function to receive ether
    receive() external payable {}
}
