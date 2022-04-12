// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../library/MerkleProof.sol";
import "../interface/ITokenInterface.sol";

contract ERC20Basic is ERC20, MerkleProof {

    address private owner;

    bytes32 private merkleInviteWhiteRoot;

    bytes32 private merkleBonusRoot;

    mapping(address => bool) public owner_admin;

    mapping(address => bool) public whiteBounsAddr;

    mapping(address => bool) public whiteTransAddr;

    bool public _open_receive;

    bool public _open_claim_bonus;

    constructor (string memory name_,string memory symbol_,uint256 totalSupply_,address[] memory whiteAddress,address[] memory owners) ERC20(name_,symbol_) {
        owner = msg.sender;
        if (owners.length > 0) {
            setOwnerAdmin(owners);
        }
        setWhiteAddress(whiteAddress);
        _mint(owner, totalSupply_);
    }

     modifier onlyOwner() {
        require(msg.sender == owner || owner_admin[msg.sender], "Only Owner can transfer Money");
        _;
    }

    function setOwnerAdmin(address[] memory _owners) public onlyOwner returns (bool) {
        for (uint i = 0;i<_owners.length;i++) {
            if (!owner_admin[_owners[i]]) {
                owner_admin[_owners[i]] = true;
            }
        }
        return true;
    }

    function burn(uint256 amount) public returns (bool) {
        _burn(msg.sender, amount);
        return true;
    }

    function transfer(address to, uint256 amount) public onlyOwner virtual override returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        require(whiteTransAddr[to] || owner_admin[from] || from == owner, "The receiving address can only be the contract Address");
        _spendAllowance(from, msg.sender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function setWhiteInviteMerkleRoot(bytes32 _rootHash) external onlyOwner returns (bool) {
        merkleInviteWhiteRoot = _rootHash;
        return true;
    }
    
    function setBonusMerkleRoot(bytes32 _rootHash) external onlyOwner returns (bool) {
        merkleBonusRoot = _rootHash;
        return true;
    }

    function setOpenReceive (bool opened) external onlyOwner returns (bool) {
        _open_receive = opened;
        return true;
    }

    function setOpenBonus (bool opened) external onlyOwner returns (bool) {
        _open_claim_bonus = opened;
        return true;
    }

    function whitelistBeInvitedClaim(uint256 amount,bytes32[] memory _merkleProof) internal view returns (bool) {
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender,amount));
        require(verify(_merkleProof,merkleInviteWhiteRoot,leaf), "Invalid proof Claimed");
        return true;
    }

    function whitelistInvitedClaim(uint256 invitedPeople,uint256 invitedTotal,uint256 amount,bytes32[] memory _merkleProof) internal view returns (bool) {
        bytes32 leaf = keccak256(abi.encodePacked(invitedPeople,invitedTotal,msg.sender,amount));
        require(verify(_merkleProof,merkleInviteWhiteRoot,leaf), "Invalid proof Claimed");
        return true;
    }

    function bounslistClaim(uint256 amount,bytes32[] memory _merkleProof) internal view returns (bool) {
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender,amount));
        require(verify(_merkleProof,merkleBonusRoot,leaf), "Invalid proof Bouns");
        return true;
    }

    // 瓜分奖池
    function claimBonus(uint256 amount,bytes32[] memory _merkleProof,address tokenAddress) public {
        require(_open_claim_bonus, "Not open yet Claim");
        require(!whiteBounsAddr[msg.sender], 'Drop already Bonus');
        require(bounslistClaim(amount,_merkleProof));
        whiteBounsAddr[msg.sender] = true;
        _claimBouns(amount,tokenAddress);
    }

    function _claimBouns(uint256 amount,address tokenAddress) private {
        IToken token = IToken(tokenAddress);
        uint256 _balances = token.balanceOf(address(this));
        require(_balances >= amount, "Insufficient Banlance Bonus");
        token.transfer(msg.sender,amount);
        _burn(msg.sender, amount);
        emit ClaimBonused(msg.sender,amount);
    }

    function setWhiteAddress (address[] memory contractAddress) public onlyOwner returns (bool) {
        for (uint i = 0;i < contractAddress.length;i++) {
            if (!whiteTransAddr[contractAddress[i]]) {
                whiteTransAddr[contractAddress[i]] = true;
            }
        }
        return true;
    }

    event Claimed(address recipient,uint256 amount,address tokenAddress);

    event ClaimBonused(address recipient,uint256 amount);

    event Minted(address recipient,uint256 amount,address tokenAddress);
}