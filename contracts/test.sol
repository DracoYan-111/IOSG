// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

// import "@chainlink/contracts/src/v0.6/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract OpenWeatherConsumer is ChainlinkClient {
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    bytes32 public weather;

    /**
     * Network: Kovan
     * Oracle:
     *      Name:           Alpha Chain - Kovan
     *      Listing URL:    https://market.link/nodes/ef076e87-49f4-486b-9878-c4806781c7a0?start=1614168653&end=1614773453
     *      Address:        0xAA1DC356dc4B18f30C347798FD5379F3D77ABC5b
     * Job:
     *      Name:           OpenWeather Data
     *      Listing URL:    https://market.link/jobs/e10388e6-1a8a-4ff5-bad6-dd930049a65f
     *      ID:             235f8b1eeb364efc83c26d0bef2d0c01
     *      Fee:            1 LINK
     */
    constructor() public {
        setPublicChainlinkToken();
        oracle = 0xa04803C3cbd890083D668e7fc3cE44863ff9df31;
        jobId = "0c02ce5432944c3fbf0f8f7eca6ae8b8"; // "89b9beb25e79400a957f86e87b0566ff";
        fee = 1 * 10 ** 17;
    }

    /**
     * Initial request
     */
    function requestCityWeather(string memory _city) public {
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfillCityWeather.selector);
        req.add("city", _city);
        req.add("copyPath", "weather.0.main");
        sendChainlinkRequestTo(oracle, req, fee);
    }

    /**
     * Callback function
     */
    function fulfillCityWeather(bytes32 _requestId, bytes32 _weather) public recordChainlinkFulfillment(_requestId) {
        weather = _weather;
    }
}
