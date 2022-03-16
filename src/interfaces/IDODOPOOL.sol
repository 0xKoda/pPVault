pragma solidity ^0.8.1;

interface IDODOPOOL {
    function sellBase(address to) external returns(uint256);
    function buyShares(address to) external returns (uint256 shares, uint256 baseInput, uint256 quoteInput);
}