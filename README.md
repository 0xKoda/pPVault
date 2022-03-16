## Description
MVP: This is an ERC4626 vault that compounds DODO USDC-USDT LP positions to increase users share of underlying.

TODO: plug in strategy to take long/short with rewards.

## Warning
(not ready for production)
## Getting Started
Build smart contracts
```
forge build
```
Ensure to set `UNDERLYING` to DODO USDC-USDT LP token address in constructor.

## BluePrint
```ml
src
├── interfaces
│   ├── IDLP.sol
│   └── IDODOPOOL.sol
├── test
│   └── Contract.t.sol
└── pVault.sol

```