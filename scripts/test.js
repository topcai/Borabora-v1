const { providers, Contract, Wallet, utils, BigNumber } = require('ethers');
const { abi, address, providerAddress, privateKey } = require('./config');

async function doTest() {

}

async function test() {
    try {
        await doTest()
    } catch (e) {
        console.error(e)
    }
}

test()