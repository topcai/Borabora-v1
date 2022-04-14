const ethers = require('ethers');

const Apple = artifacts.require("./Apple.sol");
const Banana = artifacts.require("./Banana.sol");
const Coconut = artifacts.require("./Coconut.sol");
const Durian = artifacts.require("./Durian.sol");

const whiteAddress = [];

module.exports = async function (deployer) {
  await deployer.deploy(Durian,whiteAddress);

  await Durian.deployed().then(async function () {
    whiteAddress.push(Durian.address);
    
    await deployer.deploy(Apple, whiteAddress);
    await deployer.deploy(Banana, whiteAddress);
    await deployer.deploy(Coconut, whiteAddress);
  })
};
