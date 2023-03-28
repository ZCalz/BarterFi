// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {BarterFi} from "../src/BarterFi.sol";
import {MockStableCoin} from "../src/MockStableCoin.sol";

contract DeployScript is Script {
    function run() public {
        vm.startBroadcast();
        IERC20 mockUSD = new MockStableCoin("Mock USD", "MUSD");
        BarterFi barterFi = new BarterFi(mockUSD);
        vm.stopBroadcast();
    }
}
