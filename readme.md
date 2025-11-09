# Simple counter contract

**Deployed on Sui Testnet**
- **Package ID:** `0x3ffd7fb7cc5d2c4f9fb649a463ec102cb78ce459af5e8e12f7120424e6782707`
- **Transaction Hash:** `5YtVctQsQikRBdn7e2MnrkmuXpnfA2qBx74YvGmUd2pD`
- **Explorer:** [View on SuiVision](https://testnet.suivision.xyz/txblock/5YtVctQsQikRBdn7e2MnrkmuXpnfA2qBx74YvGmUd2pD)

This is a simple smart contract on Sui which:
- can create an object for a user and send it to the user (the object can only be updated by the owner)
- can increment the user's object `count` field
- can send info about a specific object (fields' values)
- emits events on any object related action

## Structure
There are two endpoints which mutate the object's state and do not return any value:
- `create_counter` creates a new counter and emits a `CounterCreated` event which also contains the creation timestamp (using Clock)
- `increment` checks if the sender is actually the owner of the object and then increments the `count` field of the specific object. Emits a `CounterIncremented` event

**Note:**
These functions are marked with `entry` for accessibility.

The remaining functions are `readonly` and they return a specific object's fields' values. These cannot be marked with `entry`, as this information can be easily extracted from the rpc from other environments, without the need of a transaction.


### Example on Testnet
```bash
tx_hash = 5YtVctQsQikRBdn7e2MnrkmuXpnfA2qBx74YvGmUd2pD
package_id = 0x3ffd7fb7cc5d2c4f9fb649a463ec102cb78ce459af5e8e12f7120424e6782707
```

## How to use

## Build the contract
```bash
sui move build
```

## Deploy the contract on Testnet
```bash
sui client publish --gas-budget 100000000
```

## Find transaction digest and package ID

After deployment, look for these in the output:

- **Transaction Digest:** `5YtVctQsQikRBdn7e2MnrkmuXpnfA2qBx74YvGmUd2pD`
- **Package ID:** `0x3ffd7fb7cc5d2c4f9fb649a463ec102cb78ce459af5e8e12f7120424e6782707`

```bash
Transaction Digest: 5YtVctQsQikRBdn7e2MnrkmuXpnfA2qBx74YvGmUd2pD
                                                                                       │
│ Published Objects:                                                                               │
│  ┌──                                                                                             │
│  │ PackageID: 0x3ffd7fb7cc5d2c4f9fb649a463ec102cb78ce459af5e8e12f7120424e6782707                 │
│  │ Version: 1                                                                                    │
│  │ Digest: 2tTvR8RYHiYBpdyU3rVjegEbywdSFgc286eCg8fj5yhs                                          │
│  │ Modules: counter                                                                              │
│  └──                                                                                             │
╰──────────────────────────────────────────────────────────────────────────────────────────────────╯
```

## Create a counter

```bash
sui client call --package <YOUR_PACKAGE_ID> --module counter \
  --function create_counter --args 0x6 --gas-budget 10000000
```

**Note:**
0x6 is the default address for the clock

## Copy the Counter Object ID from output
```bash
│ Created Objects:                                                                                     │
│  ┌──                                                                                                 │
│  │ ObjectID: 0xaf6453d4f431fd882201b96715c3da912ee815c87b0f5e2a090543255a3362be                      │
│  │ Sender: 0x4749eda972bc42d7c4cdff06ab3884aba405f56dc80b1427e8e86bdba241cd20                        │
│  │ Owner: Account Address ( 0x4749eda972bc42d7c4cdff06ab3884aba405f56dc80b1427e8e86bdba241cd20 )     │
│  │ ObjectType: 0x3ffd7fb7cc5d2c4f9fb649a463ec102cb78ce459af5e8e12f7120424e6782707::counter::Counter  │
│  │ Version: 646510532                                                                                │
│  │ Digest: 2LUb5souvayrphro42AaSigKJhViGsWdNTNStzzhPJoS    
```

## Increment it
```bash 
sui client call --package <YOUR_PACKAGE_ID> --module counter \
  --function increment --args <COUNTER_OBJECT_ID> --gas-budget 10000000
```

## View to confirm count = 1
```bash
sui client object <COUNTER_OBJECT_ID>
```