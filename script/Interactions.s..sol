//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract FundFundMe {
    function fundTheFundmeContract() external {
        address latestDeployment = getFundMeContract();
        (bool success, ) = latestDeployment.call{value: 1 ether}("");
        require(success, "Funding failed");
    }

    function getFundMeContract() internal view returns (address) {
        return DevOpsTools.get_most_recent_deployment("Fundme", block.chainid);
    }
}

contract WithdrawFundMe {
    function WithdrawFromFundMeContract() external {
        address latestDeployment = getFundMeContract();
        (bool success, ) = latestDeployment.call(
            abi.encodeWithSignature("withdraw()")
        );
        require(success, "Withdrawal failed");
    }

    function getFundMeContract() internal view returns (address) {
        return DevOpsTools.get_most_recent_deployment("Fundme", block.chainid);
    }
}
