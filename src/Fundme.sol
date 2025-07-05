//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract Fundme {
    using PriceConverter for uint256;
    address immutable i_owner;
    AggregatorV3Interface public immutable i_priceFeed;
    mapping(address => uint256) s_funds;

    constructor(address _owner, AggregatorV3Interface _priceFeed) {
        i_owner = _owner;
        i_priceFeed = AggregatorV3Interface(_priceFeed);
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner, "Not the owner");
        _;
    }

    modifier minimumAmount() {
        require(
            msg.value.getConversionRate(i_priceFeed) >= 1 ether,
            "Min 1 ether required to fund "
        );
        _;
    }

    function startfundMe() external payable minimumAmount {
        s_funds[msg.sender] += msg.value;
    }
}
