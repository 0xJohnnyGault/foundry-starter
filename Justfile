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

# Decode errors from Solidity contract
[group('Solidity')]
decoded-errors:
	#!/usr/bin/env bash
	join() { local d=$1 s=$2; shift 2 && printf %s "$s${@/#/$d}"; }
	shopt -s globstar # so /**/ works
	errors=$(cat artifacts-forge/**/*.json | jq -r '.abi[]? | select(.type == "error") | .name' | sort | uniq)
	sigsArray=()
	for x in $errors;	do
		sigsArray+=("\"$(cast sig "${x}()")\":\"${x}()\"")
	done
	sigs=$(join ',' ${sigsArray[*]})
	echo "{${sigs}}" | jq

# Check if there is an http(s) server listening on [url]
_ping url:
	@if ! curl -k --silent --connect-timeout 2 {{url}} >/dev/null 2>&1; then echo 'No server at {{url}}!' && exit 1; fi

