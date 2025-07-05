//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/Mocks/MockV3Aggregator.t.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        address priceFeed;
    }
    NetworkConfig public networkConfig;
    uint8 constant DECIMALS = 8;
    int256 constant INITIAL_PRICE = 2000 * 10 ** 8;

    constructor() {
        if (block.chainid == 11155111) {
            setSepoliaConfig();
        } else if (block.chainid == 1) {
            setMainnetConfig();
        } else {
            setLocalConfig();
        }
    }

    function getConfig() external view returns (NetworkConfig memory) {
        return networkConfig;
    }

    function setMainnetConfig() internal {
        networkConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419 // Mainnet ETH/USD
        });
    }

    function setSepoliaConfig() internal {
        networkConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
    }

    function setLocalConfig() internal {
        MockV3Aggregator mock = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        networkConfig = NetworkConfig({priceFeed: address(mock)});
    }
}
