// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/ChainlinkClient.sol";

interface linkToken {
    function balanceOf(address account) external returns (uint256);
}

contract twitterverify is ChainlinkClient {
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    linkToken public link;

    struct userTwitter {
        bytes32 requestId;
        string twitterId;
        string retweetId;
        bool verified;

    }

    mapping(address => userTwitter) public userTwitterMap;

    /**
    * @dev 合约不是
    * @param _link link地址
    **/
    constructor(linkToken _link) public {
        link = _link;
        setPublicChainlinkToken();
        oracle = 0xa04803C3cbd890083D668e7fc3cE44863ff9df31;
        jobId = "0c02ce5432944c3fbf0f8f7eca6ae8b8";
        fee = 1 * 10 ** 17;
    }

    /**
    * @dev 前端测试数据
    * @param _address 用户地址
    */
    function createTestUser(address _address) external {
        bool test = true;
        userTwitter memory testUser =
        userTwitter({
        requestId : 0,
        twitterId : "testUser",
        retweetId : "testTwitter",
        verified : true
        });
        userTwitterMap[_address] = testUser;
    }


    /**
     * @dev 验证用户
     * @param _twitterId 用户推特Id
     * @param _retweetId 推文ID
     **/
    function verifyUser(string memory _retweeted, string memory _twitterId, string memory _retweetId) public returns (bytes32) {
        require(
            link.balanceOf(address(this)) > fee,
            "Please recharge LINK in the contract"
        );
        userTwitterMap[msg.sender].verified = false;
        userTwitterMap[msg.sender].twitterId = _twitterId;
        userTwitterMap[msg.sender].retweetId = _retweetId;
        Chainlink.Request memory req =
        buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill_verify.selector
        );
        req.add("retweeted", _retweeted);
        bytes32 Id = sendChainlinkRequestTo(oracle, req, fee);
        userTwitterMap[msg.sender].requestId = Id;
        return Id;
    }

    /**
    * @dev 完成验证
    * @param _requestId 请求ID
    * @param _address 用户地址
    */
    function fulfill_verify(bytes32 _requestId, uint256 _address)
    public
    recordChainlinkFulfillment(_requestId)
    {
        address user = address(_address);
        if (user == address(0)) {
            revert("Error occurred during verification!");
        }
        if (userTwitterMap[user].requestId == _requestId) {
            userTwitterMap[user].verified = true;
        }
    }

    /**
    * @dev 得到验证
    * @param _address 用户地址
    */
    function getVerification(address _address) external view returns (bool) {
        return userTwitterMap[_address].verified;
    }

    /**
    * @dev 获取推特
    * @param _address 用户地址
    */
    function getTwitter(address _address)
    external
    view
    returns (string memory, string memory)
    {
        return (userTwitterMap[_address].twitterId,
        userTwitterMap[_address].retweetId);
    }


}
