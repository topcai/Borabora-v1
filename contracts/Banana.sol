// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BEP20/BEP20Basic.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Banana is BEP20Basic {
    using SafeMath for uint;

    mapping(address => uint256) public _invitedTotal; 

    constructor (address[] memory whiteAddress) BEP20Basic("Banana","Ban", 100000000000000000000000000, whiteAddress) {}

    function claim(uint256 amount,uint256 invitedPeople,uint256 invitedTotal,bytes32[] memory _merkleProof) public {
        require(_open_receive, "Not open yet claim");
        require(invitedTotal > _invitedTotal[msg.sender], "Can not receive Claimed");
        require(whiteListInvitedClaim(invitedPeople,invitedTotal,amount,_merkleProof));
        _invitedTotal[msg.sender] = invitedTotal;
        _mint(msg.sender, amount);
        emit Claimed(msg.sender, amount, address(this));
    }
}
