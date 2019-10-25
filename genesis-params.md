# Kava Mainnet Genesis Parameters

## Tendermint Params

This genesis time puts global nighttime in the pacific (early-ish for San Francisco and late-ish for Korea: [Timezone chart](https://www.timeanddate.com/worldclock/meetingtime.html?month=11&day=5&year=2019&p1=224&p2=43&p3=136&p4=37&p5=33&p6=235&iv=0)). Those in the US, watch out for daylight savings time change a few days prior.

```json
    "genesis_time": "2019-11-05T14:00:00Z",
    "chain_id": "kava-1",
```

These parameters are the same as cosmoshub-2. hub 1 was slightly different.

```json
    "consensus_params": {
        "block": {
            "max_bytes": "200000",
            "max_gas": "2000000",
            "time_iota_ms": "1000"
        },
        "evidence": {
            "max_age": "1000000"
        },
        "validator": {
            "pub_key_types": [
                "ed25519"
            ]
        }
    },
```

## App State

### Bank

Start with txs disabled. A governance vote may enable them if the network reaches stability.

    "bank": {
        "send_enabled": false
    },

### Genutil

The list of gentxs to be filled in automatically.

    "genutil": {
        "gentxs": [...]
    },

### Crisis

Reference: [https://github.com/cosmos/cosmos-sdk/tree/master/x/crisis/spec](https://github.com/cosmos/cosmos-sdk/tree/master/x/crisis/spec)
Cosmoshub-2's fee is 1333atom, or $5332 at an average $4/atom. This is set to 10000kava to keep it comparable.

    "crisis": {
        "constant_fee": {
            "denom": "ukava",
            "amount": "10000000000"
        }
    },

### Distribution

These parameters are the same as cosmoshub-2, except:

- `withdraw_addr_enabled` is false, but may be enabled along with bank transfers through governance
- The community pool is disabled by setting tax to 0

```json
    "distribution": {
        "fee_pool": {
            "community_pool": []
        },
        "community_tax": "0.000000000000000000",
        "base_proposer_reward": "0.010000000000000000",
        "bonus_proposer_reward": "0.040000000000000000",
        "withdraw_addr_enabled": false,
        "delegator_withdraw_infos": [],
        "previous_proposer": "",
        "outstanding_rewards": [],
        "validator_accumulated_commissions": [],
        "validator_historical_rewards": [],
        "validator_current_rewards": [],
        "delegator_starting_infos": [],
        "validator_slash_events": []
    },
```

### Mint

These parameters are the same as cosmohub-2, except:

- `block_per_year` is calculated from testnet 3000 block time (365*24*60*60 seconds/year / 6 seconds/block = 5256000 blocks/year) ref: [https://github.com/cosmos/cosmos-sdk/issues/2846](https://github.com/cosmos/cosmos-sdk/issues/2846)
- `inflation` which is just the initial value for inflation, is set to the min, as cosmos hub 1 did
- `annual_provisions` starts at zero and is just the initial value. It is computed each block from the inflation percentage and the total supply.
- `inflation_min` is set to 3% to bring a balance of staking incentives with the role of KAVA as a governance token and lender of last resort.

```json
    "mint": {
        "minter": {
            "inflation": "0.030000000000000000",
            "annual_provisions": "0.000000000000000000"
        },
        "params": {
            "mint_denom": "ukava",
            "inflation_rate_change": "0.130000000000000000",
            "inflation_max": "0.200000000000000000",
            "inflation_min": "0.020000000000000000",
            "goal_bonded": "0.670000000000000000",
            "blocks_per_year": "5256000"
        }
    },
```

### Auth

These parameters are the same as cosmoshub-2 and 1.
Note: accounts are now stored under `auth` rather than `genaccounts`

```json
    "auth": {
        "params": {
            "max_memo_characters": "512",
            "tx_sig_limit": "7",
            "tx_size_cost_per_byte": "10",
            "sig_verify_cost_ed25519": "590",
            "sig_verify_cost_secp256k1": "1000"
        }
        "accounts": [...]
    },
```

### Params

`params` has no genesis state

```json
    "params": null
```

### Gov

These parameters are the same as cosmoshub-2 and 1, except:

- `max_deposit` Cosmoshub-2's value is 512atom, or $2048 at an average $4/atom. So this is set to 4500kava to keep it comparable.

Note: voting period must be less than unbonding period otherwise people could vote, redelegate, then vote again.

```json
    "gov": {
        "starting_proposal_id": "1",
        "deposits": null,
        "votes": null,
        "proposals": null,
        "deposit_params": {
            "min_deposit": [
                {
                    "denom": "ukava",
                    "amount": "4500000000"
                }
                ],
            "max_deposit_period": "1209600000000000" // 14 days
        },
        "voting_params": {
            "voting_period": "1209600000000000" // 14 days, has to be ≤ unbonding time
        },
        "tally_params": {
            "quorum": "0.400000000000000000",
            "threshold": "0.500000000000000000",
            "veto": "0.334000000000000000"
        }
    },
```

### Staking

These parameters are the same as cosmoshub-2 and 1.

```json
    "staking": {
        "params": {
            "unbonding_time": "1814400000000000", // 21 days
            "max_validators": 100,
            "max_entries": 7,
            "bond_denom": "ukava"
        },
        "last_total_power": "0",
        "last_validator_powers": null,
        "validators": null,
        "delegations": null,
        "unbonding_delegations": null,
        "redelegations": null,
        "exported": false
    },
```

### Slashing

These parameters are the same as cosmoshub-2 and 1.

```json
    "slashing": {
        "params": {
            "max_evidence_age": "1814400000000000", // 21 days, must be same as unbonding period
            "signed_blocks_window": "10000", // 16.67hrs hours @ 6s block time (block time of testnet 3000)
            "min_signed_per_window": "0.050000000000000000", // can be down for up to 15.83hrs without slashing
            "downtime_jail_duration": "600000000000", // 10min
            "slash_fraction_double_sign": "0.050000000000000000",
            "slash_fraction_downtime": "0.000100000000000000"
        },
        "signing_infos": {},
        "missed_blocks": {}
    },
```

### Supply

Note: neither `add-genesis-account` or `collect-gentx` modifies the supply. It's set when the chain starts based on the accounts.

```json
    "supply": {
        "supply": {
            "total": []
        }
    }
```

### Validator Vesting

This parameter sets the last block time for determining when vesting periods close after a chain restart. It's set to the zero unix time value for new chains.

```json
    "validatorvesting": {
        "previous_block_time": "1970-01-01T00:00:00Z"
    }
```
