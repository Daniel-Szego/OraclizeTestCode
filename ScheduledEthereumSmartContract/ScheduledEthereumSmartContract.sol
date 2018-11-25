pragma solidity >=0.4.18;
import "github.com/oraclize/ethereum-api/oraclizeAPI_0.5.sol";

contract ScheduledEthereumSmartContract is usingOraclize {

    uint public inc;

    event LogNewOraclizeQuery(string message);

    //Constructor
    constructor() payable {
        inc = 0;
    }
    
    // Fallback
    function () payable {
    }
    
    // Get functions
    function getInc() view public returns (uint){
        return inc;
    }
    
    function getBalance() view public returns (uint) {
        return address(this).balance;    
    }

    // Schedule
    function __callback(bytes32 myid, string result) {
        if (msg.sender != oraclize_cbAddress()) revert();
        
        // do something useful
        inc = inc + 1;
        scheduleNextUpdate();
    }

    function scheduleNextUpdate() payable {
        if (oraclize_getPrice("URL") > this.balance) {
            LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            LogNewOraclizeQuery("Next update scheduled");
            bytes32 queryId =  oraclize_query(1, "URL", "");
        }
    }
}