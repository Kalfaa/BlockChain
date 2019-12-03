const Migrations = artifacts.require("Migrations");
const SadamHuschain = artifacts.require("SadamHuschain")
module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(SadamHuschain);
};
