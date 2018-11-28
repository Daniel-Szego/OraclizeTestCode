var Migrations = artifacts.require("./SimpleOraclizeContract.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};
