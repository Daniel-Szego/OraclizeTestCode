pragma solidity ^0.4.19;

import "github.com/oraclize/ethereum-api/oraclizeAPI_0.5.sol";

contract OraclizeRandomContract is usingOraclize {

    uint public random; // XBT is a synonym of BTC
    uint public max;
    event LogConstructorInitiated(string nextStep);
    event newRandomNumber_bytes(bytes);
    event newRandomNumber_uint(uint);


    function OraclizeRandomContract(uint _max) payable {
        max = _max;
        LogConstructorInitiated("Constructor was initiated. Call 'updateRandom()' to send the Oraclize Query.");
    }

    function __callback(bytes32 myid, string result, bytes proof) {
        if (msg.sender != oraclize_cbAddress()) revert();
        
        if (oraclize_randomDS_proofVerify__returnCode(myid, result, proof) != 0) {
            // the proof verification has failed, do we need to take any action here? (depends on the use case)
        } else {
            // the proof verification has passed
            // now that we know that the random number was safely generated, let's use it..
            
            newRandomNumber_bytes(bytes(result)); // this is the resulting random number (bytes)
            
            // for simplicity of use, let's also convert the random bytes to uint if we need
            uint maxRange = 2**(8* 7); // this is the highest uint we want to get. It should never be greater than 2^(8*N), where N is the number of random bytes we had asked the datasource to return
            uint randomNumber = uint(sha3(result)) % maxRange; // this is an efficient way to get the uint out in the [0, maxRange] range
            random = randomNumber;
            newRandomNumber_uint(randomNumber); // this is the resulting random number (uint)
        }
    }

    function updateRandom() payable {
        uint N = 7; // number of random bytes we want the datasource to return
        uint delay = 0; // number of seconds to wait before the execution takes place
        uint callbackGas = 200000; // amount of gas we want Oraclize to set for the callback function
        bytes32 queryId = oraclize_newRandomDSQuery(delay, N, callbackGas); // this function internally generates the correct oraclize_query and returns its queryId
    }
}