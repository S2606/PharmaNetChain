const PharmaChain = artifacts.require("PharmaChain");

module.exports = function(deployer) {
  deployer.deploy(PharmaChain);
};
