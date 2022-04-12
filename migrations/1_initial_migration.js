const ethers = require('ethers');

const Apple = artifacts.require("./Apple.sol");
const Banana = artifacts.require("./Banana.sol");
const Coconut = artifacts.require("./Coconut.sol");
const Durian = artifacts.require("./Durian.sol");

// @params string name
// @params string symbol
// @params uint totalSupply
const AppleInfo = {
    name: 'Apple',
    symbol: 'app',
    total: 100000000,
    claim_max_amount: 500
}

// @params string name
// @params string symbol
// @params uint totalSupply
const BananaBInfo = {
  name: "Banana",
  symbol: "Ban",
  total: 100000000
}

// @params string name
// @params string symbol
// @params uint max_claim_amount
// @params uint totalSupply
const CoconutInfo = {
  name: "Coconut",
  symbol: "Coc",
  max_claim_amount: 1000,
  total: 100000000
}

// @params string name
// @params string symbol
// @params uint totalSupply
// @params tokenA_amount_base、tokenB_amount_base、tokenC_amount_base
const DurianInfo = {
  name: "Durian",
  symbol: "Dur",
  total: 100000000,
  token_base: [1000,300,1000]
}

const whiteAddress = [];

const ownerAddress = []; // Admin

const formatETH = (amount) => {
  return ethers.utils.parseUnits(amount.toString(),18).toString()
}

module.exports = async function (deployer) {
  await deployer.deploy(Durian, DurianInfo.name, DurianInfo.symbol,formatETH(DurianInfo.total),whiteAddress, DurianInfo.token_base, ownerAddress);

  await Durian.deployed().then(async function () {
    whiteAddress.push(Durian.address);
    await deployer.deploy(Apple, AppleInfo.name, AppleInfo.symbol, formatETH(AppleInfo.total),formatETH(AppleInfo.claim_max_amount), whiteAddress, ownerAddress);
    await deployer.deploy(Banana, BananaBInfo.name, BananaBInfo.symbol, formatETH(BananaBInfo.total), whiteAddress, ownerAddress);
    await deployer.deploy(Coconut, CoconutInfo.name, CoconutInfo.symbol, formatETH(CoconutInfo.total), formatETH(CoconutInfo.max_claim_amount), whiteAddress, ownerAddress);
  })
};
