//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract HelloFormsify {
    string public message = "Hello Formsify";

    constructor() {
        console.log("Formsify is coming!");
    }
}
