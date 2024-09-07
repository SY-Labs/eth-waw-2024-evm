// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract MockStakingETH is Ownable {
    mapping(address => uint256) public stakedBalances;

    error AmountMustBeGreaterThanZero();
    error NoETHStaked();
    error InsufficientContractBalance();

    event EthStaked(address indexed user, uint256 amount);
    event EthUnstaked(address indexed user, uint256 amount);

    constructor() Ownable(msg.sender) {}

    function stakeEth() external payable {
        if (msg.value == 0) {
            revert AmountMustBeGreaterThanZero();
        }

        stakedBalances[msg.sender] += msg.value;
        emit EthStaked(msg.sender, msg.value);
    }

    function unstakeEth() external {
        uint256 stakedAmount = stakedBalances[msg.sender];
        if (stakedAmount == 0) {
            revert NoETHStaked();
        }

        uint256 amountToTransfer = stakedAmount + (stakedAmount * 20 / 100);

        stakedBalances[msg.sender] = 0;

        if (address(this).balance < amountToTransfer) {
            revert InsufficientContractBalance();
        }

        payable(msg.sender).transfer(amountToTransfer);

        emit EthUnstaked(msg.sender, amountToTransfer);
    }

    function fundContract() external payable onlyOwner {
    }

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    receive() external payable {}
}