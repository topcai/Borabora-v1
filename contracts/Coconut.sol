// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BEP20/BEP20Basic.sol";
import "./interface/ITokenInterface.sol";

contract Coconut is BEP20Basic {

    bool public checkTokenAddress = false;

    mapping(address => bool) public claimedUser;

    uint256 public MINT_TOTAL_MAX = 1000000000000000000000;

    constructor (address[] memory whiteAddress) BEP20Basic("Coconut","COC",100000000000000000000000000,whiteAddress) {}

    function claim(uint256 amount,address tokenAddress) public {
        require(_open_receive, "Claim has not yet started");
        require(!claimedUser[msg.sender], "Each address can only be collected once");
        require(amount <= MINT_TOTAL_MAX, "Exceed Upper Limit");
        if (checkTokenAddress) {
            require(whiteTransAddr[tokenAddress], "The contract address is invalid");
            _claim(amount, tokenAddress);
        } else {
            _claim(amount, tokenAddress);
        }
    }

    function _claim (uint256 amount,address tokenAddress) private {
        IToken ItokenCoc = IToken(tokenAddress);
        uint256 token_balances = ItokenCoc.balanceOf(msg.sender);
        require(token_balances > 0, "Insufficient Balance");
        ItokenCoc.transferFrom(msg.sender, address(this), amount);
        claimedUser[msg.sender] = true;
        _mint(msg.sender, MINT_TOTAL_MAX);
        emit Claimed(msg.sender, MINT_TOTAL_MAX, address(this));
    }

    function setTokenAddress(address[] memory contractAddress) public onlyOwner returns (bool) {
        checkTokenAddress = true;
        setWhiteAddress(contractAddress);
        return true;
    }
}