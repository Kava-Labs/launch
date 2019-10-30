# Launching Kava

This document includes instructions for validators who intend to participate in the launch of the Kava mainnet. Please note:

1. This process is intended for technically inclined people who have participated in Kava testnets and other `cosmos-sdk` based blockchain launches. Experience running production IT systems is strongly recommended.
2. KAVA staked during genesis will be at risk of 5% slashing if your validator double signs. If you accidentally misconfigure your validator setup, this can easily happen, and slashed KAVA are not expected to be recoverable by any means. Additionally, if you double-sign, your validator will be tombstoned and you will be required to change operator and signing keys.
3. You will be creating public key accounts that are restored via their mnemonic. It is vital that you securely backup and store your mnemonic for any accounts that are created during this process. **Failure to do so can result in the irrecoverable loss of all KAVA tokens**.


## Instructions

* [Validator Sale Participants](#for-validator-sale-participants)
* [Founder Rewards Participants](#for-founder-rewards-participants)

## For Validator Sale Participants

You will be preparing two documents:

1. `gentx.json` a signed transaction with your validator key that will create a validator at genesis with 50 self-delegated KAVA.
2. `account.json` a json file containing the address and amount of KAVA tokens you will receive at this address. The tokens at this address will be subject to vesting terms based on the contract you signed.

Once the documents are created, you will place them in a new directory in the `gentx` folder of this repo. Choose a unique directory name.

<br>

#### Prepare documents

1. Install `kvd` version v0.3.0

##### Requires Go 1.13+

```sh
git clone https://github.com/kava-labs/kava
cd kava
git checkout v0.3.0
make install
kvd init <your-validator-moniker> --chain-id kava-1
```

2. Create a key for your validator account. Back up the mnemonic and store the key information securely.

```sh
kvcli keys add <your-validator-key-name>
```

3. Assign 50 KAVA to your validator

```sh
kvd add-genesis-account $(kvcli keys show <your-validator-key-name> -a) 50000000ukava
```

4. Sign a genesis transaction

```sh
kvd gentx \
  --amount 50000000ukava \
  --commission-rate <commission_rate> \
  --commission-max-rate <commission_max_rate> \
  --commission-max-change-rate <commission_max_change_rate> \
  --pubkey <consensus_pubkey> \
  --name <key_name>
```

**NOTE:**  If you would like to override the memo field use the `--ip` and `--node-id` flags for the `kvd gentx` command above. `pubkey` can be obtained using `kvd tendermint show-validator`

5. Copy the gentx you created to a new directory in the `gentx` directory of this repo and name it `gentx.json`

```sh
cp $HOME/.kvd/config/gentx/gentx-<node_id>.json ./gentx/<your-directory>/gentx.json
```

6. Create a key for your vesting account

```sh
kvcli keys add <your-vesting-account-key-name>
```

7. Create an `account.json` file in your new directory

```sh
printf '{"account": "", "amount": ""}\n' > ./gentx/<your-directory>/account.json
```

8. Fill in the address and amount of ukava you expect to receive in the vesting account

Example: If you expect to receive 100,000 KAVA

  * Subtract 50 KAVA, which was allocated to your validator
  * multiply by 10^6 to convert KAVA to ukava
  * (100000 - 50) * 10^6 = 99950000000 ukava

```json
{
  "account": "kava1...",
  "amount": "99950000000ukava"
}
```

9. Submit your directory, with `gentx.json` and `account.json` files, as a PR on this repo.

## For Founder Rewards Participants

Eligible participants in the founder rewards program will submit an account that will be included in genesis:

1. `account.json` a json file containing the address and amount of KAVA tokens you will receive at this address. The tokens will be immediately available and not bonded to a particular validator. Founder badge participants are free to create a validator immediately after launch.

Once the `account.json` file is created, you will place it in a new directory in the `gentx` folder of this repo. Choose a unique directory name.

#### Prepare documents

1. Install `kvd` version v0.3.0

##### Requires Go 1.13+

```sh
git clone https://github.com/kava-labs/kava
cd kava
git checkout v0.3.0
make install

kvd init <your-moniker> --chain-id kava-1
```

2. Create a key for your account. Back up the mnemonic and store the key information securely.

```sh
kvcli keys add <your-account-key-name>
```

3. Create an `account.json` file in a new directory in the `gentx` directory of this repo.


```sh
printf '{"account": "", "amount": ""}\n' > ./gentx/<your-directory>/account.json
```

4. Fill in the address and amount of ukava you expect to receive in the account. Refer to the founder [documentation](https://github.com/Kava-Labs/kava/blob/master/docs/REWARDS.md) for reward amounts and eligibility.

Example: If you expect to receive 3000 KAVA

  * multiply by 10^6 to convert KAVA to ukava
  * 3000 * 10^6 = 3000000000 ukava

```json
{
  "account": "kava1...",
  "amount": "3000000000ukava"
}
```

5. Submit your directory, with `account.json` file, as a PR on this repo.

## Helpful resources

For resources that references `gaiacli`, you can replace `gaiacli` with `kvcli`

* [Using the Cosmos app and a Ledger device to store your Kava keys](https://cosmos.network/docs/cosmos-hub/delegator-guide-cli.html#cosmos-accounts)
* [Validator Security](https://cosmos.network/docs/cosmos-hub/validators/security.html#validator-security)
* [Creating a validator after mainnet launch](https://cosmos.network/docs/cosmos-hub/validators/validator-setup.html#create-your-validator)

## Disclaimer

The Kava blockchain is highly experimental software. In these early days, we can expect to have issues, updates, and bugs. The existing tools require advanced technical skills and involve risks which are outside of the control of Kava Labs. Any use of this open source Apache 2.0 licensed software is done at your own risk and on a “AS IS” basis, without warranties or conditions of any kind, and any and all liability of Kava Labs for damages arising in connection to the software is excluded. Please exercise extreme caution!
