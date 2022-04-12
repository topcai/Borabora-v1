// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20/ERC20Basic.sol";

contract Apple is ERC20Basic {
    mapping(address => uint) public claimIndex;

    uint256 public _MAX_CLAIM_TOTAL;

    constructor (string memory name_,string memory symbol_,uint256 totalSupply_,uint256 maxClaimTotal_,address[] memory whiteAddress,address[] memory owners) ERC20Basic(name_, symbol_,totalSupply_,whiteAddress, owners) {
        _MAX_CLAIM_TOTAL = maxClaimTotal_;
    }

    function claim() public {
        require(_open_receive, "Not open yet Claim");
        require(claimIndex[msg.sender] == 0, "Claim once");
        claimIndex[msg.sender] = 1;
        _claim(_MAX_CLAIM_TOTAL);
    }

    function claimIncome(uint256 amount,bytes32[] memory _merkleProof) public {
        require(_open_receive, "Not open yet Claim");
        require(claimIndex[msg.sender] == 1, "Claim once Income");
        require(whitelistBeInvitedClaim(amount,_merkleProof));
        claimIndex[msg.sender] = 2;
        _claim(amount);
    }

    function _claim (uint256 amount) private {
        _mint(msg.sender, amount);
        emit ClaimedApple(claimIndex[msg.sender], msg.sender, amount, address(this));
    }

    event ClaimedApple(uint256 indexed,address recipient,uint256 amount,address tokenAddress);
}