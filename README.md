# Crowdfunding Smart Contract

A decentralized crowdfunding platform built with Solidity and Hardhat 3, allowing users to create campaigns, receive contributions, and manage funds based on goal achievement.

## 📋 Project Overview

This project implements a crowdfunding smart contract on Ethereum that enables:

- **Campaign Creation**: Anyone can create a crowdfunding campaign with a specific goal and deadline
- **Contributions**: Support campaigns by contributing ETH
- **Automatic Withdrawals**: Campaign creators can withdraw funds when goals are met
- **Refunds**: Contributors can claim refunds if campaigns fail to reach their goals

## 🌐 Deployed Contract

**Sepolia Testnet**: [0x349aBCbfaDe35640472148520B9f07A8C146E563](https://sepolia.etherscan.io/address/0x349aBCbfaDe35640472148520B9f07A8C146E563#code)

You can interact with the deployed contract on Sepolia testnet using the address above.

## 🎯 Smart Contract Features

### Main Functions

- `createCampaign(uint256 _goal, uint256 _durationInSeconds)`: Create a new crowdfunding campaign
- `contribute(uint256 _campaignId)`: Contribute ETH to a specific campaign
- `withdraw(uint256 _campaignId)`: Withdraw funds after successfully reaching the goal
- `refund(uint256 _campaignId)`: Claim refund if campaign failed to reach its goal
- `getCampaign(uint256 _campaignId)`: View campaign details
- `getCampaignCount()`: Get total number of campaigns

### Events

- `CampaignCreated`: Emitted when a new campaign is created
- `Contributed`: Emitted when someone contributes to a campaign
- `Withdrawn`: Emitted when creator withdraws funds
- `Refunded`: Emitted when contributor receives a refund

## 🚀 Getting Started

### Prerequisites

- Node.js (v16 or higher)
- npm or yarn
- An Ethereum wallet with testnet ETH for deployment

### Installation

```shell
npm install
```

### Configuration

Create a `.env` file in the root directory with the following variables:

```env
SEPOLIA_RPC_URL=your_sepolia_rpc_url
PRIVATE_KEY=your_wallet_private_key
ETHERSCAN_API_KEY=your_etherscan_api_key
```

## 📝 Usage

### Compile Contracts

```shell
npx hardhat compile
```

### Run Tests

```shell
npx hardhat test
```

### Deploy to Local Network

Deploy the contract to a local Hardhat network:

```shell
npx hardhat ignition deploy ignition/modules/CrowdfundingModule.ts
```

### Deploy to Sepolia Testnet

To deploy to Sepolia testnet, ensure your wallet has testnet ETH and run:

```shell
npx hardhat ignition deploy --network sepolia ignition/modules/CrowdfundingModule.ts
```

### Verify Contract on Etherscan

After deployment, verify your contract:

```shell
npx hardhat verify --network sepolia <DEPLOYED_CONTRACT_ADDRESS>
```

## 🏗️ Project Structure

```
crowdfunding-contracts/
├── contracts/
│   └── Crowdfunding.sol          # Main crowdfunding smart contract
├── ignition/
│   └── modules/
│       └── CrowdfundingModule.ts # Deployment module
├── types/                         # TypeScript type definitions
├── hardhat.config.ts             # Hardhat configuration
├── package.json
└── README.md
```

## 🔧 Technology Stack

- **Solidity ^0.8.28**: Smart contract language
- **Hardhat 3**: Development environment
- **Ethers.js v6**: Ethereum library
- **TypeScript**: Type-safe development
- **Hardhat Ignition**: Declarative deployment system

## 📄 License

ISC

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

## 👤 Author

GitHub: [@Fink2005](https://github.com/Fink2005)

## 📚 Learn More

- [Hardhat Documentation](https://hardhat.org/docs)
- [Solidity Documentation](https://docs.soliditylang.org/)
- [Ethers.js Documentation](https://docs.ethers.org/)
