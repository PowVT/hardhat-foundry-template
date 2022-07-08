// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import "../src/MarketNG.sol";
import "../src/IWETH.sol";
import "../src/mocks/MockERC20.sol";
import "../src/mocks/MockERC721.sol";

contract MarketNGTest is Test {

    address constant alice = address(0x1111);
    address constant bob = address(0x1337);

    IWETH public iweth;
    MarketNG public marketNG;
    MockERC20 public mockERC20;
    MockERC721 public mockERC721;

    function setUp() public {
        ////// deploy contracts
        // MarketNG
        marketNG = new MarketNG(iweth);
        marketNG.unpause();

        // MockERC20
        mockERC20 = new MockERC20();

        // MockERC721
        mockERC721 = new MockERC721();
        deal(address(mockERC721), alice, 1);

        ////// verify setup
        // market
        assertEq(marketNG.RATE_BASE(), 1e6);
        assertTrue(marketNG.paused());

        // ERC20
        assertEq(mockERC20.balanceOf(alice), 1_000_000e18);

        //ERC721
        assertEq(mockERC721.balanceOf(alice), 1);

        emit log_address(bob);
        emit log_address(alice);
    }

    // swap erc721 for erc721 fuzz
    function createSwap(MarketNG.Swap memory req, bytes memory signature) public {
        marketNG.swap(req, signature);
    }

    function runTx(
        MarketNG.Intention calldata intent,
        MarketNG.Detail calldata detail,
        bytes calldata sigIntent,
        bytes calldata sigDetail
    ) public {
        marketNG.run(intent, detail, sigIntent, sigDetail);
    }

}
