// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.7.0 < 0.9.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import "@openzeppelin/contracts/access/Ownable.sol";

contract Token  is ERC20 {

    // the max total supply is 1000000 for TayaSwap Tokens
    uint256 public  maxTotalSupply = 1000000 * 10**18;

    constructor(uint256 maxSupply  ) ERC20("Taya USDC Token", "tUSDC"){
        maxTotalSupply = maxSupply;
        _mint(msg.sender, maxTotalSupply);
    }

}
