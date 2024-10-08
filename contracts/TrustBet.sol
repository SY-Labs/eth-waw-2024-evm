// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Bet.sol";

contract TrustBet is Ownable, Bet {
    constructor(
        uint256 _end,
        address stakingAddress
        ) Bet(stakingAddress) {
        end = _end;
    }

    function setOutcome(bool _outcome) public onlyOwner {
        stakePool = IStaking(stakingAddress).unstakeEth();
        if(_outcome) {
            outcome = 1;
        } else {
            outcome = -1;
        }
    }
}

