// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/DAO.sol";
import "../src/GovernanceToken.sol";

contract DAOTest is Test {
    DAO private dao;
    GovernanceToken private governanceToken;
    address private voter = address(0x123);

    function setUp() public {
        governanceToken = new GovernanceToken();
        dao = new DAO(governanceToken);

        // Allocate tokens to a test account
        vm.prank(address(this));
        governanceToken.transfer(voter, 1000 * 10 ** governanceToken.decimals());
    }

    function testCreateProposal() public {
        dao.createProposal("Increase treasury allocation");
        (,,string memory description,,,) = dao.proposals(1);
        assertEq(description, "Increase treasury allocation");
    }

    function testVoteOnProposal() public {
        dao.createProposal("Launch new project");
        
        vm.prank(voter);
        dao.vote(1);
        
        (,uint256 voteCount,,,) = dao.proposals(1);
        assertGt(voteCount, 0);
    }

    function testExecuteProposal() public {
        dao.createProposal("Allocate funds for marketing");

        vm.prank(voter);
        dao.vote(1);

        vm.roll(block.number + 10001); // Fast-forward past voting period
        dao.executeProposal(1);
        
        // Use the getter to check proposal status
        DAO.ProposalStatus status = dao.getProposalStatus(1);
        assertEq(uint256(status), uint256(DAO.ProposalStatus.Executed));
    }
}
