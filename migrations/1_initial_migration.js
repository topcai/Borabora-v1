const ethers = require('ethers');

const Apple = artifacts.require("./Apple.sol");
const Banana = artifacts.require("./Banana.sol");
const Coconut = artifacts.require("./Coconut.sol");
const Durian = artifacts.require("./Durian.sol");

const whiteAddress = ["0x8624b717379cb81954f0a1e8cbf22ea2966f0c64"];

const executor = ["0x4aAbCC2aDcaC52706156Ed7BFEb0294A649F5684", "0xa36FA6F13FCB6a78945a8fF4fbBfABD9A1daa16c", "0x775FeD8E4E57a349e986e6b88E6b05eFFDbEB325", "0x437672Ee962971e3fDa4366334B680724Ac9d89E"];

module.exports = async function (deployer) {
  await deployer.deploy(Durian, executor, whiteAddress);

  await Durian.deployed().then(async function () {
    whiteAddress.push(Durian.address);

    await deployer.deploy(Apple, executor, whiteAddress);
    await deployer.deploy(Banana, executor, whiteAddress);
    await deployer.deploy(Coconut, executor, whiteAddress);
  })
};
