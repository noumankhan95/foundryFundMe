//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {Script} from "forge-std/Script.sol";
import {Fundme} from "../src/Fundme.sol";

contract FundFundMe is Script {
    function fundTheFundmeContract(address latestDeployment) public {
        vm.startBroadcast();
        (bool success, ) = latestDeployment.call{value: 1 ether}(
            abi.encodeWithSignature("startfundMe()")
        );
        vm.stopBroadcast();
    }

    function getFundMeContract() public {
        address latestDeployment = DevOpsTools.get_most_recent_deployment(
            "Fundme",
            block.chainid
        );
        vm.startBroadcast();
        fundTheFundmeContract(latestDeployment);
        vm.stopBroadcast();
    }
}

contract WithdrawFundMe is Script {
    function WithdrawFromFundMeContract(address latestDeployment) public {
        vm.startBroadcast();

        (bool success, ) = latestDeployment.call(
            abi.encodeWithSignature("withdraw()")
        );
        vm.stopBroadcast();
        // require(success, "Withdrawal failed");
    }

    function getFundMeContract() public {
        address latestDeployment = DevOpsTools.get_most_recent_deployment(
            "Fundme",
            block.chainid
        );
        WithdrawFromFundMeContract(latestDeployment);
    }
}
