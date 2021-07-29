// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
* @title IOSG ERC721 token
*/
contract IOSGNft is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    /**
    * @dev 部署合约
    * @param _name token名称
    * @param _symbol token简称
    */
    constructor(string memory _name, string memory _symbol)
    ERC721(_name, _symbol) {}

    /**
    * @dev 创建nft
    * @param player 收款人地址
    * @param tokenURI tokenURI
    */
    function awardItem(address player, string memory tokenURI)
    public
    returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }


}
