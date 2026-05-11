// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CoopLedger is Ownable {
    struct Transaction {
        string txType;
        uint256 amount;
        address member;
        uint256 date;
        string description;
    }

    mapping(uint256 => Transaction) public transactions;
    
    event TransactionRecorded(
        uint256 indexed id,
        string txType,
        uint256 amount,
        address indexed member,
        uint256 date,
        string description
    );

    constructor() Ownable(msg.sender) {}

    function recordTransaction(
        uint256 id,
        string memory txType,
        uint256 amount,
        address member,
        uint256 date,
        string memory description
    ) external onlyOwner {
        transactions[id] = Transaction(txType, amount, member, date, description);
        emit TransactionRecorded(id, txType, amount, member, date, description);
    }

    function getTransaction(uint256 id) external view returns (
        string memory txType,
        uint256 amount,
        address member,
        uint256 date,
        string memory description
    ) {
        Transaction memory txn = transactions[id];
        return (txn.txType, txn.amount, txn.member, txn.date, txn.description);
    }
}
