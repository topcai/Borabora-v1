const ethers = require('ethers');

const Apple = artifacts.require("./Apple.sol");
const Banana = artifacts.require("./Banana.sol");
const Coconut = artifacts.require("./Coconut.sol");
const Durian = artifacts.require("./Durian.sol");

const whiteAddress = ["0x8624b717379cb81954f0a1e8cbf22ea2966f0c64"];

const executor = ["0x01", "0x02"];

module.exports = async function (deployer) {
  await deployer.deploy(Durian, executor, whiteAddress);

  await Durian.deployed().then(async function () {
    whiteAddress.push(Durian.address);

    await deployer.deploy(Apple, executor, whiteAddress);
    await deployer.deploy(Banana, executor, whiteAddress);
    await deployer.deploy(Coconut, executor, whiteAddress);
  })
};
