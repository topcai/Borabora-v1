// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20/ERC20Basic.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Banana is ERC20Basic {
    using SafeMath for uint;

    mapping(address => uint256) public _invitedTotal; 

    constructor (string memory name_,string memory symbol_,uint256 totalSupply_,address[] memory whiteAddress,address[] memory owners) ERC20Basic(name_, symbol_,totalSupply_,whiteAddress, owners) {}

    function claim(uint256 amount,uint256 invitedPeople,uint256 invitedTotal,bytes32[] memory _merkleProof) public {
        require(_open_receive, "Not open yet claim");
        require(invitedTotal > _invitedTotal[msg.sender], "Can not receive Claimed");
        require(whitelistInvitedClaim(invitedPeople,invitedTotal,amount,_merkleProof));
        _invitedTotal[msg.sender] = invitedTotal;
        _mint(msg.sender, amount);
        emit Claimed(msg.sender, amount, address(this));
    }
}
