// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract VoteGovernance is Ownable {
    struct Vote {
        string titre;
        string description;
        uint256 seuil;
        uint256 dateCloture;
        bool statut;
    }

    mapping(uint256 => Vote) public voteSessions;
    mapping(uint256 => mapping(address => uint8)) public votes; // voteId => member => choice
    mapping(uint256 => mapping(uint8 => uint256)) public voteCounts; // voteId => choice => count

    uint256 public nextVoteId;

    event VoteCast(uint256 indexed voteId, address indexed voter, uint8 choice);
    event VoteFinalized(uint256 indexed voteId, bool passed);

    constructor() Ownable(msg.sender) {}

    function createVote(
        string memory titre,
        string memory description,
        uint256 seuil,
        uint256 dateCloture
    ) external onlyOwner {
        uint256 voteId = nextVoteId++;
        voteSessions[voteId] = Vote({
            titre: titre,
            description: description,
            seuil: seuil,
            dateCloture: dateCloture,
            statut: true
        });
    }

    // Note: The prompt asks for castVote(voteId, choice) public.
    // But backend integration specifies castVote(voteId, choice, memberAddress).
    // To allow the backend to relay votes while respecting the "1 vote per address" rule:
    function castVote(uint256 voteId, uint8 choice, address memberAddress) external onlyOwner {
        require(voteSessions[voteId].statut == true, "Le vote n'est pas actif");
        require(block.timestamp <= voteSessions[voteId].dateCloture, "Le vote est clos");
        require(votes[voteId][memberAddress] == 0, "A deja vote");
        require(choice >= 1 && choice <= 3, "Choix invalide (1=Pour, 2=Contre, 3=Abstention)");

        votes[voteId][memberAddress] = choice;
        voteCounts[voteId][choice]++;

        emit VoteCast(voteId, memberAddress, choice);
    }

    function finalizeVote(uint256 voteId) external onlyOwner {
        require(voteSessions[voteId].statut == true, "Deja finalise");
        require(block.timestamp > voteSessions[voteId].dateCloture, "Vote encore ouvert");
        
        voteSessions[voteId].statut = false;
        
        bool passed = voteCounts[voteId][1] >= voteSessions[voteId].seuil;
        emit VoteFinalized(voteId, passed);
    }

    function getResults(uint256 voteId) external view returns (uint256 pour, uint256 contre, uint256 abstention) {
        return (voteCounts[voteId][1], voteCounts[voteId][2], voteCounts[voteId][3]);
    }
}
