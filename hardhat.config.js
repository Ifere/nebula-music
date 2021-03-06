require("hardhat-deploy");
require("@nomiclabs/hardhat-waffle")
/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.5",
      },
      {
        version: "0.8.7",
        settings: {
          optimizer: {
            enabled: true,
            runs: 1
          }
        },
      },
    ],
  },
  networks: {
    hardhat: {
      chainId: 31337,
    },
    rinkeby: {
      chainId: 4,
      url: "https://rinkeby.infura.io/v3/39b8011800ce43469aac1b4e6877f14f",
    },
  },
  namedAccounts: {
    deployer: {
      default: 0,
    },
  },
};
