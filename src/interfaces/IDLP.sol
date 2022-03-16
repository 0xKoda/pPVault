pragma solidity ^0.8.1;

interface IDLP {
    function deposit(uint256 amount) external;
    function withdraw(uint256 amount) external;
    function claimAllRewards() external;
}