var OQ = artifacts.require("SimpleOraclizeContract");
var OQInstance;
var price;

function pause(milliseconds) {
	var dt = new Date();
	while ((new Date()) - dt <= milliseconds) { /* Do nothing */ }
}

contract('Oraclize call', function(accounts) {
    it("test of the Order Matching contract: deployed", function() {
        return OQ.deployed().then(function(instance) {
            OQInstance = instance;
            return OQInstance.sendTransaction({from:web3.eth.coinbase,value:10000000000000000000})
        }).then(function(result) {
            return OQInstance.updatePrice({from: accounts[0]});             
        }).then(function(result) {
            pause(100000);
            return OQInstance.XBTEUR({from: accounts[0]});             
        }).then(function(result) {
            price = result;
            console.log("price info :" + price);
            if (price > 0){
                assert.equal(1, 1, "cool");                      
            }
            else {
                assert.equal(1, 2, "not cool");                                      
            }
        });
    });
});