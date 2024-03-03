// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interaction.s.sol"; // <--- Import the interaction script

contract InteractionsTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether; // 100000000000000000 wei
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe(); // <--- Create a new instance of the interaction script
        fundFundMe.fundFundMe(address(fundMe)); // <--- Call the function to fund the contract

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe(); // <--- Create a new instance of the interaction script
        withdrawFundMe.withdrawFundMe(address(fundMe)); // <--- Call the function to withdraw the funds

        assert(address(fundMe).balance == 0);
    }
}
