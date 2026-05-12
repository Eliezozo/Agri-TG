// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CoopLedger is Ownable {
    struct Transaction {
        string typeTx; // I will use typeTx to avoid collision with reserved keyword 'type'
        uint256 montant;
        address membre;
        uint256 date;
        string description;
    }

    mapping(uint256 => Transaction) public transactions;
    
    event TransactionRecorded(
        uint256 indexed id,
        string typeTx,
        uint256 montant,
        address indexed membre,
        uint256 date,
        string description
    );

    constructor() Ownable(msg.sender) {}

    function recordTransaction(
        uint256 id,
        string memory _type,
        uint256 _montant,
        address _membre,
        uint256 _date,
        string memory _description
    ) external onlyOwner {
        transactions[id] = Transaction(_type, _montant, _membre, _date, _description);
        emit TransactionRecorded(id, _type, _montant, _membre, _date, _description);
    }

    function getTransaction(uint256 id) external view returns (
        string memory _type,
        uint256 _montant,
        address _membre,
        uint256 _date,
        string memory _description
    ) {
        Transaction memory txn = transactions[id];
        return (txn.typeTx, txn.montant, txn.membre, txn.date, txn.description);
    }
}
