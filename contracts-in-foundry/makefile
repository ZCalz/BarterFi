# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

update:; forge update

build:; forge build

test :; forge test 

slither :; slither ./src 

script-goerli :; forge script script/BarterFi.s.sol:DeployScript --rpc-url ${GOERLI_RPC_URL}  --private-key ${PRIVATE_KEY} --broadcast --verify --etherscan-api-key ${ETHERSCAN_KEY} -vvvv

script-local :; forge script script/BarterFi.s.sol:DeployScript --rpc-url http://localhost:8545  --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast -vvvv
