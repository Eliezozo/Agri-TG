// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ReportAnchor is Ownable {
    mapping(string => bytes32) public month; // month => pdfHash

    event ReportAnchored(string month, bytes32 pdfHash);

    constructor() Ownable(msg.sender) {}

    function anchorReport(string memory _month, bytes32 pdfHash) external onlyOwner {
        month[_month] = pdfHash;
        emit ReportAnchored(_month, pdfHash);
    }

    function verifyReport(string memory _month, bytes32 pdfHash) external view returns (bool) {
        return month[_month] == pdfHash;
    }
}
