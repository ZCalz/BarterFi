# BarterFi

Users can provide collateral with a native onchain token and receive a loan in stablecoin by the smart contracts.

Created an implementation in Solidity with Foundry, and another implementation with Sway & Rust with Fuel

## Sway Contracts with Fuel

```
cd contracts-in-sway

forc build
cargo test

or

make build
make test
```

## Solidity Contracts with Foundry

```
cd contracts-in-foundry
forge build
forge test
```
