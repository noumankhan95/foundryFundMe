//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract Fundme {
    using PriceConverter for uint256;
    address private immutable i_owner;
    AggregatorV3Interface public immutable i_priceFeed;
    mapping(address => uint256) s_funds;
    address[] s_funders;

    constructor(AggregatorV3Interface _priceFeed) {
        i_owner = msg.sender;
        i_priceFeed = AggregatorV3Interface(_priceFeed);
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner, "Not the owner");
        _;
    }

    modifier minimumAmount() {
        require(
            msg.value.getConversionRate(i_priceFeed) >= 0.5 ether,
            "Min 1 ether required to fund "
        );
        _;
    }

    function startfundMe() external payable minimumAmount {
        s_funds[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }

    function withdraw() external payable onlyOwner {
        address[] memory funders = s_funders;
        for (uint256 i = 0; i < funders.length; i++) {
            s_funds[funders[i]] = 0;
        }
        s_funders = new address[](0);
        (bool success, ) = i_owner.call{value: address(this).balance}("");
        require(success, "Withdrawal failed");
    }

    receive() external payable {}

    function getOwner() external view returns (address) {
        return i_owner;
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }
}
