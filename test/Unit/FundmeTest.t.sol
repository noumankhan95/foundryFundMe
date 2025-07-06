//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Fundme} from "../../src/Fundme.sol";
import {Test} from "forge-std/Test.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {AggregatorV3Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {DeployContract} from "../../script/DeployContract.s.sol";

contract TestFundMe is Test {
    Fundme public fundme;
    HelperConfig public helperConfig;
    DeployContract deployer;

    function setUp() public {
        deployer = new DeployContract();
        (fundme, helperConfig) = deployer.run();
        vm.deal(address(this), 10 ether);
    }

    function testOwner() public {
        assertEq(fundme.getOwner(), address(deployer));
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
