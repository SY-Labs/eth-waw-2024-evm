// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract TrustBet is Ownable {
    int256 public outcome = 0;
    uint256 public end;
    uint256 public endLimit;
    mapping (address => int8) public bets;
    mapping (address => uint256) public stakes;
    mapping (address => bool) public claims;
    uint256 public yesPool;
    uint256 public noPool;

    constructor(uint256 _end) Ownable(msg.sender) {
        end = _end;
    }

    function setOutcome(bool _outcome) public onlyOwner {
        if(_outcome) {
            outcome = 1;
        } else {
            outcome = -1;
        }
    }
}

