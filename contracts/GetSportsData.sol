//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract GetSportsData is ChainlinkClient {
    using Chainlink for Chainlink.Request;

    address private oracle;
    bytes32 private jobId;
    uint256 private fee;
    
    uint256 public result;
    
    constructor() {
        setPublicChainlinkToken();
        oracle = 0x9C0383DE842A3A0f403b0021F6F85756524d5599; //0xAA1DC356dc4B18f30C347798FD5379F3D77ABC5b; //0xfF07C97631Ff3bAb5e5e5660Cdf47AdEd8D4d4Fd;
        jobId = "7fb536be865b4336b27fc10147c193c7"; //"b7285d4859da4b289c7861db971baf0a";  //"9abb342e5a1d41c6b72941a3064cf55f";      
        fee = 0.1 * 10 ** 18; // (Varies by network and job)
    }
    
    /**
     * Initial request
     */
    function requestData() public returns (bytes32 requestId) 
    {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        
        // Set the URL to perform the GET request on
        //request.add("get", "https://api.sportsdata.io/v3/soccer/scores/json/Areas?key=32474a4d5c0a4340b55ebc1fcea3ead6");
        //request.add("get", "https://api.sportsdata.io/v3/soccer/scores/json/Player/90026231?key=32474a4d5c0a4340b55ebc1fcea3ead6");
        request.add("get", "https://api.sportsdata.io/v3/soccer/stats/json/PlayerSeasonStatsByPlayer/1/90026231?key=??");
        
        //request.add("path", "FirstName");
        request.add("path", "data.0.Games");
                       
        // Sends the request
        return sendChainlinkRequestTo(oracle, request, fee);
    }
    
    /**
     * Callback function
     */
    function fulfill(bytes32 _requestId, uint256 _result) public recordChainlinkFulfillment(_requestId) {
        result = _result;
    }
    
}
