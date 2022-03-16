## Getting Started
This is an ERC4626 vault that compounds DODO USDC-USDT LP positions.
(not ready for production)
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