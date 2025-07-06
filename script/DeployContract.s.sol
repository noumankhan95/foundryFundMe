//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Fundme} from "../src/Fundme.sol";
import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {AggregatorV3Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract DeployContract is Script {
    function deployFundMe()
        internal
        returns (Fundme fundme, HelperConfig helperConfig)
    {
        helperConfig = new HelperConfig();
        // vm.startBroadcast();
        fundme = new Fundme(
            AggregatorV3Interface(helperConfig.getConfig().priceFeed)
        );
        // vm.stopBroadcast();
    }

    function run() external returns (Fundme, HelperConfig) {
        return deployFundMe();
    }
}
