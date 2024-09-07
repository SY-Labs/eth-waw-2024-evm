// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@redstone-finance/evm-connector/contracts/data-services/MainDemoConsumerBase.sol";
import "./Bet.sol";

contract PriceBet is MainDemoConsumerBase, Bet {
    bytes32 symbol;
    uint256 public expected;
<<<<<<< Updated upstream
    uint256 public endLimit;
=======
<<<<<<< Updated upstream
    int256 public outcome = 0;
    uint256 public end;
    uint256 public endLimit;
    mapping (address => int8) public bets;
    mapping (address => uint256) public stakes;
    mapping (address => bool) public claims;
    uint256 public yesPool;
    uint256 public noPool;
=======
>>>>>>> Stashed changes
>>>>>>> Stashed changes

    constructor(
        bytes32 _symbol,
        uint256 _expected,
        uint256 _end
    ) {
        symbol = _symbol;
        expected = _expected;
        end = _end;
    }
    
    function validateTimestamp(uint256 receivedTimestampMilliseconds) public view virtual override { }

    function finalize() external {
        require(outcome == 0, "Already finalized");
        require(end == extractTimestampsAndAssertAllAreEqual(), "Invalid timestamp");

        uint256 answer = getOracleNumericValueFromTxMsg(symbol);
        if(answer >= expected) {
            outcome = 1;
        } else {
            outcome = -1;
        }
    }
}
