pragma solidity >=0.7.0;

import "./AccessControl.sol";

contract Inspector{
    using AccessControl for AccessControl.Role;

    event InspectorRoleGiven(address indexed account);
    event InspectorRoleTaken(address indexed account);

    AccessControl.Role private _inspectors;

    constructor(){
        _giveInspectorRole(msg.sender);
    }

    modifier checkInspector(){
        require(_inspectors.contains(msg.sender), "account does not have inspector role");
        _;
    }

    function giveInspectorRole(address account) public {
        _giveInspectorRole(account);
    }

    function takeInspectorRole() public checkInspector {
        _takeInspectorRole(msg.sender);
    }

    function _giveInspectorRole(address account) internal {
        _inspectors.give(account);
        emit InspectorRoleGiven(account);
    }

    function _takeInspectorRole(address account) internal {
        _inspectors.take(account);
        emit InspectorRoleTaken(account);
    }
}