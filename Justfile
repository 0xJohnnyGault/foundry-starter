# Justfiles are better Makefiles (Don't @ me)
# Install the `just` command from here https://github.com/casey/just
# or `cargo install just` or `brew install just`
# https://cheatography.com/linux-china/cheat-sheets/justfile/

# Autoload a .env if one exists
set dotenv-load
# Export all variables to the ENV
set export

ETH_RPC_URL := env_var_or_default("ETH_RPC_URL", "http://127.0.0.1:8545")
MNEMONIC := env_var_or_default("MNEMONIC", "test test test test test test test test test test test junk")
# First key from MNEMONIC `cast wallet private-key "${MNEMONIC}"`
PRIVATE_KEY := env_var_or_default("PRIVATE_KEY", "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80")
ETH_FROM := env_var_or_default("ETH_FROM", "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266")

# Print out some help
default:
	@just --list --unsorted

build:
  forge build
  
# Run forge unit tests
test contract="." test="." *flags="":
	forge test --match-contract {{contract}} --match-test {{test}} {{flags}}

# Execute a Forge script from scripts/
forge-script cmd:
	#!/usr/bin/env bash
	fn={{cmd}}
	forge script --broadcast --slow --ffi --fork-url=${ETH_RPC_URL} --private-key=${PRIVATE_KEY} script/${fn%.*.*}.s.sol

# Start anvil with $MNEMONIC
anvil *args:
	anvil --mnemonic "${MNEMONIC}" {{args}}

cast-send contract method *args:
  cast send --from $ETH_FROM --private-key ${PRIVATE_KEY} {{contract}} "{{method}}" {{args}}

cast-call contract method *args:
  cast call --from $ETH_FROM {{contract}} "{{method}}" {{args}}

