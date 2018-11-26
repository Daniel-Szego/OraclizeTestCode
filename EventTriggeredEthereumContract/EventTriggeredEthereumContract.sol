pragma solidity >=0.4.18;
import "github.com/oraclize/ethereum-api/oraclizeAPI_0.5.sol";

contract TestEventContract {
    
    event Trigger();
    
    function RaiseEvent() public {
        emit Trigger();
    }
}

contract EventTriggeredEthereumContract is usingOraclize {

    uint public trig;

    event LogNewOraclizeQuery(string message);

    //Constructor
    constructor() payable {
        trig = 0;
    }
    
    // Fallback
    function () payable {
    }
    
    // Get functions
    function getTrigger() view public returns (uint){
        return trig;
    }
    
    function getBalance() view public returns (uint) {
        return address(this).balance;    
    }

    // Schedule
    function __callback(bytes32 myid, string result) {
        if (msg.sender != oraclize_cbAddress()) revert();
        
        if (bytes(result).length > 90){
            trig = trig + 1;
        }
        else {
            scheduleNextUpdate();
        }
    }

    function scheduleNextUpdate() payable {
        if (oraclize_getPrice("URL") > this.balance) {
            LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            LogNewOraclizeQuery("Next update scheduled");
            string memory URL = "https://api-ropsten.etherscan.io/api?module=logs&action=getLogs&fromBlock=4508634&toBlock=latest&address=0x103C4A84831b47A0237B00a473E72CBcf816B989&topic0=0x3d53a39550e04688065827f3bb86584cb007ab9ebca7ebd528e7301c9c31eb5d&apikey=YourApiKeyToken";
            bytes32 queryId =  oraclize_query(1, "URL", URL);
        }
    }
}