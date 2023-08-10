// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";



contract Faucet is Ownable , ReentrancyGuard {
    IERC20 public token;

    using SafeMath for uint256;

    uint256 public withdrawalAmount = 1 * (10**18);
    uint256 public lockTime = 24 hours;

    // Event Declaration
    event Withdrawal(address indexed to, uint256 indexed amount);
    event Deposit(address indexed from, uint256 indexed amount);

    mapping(address => uint256) nextAccessTime;

    constructor(address tokenAddress) payable {
        token = IERC20(tokenAddress);
    }

    function requestTokens() external nonReentrant {
        require(
            msg.sender != address(0),
           "Zero address is not allowed to request tokens"
        );
        require(
            token.balanceOf(address(this)) >= withdrawalAmount,
            "Insufficient balance in faucet for withdrawal request"
        );
        require(
            block.timestamp >= nextAccessTime[msg.sender],
            "Insufficient time elapsed since last withdrawal - try again later."
        );

        nextAccessTime[msg.sender] = block.timestamp.add(lockTime);

        token.transferFrom( address(this) ,msg.sender, withdrawalAmount);
        
        emit Withdrawal(msg.sender, withdrawalAmount);
    }


    function getBalance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function setWithdrawalAmount(uint256 amount)  external  onlyOwner {
        withdrawalAmount = amount.mul(10**18);  
    }

    function setLockTime(uint256 time) external onlyOwner {
        lockTime = time.mul(1 minutes);
    }

    function withdrawTokens(uint256 amount) external onlyOwner {
        require(amount > 0, "Withdrawal amount must be greater than 0");
        require(
            token.balanceOf(address(this)) >= amount,
            "Insufficient balance in faucet for withdrawal"
        );

        token.transfer(owner(), amount);
        emit Withdrawal(owner(), amount);
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    fallback() external payable {}
}