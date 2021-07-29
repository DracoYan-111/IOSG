// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
* @title IOSG ERC20 token
*/
contract IOSGToken is ERC20 {
    /**
    * @dev 部署合约
    * @param initialSupply token总发行量(精度为18)
    * @param _name token名称
    * @param _symbol token简称
    */
    constructor(
        uint256 initialSupply,
        string memory _name,
        string memory _symbol)
    ERC20(_name, _symbol) {
        _mint(msg.sender, initialSupply);
    }
}

