// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;
import {ERC4626} from "solmate/mixins/ERC4626.sol";

import {ERC20} from "solmate/tokens/ERC20.sol";
import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";
import {IDLP} from "./interfaces/IDLP.sol";
import {Ownable} from "openzeppelin/access/Ownable.sol";
import {IDODOPOOL} from "./interfaces/IDODOPOOL.sol";

//a simple ERC4626 vault for compounding DODO USDC-USDT LP rewards

contract PVAULT is ERC4626 {
    //this must be set to DODO LP token in Constructor 
    ERC20 public UNDERLYING; 
    //sets owner of vault
    address payable public owner;
    //mapping strategies to bool approval
    mapping(address => bool) strategies;
    //Dodo LP mining contract
    IDLP public idlp;
    //signals reward harvest
    bool public claimed;
    //compounded rewards?
    bool public compounded;
    //pool for swapping dodo to USDC
    IDODOPOOL public dodoPool;
    //dodo token address
    ERC20 public dodo;
    //usdc token address
    ERC20 public usdc;
    //usdc-usdt LP address
    IDODOPOOL public usdcLP;

    constructor(ERC20 underlying) ERC4626(underlying, "pPVaultt", "PVLT") {
        UNDERLYING = ERC20(underlying);
        owner = payable(msg.sender);
        idlp = IDLP(0x38Dbb42C4972116c88E27edFacD2451cf1b14255);
        dodoPool = IDODOPOOL(0x6a58c68FF5C4e4D90EB6561449CC74A64F818dA5);
        dodo = ERC20(0x69Eb4FA4a2fbd498C257C57Ea8b7655a2559A581);
        usdc = ERC20(0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8);
        usdcLP = IDODOPOOL(0xe4B2Dfc82977dd2DCE7E8d37895a6A8F50CbB4fB);
    }
    function totalAssets() public view virtual override returns (uint256) {
        return UNDERLYING.balanceOf(address(this)) + UNDERLYING.balanceOf(address(idlp));
    }
    function afterDeposit(uint256 assets, uint256 shares) internal virtual override {
        //deposit into LM contract
        idlp.deposit( assets);
    }
    function beforeWithdraw(uint256 assets, uint256 shares) internal virtual override {
        //withdraw from LM contract
        idlp.withdraw( assets);
    }
    //Only call this once to signal rewards harvest
    function claimRewards() public {
        require(msg.sender == owner, "caller not vault owner");
        idlp.claimAllRewards();
        claimed = true;
    }
    //swap rewards for more LP tokens and stake
    function swapRewards() public {
        //todo logic to swap DODO tokens for more Underlying
        require(msg.sender == owner, "caller not vault owner");
        require(claimed, "rewards not claimed");
        address to = address(this);
        dodoPool.sellBase(to);
        dodo.transfer(0x6a58c68FF5C4e4D90EB6561449CC74A64F818dA5, dodo.balanceOf(address(this)));
        //would recieve USDC tokens, now deposit into pool
        usdcLP.buyShares(to);
        //sell for more USDC-USDT LP
        usdc.transfer(0xe4B2Dfc82977dd2DCE7E8d37895a6A8F50CbB4fB, usdc.balanceOf(address(this)));
        //deposit LP to LM contract
        idlp.deposit(UNDERLYING.balanceOf(address(this)));
        compounded = true;
    }

}
