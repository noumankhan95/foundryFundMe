//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Fundme} from "../../src/Fundme.sol";
import {Test} from "forge-std/Test.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {AggregatorV3Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract TestFundMe is Test {
    Fundme public fundme;
    HelperConfig public helperConfig;

    function setUp() public {
        helperConfig = new HelperConfig();
        fundme = new Fundme(
            AggregatorV3Interface(helperConfig.getConfig().priceFeed)
        );
        vm.deal(address(this), 10 ether);
    }

    function testOwner() public {
        assertEq(fundme.getOwner(), address(this));
    }

    function testMinAmount() public {
        vm.prank(address(this));
        fundme.startfundMe{value: 0.5 ether}();
        assertEq(address(fundme).balance, 0.5 ether);
        assertEq(address(this).balance, 9.5 ether);
    }

    function testReceiveFunction() public {
        vm.prank(address(this));
        (bool success, ) = address(fundme).call{value: 0.5 ether}("");
        assertEq(address(fundme).balance, 0.5 ether);
    }
}
