// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
// import "@solmate/tokens/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockStableCoin is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(msg.sender, 10000 ether);
    }
}
