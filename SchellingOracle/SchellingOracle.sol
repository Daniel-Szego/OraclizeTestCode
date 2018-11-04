pragma solidity ^0.4.19;

import "github.com/oraclize/ethereum-api/oraclizeAPI_0.5.sol";

contract SchellingOracle is usingOraclize {
    
    string public value;
    ProbeContract[] probes;

    event ProbeAdded(address probeAddress);
    event UpdateFinished(string value);
    
    function addProbe(address probeAddress) public {
        probes.push(ProbeContract(probeAddress));
    }

    function __callback(bytes32 myid, string result, bytes proof) {
        if (msg.sender != oraclize_cbAddress()) revert();

    }
    
    function updateValue() payable public {
        
    }
}

contract ProbeContract is usingOraclize {

    string public value; 
    event ProbeUpdated(string value);

    function ProbeContract() payable {
    }

    function __callback(bytes32 myid, string result, bytes proof) {
        if (msg.sender != oraclize_cbAddress()) revert();
        
    }

    function updateValue() payable {

    }
}