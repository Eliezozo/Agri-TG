// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ReportAnchor is Ownable {
    mapping(string => bytes32) public reports; // month => pdfHash

    event ReportAnchored(string month, bytes32 pdfHash);

    constructor() Ownable(msg.sender) {}

    function anchorReport(string memory month, bytes32 pdfHash) external onlyOwner {
        reports[month] = pdfHash;
        emit ReportAnchored(month, pdfHash);
    }

    function verifyReport(string memory month, bytes32 pdfHash) external view returns (bool) {
        return reports[month] == pdfHash;
    }
}
