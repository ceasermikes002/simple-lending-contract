// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Lending {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public loans;
    mapping(address => uint256) public collateral;

    uint256 public interestRate = 5; // 5% interest rate on loans

    // Lend Ether to the contract
    function lend() external payable {
        require(msg.value > 0, "You must lend a positive amount");
        balances[msg.sender] += msg.value;
    }

    // Borrow Ether with collateral (1.5x collateral ratio)
    function borrow(uint256 amount) external payable {
        require(amount > 0, "Amount must be greater than zero");
        require(msg.value >= (amount * 150) / 100, "Not enough collateral (150% required)");

        collateral[msg.sender] += msg.value;
        loans[msg.sender] += amount;

        payable(msg.sender).transfer(amount);
    }

    // Repay the loan with interest
    function repayLoan() external payable {
        uint256 loan = loans[msg.sender];
        require(loan > 0, "No active loan");
        uint256 interest = (loan * interestRate) / 100;
        uint256 totalOwed = loan + interest;

        require(msg.value >= totalOwed, "Not enough Ether to repay loan with interest");

        loans[msg.sender] = 0;
        collateral[msg.sender] = 0;
    }

    // Withdraw lent Ether (if no active loan)
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(loans[msg.sender] == 0, "Loan active, cannot withdraw");

        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }
}
