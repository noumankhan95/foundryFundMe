//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {Test} from "forge-std/Test.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";
import {DeployContract} from "../../script/DeployContract.s.sol";
import {Fundme} from "../../src/Fundme.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract InteractionsTest is Test {
    address user = makeAddr("user");
    Fundme fundme;

    function setUp() public {
        vm.deal(user, 100 ether);
        DeployContract deployContract = new DeployContract();
        (fundme, ) = deployContract.run();
    }

    function testUserCanFundContract() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundTheFundmeContract(address(fundme));

        assertEq(address(fundme).balance, 1 ether);
    }
}
