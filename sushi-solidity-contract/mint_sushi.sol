// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma abicoder v2;


import "https://github.com/LayerZero-Labs/solidity-examples/blob/main/contracts/lzApp/NonblockingLzApp.sol";
import "https://github.com/LayerZero-Labs/solidity-examples/blob/main/contracts/util/ExcessivelySafeCall.sol";




/// @title A LayerZero example sending a cross chain message from a source chain to a destination chain to increment a counter
contract Sushi is NonblockingLzApp {
constructor(address _lzEndpoint) NonblockingLzApp(_lzEndpoint) {}


function sendToAptos(uint16 _dstChainId,address _zroPaymentAddress, bytes memory _adapterParams,bytes memory lzPayload) public payable {
_lzSend(_dstChainId, lzPayload, payable(msg.sender), _zroPaymentAddress, _adapterParams, msg.value);
}


}
