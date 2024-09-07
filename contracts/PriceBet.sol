// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@redstone-finance/evm-connector/contracts/data-services/MainDemoConsumerBase.sol";
import "./Bet.sol";

contract PriceBet is MainDemoConsumerBase, Bet {
    bytes32 symbol;
    uint256 public expected;

    constructor(
        bytes32 _symbol,
        uint256 _expected,
        uint256 _end,
        address stakingAddress
    ) Bet(stakingAddress) {
        symbol = _symbol;
        expected = _expected;
        end = _end;
    }
    
    function validateTimestamp(uint256 receivedTimestampMilliseconds) public view virtual override { }

    function finalize() external {
        require(outcome == 0, "Already finalized");
        require(end == extractTimestampsAndAssertAllAreEqual(), "Invalid timestamp");
        stakePool = IStaking(stakingAddress).unstakeEth();

        uint256 answer = getOracleNumericValueFromTxMsg(symbol);
        if(answer >= expected) {
            outcome = 1;
        } else {
            outcome = -1;
        }
    }
}
