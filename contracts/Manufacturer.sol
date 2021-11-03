pragma solidity >=0.7.0;

import "./AccessControl.sol";

contract Manufacturer{
    using AccessControl for AccessControl.Role;

    event ManufacturerRoleGiven(address indexed account);
    event ManufacturerRoleTaken(address indexed account);

    AccessControl.Role private _manufacturers;

    constructor(){
        _giveManufacturerRole(msg.sender);
    }

    modifier checkManufacturer(){
        require(_manufacturers.contains(msg.sender), "account does not have manufacturer role");
        _;
    }

    function giveManufacturerRole(address account) public {
        _giveManufacturerRole(account);
    }

    function takeManufacturerRole() public checkManufacturer {
        _takeManufacturerRole(msg.sender);
    }

    function _giveManufacturerRole(address account) internal {
        _manufacturers.give(account);
        emit ManufacturerRoleGiven(account);
    }

    function _takeManufacturerRole(address account) internal {
        _manufacturers.take(account);
        emit ManufacturerRoleTaken(account);
    }
}