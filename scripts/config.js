exports.providerAddress = require('./secret.json').providerAddress;
exports.privateKey = require('./secret.json').privateKey;

exports.abi = function(name) {
    return require('../build/contracts/' + name + '.json').abi;
}

exports.address = function(network, name) {
    return require('../build/contracts/' + name + '.json').networks[network].address;
}
