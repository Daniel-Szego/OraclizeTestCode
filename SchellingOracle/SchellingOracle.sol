pragma solidity ^0.4.25;

import "github.com/oraclize/ethereum-api/oraclizeAPI_0.5.sol";

contract SchellingOracle is usingOraclize {
    
    uint public value;
    ProbeContract[] probes;

    event ProbeAdded(address probeAddress);
    event UpdateFinished(uint value);
    
    function addProbe(address probeAddress) public {
        probes.push(ProbeContract(probeAddress));
    }

    function __callback(bytes32 myid, string result, bytes proof) {
        if (msg.sender != oraclize_cbAddress()) revert();
        // aggregationg values 
        uint aggregatedValue;
        
         for (uint i = 0; i < probes.length; i++) {
            aggregatedValue = probes[i].valueI();
         }
        value = aggregatedValue;
        UpdateFinished(aggregatedValue);
    }
    
    function updateValue() payable public {
        for (uint i = 0; i < probes.length; i++) {
            probes[i].updateValue();
        }
        // scheduled query only for aggregation
        oraclize_query(360, "URL", "json(https://api.kraken.com/0/public/Ticker?pair=XXBTZEUR).result.XXBTZEUR.c.0");
    }
}

contract ProbeContract is usingOraclize {

    uint public valueI; 
    event ProbeUpdated(uint value);

    function ProbeContract() payable {
        
    }

    function __callback(bytes32 myid, string result) {
        if (msg.sender != oraclize_cbAddress()) revert();
        valueI = parseInt(result);
        emit ProbeUpdated(valueI);
    }

    function updateValue() payable {
        if (oraclize_getPrice("URL") > this.balance) {

        } else {
            oraclize_query("URL", "json(https://api.kraken.com/0/public/Ticker?pair=XXBTZEUR).result.XXBTZEUR.c.0");
        }
    }
}