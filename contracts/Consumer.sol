pragma solidity >=0.7.0;

import "./AccessControl.sol";

contract Consumer{
    using AccessControl for AccessControl.Role;

    event ConsumerRoleGiven(address indexed account);
    event ConsumerRoleTaken(address indexed account);

    AccessControl.Role private _consumers;

    constructor(){
        _giveConsumerRole(msg.sender);
    }

    modifier checkConsumer(){
        require(_consumers.contains(msg.sender), "account does not have consumer role");
        _;
    }

    function giveConsumerRole(address account) public {
        _giveConsumerRole(account);
    }

    function takeConsumerRole() public checkConsumer {
        _takeConsumerRole(msg.sender);
    }

    function _giveConsumerRole(address account) internal {
        _consumers.give(account);
        emit ConsumerRoleGiven(account);
    }

    function _takeConsumerRole(address account) internal {
        _consumers.take(account);
        emit ConsumerRoleTaken(account);
    }
}