pragma solidity ^0.4.19;

import "github.com/oraclize/ethereum-api/oraclizeAPI_0.5.sol";

contract ExternalRandomContract is usingOraclize {

    string public random; // XBT is a synonym of BTC
    string public min;
    string public max;
    event LogConstructorInitiated(string nextStep);
    event LogRandomUpdated(string random);
    event LogNewOraclizeQuery(string description);

    function ExternalRandomContract(string _min,string _max) payable {
        min = _min;
        max = _max;
        LogConstructorInitiated("Constructor was initiated. Call 'updateRandom()' to send the Oraclize Query.");
    }

    function __callback(bytes32 myid, string result) {
        if (msg.sender != oraclize_cbAddress()) revert();
        random = result;
        LogRandomUpdated(random);
    }

    function updateRandom() payable {
        if (oraclize_getPrice("URL") > this.balance) {
            LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            //https://www.random.org/integers/?num=1&min=1&max=10000&col=1&base=10&format=plain&rnd=new
            string memory urlFirstPart = "https://www.random.org/integers/?num=1&min=";
            string memory middlePart = "&max=";
            string memory finalPart = "&col=1&base=10&format=plain&rnd=new";
            string memory fullURL = strConcat(urlFirstPart,min,middlePart,max,finalPart);

            LogNewOraclizeQuery(strConcat("Oraclize query was sent, standing by for the answer..",fullURL));
            oraclize_query("URL", fullURL);
        }
    }
}