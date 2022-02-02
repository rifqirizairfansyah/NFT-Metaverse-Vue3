require('@nomiclabs/hardhat-waffle')
// eslint-disable-next-line @typescript-eslint/no-var-requires
const fs = require('fs-extra')
const privateKey = fs.readFileSync('.secret').toString()
const projectId = '660af9c6c3e546b2815c84ce01f74772'
module.exports = {
  networks: {
    hardhat: {
      chainId: 1337
    },
    mumbai: {
      url: `https://polygon-mumbai.infura.io/v3/${projectId}`,
      accounts: [privateKey]
    },
    mainnet: {
      url: `https://polygon-mainnet.infura.io/v3/${projectId}`,
      accounts: [privateKey]
    }
  },
  solidity: '0.8.4'
}
