pragma solidity >=0.7.0;

import "./AccessControl.sol";

contract Distributor{
    using AccessControl for AccessControl.Role;

    event DistributorRoleGiven(address indexed account);
    event DistributorRoleTaken(address indexed account);

    AccessControl.Role private _distributors;

    constructor(){
        _giveDistributorRole(msg.sender);
    }

    modifier checkDistributor(){
        require(_distributors.contains(msg.sender), "account does not have distributor role");
        _;
    }

    function giveDistributorRole(address account) public {
        _giveDistributorRole(account);
    }

    function takeDistributorRole() public checkDistributor {
        _takeDistributorRole(msg.sender);
    }

    function _giveDistributorRole(address account) internal {
        _distributors.give(account);
        emit DistributorRoleGiven(account);
    }

    function _takeDistributorRole(address account) internal {
        _distributors.take(account);
        emit DistributorRoleTaken(account);
    }
}