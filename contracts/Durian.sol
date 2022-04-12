// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20/ERC20Basic.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./interface/ITokenInterface.sol";

contract Durian is ERC20Basic {
    using SafeMath for uint;

    uint256 public _token_apple_base;
    uint256 public _token_banana_base;
    uint256 public _token_coconut_base;

    constructor (string memory name_,string memory symbol_,uint256 totalSupply_,address[] memory whiteAddress,uint256[] memory token_base,address[] memory owners) ERC20Basic(name_, symbol_,totalSupply_,whiteAddress, owners) {
        _token_apple_base = token_base[0];
        _token_banana_base = token_base[1];
        _token_coconut_base = token_base[2];
    }

    function mintToken(uint256 amount,address[] memory tokenAddress) public {
        require(_open_receive, "Not open yet Minter");
        require(whiteTransAddr[tokenAddress[0]] && whiteTransAddr[tokenAddress[1]] && whiteTransAddr[tokenAddress[2]], "The Mined token must be Apple+Banana+Coconut");
        IToken tokenApple = IToken(tokenAddress[0]);
        IToken tokenBanana = IToken(tokenAddress[1]);
        IToken tokenCoconut = IToken(tokenAddress[2]);

        uint256 token_apple_balance = tokenApple.balanceOf(msg.sender);
        uint256 token_banana_balance = tokenBanana.balanceOf(msg.sender);
        uint256 token_coconut_balance = tokenCoconut.balanceOf(msg.sender);

        uint256 apple_amount = _token_apple_base.mul(amount);
        uint256 banana_amount = _token_banana_base.mul(amount);
        uint256 coconut_amount = _token_coconut_base.mul(amount);

        require(token_apple_balance >= apple_amount, "Apple Token Insufficient Balance");
        require(token_banana_balance >= banana_amount, "Banana Token Insufficient Balance");
        require(token_coconut_balance >= coconut_amount, "Coconut Token Insufficient Balance");

        tokenApple.transferFrom(msg.sender, address(this), apple_amount);
        tokenBanana.transferFrom(msg.sender, address(this), banana_amount);
        tokenCoconut.transferFrom(msg.sender, address(this), coconut_amount);

        tokenApple.burn(apple_amount);
        tokenBanana.burn(banana_amount);
        tokenCoconut.burn(coconut_amount);

        _mint(msg.sender, amount);
        emit Minted(msg.sender, amount, address(this));
    }

    function setTokenBase (uint256[] memory token_base) public onlyOwner returns (bool) {
        _token_apple_base = token_base[0];
        _token_banana_base = token_base[1];
        _token_coconut_base = token_base[2];
        return true;
    }
}