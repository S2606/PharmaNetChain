pragma solidity >=0.4.24;

import "./AccessControl.sol";

contract Transporter{
    using AccessControl for AccessControl.Role;

    event TransporterRoleGiven(address indexed account);
    event TransporterRoleTaken(address indexed account);

    AccessControl.Role private _transporters;

    constructor(){
        _giveTransporterRole(msg.sender);
    }

    modifier checkTransporter(){
        require(_transporters.contains(msg.sender), "account does not have transporter role");
        _;
    }

    function giveTransporterRole(address account) public {
        _giveTransporterRole(account);
    }

    function takeTransporterRole() public checkTransporter {
        _takeTransporterRole(msg.sender);
    }

    function _giveTransporterRole(address account) internal {
        _transporters.give(account);
        emit TransporterRoleGiven(account);
    }

    function _takeTransporterRole(address account) internal {
        _transporters.take(account);
        emit TransporterRoleTaken(account);
    }
}