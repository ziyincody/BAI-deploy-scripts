# H20 deployment scripts
![Build Status](https://github.com/stablecoin-research/H20-deploy-scripts/actions/workflows/.github/workflows/tests.yaml/badge.svg?branch=master)

A set of scripts that deploy  the whole H20  core system contracts and helpers []() to an
Ethereum chain of your choosing. this then  is used by the testchain to allow the SDK to interact with the  contracts for running the application .

## Description

This repo is composed of following main components:

* Bash [scripts](/scripts) to set the enviornment variables  of the base system.

* [Dependency of core contracts](/deps) for  providing the necessary contracts  to be deployed on the mainnet . 


* [Whole deployment schedule](/libexec)  : these scripts  consist of the whole logic of setting up the contracts with the default system parameters , and then setting up the 

for the first time  mainnet deployment , the  values are to be referenced from file like  config-H20-params.json . it will be stored as `$CONFIG_FILE` in the given


At the end of the first step, the addresses of deployed contracts are written to
an `testchain-H20/out/addresses.json` file. The scripts read those addresses and use `seth`
and `dapp` to modify the deployment, using the values in `testchain-H20/out/config.json`.



## Installing

The only way to install everything necessary to deploy is Nix. Run

```
$ nix-shell --pure
```

to drop into a Bash shell with all dependency installed.

### Ethereum node

You'll also need an Ethereum RPC node to connect to. Depending on your usecase, this
could be a local node (e.g. `dapp testnet`) or a remote one.

## Configuration

There are 2 main pieces of configuration necessary for a deployment:

* Ethereum account configuration
* Chain configuration

#### Account configuration

`seth` relies on the presence of environment variables to know which Ethereum account to
use, which RPC server to talk to, etc.

If you're using `nix-shell`, these variables are set automatically for you in
[shell.nix](./shell.nix).

But you can also configure the below variables manually:

- `ETH_FROM`: address of deployment account
- `ETH_PASSWORD`: path of account password file
- `ETH_KEYSTORE`: keystore path
- `ETH_RPC_URL`: URL of the RPC node



## Libexec : 

- these form the core scripts that define the actual workflow of defining the contracts on the 

## parameters to be set





### Chain configuration

Some networks have a default config file at `config/<NETWORK>.json`, which will be used if non custom config values are set.
A config file can be passed via param with flag `-f` allowing to execute the script in any network (e.g. `dss-deploy testchain -f <CONFIG_FILE_PATH>`).
As other option, custom config values can be loaded as an environment variable called `DDS_CONFIG_VALUES`.
File passed by parameter overwrites the environment variable.


## Default config files

Currently, there are default config files for 3 networks:

* a local testchain (e.g. `dapp testnet`)
* Kovan
* Mainnet

### Deploy on local testchain with default config file

`dss-deploy testchain`

It is possible to pass a value to define a testing scenario via `-c` flag (e.g. `dss-deploy testchain -c crash-bite`)

The only case currently available is:

- `crash-bite`

### Deploy on Kovan (or mainnet) with default config file

`dss-deploy kovan / main `


### Deploy on any network passing a custom config file

`dss-deploy <NETWORK> -f <CONFIG_FILE_PATH>`

### Output

Successful deployments save their output to the following files:

- `out/addresses.json`: addresses of all deployed contracts
- `out/config.json`: copy of the configuration file used for the deployment
- `out/abi/`: JSON representation of the ABIs of all deployed contracts
- `out/bin/`: .bin and .bin-runtime files of all deployed contracts
- `out/meta/`: meta.json files of all deployed contracts
- `out/dss-<NETWORK>.log`: output log of deployment

### Helper scripts

The `auth-checker` script loads the addresses from `out/addresses.json` and the config file from `out/config.json` and verifies that the deployed authorizations match what is expected.

## Nix

To enable full reproducibility of our deployments, we use Nix.

This command will drop you in a shell with all dependencies and environment
variables definend:

```
nix-shell --pure
```

You can even run deploy scripts without having to clone this repo:

```
nix run -f https://github.com/makerdao/dss-deploy-scripts/tarball/master -c dss-deploy testchain
```

Dependencies are managed through a central repository referenced in
[`nix/pkgs.nix`](nix/pkgs.nix) and the main Nix expression to build this
repo is in [`default.nix`](default.nix).

## Smart Contract Dependencies

To update smart contract dependencies use `dapp2nix`:

```sh
nix-shell --pure
dapp2nix help
dapp2nix list
dapp2nix up vote-proxy <COMMIT_HASH>
```

To clone smart contract dependencies into working directory run:

```sh
dapp2nix clone-recursive contracts
```

## Additional Documentation and great references 

- `dss-deploy` [source code](https://github.com/makerdao/dss-deploy)
- `dss` is documented in the [wiki](https://github.com/makerdao/dss/wiki) and in [DEVELOPING.md](https://github.com/makerdao/dss/blob/master/DEVELOPING.md)




