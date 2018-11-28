pragma solidity ^0.4.19;
import "./OraclizeAPI_0.5.sol";

contract SimpleOraclizeContract is usingOraclize {

    string public XBTEUR; // XBT is a synonym of BTC 
    event LogConstructorInitiated(string nextStep);
    event LogPriceUpdated(string price);
    event LogNewOraclizeQuery(string description);

    function SimpleOraclizeContract() payable {
        LogConstructorInitiated("Constructor was initiated. Call 'updatePrice()' to send the Oraclize Query.");
    }

    function () payable {

    }

    function __callback(bytes32 myid, string result) {
        if (msg.sender != oraclize_cbAddress()) revert();
        XBTEUR = result;
        LogPriceUpdated(result);
    }

    function updatePrice() payable {

            LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
            oraclize_query("URL", "json(https://api.kraken.com/0/public/Ticker?pair=XXBTZEUR).result.XXBTZEUR.c.0");
    }
}