# Sushi OFT Smart Contract
Aptos Contract

## How to deploy sushi-OFT contract on test net

1.  Comment out the LayerZero Mainner Addresses from the Move.toml file
and uncomment LayterZero Testnet Addresses.

    ```
    #LayerZero Mainnet Addresses

    layerzero = "0x54ad3d30af77b60d939ae356e6606de9a4da67583f02b962d2d3f2e481484e90"
    layerzero_common = "0x54ad3d30af77b60d939ae356e6606de9a4da67583f02b962d2d3f2e481484e90"
    msglib_auth = "0x54ad3d30af77b60d939ae356e6606de9a4da67583f02b962d2d3f2e481484e90"
    msglib_v1_1 = "0x54ad3d30af77b60d939ae356e6606de9a4da67583f02b962d2d3f2e481484e90"
    msglib_v2 = "0x54ad3d30af77b60d939ae356e6606de9a4da67583f02b962d2d3f2e481484e90"
    zro = "0x54ad3d30af77b60d939ae356e6606de9a4da67583f02b962d2d3f2e481484e90"
    executor_auth = "0x54ad3d30af77b60d939ae356e6606de9a4da67583f02b962d2d3f2e481484e90"
    executor_v2 = "0x54ad3d30af77b60d939ae356e6606de9a4da67583f02b962d2d3f2e481484e90"
    layerzero_apps = "0x43d8cad89263e6936921a0adb8d5d49f0e236c229460f01b14dca073114df2b9"

    ```

<br/>

2. To deploy the contract we have to change the
**sushi_oft_origin**,**sushi_oft_admin**, and **sushi_oft** address
in the Move.toml file.

<br/>

3. To create **sushi_oft_origin** and **sushi_oft_admin**

   **Accounts run the below command**

    ```shell
    aptos init --profile sushi_oft_origin
    ```
    ```shell
    aptos init --profile sushi_oft_admin
    ```

<br/>

4. To deploy sushi-OFT contract run the below command

    ```shell
    aptos move create-resource-account-and-publish-package
    --seed 1223 --address-name sushi_oft
    ```

    <br>
    
    ---
    **NOTE**

    After successfully deploying of contract replace sushi_oft address with the resource account address.

    ---

<br>
<br>

## How to run sushi-OFT contract on test net

1. Create masterchef_upkeep_operator account in your masterchef contract.

    ```shell
    aptos init --profile masterchef_upkeep_operator
    ```

<br>

2. Whitelist masterchef_upkeep_operator address in
sushi-OFT contract using below command.

    ```shell
    aptos move run --function-id
    sushi_oft(address)::oft::whitelist --profile
    sushi_oft_admin --args
    address:masterchef_upkeep_operator(address) bool:true
    ```

<br>

3. Download sushi-solidity-contract smart contract.

<br>

4. Deploy the above smart contract in solidity goerli
network using below endpoint.

    Goerli (Ethereum Testnet)
    
    ```shell​
    chainId: 10121

    endpoint: 0xbfD2135BFfbb0B5378b56643c2Df8a87552Bfa23
    ```
<br>

5. Run setTrustedRemoteAddress function in remix IDE for
trust your your sushi_oft address.


<br/>

6. Set trust remote in your sushi-OFT aptos contract.

    **Run set_trust_remote function from aptos explorer**

    https://explorer.aptoslabs.com/account/**sushi_oft(address)**?network=testnet

    <br/>
    
    ---
    **NOTE**

    In the chain_id give the goerli testnet chainid and
    add solidity smart contract address in remote_addr.

    ---
<br>

7. Run **sendToAptos** function using below parameter.

    ```
    _dstChainId: 10108
    ```

    ```
    _zroPaymentAddress:
    0x0000000000000000000000000000000000000000
    ```

    ```
    _adapterParams:
    0x0001000000000000000000000000000000000000000000000000
    0000000000030d40
    ```

    ```
    lzPayload:
    0x0003d330c1cd8f30bd20c294a9f2052c4c0dbeb70a6c19d83e04
    2a8e7b25ba91ab0000000877359400
    ```

    <br/>

    ---
    **NOTE**

    change **03d330c1cd8f30bd20c294a9f2052c4c0dbeb70a6c19d83e042a8e7b25ba91ab** with your masterchef_upkeep_operator(address).
    
