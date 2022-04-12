// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20/ERC20Basic.sol";
import "./interface/ITokenInterface.sol";

contract Coconut is ERC20Basic {

    bool public checkTokenAddress = false;

    mapping(address => bool) public claimedUser;

    uint256 public MINT_TOTAL_MAX;

    constructor (string memory name_,string memory symbol_,uint256 totalSupply_,uint256 mint_total_max_,address[] memory whiteAddress, address[] memory owners) ERC20Basic(name_, symbol_,totalSupply_,whiteAddress, owners) {
        MINT_TOTAL_MAX = mint_total_max_;
    }

    function claim(uint256 amount,address tokenAddress) public {
        require(_open_receive, "Not open yet Claim");
        require(!claimedUser[msg.sender], "Each address can only be collected once");
        require(amount <= MINT_TOTAL_MAX, "Upper limit exceeded");
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
        require(token_balances > 0, "Insufficient balance");
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