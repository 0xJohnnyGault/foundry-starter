# Foundry Starter Project

## Installation

```bash
# https://github.com/casey/just
brew install just
# Reads .env whenever you cd into the project
brew install direnv
# Foundry ethereum dev tools
curl -L https://foundry.paradigm.xyz | bash
# Clone the project
git clone git@github.com:0xJohnnyGault/foundry-starter.git
cd foundry-starter
# Build and test the project
just buid
just test
```

## Deploy to Anvil

Anvil is a local Ethereum network that is used for testing and development.

```bash
# In one terminal run this...
just anvil

# In another terminal run this to deploy the Counter.sol contract
just forge-script Counter

# You should see
eth_sendRawTransaction
    Transaction: 0xd90588109ad7deea2991a5e8019e654021dfc6a0980f9e238bbbdf75203e7606
    Contract created: 0x5FbDB2315678afecb367f032d93F642f64180aa3
    Gas used: 104475
    Block Number: 1
    Block Hash: 0x9edd21a378059489570aeccca580c76bb12888afeb621a8af9b5ce1cd294852a
    Block Time: "Thu, 30 Jan 2025 02:26:23 +0000"

# Now we can interact with the contract
export CONTRACT=0x5FbDB2315678afecb367f032d93F642f64180aa3

# See how much eth we have
just cast balance $ETH_FROM

# Increment the counter
just cast-send $CONTRACT "increment()"

# See the counter value
just cast-call $CONTRACT "number()"   

# Now set the counter value to a specific number
just cast-send $CONTRACT "setNumber(uint256)" 0xf

# See the counter value
just cast-call $CONTRACT "number()"   
```
