pragma solidity >=0.7.0;

library AccessControl{
    struct Role{
        mapping(address => bool) member;
    }

    function give(Role storage role, address acc) internal{
        require(!contains(role, acc), "Account already has the given role");
        role.member[acc] = true;
    }

    function take(Role storage role, address acc) internal{
        require(contains(role, acc), "Account does not have the given role");
        role.member[acc] = false;
    }

    function contains(Role storage role, address acc) internal view returns (bool){
        require(acc!=address(0), "Accout is actually address zero");
        return role.member[acc];
    }
}