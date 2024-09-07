// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract Bet is Ownable {
    int256 public outcome = 0;
    uint256 public end;
    mapping (address => int8) public bets;
    mapping (address => uint256) public stakes;
    mapping (address => bool) public claims;
    uint256 public yesPool;
    uint256 public noPool;
    // Clock control for hackathon
    uint256 public clock;

    function placeBet(bool _outcome) public payable {
        require(msg.value != 0, "No value im bet");
        require(bets[msg.sender] == 0, "Bet already placed");
        require(getClock() < end, "Passed the limit");

        if(_outcome) {
            bets[msg.sender] = 1;
            yesPool += msg.value;
        } else {
            bets[msg.sender] = -1;
            noPool += msg.value;
        }
        stakes[msg.sender] += msg.value;
    }

    function claim() public {
        require(outcome != 0, "Not finalized");
        require(bets[msg.sender] == outcome, "Did not win");
        require(claims[msg.sender] == false, "Already claimed");

        uint256 stake = stakes[msg.sender];
        payable (msg.sender).transfer(payout(stake));
        payable (msg.sender).transfer(stake);

        claims[msg.sender] = true;
    }

    function payout(uint256 bet) public view returns(uint256) {
        uint256 factor = 100000000;
        uint256 winningPool = outcome == 1 ? yesPool : noPool;
        require(bet <= winningPool, "Bet bigger than winning pool");
        uint256 losingPool = outcome == -1 ? noPool : yesPool;
        uint256 share = bet * factor / winningPool;
        return share * losingPool / factor;
    }

    function setClock(uint256 timestamp) public onlyOwner {
        clock = timestamp;
    }

    function getClock() public view returns(uint256) {
        if(clock == 0) {
            return block.timestamp;
        } else {
        return clock;
        }
    }
}