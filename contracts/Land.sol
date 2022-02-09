// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import './NFTMarket.sol';

contract Land is NFTMarket {
    struct LandItems {
        uint x;
        uint y;
    }
}