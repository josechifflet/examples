// SPDX-License-Identifier: GPL-3-0-or-later
pragma solidity >=0.8.13;

import { ISablierV2LockupLinear } from "@sablier/v2-core/interfaces/ISablierV2LockupLinear.sol";
import { Test } from "forge-std/Test.sol";

import { LockupLinearStreamCreator } from "./LinearStreamCreator.sol";

contract LockupLinearStreamCreatorTest is Test {
    // Get the latest deployment address from the docs
    // https://docs.sablier.com/contracts/v2/addresses
    address internal constant SABLIER_ADDRESS = address(0xcafe);

    // Test contracts
    LockupLinearStreamCreator internal creator;
    ISablierV2LockupLinear internal sablier;

    function setUp() public {
        // Fork Ethereum Mainnet
        vm.createSelectFork({ urlOrAlias: "mainnet" });

        // Load the Sablier contract from Ethereum Mainnet
        sablier = ISablierV2LockupLinear(SABLIER_ADDRESS);

        // Deploy the stream creator
        creator = new LockupLinearStreamCreator(sablier);

        // Mint some DAI tokens to the creator contract using the `deal` cheatcode
        deal({ token: address(creator.DAI()), to: address(creator), give: 1337e18 });
    }

    // Tests that creating streams works by checking the stream ids
    function test_CreateLockupLinearStream() public {
        uint256 expectedStreamId = sablier.nextStreamId();
        uint256 actualStreamId = creator.createLinearStream({ amount: 1337e18 });
        assertEq(actualStreamId, expectedStreamId);
    }
}