// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract VoteGovernance is Ownable {
    struct Vote {
        string title;
        string description;
        uint256 threshold;
        uint256 closingDate;
        bool status;
    }

    mapping(uint256 => Vote) public votes;
    mapping(uint256 => mapping(address => uint8)) public hasVoted; // voteId => address => choice
    mapping(uint256 => mapping(uint8 => uint256)) public voteCounts; // voteId => choice => count

    uint256 public nextVoteId;

    event VoteCreated(uint256 indexed voteId, string title, uint256 closingDate);
    event VoteCast(uint256 indexed voteId, address indexed voter, uint8 choice);
    event VoteFinalized(uint256 indexed voteId, bool passed);

    constructor() Ownable(msg.sender) {}

    function createVote(
        string memory title,
        string memory description,
        uint256 threshold,
        uint256 closingDate
    ) external onlyOwner {
        uint256 voteId = nextVoteId++;
        votes[voteId] = Vote({
            title: title,
            description: description,
            threshold: threshold,
            closingDate: closingDate,
            status: true // true = active, false = finalized
        });
        emit VoteCreated(voteId, title, closingDate);
    }

    function castVote(uint256 voteId, uint8 choice) external {
        require(votes[voteId].status == true, "Vote is not active");
        require(block.timestamp <= votes[voteId].closingDate, "Vote is closed");
        require(hasVoted[voteId][msg.sender] == 0, "Already voted");
        require(choice > 0, "Invalid choice, must be > 0");

        hasVoted[voteId][msg.sender] = choice;
        voteCounts[voteId][choice]++;

        emit VoteCast(voteId, msg.sender, choice);
    }

    function finalizeVote(uint256 voteId) external onlyOwner {
        require(votes[voteId].status == true, "Already finalized");
        require(block.timestamp > votes[voteId].closingDate, "Voting still open");
        
        votes[voteId].status = false;
        
        // Let's assume choice 1 is YES. If yes votes >= threshold, it passed.
        bool passed = voteCounts[voteId][1] >= votes[voteId].threshold;
        emit VoteFinalized(voteId, passed);
    }

    function getResults(uint256 voteId) external view returns (uint256 yesVotes, uint256 noVotes) {
        return (voteCounts[voteId][1], voteCounts[voteId][2]);
    }
}
