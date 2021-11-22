from brownie import accounts, config, network, MockV3Aggregator
from web3 import Web3

DECIMALS = 8
STARTING_PRICE = 200000000000

FORKED_LOCAL_ENVIRONMENT = ["mainnet-fork", "mainnet-fork-dev"]
LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["development", "ganache-local"]


def deploy_mock():
    print(f"The active network is {network.show_active()}")
    account = get_account()
    if len(MockV3Aggregator) <= 0:
        print("Deploying Mocks...")
        MockV3Aggregator.deploy(DECIMALS, STARTING_PRICE, {"from": account})
        print("Mocks Deployed!")
    return MockV3Aggregator[-1].address


def get_account():
    if (
        network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS
        or network.show_active() in FORKED_LOCAL_ENVIRONMENT
    ):
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])


# useful scripts functions:
# brownie networks add Ethereum ganache-local host=http://127.0.0.1:7545 chainid=1337
# brownie networks add development mainnet-fork-dev cmd=ganache-cli host=http://127.0.0.1 fork=https://eth-mainnet.alchemyapi.io/v2/55tTpNB6kacW-0t4g7CQcZIIqdBuCJxc accounts=10 mnemonic=brownie port=8545
# git init -b main
# git config user.name "ziyuan"
# git config user.email "wzy.prince@gmail.com"
