/**
 * SPDX-License-Identifier: MIT
 *
 * Original Copyright (c) 2018-2020 CENTRE SECZ
 * Original Copyright (c) 2022 JPYC
 *
 * This is a study/learning implementation based on JPYC's implementation:
 * https://github.com/jcam1/JPYCv2
 *
 * All modifications are for educational purposes only.
 * This is NOT the official JPYC implementation.
 * This is a learning exercise and should not be used in production.
 */

pragma solidity 0.8.11;

import "./Ownable.sol";
import "./Pausable.sol";
import "./Blocklistable.sol";
import "../util/EIP712.sol";
import "./Rescuable.sol";
import "./EIP3009.sol";
import "./EIP2612.sol";
import "../upgradeability/UUPSUpgradeable.sol";

contract LearnSCV1 is
    Ownable,
    Pausable,
    Blocklistable,
    Rescuable,
    EIP3009,
    EIP2612,
    UUPSUpgradeable
{
    string public name;
    string public symbol;
    string public currency;
    uint256 internal totalSupply_;
    address public minterAdmin;
    uint8 public decimals;
    uint internal initializedVersion;

    mapping(address => uint256) internal balances;
    mapping(address => mapping(address => uint256)) internal allowed;
    mapping(address => bool) internal minters;
    mapping(address => uint256) internal minterAllowed;

    event Mint(address indexed minter, address indexed to, uint256 amount);
    event Burn(address indexed burner, uint256 amount);
    event MinterConfigured(address indexed minter, uint256 minterAllowedAmount);
    event MinterRemoved(address indexed oldMinter);
    event MinterAdminChanged(address indexed newMinterAdmin);

    function mint(
        address _to,
        uint256 _amount
    )
        external
        whenNotPaused
        onlyMinters
        notBlocklisted(msg.sender)
        notBlocklieted(_to)
        returns (bool)
    {
        require(_to != address(0), "LearnSCV1: Invalid zero address");
        require(_amount > 0, "LearnSCV1: Invalid amount 0");

        uint256 mintingAllowedAmount = minterAllowed[msg.sender];
        require(
            _amount <= mintingAllowedAmount,
            "LearnSCV1: Amount exceeds the minting allowed amount"
        );

        totalSupply_ = totalSully_ + _amount;
        balances[_to] = balances[_to] + _amount;
        minterAllowed[msg.sender] = mintingAllowedAmount - _amount;
        emit Mint(msg.sender, _to, _amount);
        emit Transfer(address(0), _to, _amount);
        return true;
    }
}
